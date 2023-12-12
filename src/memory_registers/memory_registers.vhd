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
-- Module:
--  Memory registers
--
-- Purpose:
--  Configuration and Status registers are implemented here. Access over 32 bit,
--  Avalon compatible interface. Write in the same clock cycle, read data are
--  returned in next clock cycle. Driving bus is created here. Memory registers
--  are generated by Register Map Generation Tool.
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

Library ctu_can_fd_rtl;
use ctu_can_fd_rtl.id_transfer_pkg.all;
use ctu_can_fd_rtl.can_constants_pkg.all;

use ctu_can_fd_rtl.can_types_pkg.all;
use ctu_can_fd_rtl.unary_ops_pkg.all;

use ctu_can_fd_rtl.CAN_FD_register_map.all;
use ctu_can_fd_rtl.CAN_FD_frame_format.all;

use ctu_can_fd_rtl.can_registers_pkg.all;

entity memory_registers is
    generic (
        -- Support Filter A
        G_SUP_FILTA             : boolean;

        -- Support Filter B
        G_SUP_FILTB             : boolean;

        -- Support Filter C
        G_SUP_FILTC             : boolean;

        -- Support Range Fi
        G_SUP_RANGE             : boolean;

        -- Support Test registers
        G_SUP_TEST_REGISTERS    : boolean;

        -- Support Traffic counters
        G_SUP_TRAFFIC_CTRS      : boolean;

        -- Support Parity
        G_SUP_PARITY            : boolean;

        -- Number of TXT Buffers
        G_TXT_BUFFER_COUNT      : natural range 2 to 8;

        -- Size of RX Buffer
        G_RX_BUFF_SIZE          : natural;

        -- Number of Interrupts
        G_INT_COUNT             : natural;

        -- Width (number of bits) in transceiver delay measurement counter
        G_TRV_CTR_WIDTH         : natural;

        -- Number of active timestamp bits
        G_TS_BITS               : natural range 0 to 63;

        -- DEVICE_ID (read from register)
        G_DEVICE_ID             : std_logic_vector(15 downto 0);

        -- MINOR Design version
        G_VERSION_MINOR         : std_logic_vector(7 downto 0);

        -- MAJOR Design version
        G_VERSION_MAJOR         : std_logic_vector(7 downto 0);

        -- Technology type
        G_TECHNOLOGY            : natural
    );
    port (
        -------------------------------------------------------------------------------------------
        -- Clock and Reset
        -------------------------------------------------------------------------------------------
        clk_sys                         : in std_logic;
        res_n                           : in std_logic;

        -- Soft reset (Input reset + Software Reset)
        res_soft_n                      : out std_logic;

        -- Core Reset (Input reset + Software Reset + Active when disabled)
        res_core_n                      : out std_logic;

        -------------------------------------------------------------------------------------------
        -- DFT support
        -------------------------------------------------------------------------------------------
        scan_enable                     : in std_logic;

        -------------------------------------------------------------------------------------------
        -- Main memory bus interface
        -------------------------------------------------------------------------------------------
        -- Data input
        data_in                         : in std_logic_vector(31 downto 0);

        -- Data output
        data_out                        : out std_logic_vector(31 downto 0);

        -- Address
        adress                          : in std_logic_vector(15 downto 0);

        -- Chip Select
        scs                             : in std_logic;

        -- Read
        srd                             : in std_logic;

        -- Write
        swr                             : in std_logic;

        -- Byte enable
        sbe                             : in std_logic_vector(3 downto 0);

        -- Timestamp input
        timestamp                       : in std_logic_vector(63 downto 0);

        -------------------------------------------------------------------------------------------
        -- Configuration and Status to/from rest of the core
        -------------------------------------------------------------------------------------------
        -- Configuration from control registers to rest of the core
        mr_ctrl_out                     : out control_registers_out_t;

        -- Configuration from test registers to rest of the core
        mr_tst_out                      : out test_registers_out_t;

        -- Status to registers from CAN core
        cc_stat                         : in  t_can_core_stat;

        -- Debug record from Protocol control
        pc_dbg                          : in  t_protocol_control_dbg;

        -- RX buffer test data in
        mr_tst_rdata_tst_rdata_rxb      : in  std_logic_vector(31 downto 0);

        -- TXT buffers test data input
        mr_tst_rdata_tst_rdata_txb      : in  t_txt_bufs_output(G_TXT_BUFFER_COUNT - 1 downto 0);

        -------------------------------------------------------------------------------------------
        -- RX Buffer Interface
        -------------------------------------------------------------------------------------------
        -- RX Buffer is full
        rx_full                         : in std_logic;

        -- RX Buffer is empty
        rx_empty                        : in std_logic;

        -- Number of frames in RX buffer
        rx_frame_count                  : in std_logic_vector(10 downto 0);

        -- Number of free 32 bit words
        rx_mem_free                     : in std_logic_vector(12 downto 0);

        -- Position of read pointer
        rx_read_pointer                 : in std_logic_vector(11 downto 0);

        -- Position of write pointer
        rx_write_pointer                : in std_logic_vector(11 downto 0);

        -- Data overrun Flag
        rx_data_overrun                 : in std_logic;

        -- Middle of frame indication
        rx_mof                          : in std_logic;

        -- RX Buffer parity error flag
        rx_parity_error                 : in std_logic;

        -- RX Buffer data output
        rxb_port_b_data_out             : in std_logic_vector(31 downto 0);

        -------------------------------------------------------------------------------------------
        -- Interface to TXT Buffers
        -------------------------------------------------------------------------------------------
        -- TXT Buffer RAM Port A - Write port
        txtb_port_a_data_in             : out std_logic_vector(31 downto 0);
        txtb_port_a_address             : out std_logic_vector(4 downto 0);
        txtb_port_a_cs                  : out std_logic_vector(G_TXT_BUFFER_COUNT - 1 downto 0);
        txtb_port_a_be                  : out std_logic_vector(3 downto 0);

        -- Prioriy of buffers
        mr_tx_priority                  : out t_txt_bufs_priorities(G_TXT_BUFFER_COUNT - 1 downto 0);

        -- Command indices (chip selects)
        mr_tx_command_txbi              : out std_logic_vector(G_TXT_BUFFER_COUNT - 1 downto 0);

        -- TXT Buffer status
        txtb_state                      : in t_txt_bufs_state(G_TXT_BUFFER_COUNT - 1 downto 0);

        -- TXT Buffer Parity Error
        txtb_parity_error_valid         : in std_logic_vector(G_TXT_BUFFER_COUNT - 1 downto 0);

        -- Parity Error in Backup buffer during TXT Buffer backup mode
        txtb_bb_parity_error            : in std_logic_vector(G_TXT_BUFFER_COUNT - 1 downto 0);

        -------------------------------------------------------------------------------------------
        -- Bus synchroniser interface
        -------------------------------------------------------------------------------------------
        -- Measured Transceiver Delay
        trv_delay                       : in std_logic_vector(G_TRV_CTR_WIDTH - 1 downto 0);

        -------------------------------------------------------------------------------------------
        -- Interrrupt Manager Interface
        -------------------------------------------------------------------------------------------
        -- Interrupt Vector
        mr_int_stat_rxi_o               : in  std_logic;
        mr_int_stat_txi_o               : in  std_logic;
        mr_int_stat_ewli_o              : in  std_logic;
        mr_int_stat_doi_o               : in  std_logic;
        mr_int_stat_fcsi_o              : in  std_logic;
        mr_int_stat_ali_o               : in  std_logic;
        mr_int_stat_bei_o               : in  std_logic;
        mr_int_stat_ofi_o               : in  std_logic;
        mr_int_stat_rxfi_o              : in  std_logic;
        mr_int_stat_bsi_o               : in  std_logic;
        mr_int_stat_rbnei_o             : in  std_logic;
        mr_int_stat_txbhci_o            : in  std_logic;

        -- Interrupt Enable
        mr_int_ena_set_int_ena_set_o    : in  std_logic_vector(G_INT_COUNT - 1 downto 0);

        -- Interrupt Mask
        mr_int_mask_set_int_mask_set_o  : in  std_logic_vector(G_INT_COUNT - 1 downto 0)
    );
end entity;

architecture rtl of memory_registers is

    -- Generated register maps inputs/outputs
    signal mr_ctrl_out_i                : control_registers_out_t;
    signal mr_ctrl_in                   : control_registers_in_t;

    signal mr_tst_out_i                 : test_registers_out_t;
    signal mr_tst_in                    : test_registers_in_t;

    -- TXT buffer outputs - padded
    signal mr_tst_rdata_tst_rdata_txb_i : t_txt_bufs_output(7 downto 0);

    -- Main chip select signal
    signal can_core_cs                  : std_logic;

    -- Chip select signals for each memory sub-block
    signal control_registers_cs         : std_logic;
    signal control_registers_cs_reg     : std_logic;

    signal test_registers_cs            : std_logic;
    signal test_registers_cs_reg        : std_logic;

    -- Read data from generated register modules
    signal control_registers_rdata      : std_logic_vector(31 downto 0);
    signal test_registers_rdata         : std_logic_vector(31 downto 0);

    -- Locks active
    signal reg_lock_1_active            : std_logic;
    signal reg_lock_2_active            : std_logic;

    -- Additional generated resets
    signal soft_res_d_n                 : std_logic;
    signal soft_res_q_n                 : std_logic;

    signal res_core_d_n                 : std_logic;

    -- Clock gating for register map
    signal control_regs_clk_en          : std_logic;
    signal test_regs_clk_en             : std_logic;

    signal clk_control_regs             : std_logic;
    signal clk_test_regs                : std_logic;

begin

    -----------------------------------------------------------------------------------------------
    -- Propagation of Avalon Data Bus to TXT Buffer RAM
    -----------------------------------------------------------------------------------------------
    txtb_port_a_data_in <= data_in;

    -----------------------------------------------------------------------------------------------
    -- Since TX_DATA registers are in separate region, which is word aligned, it is enough to take
    -- the lowest bits to create the address offset.
    -----------------------------------------------------------------------------------------------
    txtb_port_a_address <= adress(6 downto 2);

    -----------------------------------------------------------------------------------------------
    -- TXT Buffer RAMs chip select signals.
    -----------------------------------------------------------------------------------------------
    txtb_port_a_cs_gen : for i in 0 to G_TXT_BUFFER_COUNT - 1 generate
        type tx_buff_addr_type is array (0 to 7) of
            std_logic_vector(3 downto 0);
        constant buf_addr : tx_buff_addr_type := (
            TX_BUFFER_1_BLOCK, TX_BUFFER_2_BLOCK,
            TX_BUFFER_3_BLOCK, TX_BUFFER_4_BLOCK,
            TX_BUFFER_5_BLOCK, TX_BUFFER_6_BLOCK,
            TX_BUFFER_7_BLOCK, TX_BUFFER_8_BLOCK
        );

    begin
        txtb_port_a_cs(i) <= '1' when ((adress(11 downto 8) = buf_addr(i)) and
                                        scs = '1' and swr = '1')
                                 else
                             '0';
    end generate txtb_port_a_cs_gen;

    txtb_port_a_be <= sbe;

    can_core_cs <= '1' when (scs = ACT_CSC) else
                   '0';

    -----------------------------------------------------------------------------------------------
    -- Chip selects for register map blocks
    -----------------------------------------------------------------------------------------------
    control_registers_cs <= '1' when (adress(11 downto 8) = CONTROL_REGISTERS_BLOCK) and
                                     (can_core_cs = '1')
                                else
                            '0';

    test_registers_cs <= '1' when (adress(11 downto 8) = TEST_REGISTERS_BLOCK) and
                                  (can_core_cs = '1')
                             else
                         '0';

    -----------------------------------------------------------------------------------------------
    -- Registering control registers chip select
    -----------------------------------------------------------------------------------------------
    chip_sel_reg_proc : process(res_n, clk_sys)
    begin
        if (res_n = '0') then
            control_registers_cs_reg  <= '0';
            test_registers_cs_reg <= '0';
        elsif (rising_edge(clk_sys)) then
            control_registers_cs_reg  <= control_registers_cs;
            test_registers_cs_reg <= test_registers_cs;
        end if;
    end process;

    -----------------------------------------------------------------------------------------------
    -- Read data multiplexor. Use registered version of chip select signals since read data are
    -- returned one clock cycle later!
    -----------------------------------------------------------------------------------------------
    data_out <= control_registers_rdata when (control_registers_cs_reg = '1') else
                   test_registers_rdata when (test_registers_cs_reg = '1') else
                        (others => '0');

    -----------------------------------------------------------------------------------------------
    -- Clock gating - Ungate clocks for read or write. Note that write enable / read enable is
    -- still brought also to register map! This is for FPGA implementation where clock gate is
    -- transparent!
    -----------------------------------------------------------------------------------------------
    control_regs_clk_en <= '1' when (srd = '1' or swr = '1') and (control_registers_cs = '1')
                               else
                           '0';

    test_regs_clk_en <= '1' when (srd = '1' or swr = '1') and (test_registers_cs = '1')
                            else
                        '0';

    clk_gate_control_regs_comp : entity ctu_can_fd_rtl.clk_gate
    generic map(
        G_TECHNOLOGY       => G_TECHNOLOGY
    )
    port map(
        clk_in             => clk_sys,                          -- IN
        clk_en             => control_regs_clk_en,              -- IN
        scan_enable        => scan_enable,                      -- IN

        clk_out            => clk_control_regs                  -- OUT
    );

    clk_gate_test_regs_comp : entity ctu_can_fd_rtl.clk_gate
    generic map(
        G_TECHNOLOGY       => G_TECHNOLOGY
    )
    port map(
        clk_in             => clk_sys,                          -- IN
        clk_en             => test_regs_clk_en,                 -- IN
        scan_enable        => scan_enable,                      -- IN

        clk_out            => clk_test_regs                     -- OUT
    );

    -----------------------------------------------------------------------------------------------
    -- Control registers instance
    -----------------------------------------------------------------------------------------------
    control_registers_reg_map_comp : entity ctu_can_fd_rtl.control_registers_reg_map
    generic map(
        DATA_WIDTH            => 32,
        ADDRESS_WIDTH         => 16,
        REGISTERED_READ       => true,
        CLEAR_READ_DATA       => false,
        SUP_FILT_A            => G_SUP_FILTA,
        SUP_RANGE             => G_SUP_RANGE,
        SUP_FILT_C            => G_SUP_FILTC,
        SUP_FILT_B            => G_SUP_FILTB,
        SUP_TRAFFIC_CTRS      => G_SUP_TRAFFIC_CTRS
    )
    port map(
        clk_sys               => clk_control_regs,              -- IN
        res_n                 => soft_res_q_n,                  -- IN
        address               => adress,                        -- IN
        w_data                => data_in,                       -- IN
        r_data                => control_registers_rdata,       -- OUT
        cs                    => control_registers_cs,          -- IN
        read                  => srd,                           -- IN
        write                 => swr,                           -- IN
        be                    => sbe,                           -- IN
        lock_1                => reg_lock_1_active,             -- IN
        lock_2                => reg_lock_2_active,             -- IN
        control_registers_out => mr_ctrl_out_i,                 -- OUT
        control_registers_in  => mr_ctrl_in                     -- IN
    );
    mr_ctrl_out <= mr_ctrl_out_i;

    -----------------------------------------------------------------------------------------------
    -- Test registers instance
    -----------------------------------------------------------------------------------------------
    test_registers_gen_true : if (G_SUP_TEST_REGISTERS) generate
        test_registers_reg_map_comp : entity ctu_can_fd_rtl.test_registers_reg_map
        generic map (
            DATA_WIDTH          => 32,
            ADDRESS_WIDTH       => 16,
            REGISTERED_READ     => true,
            CLEAR_READ_DATA     => false
        )
        port map(
            clk_sys             => clk_test_regs,               -- IN
            res_n               => soft_res_q_n,                -- IN
            address             => adress,                      -- IN
            w_data              => data_in,                     -- IN
            r_data              => test_registers_rdata,        -- OUT
            cs                  => test_registers_cs,           -- IN
            read                => srd,                         -- IN
            write               => swr,                         -- IN
            be                  => sbe,                         -- IN
            lock_1              => reg_lock_1_active,           -- IN
            lock_2              => reg_lock_2_active,           -- IN
            test_registers_out  => mr_tst_out_i,                -- OUT
            test_registers_in   => mr_tst_in                    -- IN
        );

        -- Padding to full width of possible TXT Buffers
        txt_buf_test_data_padding_gen : for i in 0 to 7 generate

            txt_buf_padding_index_gen_true : if (i < G_TXT_BUFFER_COUNT) generate
                mr_tst_rdata_tst_rdata_txb_i(i) <= mr_tst_rdata_tst_rdata_txb(i);
            end generate txt_buf_padding_index_gen_true;

            txt_buf_padding_index_gen_false : if (i >= G_TXT_BUFFER_COUNT) generate
                mr_tst_rdata_tst_rdata_txb_i(i) <= (others => '0');
            end generate txt_buf_padding_index_gen_false;

        end generate;

        -- Select test read data from RX buffer and TXT buffers
        with mr_tst_out_i.tst_dest_tst_mtgt select mr_tst_in.tst_rdata_tst_rdata <=
                 mr_tst_rdata_tst_rdata_rxb when TMTGT_RXBUF,
            mr_tst_rdata_tst_rdata_txb_i(0) when TMTGT_TXTBUF1,
            mr_tst_rdata_tst_rdata_txb_i(1) when TMTGT_TXTBUF2,
            mr_tst_rdata_tst_rdata_txb_i(2) when TMTGT_TXTBUF3,
            mr_tst_rdata_tst_rdata_txb_i(3) when TMTGT_TXTBUF4,
            mr_tst_rdata_tst_rdata_txb_i(4) when TMTGT_TXTBUF5,
            mr_tst_rdata_tst_rdata_txb_i(5) when TMTGT_TXTBUF6,
            mr_tst_rdata_tst_rdata_txb_i(6) when TMTGT_TXTBUF7,
            mr_tst_rdata_tst_rdata_txb_i(7) when TMTGT_TXTBUF8,
                            (others => '0') when others;

    end generate test_registers_gen_true;

    test_registers_gen_false : if (not G_SUP_TEST_REGISTERS) generate
        test_registers_rdata <= (others => '0');
        mr_tst_in.tst_rdata_tst_rdata <= (others => '0');
        mr_tst_out_i <= ('0', '0', (others => '0'), (others => '0'), (others => '0'));
        mr_tst_rdata_tst_rdata_txb_i <= (others => (others => '0'));
    end generate;

    mr_tst_out <= mr_tst_out_i;

    -----------------------------------------------------------------------------------------------
    -- Lock signals
    -----------------------------------------------------------------------------------------------
    -- Lock 1 - Locked when MODE[TSTM] = 0
    reg_lock_1_active <= not mr_ctrl_out_i.mode_tstm;

    -- Lock 2 - Locked when SETTINGS[ENA] = 1
    reg_lock_2_active <= mr_ctrl_out_i.settings_ena;

    -----------------------------------------------------------------------------------------------
    -- Two reset registers:
    --  1. Soft reset - Resets memory registers
    --  2. Core reset - Resets rest of the core when disabled.
    --
    -- Both need to be gated to inactive value in Scan mode since they reset other flops.
    -----------------------------------------------------------------------------------------------

    -- Writing MODE[RST] = 1 causes Soft Reset
    soft_res_d_n <= not mr_ctrl_out_i.mode_rst;

    soft_rst_rst_reg_inst : entity ctu_can_fd_rtl.rst_reg
    generic map (
        G_RESET_POLARITY    => '0'
    )
    port map(
        -- Clock and Reset
        clk                 => clk_sys,                         -- IN
        arst                => res_n,                           -- IN

        -- Flip flop input / output
        d                   => soft_res_d_n,                    -- IN
        q                   => soft_res_q_n,                    -- OUT

        -- Scan mode control
        scan_enable         => scan_enable                      -- IN
    );

    -- Reset of the rest of core is the same as soft reset, but it is also active when
    -- SETTINGS[ENA] = '0'. Thus disabled node has all of its logic in reset!
    res_core_d_n <= '0' when (mr_ctrl_out_i.mode_rst = '1' or mr_ctrl_out_i.settings_ena = '0')
                        else
                    '1';

    global_rst_rst_reg_inst : entity ctu_can_fd_rtl.rst_reg
    generic map (
        G_RESET_POLARITY    => '0'
    )
    port map(
        -- Clock and Reset
        clk                 => clk_sys,                         -- IN
        arst                => res_n,                           -- IN

        -- Flip flop input / output
        d                   => res_core_d_n,                    -- IN
        q                   => res_core_n,                      -- OUT

        -- Scan mode control
        scan_enable         => scan_enable                      -- IN
    );

    -----------------------------------------------------------------------------------------------
    -- Reset propagation to output
    -----------------------------------------------------------------------------------------------
    res_soft_n <= soft_res_q_n;

    -----------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    -- Control registers - Write Data to Driving Bus connection
    -----------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------

    mr_tx_priority(0)       <= mr_ctrl_out_i.tx_priority_txt1p;
    mr_tx_command_txbi(0)   <= mr_ctrl_out_i.tx_command_txb1;

    mr_tx_priority(1)       <= mr_ctrl_out_i.tx_priority_txt2p;
    mr_tx_command_txbi(1)   <= mr_ctrl_out_i.tx_command_txb2 when (mr_ctrl_out_i.mode_txbbm = '0')
                                                             else
                               mr_ctrl_out_i.tx_command_txb1 or mr_ctrl_out_i.tx_command_txb2;

    mt_2_txt_buffs : if (G_TXT_BUFFER_COUNT > 2) generate
        mr_tx_priority(2)       <= mr_ctrl_out_i.tx_priority_txt3p;
        mr_tx_command_txbi(2)   <= mr_ctrl_out_i.tx_command_txb3;
    end generate;

    mt_3_txt_buffs : if (G_TXT_BUFFER_COUNT > 3) generate
        mr_tx_priority(3)       <= mr_ctrl_out_i.tx_priority_txt4p;
        mr_tx_command_txbi(3)   <= mr_ctrl_out_i.tx_command_txb4 when (mr_ctrl_out_i.mode_txbbm = '0')
                                                                 else
                                   mr_ctrl_out_i.tx_command_txb3 or mr_ctrl_out_i.tx_command_txb4;
    end generate;

    mt_4_txt_buffs : if (G_TXT_BUFFER_COUNT > 4) generate
        mr_tx_priority(4)       <= mr_ctrl_out_i.tx_priority_txt5p;
        mr_tx_command_txbi(4)   <= mr_ctrl_out_i.tx_command_txb5;
    end generate;

    mt_5_txt_buffs : if (G_TXT_BUFFER_COUNT > 5) generate
        mr_tx_priority(5)       <= mr_ctrl_out_i.tx_priority_txt6p;
        mr_tx_command_txbi(5)   <= mr_ctrl_out_i.tx_command_txb6 when (mr_ctrl_out_i.mode_txbbm = '0')
                                                                 else
                                   mr_ctrl_out_i.tx_command_txb5 or mr_ctrl_out_i.tx_command_txb6;
    end generate;

    mt_6_txt_buffs : if (G_TXT_BUFFER_COUNT > 6) generate
        mr_tx_priority(6)       <= mr_ctrl_out_i.tx_priority_txt7p;
        mr_tx_command_txbi(6)   <= mr_ctrl_out_i.tx_command_txb7;
    end generate;

    mt_7_txt_buffs : if (G_TXT_BUFFER_COUNT > 7) generate
        mr_tx_priority(7)       <= mr_ctrl_out_i.tx_priority_txt8p;
        mr_tx_command_txbi(7)   <= mr_ctrl_out_i.tx_command_txb8 when (mr_ctrl_out_i.mode_txbbm = '0')
                                                                 else
                                   mr_ctrl_out_i.tx_command_txb7 or mr_ctrl_out_i.tx_command_txb8;
    end generate;

    -----------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    -- Control registers - Read Data to status signals connection
    -----------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------

    -- DEVICE ID
    mr_ctrl_in.device_id_device_id <= G_DEVICE_ID;

    -- VERSION
    mr_ctrl_in.version_ver_minor <= G_VERSION_MINOR;
    mr_ctrl_in.version_ver_major <= G_VERSION_MAJOR;

    -- STATUS
    mr_ctrl_in.status_idle <= '1' when (cc_stat.is_bus_off = '1') else
                              '1' when (cc_stat.is_idle = '1') else
                              '0';
    mr_ctrl_in.status_ewl <= cc_stat.status_ewl;
    mr_ctrl_in.status_txs <= cc_stat.is_transmitter;
    mr_ctrl_in.status_rxs <= cc_stat.is_receiver;

    -- Go through TXT Buffers and check at least one is empty
    txnf_calc_proc : process(txtb_state)
    begin
        mr_ctrl_in.status_txnf <= '0';
        for i in 0 to G_TXT_BUFFER_COUNT - 1 loop
            if (txtb_state(i) = TXT_ETY) then
                mr_ctrl_in.status_txnf <= '1';
            end if;
        end loop;
    end process;

    mr_ctrl_in.status_rxne <= not rx_empty;
    mr_ctrl_in.status_dor <= rx_data_overrun;
    mr_ctrl_in.status_eft <= pc_dbg.is_err;
    mr_ctrl_in.status_pexs <= cc_stat.status_pexs;
    mr_ctrl_in.status_rxpe <= rx_parity_error;

    -- TXT Buffer parity error and double parity error
    txpe_flag_proc : process(res_n, clk_sys)
    begin
        if (res_n = '0') then
            mr_ctrl_in.status_txpe <= '0';
            mr_ctrl_in.status_txdpe <= '0';
        elsif rising_edge(clk_sys) then
            for i in 0 to G_TXT_BUFFER_COUNT - 1 loop
                if (txtb_parity_error_valid(i) = '1') then
                    mr_ctrl_in.status_txpe <= '1';
                end if;

                if (txtb_bb_parity_error(i) = '1') then
                    mr_ctrl_in.status_txdpe <= '1';
                end if;
            end loop;

            if (mr_ctrl_out_i.command_ctxpe = '1') then
                mr_ctrl_in.status_txpe <= '0';
            end if;

            if (mr_ctrl_out_i.command_ctxdpe = '1') then
                mr_ctrl_in.status_txdpe <= '0';
            end if;
        end if;
    end process;

    mr_ctrl_in.status_stcnt <= '1' when G_SUP_TRAFFIC_CTRS
                                   else
                               '0';
    mr_ctrl_in.status_sprt <= '1' when G_SUP_PARITY
                                  else
                              '0';
    mr_ctrl_in.status_strgs <= '1' when G_SUP_TEST_REGISTERS
                                   else
                               '0';

    -- INT_STAT
    mr_ctrl_in.int_stat_rxi    <= mr_int_stat_rxi_o;
    mr_ctrl_in.int_stat_txi    <= mr_int_stat_txi_o;
    mr_ctrl_in.int_stat_ewli   <= mr_int_stat_ewli_o;
    mr_ctrl_in.int_stat_doi    <= mr_int_stat_doi_o;
    mr_ctrl_in.int_stat_fcsi   <= mr_int_stat_fcsi_o;
    mr_ctrl_in.int_stat_ali    <= mr_int_stat_ali_o;
    mr_ctrl_in.int_stat_bei    <= mr_int_stat_bei_o;
    mr_ctrl_in.int_stat_ofi    <= mr_int_stat_ofi_o;
    mr_ctrl_in.int_stat_rxfi   <= mr_int_stat_rxfi_o;
    mr_ctrl_in.int_stat_bsi    <= mr_int_stat_bsi_o;
    mr_ctrl_in.int_stat_rbnei  <= mr_int_stat_rbnei_o;
    mr_ctrl_in.int_stat_txbhci <= mr_int_stat_txbhci_o;

    -- INT_ENA_SET
    mr_ctrl_in.int_ena_set_int_ena_set <= mr_int_ena_set_int_ena_set_o;

    -- INT_MASK_SET
    mr_ctrl_in.int_mask_set_int_mask_set <= mr_int_mask_set_int_mask_set_o;

    -- FAULT_STATE
    mr_ctrl_in.fault_state_era <= cc_stat.is_err_active;
    mr_ctrl_in.fault_state_erp <= cc_stat.is_err_passive;
    mr_ctrl_in.fault_state_bof <= cc_stat.is_bus_off;

    -- REC
    mr_ctrl_in.rec_rec_val <= cc_stat.rx_err_ctr;

    -- TEC
    mr_ctrl_in.tec_tec_val <= cc_stat.tx_err_ctr;

    -- ERR_NORM
    mr_ctrl_in.err_norm_err_norm_val <= cc_stat.norm_err_ctr;
    mr_ctrl_in.err_fd_err_fd_val     <= cc_stat.data_err_ctr;

    -- FILTER_STATUS
    mr_ctrl_in.filter_status_sfa <= '1' when G_SUP_FILTA else
                                    '0';

    mr_ctrl_in.filter_status_sfb <= '1' when G_SUP_FILTB else
                                    '0';

    mr_ctrl_in.filter_status_sfc <= '1' when G_SUP_FILTC else
                                    '0';

    mr_ctrl_in.filter_status_sfr <= '1' when G_SUP_RANGE else
                                    '0';

    -- RX_MEM_INFO
    mr_ctrl_in.rx_mem_info_rx_buff_size <= std_logic_vector(to_unsigned(G_RX_BUFF_SIZE, 13));
    mr_ctrl_in.rx_mem_info_rx_mem_free  <= rx_mem_free;

    -- RX_POINTERS
    mr_ctrl_in.rx_pointers_rx_wpp <= rx_write_pointer;
    mr_ctrl_in.rx_pointers_rx_rpp <= rx_read_pointer;

    -- RX_STATUS register
    mr_ctrl_in.rx_status_rxe   <= rx_empty;
    mr_ctrl_in.rx_status_rxf   <= rx_full;
    mr_ctrl_in.rx_status_rxmof <= rx_mof;
    mr_ctrl_in.rx_status_rxfrc <= rx_frame_count;

    -- RX_DATA register - Read data word from RX Buffer FIFO.
    mr_ctrl_in.rx_data_rx_data <= rxb_port_b_data_out;

    -- TX_STATUS register
    tx_status_proc : process(txtb_state)
        variable txtb_state_padded : t_txt_bufs_state(7 downto 0);
    begin
        txtb_state_padded := (others => (others => '0'));
        txtb_state_padded(G_TXT_BUFFER_COUNT - 1 downto 0) := txtb_state;

        mr_ctrl_in.tx_status_tx1s <= txtb_state_padded(0);
        mr_ctrl_in.tx_status_tx2s <= txtb_state_padded(1);
        mr_ctrl_in.tx_status_tx3s <= txtb_state_padded(2);
        mr_ctrl_in.tx_status_tx4s <= txtb_state_padded(3);
        mr_ctrl_in.tx_status_tx5s <= txtb_state_padded(4);
        mr_ctrl_in.tx_status_tx6s <= txtb_state_padded(5);
        mr_ctrl_in.tx_status_tx7s <= txtb_state_padded(6);
        mr_ctrl_in.tx_status_tx8s <= txtb_state_padded(7);
    end process;

    -- TXTB_INFO
    mr_ctrl_in.txtb_info_txt_buffer_count <= std_logic_vector(to_unsigned(G_TXT_BUFFER_COUNT, 4));

    -- ERR_CAPT
    mr_ctrl_in.err_capt_err_pos  <= cc_stat.err_pos;
    mr_ctrl_in.err_capt_err_type <= cc_stat.err_type;

    -- RETR_CTR
    mr_ctrl_in.retr_ctr_retr_ctr_val <= cc_stat.retr_ctr;

    -- ALC
    mr_ctrl_in.alc_alc_bit      <= cc_stat.alc_bit;
    mr_ctrl_in.alc_alc_id_field <= cc_stat.alc_id_field;

    -- TS_INFO
    mr_ctrl_in.ts_info_ts_bits <= std_logic_vector(to_unsigned(G_TS_BITS, 6));

    -- TRV_DELAY
    mr_ctrl_in.trv_delay_trv_delay_value <= trv_delay;

    -- RX_FR_CTR
    mr_ctrl_in.rx_fr_ctr_rx_fr_ctr_val <= cc_stat.rx_frame_ctr;

    -- TX_FR_CTR
    mr_ctrl_in.tx_fr_ctr_tx_fr_ctr_val <= cc_stat.tx_frame_ctr;

    -- DEBUG
    mr_ctrl_in.debug_register_stuff_count   <= cc_stat.bst_ctr;
    mr_ctrl_in.debug_register_destuff_count <= cc_stat.dst_ctr;
    mr_ctrl_in.debug_register_pc_arb        <= pc_dbg.is_arbitration;
    mr_ctrl_in.debug_register_pc_con        <= pc_dbg.is_control;
    mr_ctrl_in.debug_register_pc_dat        <= pc_dbg.is_data;
    mr_ctrl_in.debug_register_pc_stc        <= pc_dbg.is_stuff_count;
    mr_ctrl_in.debug_register_pc_crc        <= pc_dbg.is_crc;
    mr_ctrl_in.debug_register_pc_crcd       <= pc_dbg.is_crc_delim;
    mr_ctrl_in.debug_register_pc_ack        <= pc_dbg.is_ack;
    mr_ctrl_in.debug_register_pc_ackd       <= pc_dbg.is_ack_delim;
    mr_ctrl_in.debug_register_pc_eof        <= pc_dbg.is_eof;
    mr_ctrl_in.debug_register_pc_int        <= pc_dbg.is_intermission;
    mr_ctrl_in.debug_register_pc_susp       <= pc_dbg.is_suspend;
    mr_ctrl_in.debug_register_pc_ovr        <= pc_dbg.is_overload;
    mr_ctrl_in.debug_register_pc_sof        <= pc_dbg.is_sof;

    -- YOLO
    mr_ctrl_in.yolo_reg_yolo_val <= YOLO_VAL_RSTVAL;

    -- TIMESTAMP_LOW, TIMESTAMP_HIGH
    mr_ctrl_in.timestamp_low_timestamp_low   <= timestamp(31 downto 0);
    mr_ctrl_in.timestamp_high_timestamp_high <= timestamp(63 downto 32);

    -- <RELEASE_OFF>
    -- pragma translate_off
    -----------------------------------------------------------------------------------------------
    -- Assertions / Functional coverage
    -----------------------------------------------------------------------------------------------

    -- psl default clock is rising_edge(clk_sys);

    -- psl no_simul_two_reg_block_access_asrt : assert never
    --   (control_registers_cs_reg = '1' and test_registers_cs_reg = '1')
    --   report "Control registers and test registers can't be accessed at once!";

    -- psl no_rxpe_when_parity_disabled_cov : assert never
    --  (mr_ctrl_out_i.settings_pchke = '0' and rx_parity_error = '1')
    --  report "RX Parity error generated when SETTINGS[PCHKE] is disabled.";

    -- psl no_txpe_when_parity_disabled_cov : assert never
    --  (mr_ctrl_out_i.settings_pchke = '0' and mr_ctrl_in.status_txpe = '1')
    --  report "TX Parity error generated when SETTINGS[PCHKE] is disabled.";

    -- psl no_txdpe_when_parity_disabled_cov : assert never
    --  (mr_ctrl_out_i.settings_pchke = '0' and mr_ctrl_in.status_txdpe = '1')
    --  report "TX Double parity error generated when SETTINGS[PCHKE] is disabled.";

    txtb_func_cov_gen : for i in 0 to G_TXT_BUFFER_COUNT - 1 generate
    begin

        process (txtb_state, mr_ctrl_out_i.settings_pchke)
        begin
            if (mr_ctrl_out_i.settings_pchke = '0' and txtb_state(i) = TXT_PER) then
                report "TXT Buffer in 'Parity error' state when SETTINGS[PCHKE] is disabled."
                severity error;
            end if;
        end process;

    end generate;

    -- psl rx_buf_automatic_mode_cov : cover
    --   {mr_ctrl_out_i.mode_rxbam = RXBAM_ENABLED};

    -- psl rx_buf_manual_mode_cov : cover
    --   {mr_ctrl_out_i.mode_rxbam = RXBAM_DISABLED};

    -- pragma translate_on
    -- <RELEASE_ON>

end architecture;
