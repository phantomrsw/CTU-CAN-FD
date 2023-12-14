--------------------------------------------------------------------------------
--
-- CTU CAN FD IP Core
-- Copyright (C) 2021-present Ondrej Ille
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this VHDL component and associated documentation files (the "Component"),
-- to use, copy, modify, merge, publish, distribute the Component for
-- educational, research, evaluation, self-interest purposes. Using the
-- Component for commercial purposes is forbidden unless previously agreed with
-- Copyright holder.
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Component.
--
-- THE COMPONENT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHTHOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE COMPONENT OR THE USE OR OTHER DEALINGS
-- IN THE COMPONENT.
--
-- The CAN protocol is developed by Robert Bosch GmbH and protected by patents.
-- Anybody who wants to implement this IP core on silicon has to obtain a CAN
-- protocol license from Bosch.
--
-- -------------------------------------------------------------------------------
--
-- CTU CAN FD IP Core
-- Copyright (C) 2015-2020 MIT License
--
-- Authors:
--     Ondrej Ille <ondrej.ille@gmail.com>
--     Martin Jerabek <martin.jerabek01@gmail.com>
--
-- Project advisors:
-- 	Jiri Novak <jnovak@fel.cvut.cz>
-- 	Pavel Pisa <pisa@cmp.felk.cvut.cz>
--
-- Department of Measurement         (http://meas.fel.cvut.cz/)
-- Faculty of Electrical Engineering (http://www.fel.cvut.cz)
-- Czech Technical University        (http://www.cvut.cz/)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this VHDL component and associated documentation files (the "Component"),
-- to deal in the Component without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Component, and to permit persons to whom the
-- Component is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Component.
--
-- THE COMPONENT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHTHOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE COMPONENT OR THE USE OR OTHER DEALINGS
-- IN THE COMPONENT.
--
-- The CAN protocol is developed by Robert Bosch GmbH and protected by patents.
-- Anybody who wants to implement this IP core on silicon has to obtain a CAN
-- protocol license from Bosch.
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- @TestInfoStart
--
-- @Purpose:
--  Interrupt RX Buffer Full feature test.
--
-- @Verifies:
--  @1. When INT_MASK[RXFI] = 0, INT_STAT[RXFI] is set when RX Buffer is full.
--  @2. When INT_MASK[RXFI] = 1, INT_STAT[RXFI] is set when RX Buffer is full.
--  @3. When INT_ENA[RXFI]  = 1, INT_STAT[RXFI] = 1 causes interrupt output to
--      go high.
--  @4. When INT_ENA[RXFI]  = 0, INT_STAT[RXFI] = 1 does not cause interrupt
--      output to go high.
--  @7. RXF Interrupt enable is manipulated properly by INT_ENA_SET and
--      INT_ENA_CLEAR.
--  @8. RXF Interrupt mask is manipulated properly by INT_MASk_SET and
--      INT_MASK_CLEAR.

-- @Test sequence:
--  @1. Fill RX Buffer of DUT Node by transmitting CAN frames from Test Node.
--  @2. Loop through all configurations of INT_MASK[RXFI] and INT_EN[RXFI].
--      @2.1 Check that when Interrupt is masked it is not captured. Check that
--           when Interrupt is Enabled, it causes interrupt to propagate to
--           output
--
-- @TestInfoEnd
--------------------------------------------------------------------------------
-- Revision History:
--    5.11.2023   Created file
--------------------------------------------------------------------------------

Library ctu_can_fd_tb;
context ctu_can_fd_tb.ieee_context;
context ctu_can_fd_tb.rtl_context;
context ctu_can_fd_tb.tb_common_context;

use ctu_can_fd_tb.feature_test_agent_pkg.all;
use ctu_can_fd_tb.interrupt_agent_pkg.all;

package int_rxf_ftest is
    procedure int_rxf_ftest_exec(
        signal      chn             : inout  t_com_channel
    );
end package;

package body int_rxf_ftest is
    procedure int_rxf_ftest_exec(
        signal      chn             : inout  t_com_channel
    ) is
        variable CAN_frame          :     SW_CAN_frame_type;
        variable CAN_frame_rx       :     SW_CAN_frame_type;
        variable frame_sent         :     boolean := false;
        variable frames_equal       :     boolean := false;

        variable int_mask           :     SW_interrupts := SW_interrupts_rst_val;
        variable int_ena            :     SW_interrupts := SW_interrupts_rst_val;
        variable int_stat           :     SW_interrupts := SW_interrupts_rst_val;
        variable pc_dbg             :     SW_PC_Debug;
        variable rxb_state          :     SW_RX_Buffer_info;

    begin

        -----------------------------------------------------------------------
        -- @1. Fill RX Buffer of DUT Node by transmitting CAN frames from Test
        --     Node.
        -----------------------------------------------------------------------
        info_m("Step 1: Filling RX Buffer");

        CAN_generate_frame(CAN_frame);
        CAN_frame.data_length := 0;
        CAN_frame.frame_format := NORMAL_CAN;
        CAN_frame.rtr := RTR_FRAME;
        decode_length(CAN_frame.data_length, CAN_frame.dlc);

        get_rx_buf_state(rxb_state, DUT_NODE, chn);
        for i in 0 to (rxb_state.rx_buff_size / 4) + 1 loop
            CAN_send_frame(CAN_Frame, 1, TEST_NODE, chn, frame_sent);
            CAN_wait_frame_sent(TEST_NODE, chn);
        end loop;

        -----------------------------------------------------------------------
        -- @2. Loop through all configurations of INT_MASK[RXFI] and INT_EN[RXFI].
        -----------------------------------------------------------------------
        for mask in boolean'left to boolean'right loop
            for ena in boolean'left to boolean'right loop

                ---------------------------------------------------------------
                -- @2.1 Check that when Interrupt is masked it is not captured.
                --      Check that when Interrupt is Enabled, it causes interrupt
                --      to propagate to output
                ---------------------------------------------------------------
                info_m("Step 2.1 with:" &
                              "MASK: "  & boolean'image(mask) &
                              "ENABLE:" & boolean'image(ena));

                int_mask.rx_buffer_full_int := mask;
                int_ena.rx_buffer_full_int := ena;

                write_int_mask(int_mask, DUT_NODE, chn);
                write_int_enable(int_ena, DUT_NODE, chn);

                read_int_status(int_stat, DUT_NODE, chn);
                wait for 20 ns;

                check_m(int_stat.rx_buffer_full_int = (not mask),
                      "INT_MASK[RXFI] != INT_STAT[RXFI]" &
                      "INT_MASK[RXFI] : " & boolean'image(int_mask.rx_buffer_full_int) &
                      "INT_STAT[RXFI] : " & boolean'image(int_stat.rx_buffer_full_int));

                if ((not mask) and ena) then
                    wait for 20 ns;
                    interrupt_agent_check_asserted(chn);

                    -- Disable and check output is low
                    int_ena.rx_buffer_full_int := false;
                    write_int_enable(int_ena, DUT_NODE, chn);
                    wait for 20 ns;
                    interrupt_agent_check_not_asserted(chn);

                    -- Enable and check output is high again
                    int_ena.rx_buffer_full_int := true;
                    write_int_enable(int_ena, DUT_NODE, chn);
                    wait for 20 ns;
                    interrupt_agent_check_asserted(chn);

                    -- Mask, and clear and check it was cleared
                    int_mask.rx_buffer_full_int := true;
                    write_int_mask(int_mask, DUT_NODE, chn);
                    clear_int_status(int_stat, DUT_NODE, chn);
                    wait for 20 ns;
                    read_int_status(int_stat, DUT_NODE, chn);

                    check_false_m(int_stat.rx_buffer_full_int,
                                  "RX Buffer Full Interrupt cleared!");
                    interrupt_agent_check_not_asserted(chn);

                else
                    interrupt_agent_check_not_asserted(chn);
                end if;

            end loop;
        end loop;

    end procedure;
end package body;