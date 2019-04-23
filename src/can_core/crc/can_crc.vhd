--------------------------------------------------------------------------------
-- 
-- CTU CAN FD IP Core
-- Copyright (C) 2015-2018
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
-- Purpose:
--  CRC calculation for CTU CAN FD. Contains:
--      1 * CRC 15 from RX Data
--      1 * CRC 17 from RX/TX Data (multiplexed)
--      1 * CRC 21 from RX/TX Data (multiplexed)
--
--  CRCs are multiplexed combinationally and final CRC is chosen on output.
--  CRCs for 15 are always calculated from RX Data since in CAN 2.0 data will
--  be always settled at latest in sample point of the actual bit.
--  CRCs for 17 and 21 are calculated from TX Data for transmitter and from RX
--  Data for receiver. Thus if unit loses the arbitration, CRC source will
--  switch! Transmitter in Data Bit rate can't calculate CRC from RX Data,
--  because Data might not yet arrived to RX pin (due to Transceiver delay)!
--------------------------------------------------------------------------------
-- Revision History:
--    28.12.2018    Created file
--     24.3.2019    Modified to calculate only 5 CRCs instead of 12.
--      1.4.2019    Used only single CRC 17 and CRC 21 according to proposal
--                  by Martin Jerabek.
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

Library work;
use work.id_transfer.all;
use work.can_constants.all;
use work.can_components.all;
use work.can_types.all;
use work.cmn_lib.all;
use work.drv_stat_pkg.all;
use work.endian_swap.all;
use work.reduce_lib.all;

use work.CAN_FD_register_map.all;
use work.CAN_FD_frame_format.all;

entity can_crc is
    generic(
        -- Reset polarity
        G_RESET_POLARITY    :     std_logic := '0';
        
        -- CRC 15 polynomial
        G_CRC15_POL         :     std_logic_vector(15 downto 0) := x"C599";
        
        -- CRC 17 polynomial
        G_CRC17_POL         :     std_logic_vector(19 downto 0) := x"3685B";
        
        -- CRC 15 polynomial
        G_CRC21_POL         :     std_logic_vector(23 downto 0) := x"302899"  
    );
    port(
        ------------------------------------------------------------------------
        -- System clock and Asynchronous Reset
        ------------------------------------------------------------------------
        -- System clock
        clk_sys          :in   std_logic;

        -- Asynchronous reset
        res_n            :in   std_logic;

        ------------------------------------------------------------------------
        -- Memory registers interface
        ------------------------------------------------------------------------
        -- Driving bus
        drv_bus          :in   std_logic_vector(1023 downto 0);

        ------------------------------------------------------------------------
        -- Data inputs for CRC calculation
        ------------------------------------------------------------------------
        -- TX Data with Bit Stuffing
        data_tx_wbs      :in   std_logic;
        
        -- RX Data with Bit Stuffing
        data_rx_wbs      :in   std_logic;
        
        -- RX Data without Bit Stuffing
        data_rx_nbs      :in   std_logic;

        ------------------------------------------------------------------------
        -- Trigger signals to process the data on each CRC input.
        ------------------------------------------------------------------------
        -- Trigger for TX Data with Bit Stuffing
        trig_tx_wbs      :in   std_logic;
        
        -- Trigger for RX Data with Bit Stuffing
        trig_rx_wbs      :in   std_logic;
        
        -- Trigger for RX Data without Bit Stuffing
        trig_rx_nbs      :in   std_logic;

        ------------------------------------------------------------------------
        -- Control signals
        ------------------------------------------------------------------------
        -- Enable for all CRC circuits.
        crc_enable       :in   std_logic;

        -- CRC calculation - speculative enable
        crc_spec_enable  :in   std_logic;

        -- Unit is receiver of a frame
        is_receiver      :in   std_logic;

        -- CRC source (CRC15, CRC17, CRC21)
        crc_src          :in   std_logic_vector(1 downto 0);

        ------------------------------------------------------------------------
        -- CRC Outputs
        ------------------------------------------------------------------------
        -- Calculated CRC 15
        crc_15           :out  std_logic_vector(14 downto 0);

        -- Calculated CRC 17
        crc_17           :out  std_logic_vector(16 downto 0);
        
        -- Calculated CRC 21
        crc_21           :out  std_logic_vector(20 downto 0)
    );
end entity;

architecture rtl of can_crc is

    -- ISO CAN FD or NON ISO CAN FD Value
    signal drv_fd_type      :     std_logic;

    -- Initialization vectors
    signal init_vect_15     :     std_logic_vector(14 downto 0);
    signal init_vect_17     :     std_logic_vector(16 downto 0);
    signal init_vect_21     :     std_logic_vector(20 downto 0); 

    ---------------------------------------------------------------------------
    -- Immediate outputs of CRC circuits
    ---------------------------------------------------------------------------

    -- Data inputs to CRC 17 and CRC 21
    signal crc_17_21_data_in   :     std_logic;

    -- Triggers for CRC 17 and 21
    signal crc_17_21_trigger   :     std_logic;
    
    -- Internal enable signals
    signal crc_ena_15          :     std_logic;
    signal crc_ena_17_21       :     std_logic;
    
begin

    -- ISO vs NON-ISO FD for selection of initialization vectors of 17 and 21.
    drv_fd_type         <= drv_bus(DRV_FD_TYPE_INDEX);

    -- For CRC 15 Init vector is constant zeroes
    init_vect_15        <= (OTHERS => '0');

    ---------------------------------------------------------------------------
    -- For CRC 17 and 21, Init vector depends on ISO/NON-ISO type. For
    -- ISO type highest bit is in logic 2.
    ---------------------------------------------------------------------------
    init_vect_17(16)    <= '1' when (drv_fd_type = ISO_FD)
                               else
                           '0';
    init_vect_17(15 downto 0) <= (OTHERS => '0');

    init_vect_21(20)    <= '1' when (drv_fd_type = ISO_FD)
                               else
                           '0';
    init_vect_21(19 downto 0) <= (OTHERS => '0');

    ---------------------------------------------------------------------------
    -- Muxes for CRC 17,21. For Receiver choose crc from RX Stream,
    -- for Transmitter use CRC from TX Stream.
    ---------------------------------------------------------------------------
    crc_17_21_data_in <= data_rx_wbs when (is_receiver = '1')
                                     else
                         data_tx_wbs;

    crc_17_21_trigger <= trig_rx_wbs when (is_receiver = '1')
                                     else
                         trig_tx_wbs;

    ---------------------------------------------------------------------------
    -- CRC circuits calculate data with according trigger when enabled by
    -- one of two enable signals:
    --  1  Regular - CRC processes data regardless of data value.
    --  2. Speculative - Processes data value only if it is DOMINANT! This
    --     corresponds to processing DOMINANT bit in IDLE, Suspend or
    --     Intermission and considering this bit as SOF! This bit must be
    --     included in CRC calculation, but only when it is DOMINANT!
    ---------------------------------------------------------------------------
    crc_ena_15   <= '1' when (crc_enable = '1')
                        else
                    '1' when (crc_spec_enable = '1' and data_rx_nbs = DOMINANT)
                        else
                    '0';

    crc_ena_17_21  <= '1' when (crc_enable = '1')
                          else
                      '1' when (crc_spec_enable = '1' and data_rx_wbs = DOMINANT)
                          else
                      '0';

    ----------------------------------------------------------------------------
    -- CRC 15 (from RX Data, no Bit Stuffing)
    ----------------------------------------------------------------------------
    crc_calc_15_comp : crc_calc
    generic map(
        G_CRC_WIDTH       => 15,
        G_RESET_POLARITY  => G_RESET_POLARITY,
        G_POLYNOMIAL      => G_CRC15_POL
    )
    port map(
        res_n           => res_n,
        clk_sys         => clk_sys,

        data_in         => data_rx_nbs,
        trig            => trig_rx_nbs,
        enable          => crc_ena_15,
        init_vect       => init_vect_15,
        crc             => crc_15
    );

    ----------------------------------------------------------------------------
    -- CRC 17 (from TX or RX Data, with Bit Stuffing)
    ----------------------------------------------------------------------------
    crc_calc_17_rx_comp : crc_calc
    generic map(
        G_CRC_WIDTH       => 17,
        G_RESET_POLARITY  => G_RESET_POLARITY,
        G_POLYNOMIAL      => G_CRC17_POL
    )
    port map(
        res_n           => res_n,
        clk_sys         => clk_sys,

        data_in         => crc_17_21_data_in,
        trig            => crc_17_21_trigger,
        enable          => crc_ena_17_21,
        init_vect       => init_vect_17,
        crc             => crc_17
    );


    ----------------------------------------------------------------------------
    -- CRC 21 (from TX or RX Data, with Bit Stuffing)
    ----------------------------------------------------------------------------
    crc_calc_21_rx_comp : crc_calc
    generic map(
        G_CRC_WIDTH       => 21,
        G_RESET_POLARITY  => G_RESET_POLARITY,
        G_POLYNOMIAL      => G_CRC21_POL
    )
    port map(
        res_n           => res_n,
        clk_sys         => clk_sys,

        data_in         => crc_17_21_data_in,
        trig            => crc_17_21_trigger,
        enable          => crc_ena_17_21,
        init_vect       => init_vect_21,
        crc             => crc_21
    );

end architecture;