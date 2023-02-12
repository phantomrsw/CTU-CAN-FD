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
-- Register map implementation of: Test_registers
--------------------------------------------------------------------------------
-- This file is autogenerated, DO NOT EDIT!

Library ieee;
use ieee.std_logic_1164.all;

Library ctu_can_fd_rtl;
use ctu_can_fd_rtl.can_registers_pkg.all;
use ctu_can_fd_rtl.cmn_reg_map_pkg.all;

entity test_registers_reg_map is
generic (
    constant DATA_WIDTH          : natural := 32;
    constant ADDRESS_WIDTH       : natural := 8;
    constant REGISTERED_READ     : boolean := true;
    constant CLEAR_READ_DATA     : boolean := true
);
port (
    signal clk_sys               :in std_logic;
    signal res_n                 :in std_logic;
    signal address               :in std_logic_vector(address_width - 1 downto 0);
    signal w_data                :in std_logic_vector(data_width - 1 downto 0);
    signal r_data                :out std_logic_vector(data_width - 1 downto 0);
    signal cs                    :in std_logic;
    signal read                  :in std_logic;
    signal write                 :in std_logic;
    signal be                    :in std_logic_vector(data_width / 8 - 1 downto 0);
    signal lock_1                :in std_logic;
    signal lock_2                :in std_logic;
    signal test_registers_out    :out Test_registers_out_t;
    signal test_registers_in     :in Test_registers_in_t
);
end entity test_registers_reg_map;


architecture rtl of test_registers_reg_map is
  signal reg_sel  : std_logic_vector(3 downto 0);
  constant ADDR_VECT
                 : std_logic_vector(23 downto 0) := "000011000010000001000000";
  signal read_data_mux_in : std_logic_vector(127 downto 0);
  signal read_data_mask_n : std_logic_vector(31 downto 0);
  signal test_registers_out_i : Test_registers_out_t;
  signal write_en : std_logic_vector(3 downto 0);
begin

    write_en <= be when (write = '1' and cs = '1') else (others => '0');

    ----------------------------------------------------------------------------
    -- Write address to One-hot decoder
    ----------------------------------------------------------------------------

    address_decoder_test_registers_comp : address_decoder
    generic map(
        address_width                   => 6 ,
        address_entries                 => 4 ,
        addr_vect                       => ADDR_VECT ,
        registered_out                  => false 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        address                         => address(7 downto 2) ,-- in
        enable                          => cs ,-- in
        addr_dec                        => reg_sel -- out
    );

    ----------------------------------------------------------------------------
    -- TST_CONTROL[TMAENA]
    ----------------------------------------------------------------------------

    tst_control_tmaena_reg_comp : memory_reg_lockable
    generic map(
        data_width                      => 1 ,
        reset_value                     => "0" ,
        modified_write_val_clear        => false 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(0 downto 0) ,-- in
        write                           => write_en(0) ,-- in
        cs                              => reg_sel(0) ,-- in
        lock                            => lock_1 ,-- in
        reg_value(0)                    => test_registers_out_i.tst_control_tmaena -- out
    );

    ----------------------------------------------------------------------------
    -- TST_CONTROL[TWRSTB]
    ----------------------------------------------------------------------------

    tst_control_twrstb_reg_comp : memory_reg_lockable
    generic map(
        data_width                      => 1 ,
        reset_value                     => "0" ,
        modified_write_val_clear        => true 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(1 downto 1) ,-- in
        write                           => write_en(0) ,-- in
        cs                              => reg_sel(0) ,-- in
        lock                            => lock_1 ,-- in
        reg_value(0)                    => test_registers_out_i.tst_control_twrstb -- out
    );

    ----------------------------------------------------------------------------
    -- TST_DEST[TST_ADDR_SLICE_1]
    ----------------------------------------------------------------------------

    tst_dest_tst_addr_slice_1_reg_comp : memory_reg_lockable
    generic map(
        data_width                      => 8 ,
        reset_value                     => "00000000" ,
        modified_write_val_clear        => false 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(7 downto 0) ,-- in
        write                           => write_en(0) ,-- in
        cs                              => reg_sel(1) ,-- in
        lock                            => lock_1 ,-- in
        reg_value                       => test_registers_out_i.tst_dest_tst_addr(7 downto 0) -- out
    );

    ----------------------------------------------------------------------------
    -- TST_DEST[TST_ADDR_SLICE_2]
    ----------------------------------------------------------------------------

    tst_dest_tst_addr_slice_2_reg_comp : memory_reg_lockable
    generic map(
        data_width                      => 8 ,
        reset_value                     => "00000000" ,
        modified_write_val_clear        => false 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(15 downto 8) ,-- in
        write                           => write_en(1) ,-- in
        cs                              => reg_sel(1) ,-- in
        lock                            => lock_1 ,-- in
        reg_value                       => test_registers_out_i.tst_dest_tst_addr(15 downto 8) -- out
    );

    ----------------------------------------------------------------------------
    -- TST_DEST[TST_MTGT]
    ----------------------------------------------------------------------------

    tst_dest_tst_mtgt_reg_comp : memory_reg_lockable
    generic map(
        data_width                      => 4 ,
        reset_value                     => "0000" ,
        modified_write_val_clear        => false 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(19 downto 16) ,-- in
        write                           => write_en(2) ,-- in
        cs                              => reg_sel(1) ,-- in
        lock                            => lock_1 ,-- in
        reg_value                       => test_registers_out_i.tst_dest_tst_mtgt -- out
    );

    ----------------------------------------------------------------------------
    -- TST_WDATA[TST_WDATA_SLICE_1]
    ----------------------------------------------------------------------------

    tst_wdata_tst_wdata_slice_1_reg_comp : memory_reg_lockable
    generic map(
        data_width                      => 8 ,
        reset_value                     => "00000000" ,
        modified_write_val_clear        => false 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(7 downto 0) ,-- in
        write                           => write_en(0) ,-- in
        cs                              => reg_sel(2) ,-- in
        lock                            => lock_1 ,-- in
        reg_value                       => test_registers_out_i.tst_wdata_tst_wdata(7 downto 0) -- out
    );

    ----------------------------------------------------------------------------
    -- TST_WDATA[TST_WDATA_SLICE_2]
    ----------------------------------------------------------------------------

    tst_wdata_tst_wdata_slice_2_reg_comp : memory_reg_lockable
    generic map(
        data_width                      => 8 ,
        reset_value                     => "00000000" ,
        modified_write_val_clear        => false 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(15 downto 8) ,-- in
        write                           => write_en(1) ,-- in
        cs                              => reg_sel(2) ,-- in
        lock                            => lock_1 ,-- in
        reg_value                       => test_registers_out_i.tst_wdata_tst_wdata(15 downto 8) -- out
    );

    ----------------------------------------------------------------------------
    -- TST_WDATA[TST_WDATA_SLICE_3]
    ----------------------------------------------------------------------------

    tst_wdata_tst_wdata_slice_3_reg_comp : memory_reg_lockable
    generic map(
        data_width                      => 8 ,
        reset_value                     => "00000000" ,
        modified_write_val_clear        => false 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(23 downto 16) ,-- in
        write                           => write_en(2) ,-- in
        cs                              => reg_sel(2) ,-- in
        lock                            => lock_1 ,-- in
        reg_value                       => test_registers_out_i.tst_wdata_tst_wdata(23 downto 16) -- out
    );

    ----------------------------------------------------------------------------
    -- TST_WDATA[TST_WDATA_SLICE_4]
    ----------------------------------------------------------------------------

    tst_wdata_tst_wdata_slice_4_reg_comp : memory_reg_lockable
    generic map(
        data_width                      => 8 ,
        reset_value                     => "00000000" ,
        modified_write_val_clear        => false 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(31 downto 24) ,-- in
        write                           => write_en(3) ,-- in
        cs                              => reg_sel(2) ,-- in
        lock                            => lock_1 ,-- in
        reg_value                       => test_registers_out_i.tst_wdata_tst_wdata(31 downto 24) -- out
    );

    ----------------------------------------------------------------------------
    -- Read data multiplexor
    ----------------------------------------------------------------------------

    data_mux_test_registers_comp : data_mux
    generic map(
        data_out_width                  => 32 ,
        data_in_width                   => 128 ,
        sel_width                       => 6 ,
        registered_out                  => REGISTERED_READ 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_selector                   => address(7 downto 2) ,-- in
        data_in                         => read_data_mux_in ,-- in
        data_mask_n                     => read_data_mask_n ,-- in
        enable                          => '1' ,-- in
        data_out                        => r_data -- out
    );

  ------------------------------------------------------------------------------
  -- Read data driver
  ------------------------------------------------------------------------------
  read_data_mux_in <=
    -- Adress:12
	test_registers_in.tst_rdata_tst_rdata	&

    -- Adress:8
	test_registers_out_i.tst_wdata_tst_wdata	&

    -- Adress:4
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	test_registers_out_i.tst_dest_tst_mtgt	&
	test_registers_out_i.tst_dest_tst_addr	&

    -- Adress:0
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	'0'	&
	test_registers_out_i.tst_control_twrstb	&
	test_registers_out_i.tst_control_tmaena
;

    ----------------------------------------------------------------------------
    -- Read data mask - Byte enables
    ----------------------------------------------------------------------------
    read_data_mask_n <=
      be(3) & be(3) & be(3) & be(3) & be(3) & be(3) & be(3) & be(3) & 
      be(2) & be(2) & be(2) & be(2) & be(2) & be(2) & be(2) & be(2) & 
      be(1) & be(1) & be(1) & be(1) & be(1) & be(1) & be(1) & be(1) & 
      be(0) & be(0) & be(0) & be(0) & be(0) & be(0) & be(0) & be(0) ;

    Test_registers_out <= Test_registers_out_i;

    -- <RELEASE_OFF>
    ----------------------------------------------------------------------------
    -- Functional coverage
    ----------------------------------------------------------------------------
    --  psl default clock is rising_edge(clk_sys);
    -- psl tst_control_write_access_cov : cover
    -- {((cs='1') and (write='1') and (reg_sel(0)='1') and ((be(0)='1') or (be(1)='1') or (be(2)='1') or (be(3)='1')))};

    -- psl tst_control_read_access_cov : cover
    -- {((cs='1') and (read='1') and (reg_sel(0)='1') and ((be(0)='1') or (be(1)='1') or (be(2)='1') or (be(3)='1')))};

    -- psl tst_dest_write_access_cov : cover
    -- {((cs='1') and (write='1') and (reg_sel(1)='1') and ((be(0)='1') or (be(1)='1') or (be(2)='1') or (be(3)='1')))};

    -- psl tst_dest_read_access_cov : cover
    -- {((cs='1') and (read='1') and (reg_sel(1)='1') and ((be(0)='1') or (be(1)='1') or (be(2)='1') or (be(3)='1')))};

    -- psl tst_wdata_write_access_cov : cover
    -- {((cs='1') and (write='1') and (reg_sel(2)='1') and ((be(0)='1') or (be(1)='1') or (be(2)='1') or (be(3)='1')))};

    -- psl tst_wdata_read_access_cov : cover
    -- {((cs='1') and (read='1') and (reg_sel(2)='1') and ((be(0)='1') or (be(1)='1') or (be(2)='1') or (be(3)='1')))};

    -- psl tst_rdata_read_access_cov : cover
    -- {((cs='1') and (read='1') and (reg_sel(3)='1') and ((be(0)='1') or (be(1)='1') or (be(2)='1') or (be(3)='1')))};

    -- <RELEASE_ON>

end architecture rtl;
