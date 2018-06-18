--------------------------------------------------------------------------------
--
-- CTU CAN FD IP Core
-- Copyright (C) 2015-2018 Ondrej Ille <ondrej.ille@gmail.com>
--
-- Project advisors and co-authors:
-- 	Jiri Novak <jnovak@fel.cvut.cz>
-- 	Pavel Pisa <pisa@cmp.felk.cvut.cz>
-- 	Martin Jerabek <jerabma7@fel.cvut.cz>
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
-- Purpose:
--  Feature test for frame transmittion with invalid combination of configu
--  rations.
--
--------------------------------------------------------------------------------
-- Revision History:
--
--    30.6.2016   Created file
--    06.02.2018  Modified to work with the IP-XACT generated memory map
--     12.6.2018  Modified to use CAN Test lib instead of direct register
--                access functions.
--------------------------------------------------------------------------------

Library ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;
USE ieee.math_real.ALL;
use work.CANconstants.all;
USE work.CANtestLib.All;
USE work.randomLib.All;
use work.pkg_feature_exec_dispath.all;

use work.CAN_FD_register_map.all;
use work.CAN_FD_frame_format.all;

package invalid_configs_feature is
    procedure invalid_configs_feature_exec(
        variable    o               : out    feature_outputs_t;
        signal      so              : out    feature_signal_outputs_t;
        signal      rand_ctr        : inout  natural range 0 to RAND_POOL_SIZE;
        signal      iout            : in     instance_outputs_arr_t;
        signal      mem_bus         : inout  mem_bus_arr_t;
        signal      bus_level       : in     std_logic
    );

end package;


package body invalid_configs_feature is
    procedure invalid_configs_feature_exec(
        variable    o               : out    feature_outputs_t;
        signal      so              : out    feature_signal_outputs_t;
        signal      rand_ctr        : inout  natural range 0 to RAND_POOL_SIZE;
        signal      iout            : in     instance_outputs_arr_t;
        signal      mem_bus         : inout  mem_bus_arr_t;
        signal      bus_level       : in     std_logic
    ) is
        variable tx_frame           :       SW_CAN_frame_type;
        variable rx_frame           :       SW_CAN_frame_type;
        variable frame_sent         :       boolean := false;
        variable ID_1           	:       natural := 1;
        variable ID_2           	:       natural := 2;
        variable command            :       SW_command := (others => false);
    begin
        o.outcome := true;

        ------------------------------------------------------------------------
        -- Part 1
        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- Release recieve buffer 2
        ------------------------------------------------------------------------
        command.release_rec_buffer := true;
        give_controller_command(command, ID_2, mem_bus(2));

        ------------------------------------------------------------------------
        -- Send NORMAL frame with BRS = 1
        ------------------------------------------------------------------------
        CAN_generate_frame(rand_ctr, tx_frame);
        tx_frame.frame_format := NORMAL_CAN;
        tx_frame.brs := BR_SHIFT;
        CAN_send_frame(tx_frame, 1, ID_1, mem_bus(1), frame_sent);
        CAN_wait_frame_sent(ID_1, mem_bus(1));

        ------------------------------------------------------------------------
        -- Read frame. CAN 2.0 frame with no BRS bit should be received.
        ------------------------------------------------------------------------
        CAN_read_frame(rx_frame, ID_2, mem_bus(2));
        if (rx_frame.brs = BR_SHIFT or rx_frame.frame_format = FD_CAN) then
            o.outcome := false;
        end if;


        ------------------------------------------------------------------------
        -- Part 2
        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- Release recieve buffer 2
        ------------------------------------------------------------------------
        give_controller_command(command, ID_2, mem_bus(2));

        ------------------------------------------------------------------------
        -- Send FD frame with RTR = 1
        ------------------------------------------------------------------------
        CAN_generate_frame(rand_ctr, tx_frame);
        tx_frame.frame_format := FD_CAN;
        tx_frame.rtr := RTR_FRAME;
        CAN_send_frame(tx_frame, 1, ID_1, mem_bus(1), frame_sent);
        CAN_wait_frame_sent(ID_1, mem_bus(1));

        ------------------------------------------------------------------------
        -- Read frame. CAN FD Frame without RTR bit should be read
        ------------------------------------------------------------------------
        CAN_read_frame(rx_frame, ID_2, mem_bus(2));
        if (rx_frame.frame_format = NORMAL_CAN or rx_frame.rtr = RTR_FRAME) then
            o.outcome := false;
        end if;

    end procedure;

end package body;
