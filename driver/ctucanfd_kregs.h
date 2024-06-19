/* SPDX-License-Identifier: GPL-2.0-or-later */
/*******************************************************************************
 *
 * CTU CAN FD IP Core
 *
 * Copyright (C) 2015-2018 Ondrej Ille <ondrej.ille@gmail.com> FEE CTU
 * Copyright (C) 2018-2020 Ondrej Ille <ondrej.ille@gmail.com> self-funded
 * Copyright (C) 2018-2019 Martin Jerabek <martin.jerabek01@gmail.com> FEE CTU
 * Copyright (C) 2018-2020 Pavel Pisa <pisa@cmp.felk.cvut.cz> FEE CTU/self-funded
 *
 * Project advisors:
 *     Jiri Novak <jnovak@fel.cvut.cz>
 *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
 *
 * Department of Measurement         (http://meas.fel.cvut.cz/)
 * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
 * Czech Technical University        (http://www.cvut.cz/)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 ******************************************************************************/

/* This file is autogenerated, DO NOT EDIT! */

#ifndef __CTU_CAN_FD_CAN_FD_REGISTER_MAP__
#define __CTU_CAN_FD_CAN_FD_REGISTER_MAP__

#include <linux/bits.h>

/* CAN_Registers memory map */
enum ctu_can_fd_can_registers {
	CTUCANFD_DEVICE_ID             = 0x0,
	CTUCANFD_VERSION               = 0x2,
	CTUCANFD_MODE                  = 0x4,
	CTUCANFD_SETTINGS              = 0x6,
	CTUCANFD_STATUS                = 0x8,
	CTUCANFD_COMMAND               = 0xc,
	CTUCANFD_INT_STAT             = 0x10,
	CTUCANFD_INT_ENA_SET          = 0x14,
	CTUCANFD_INT_ENA_CLR          = 0x18,
	CTUCANFD_INT_MASK_SET         = 0x1c,
	CTUCANFD_INT_MASK_CLR         = 0x20,
	CTUCANFD_BTR                  = 0x24,
	CTUCANFD_BTR_FD               = 0x28,
	CTUCANFD_EWL                  = 0x2c,
	CTUCANFD_ERP                  = 0x2d,
	CTUCANFD_FAULT_STATE          = 0x2e,
	CTUCANFD_REC                  = 0x30,
	CTUCANFD_TEC                  = 0x32,
	CTUCANFD_ERR_NORM             = 0x34,
	CTUCANFD_ERR_FD               = 0x36,
	CTUCANFD_CTR_PRES             = 0x38,
	CTUCANFD_FILTER_A_MASK        = 0x3c,
	CTUCANFD_FILTER_A_VAL         = 0x40,
	CTUCANFD_FILTER_B_MASK        = 0x44,
	CTUCANFD_FILTER_B_VAL         = 0x48,
	CTUCANFD_FILTER_C_MASK        = 0x4c,
	CTUCANFD_FILTER_C_VAL         = 0x50,
	CTUCANFD_FILTER_RAN_LOW       = 0x54,
	CTUCANFD_FILTER_RAN_HIGH      = 0x58,
	CTUCANFD_FILTER_CONTROL       = 0x5c,
	CTUCANFD_FILTER_STATUS        = 0x5e,
	CTUCANFD_RX_MEM_INFO          = 0x60,
	CTUCANFD_RX_POINTERS          = 0x64,
	CTUCANFD_RX_STATUS            = 0x68,
	CTUCANFD_RX_SETTINGS          = 0x6a,
	CTUCANFD_RX_DATA              = 0x6c,
	CTUCANFD_TX_STATUS            = 0x70,
	CTUCANFD_TX_COMMAND           = 0x74,
	CTUCANFD_TXTB_INFO            = 0x76,
	CTUCANFD_TX_PRIORITY          = 0x78,
	CTUCANFD_ERR_CAPT             = 0x7c,
	CTUCANFD_RETR_CTR             = 0x7d,
	CTUCANFD_ALC                  = 0x7e,
	CTUCANFD_TS_INFO              = 0x7f,
	CTUCANFD_TRV_DELAY            = 0x80,
	CTUCANFD_SSP_CFG              = 0x82,
	CTUCANFD_RX_FR_CTR            = 0x84,
	CTUCANFD_TX_FR_CTR            = 0x88,
	CTUCANFD_DEBUG_REGISTER       = 0x8c,
	CTUCANFD_YOLO_REG             = 0x90,
	CTUCANFD_TIMESTAMP_LOW        = 0x94,
	CTUCANFD_TIMESTAMP_HIGH       = 0x98,
	CTUCANFD_TXTB1_DATA_1        = 0x100,
	CTUCANFD_TXTB1_DATA_2        = 0x104,
	CTUCANFD_TXTB1_DATA_3        = 0x108,
	CTUCANFD_TXTB1_DATA_4        = 0x10c,
	CTUCANFD_TXTB1_DATA_5        = 0x110,
	CTUCANFD_TXTB1_DATA_6        = 0x114,
	CTUCANFD_TXTB1_DATA_7        = 0x118,
	CTUCANFD_TXTB1_DATA_8        = 0x11c,
	CTUCANFD_TXTB1_DATA_9        = 0x120,
	CTUCANFD_TXTB1_DATA_10       = 0x124,
	CTUCANFD_TXTB1_DATA_11       = 0x128,
	CTUCANFD_TXTB1_DATA_12       = 0x12c,
	CTUCANFD_TXTB1_DATA_13       = 0x130,
	CTUCANFD_TXTB1_DATA_14       = 0x134,
	CTUCANFD_TXTB1_DATA_15       = 0x138,
	CTUCANFD_TXTB1_DATA_16       = 0x13c,
	CTUCANFD_TXTB1_DATA_17       = 0x140,
	CTUCANFD_TXTB1_DATA_18       = 0x144,
	CTUCANFD_TXTB1_DATA_19       = 0x148,
	CTUCANFD_TXTB1_DATA_20       = 0x14c,
	CTUCANFD_TXTB1_DATA_21       = 0x150,
	CTUCANFD_TXTB2_DATA_1        = 0x200,
	CTUCANFD_TXTB2_DATA_2        = 0x204,
	CTUCANFD_TXTB2_DATA_3        = 0x208,
	CTUCANFD_TXTB2_DATA_4        = 0x20c,
	CTUCANFD_TXTB2_DATA_5        = 0x210,
	CTUCANFD_TXTB2_DATA_6        = 0x214,
	CTUCANFD_TXTB2_DATA_7        = 0x218,
	CTUCANFD_TXTB2_DATA_8        = 0x21c,
	CTUCANFD_TXTB2_DATA_9        = 0x220,
	CTUCANFD_TXTB2_DATA_10       = 0x224,
	CTUCANFD_TXTB2_DATA_11       = 0x228,
	CTUCANFD_TXTB2_DATA_12       = 0x22c,
	CTUCANFD_TXTB2_DATA_13       = 0x230,
	CTUCANFD_TXTB2_DATA_14       = 0x234,
	CTUCANFD_TXTB2_DATA_15       = 0x238,
	CTUCANFD_TXTB2_DATA_16       = 0x23c,
	CTUCANFD_TXTB2_DATA_17       = 0x240,
	CTUCANFD_TXTB2_DATA_18       = 0x244,
	CTUCANFD_TXTB2_DATA_19       = 0x248,
	CTUCANFD_TXTB2_DATA_20       = 0x24c,
	CTUCANFD_TXTB2_DATA_21       = 0x250,
	CTUCANFD_TXTB3_DATA_1        = 0x300,
	CTUCANFD_TXTB3_DATA_2        = 0x304,
	CTUCANFD_TXTB3_DATA_3        = 0x308,
	CTUCANFD_TXTB3_DATA_4        = 0x30c,
	CTUCANFD_TXTB3_DATA_5        = 0x310,
	CTUCANFD_TXTB3_DATA_6        = 0x314,
	CTUCANFD_TXTB3_DATA_7        = 0x318,
	CTUCANFD_TXTB3_DATA_8        = 0x31c,
	CTUCANFD_TXTB3_DATA_9        = 0x320,
	CTUCANFD_TXTB3_DATA_10       = 0x324,
	CTUCANFD_TXTB3_DATA_11       = 0x328,
	CTUCANFD_TXTB3_DATA_12       = 0x32c,
	CTUCANFD_TXTB3_DATA_13       = 0x330,
	CTUCANFD_TXTB3_DATA_14       = 0x334,
	CTUCANFD_TXTB3_DATA_15       = 0x338,
	CTUCANFD_TXTB3_DATA_16       = 0x33c,
	CTUCANFD_TXTB3_DATA_17       = 0x340,
	CTUCANFD_TXTB3_DATA_18       = 0x344,
	CTUCANFD_TXTB3_DATA_19       = 0x348,
	CTUCANFD_TXTB3_DATA_20       = 0x34c,
	CTUCANFD_TXTB3_DATA_21       = 0x350,
	CTUCANFD_TXTB4_DATA_1        = 0x400,
	CTUCANFD_TXTB4_DATA_2        = 0x404,
	CTUCANFD_TXTB4_DATA_3        = 0x408,
	CTUCANFD_TXTB4_DATA_4        = 0x40c,
	CTUCANFD_TXTB4_DATA_5        = 0x410,
	CTUCANFD_TXTB4_DATA_6        = 0x414,
	CTUCANFD_TXTB4_DATA_7        = 0x418,
	CTUCANFD_TXTB4_DATA_8        = 0x41c,
	CTUCANFD_TXTB4_DATA_9        = 0x420,
	CTUCANFD_TXTB4_DATA_10       = 0x424,
	CTUCANFD_TXTB4_DATA_11       = 0x428,
	CTUCANFD_TXTB4_DATA_12       = 0x42c,
	CTUCANFD_TXTB4_DATA_13       = 0x430,
	CTUCANFD_TXTB4_DATA_14       = 0x434,
	CTUCANFD_TXTB4_DATA_15       = 0x438,
	CTUCANFD_TXTB4_DATA_16       = 0x43c,
	CTUCANFD_TXTB4_DATA_17       = 0x440,
	CTUCANFD_TXTB4_DATA_18       = 0x444,
	CTUCANFD_TXTB4_DATA_19       = 0x448,
	CTUCANFD_TXTB4_DATA_20       = 0x44c,
	CTUCANFD_TXTB4_DATA_21       = 0x450,
	CTUCANFD_TXTB5_DATA_1        = 0x500,
	CTUCANFD_TXTB5_DATA_2        = 0x504,
	CTUCANFD_TXTB5_DATA_3        = 0x508,
	CTUCANFD_TXTB5_DATA_4        = 0x50c,
	CTUCANFD_TXTB5_DATA_5        = 0x510,
	CTUCANFD_TXTB5_DATA_6        = 0x514,
	CTUCANFD_TXTB5_DATA_7        = 0x518,
	CTUCANFD_TXTB5_DATA_8        = 0x51c,
	CTUCANFD_TXTB5_DATA_9        = 0x520,
	CTUCANFD_TXTB5_DATA_10       = 0x524,
	CTUCANFD_TXTB5_DATA_11       = 0x528,
	CTUCANFD_TXTB5_DATA_12       = 0x52c,
	CTUCANFD_TXTB5_DATA_13       = 0x530,
	CTUCANFD_TXTB5_DATA_14       = 0x534,
	CTUCANFD_TXTB5_DATA_15       = 0x538,
	CTUCANFD_TXTB5_DATA_16       = 0x53c,
	CTUCANFD_TXTB5_DATA_17       = 0x540,
	CTUCANFD_TXTB5_DATA_18       = 0x544,
	CTUCANFD_TXTB5_DATA_19       = 0x548,
	CTUCANFD_TXTB5_DATA_20       = 0x54c,
	CTUCANFD_TXTB5_DATA_21       = 0x550,
	CTUCANFD_TXTB6_DATA_1        = 0x600,
	CTUCANFD_TXTB6_DATA_2        = 0x604,
	CTUCANFD_TXTB6_DATA_3        = 0x608,
	CTUCANFD_TXTB6_DATA_4        = 0x60c,
	CTUCANFD_TXTB6_DATA_5        = 0x610,
	CTUCANFD_TXTB6_DATA_6        = 0x614,
	CTUCANFD_TXTB6_DATA_7        = 0x618,
	CTUCANFD_TXTB6_DATA_8        = 0x61c,
	CTUCANFD_TXTB6_DATA_9        = 0x620,
	CTUCANFD_TXTB6_DATA_10       = 0x624,
	CTUCANFD_TXTB6_DATA_11       = 0x628,
	CTUCANFD_TXTB6_DATA_12       = 0x62c,
	CTUCANFD_TXTB6_DATA_13       = 0x630,
	CTUCANFD_TXTB6_DATA_14       = 0x634,
	CTUCANFD_TXTB6_DATA_15       = 0x638,
	CTUCANFD_TXTB6_DATA_16       = 0x63c,
	CTUCANFD_TXTB6_DATA_17       = 0x640,
	CTUCANFD_TXTB6_DATA_18       = 0x644,
	CTUCANFD_TXTB6_DATA_19       = 0x648,
	CTUCANFD_TXTB6_DATA_20       = 0x64c,
	CTUCANFD_TXTB6_DATA_21       = 0x650,
	CTUCANFD_TXTB7_DATA_1        = 0x700,
	CTUCANFD_TXTB7_DATA_2        = 0x704,
	CTUCANFD_TXTB7_DATA_3        = 0x708,
	CTUCANFD_TXTB7_DATA_4        = 0x70c,
	CTUCANFD_TXTB7_DATA_5        = 0x710,
	CTUCANFD_TXTB7_DATA_6        = 0x714,
	CTUCANFD_TXTB7_DATA_7        = 0x718,
	CTUCANFD_TXTB7_DATA_8        = 0x71c,
	CTUCANFD_TXTB7_DATA_9        = 0x720,
	CTUCANFD_TXTB7_DATA_10       = 0x724,
	CTUCANFD_TXTB7_DATA_11       = 0x728,
	CTUCANFD_TXTB7_DATA_12       = 0x72c,
	CTUCANFD_TXTB7_DATA_13       = 0x730,
	CTUCANFD_TXTB7_DATA_14       = 0x734,
	CTUCANFD_TXTB7_DATA_15       = 0x738,
	CTUCANFD_TXTB7_DATA_16       = 0x73c,
	CTUCANFD_TXTB7_DATA_17       = 0x740,
	CTUCANFD_TXTB7_DATA_18       = 0x744,
	CTUCANFD_TXTB7_DATA_19       = 0x748,
	CTUCANFD_TXTB7_DATA_20       = 0x74c,
	CTUCANFD_TXTB7_DATA_21       = 0x750,
	CTUCANFD_TXTB8_DATA_1        = 0x800,
	CTUCANFD_TXTB8_DATA_2        = 0x804,
	CTUCANFD_TXTB8_DATA_3        = 0x808,
	CTUCANFD_TXTB8_DATA_4        = 0x80c,
	CTUCANFD_TXTB8_DATA_5        = 0x810,
	CTUCANFD_TXTB8_DATA_6        = 0x814,
	CTUCANFD_TXTB8_DATA_7        = 0x818,
	CTUCANFD_TXTB8_DATA_8        = 0x81c,
	CTUCANFD_TXTB8_DATA_9        = 0x820,
	CTUCANFD_TXTB8_DATA_10       = 0x824,
	CTUCANFD_TXTB8_DATA_11       = 0x828,
	CTUCANFD_TXTB8_DATA_12       = 0x82c,
	CTUCANFD_TXTB8_DATA_13       = 0x830,
	CTUCANFD_TXTB8_DATA_14       = 0x834,
	CTUCANFD_TXTB8_DATA_15       = 0x838,
	CTUCANFD_TXTB8_DATA_16       = 0x83c,
	CTUCANFD_TXTB8_DATA_17       = 0x840,
	CTUCANFD_TXTB8_DATA_18       = 0x844,
	CTUCANFD_TXTB8_DATA_19       = 0x848,
	CTUCANFD_TXTB8_DATA_20       = 0x84c,
	CTUCANFD_TXTB8_DATA_21       = 0x850,
	CTUCANFD_TST_CONTROL         = 0x900,
	CTUCANFD_TST_DEST            = 0x904,
	CTUCANFD_TST_WDATA           = 0x908,
	CTUCANFD_TST_RDATA           = 0x90c,
};
/* Control_registers memory region */

/*  DEVICE_ID VERSION registers */
#define REG_DEVICE_ID_DEVICE_ID GENMASK(15, 0)
#define REG_DEVICE_ID_VER_MINOR GENMASK(23, 16)
#define REG_DEVICE_ID_VER_MAJOR GENMASK(31, 24)

/*  MODE SETTINGS registers */
#define REG_MODE_RST BIT(0)
#define REG_MODE_BMM BIT(1)
#define REG_MODE_STM BIT(2)
#define REG_MODE_AFM BIT(3)
#define REG_MODE_FDE BIT(4)
#define REG_MODE_TTTM BIT(5)
#define REG_MODE_ROM BIT(6)
#define REG_MODE_ACF BIT(7)
#define REG_MODE_TSTM BIT(8)
#define REG_MODE_RXBAM BIT(9)
#define REG_MODE_TXBBM BIT(10)
#define REG_MODE_SAM BIT(11)
#define REG_MODE_ERFM BIT(12)
#define REG_MODE_RTRLE BIT(16)
#define REG_MODE_RTRTH GENMASK(20, 17)
#define REG_MODE_ILBP BIT(21)
#define REG_MODE_ENA BIT(22)
#define REG_MODE_NISOFD BIT(23)
#define REG_MODE_PEX BIT(24)
#define REG_MODE_TBFBO BIT(25)
#define REG_MODE_FDRF BIT(26)
#define REG_MODE_PCHKE BIT(27)

/*  STATUS registers */
#define REG_STATUS_RXNE BIT(0)
#define REG_STATUS_DOR BIT(1)
#define REG_STATUS_TXNF BIT(2)
#define REG_STATUS_EFT BIT(3)
#define REG_STATUS_RXS BIT(4)
#define REG_STATUS_TXS BIT(5)
#define REG_STATUS_EWL BIT(6)
#define REG_STATUS_IDLE BIT(7)
#define REG_STATUS_PEXS BIT(8)
#define REG_STATUS_RXPE BIT(9)
#define REG_STATUS_TXPE BIT(10)
#define REG_STATUS_TXDPE BIT(11)
#define REG_STATUS_STCNT BIT(16)
#define REG_STATUS_STRGS BIT(17)
#define REG_STATUS_SPRT BIT(18)

/*  COMMAND registers */
#define REG_COMMAND_RXRPMV BIT(1)
#define REG_COMMAND_RRB BIT(2)
#define REG_COMMAND_CDO BIT(3)
#define REG_COMMAND_ERCRST BIT(4)
#define REG_COMMAND_RXFCRST BIT(5)
#define REG_COMMAND_TXFCRST BIT(6)
#define REG_COMMAND_CPEXS BIT(7)
#define REG_COMMAND_CRXPE BIT(8)
#define REG_COMMAND_CTXPE BIT(9)
#define REG_COMMAND_CTXDPE BIT(10)

/*  INT_STAT registers */
#define REG_INT_STAT_RXI BIT(0)
#define REG_INT_STAT_TXI BIT(1)
#define REG_INT_STAT_EWLI BIT(2)
#define REG_INT_STAT_DOI BIT(3)
#define REG_INT_STAT_FCSI BIT(4)
#define REG_INT_STAT_ALI BIT(5)
#define REG_INT_STAT_BEI BIT(6)
#define REG_INT_STAT_OFI BIT(7)
#define REG_INT_STAT_RXFI BIT(8)
#define REG_INT_STAT_BSI BIT(9)
#define REG_INT_STAT_RBNEI BIT(10)
#define REG_INT_STAT_TXBHCI BIT(11)

/*  INT_ENA_SET registers */
#define REG_INT_ENA_SET_INT_ENA_SET GENMASK(11, 0)

/*  INT_ENA_CLR registers */
#define REG_INT_ENA_CLR_INT_ENA_CLR GENMASK(11, 0)

/*  INT_MASK_SET registers */
#define REG_INT_MASK_SET_INT_MASK_SET GENMASK(11, 0)

/*  INT_MASK_CLR registers */
#define REG_INT_MASK_CLR_INT_MASK_CLR GENMASK(11, 0)

/*  BTR registers */
#define REG_BTR_PROP GENMASK(6, 0)
#define REG_BTR_PH1 GENMASK(12, 7)
#define REG_BTR_PH2 GENMASK(18, 13)
#define REG_BTR_BRP GENMASK(26, 19)
#define REG_BTR_SJW GENMASK(31, 27)

/*  BTR_FD registers */
#define REG_BTR_FD_PROP_FD GENMASK(5, 0)
#define REG_BTR_FD_PH1_FD GENMASK(11, 7)
#define REG_BTR_FD_PH2_FD GENMASK(17, 13)
#define REG_BTR_FD_BRP_FD GENMASK(26, 19)
#define REG_BTR_FD_SJW_FD GENMASK(31, 27)

/*  EWL ERP FAULT_STATE registers */
#define REG_EWL_EW_LIMIT GENMASK(7, 0)
#define REG_EWL_ERP_LIMIT GENMASK(15, 8)
#define REG_EWL_ERA BIT(16)
#define REG_EWL_ERP BIT(17)
#define REG_EWL_BOF BIT(18)

/*  REC TEC registers */
#define REG_REC_REC_VAL GENMASK(8, 0)
#define REG_REC_TEC_VAL GENMASK(24, 16)

/*  ERR_NORM ERR_FD registers */
#define REG_ERR_NORM_ERR_NORM_VAL GENMASK(15, 0)
#define REG_ERR_NORM_ERR_FD_VAL GENMASK(31, 16)

/*  CTR_PRES registers */
#define REG_CTR_PRES_CTPV GENMASK(8, 0)
#define REG_CTR_PRES_PTX BIT(9)
#define REG_CTR_PRES_PRX BIT(10)
#define REG_CTR_PRES_ENORM BIT(11)
#define REG_CTR_PRES_EFD BIT(12)

/*  FILTER_A_MASK registers */
#define REG_FILTER_A_MASK_BIT_MASK_A_VAL GENMASK(28, 0)

/*  FILTER_A_VAL registers */
#define REG_FILTER_A_VAL_BIT_VAL_A_VAL GENMASK(28, 0)

/*  FILTER_B_MASK registers */
#define REG_FILTER_B_MASK_BIT_MASK_B_VAL GENMASK(28, 0)

/*  FILTER_B_VAL registers */
#define REG_FILTER_B_VAL_BIT_VAL_B_VAL GENMASK(28, 0)

/*  FILTER_C_MASK registers */
#define REG_FILTER_C_MASK_BIT_MASK_C_VAL GENMASK(28, 0)

/*  FILTER_C_VAL registers */
#define REG_FILTER_C_VAL_BIT_VAL_C_VAL GENMASK(28, 0)

/*  FILTER_RAN_LOW registers */
#define REG_FILTER_RAN_LOW_BIT_RAN_LOW_VAL GENMASK(28, 0)

/*  FILTER_RAN_HIGH registers */
#define REG_FILTER_RAN_HIGH_BIT_RAN_HIGH_VAL GENMASK(28, 0)

/*  FILTER_CONTROL FILTER_STATUS registers */
#define REG_FILTER_CONTROL_FANB BIT(0)
#define REG_FILTER_CONTROL_FANE BIT(1)
#define REG_FILTER_CONTROL_FAFB BIT(2)
#define REG_FILTER_CONTROL_FAFE BIT(3)
#define REG_FILTER_CONTROL_FBNB BIT(4)
#define REG_FILTER_CONTROL_FBNE BIT(5)
#define REG_FILTER_CONTROL_FBFB BIT(6)
#define REG_FILTER_CONTROL_FBFE BIT(7)
#define REG_FILTER_CONTROL_FCNB BIT(8)
#define REG_FILTER_CONTROL_FCNE BIT(9)
#define REG_FILTER_CONTROL_FCFB BIT(10)
#define REG_FILTER_CONTROL_FCFE BIT(11)
#define REG_FILTER_CONTROL_FRNB BIT(12)
#define REG_FILTER_CONTROL_FRNE BIT(13)
#define REG_FILTER_CONTROL_FRFB BIT(14)
#define REG_FILTER_CONTROL_FRFE BIT(15)
#define REG_FILTER_CONTROL_SFA BIT(16)
#define REG_FILTER_CONTROL_SFB BIT(17)
#define REG_FILTER_CONTROL_SFC BIT(18)
#define REG_FILTER_CONTROL_SFR BIT(19)

/*  RX_MEM_INFO registers */
#define REG_RX_MEM_INFO_RX_BUFF_SIZE GENMASK(12, 0)
#define REG_RX_MEM_INFO_RX_MEM_FREE GENMASK(28, 16)

/*  RX_POINTERS registers */
#define REG_RX_POINTERS_RX_WPP GENMASK(11, 0)
#define REG_RX_POINTERS_RX_RPP GENMASK(27, 16)

/*  RX_STATUS RX_SETTINGS registers */
#define REG_RX_STATUS_RXE BIT(0)
#define REG_RX_STATUS_RXF BIT(1)
#define REG_RX_STATUS_RXMOF BIT(2)
#define REG_RX_STATUS_RXFRC GENMASK(14, 4)
#define REG_RX_STATUS_RTSOP BIT(16)

/*  RX_DATA registers */
#define REG_RX_DATA_RX_DATA GENMASK(31, 0)

/*  TX_STATUS registers */
#define REG_TX_STATUS_TX1S GENMASK(3, 0)
#define REG_TX_STATUS_TX2S GENMASK(7, 4)
#define REG_TX_STATUS_TX3S GENMASK(11, 8)
#define REG_TX_STATUS_TX4S GENMASK(15, 12)
#define REG_TX_STATUS_TX5S GENMASK(19, 16)
#define REG_TX_STATUS_TX6S GENMASK(23, 20)
#define REG_TX_STATUS_TX7S GENMASK(27, 24)
#define REG_TX_STATUS_TX8S GENMASK(31, 28)

/*  TX_COMMAND TXTB_INFO registers */
#define REG_TX_COMMAND_TXCE BIT(0)
#define REG_TX_COMMAND_TXCR BIT(1)
#define REG_TX_COMMAND_TXCA BIT(2)
#define REG_TX_COMMAND_TXB1 BIT(8)
#define REG_TX_COMMAND_TXB2 BIT(9)
#define REG_TX_COMMAND_TXB3 BIT(10)
#define REG_TX_COMMAND_TXB4 BIT(11)
#define REG_TX_COMMAND_TXB5 BIT(12)
#define REG_TX_COMMAND_TXB6 BIT(13)
#define REG_TX_COMMAND_TXB7 BIT(14)
#define REG_TX_COMMAND_TXB8 BIT(15)
#define REG_TX_COMMAND_TXT_BUFFER_COUNT GENMASK(19, 16)

/*  TX_PRIORITY registers */
#define REG_TX_PRIORITY_TXT1P GENMASK(2, 0)
#define REG_TX_PRIORITY_TXT2P GENMASK(6, 4)
#define REG_TX_PRIORITY_TXT3P GENMASK(10, 8)
#define REG_TX_PRIORITY_TXT4P GENMASK(14, 12)
#define REG_TX_PRIORITY_TXT5P GENMASK(18, 16)
#define REG_TX_PRIORITY_TXT6P GENMASK(22, 20)
#define REG_TX_PRIORITY_TXT7P GENMASK(26, 24)
#define REG_TX_PRIORITY_TXT8P GENMASK(30, 28)

/*  ERR_CAPT RETR_CTR ALC TS_INFO registers */
#define REG_ERR_CAPT_ERR_POS GENMASK(4, 0)
#define REG_ERR_CAPT_ERR_TYPE GENMASK(7, 5)
#define REG_ERR_CAPT_RETR_CTR_VAL GENMASK(11, 8)
#define REG_ERR_CAPT_ALC_BIT GENMASK(20, 16)
#define REG_ERR_CAPT_ALC_ID_FIELD GENMASK(23, 21)
#define REG_ERR_CAPT_TS_BITS GENMASK(29, 24)

/*  TRV_DELAY SSP_CFG registers */
#define REG_TRV_DELAY_TRV_DELAY_VALUE GENMASK(6, 0)
#define REG_TRV_DELAY_SSP_OFFSET GENMASK(23, 16)
#define REG_TRV_DELAY_SSP_SRC GENMASK(25, 24)

/*  RX_FR_CTR registers */
#define REG_RX_FR_CTR_RX_FR_CTR_VAL GENMASK(31, 0)

/*  TX_FR_CTR registers */
#define REG_TX_FR_CTR_TX_FR_CTR_VAL GENMASK(31, 0)

/*  DEBUG_REGISTER registers */
#define REG_DEBUG_REGISTER_STUFF_COUNT GENMASK(2, 0)
#define REG_DEBUG_REGISTER_DESTUFF_COUNT GENMASK(5, 3)
#define REG_DEBUG_REGISTER_PC_ARB BIT(6)
#define REG_DEBUG_REGISTER_PC_CON BIT(7)
#define REG_DEBUG_REGISTER_PC_DAT BIT(8)
#define REG_DEBUG_REGISTER_PC_STC BIT(9)
#define REG_DEBUG_REGISTER_PC_CRC BIT(10)
#define REG_DEBUG_REGISTER_PC_CRCD BIT(11)
#define REG_DEBUG_REGISTER_PC_ACK BIT(12)
#define REG_DEBUG_REGISTER_PC_ACKD BIT(13)
#define REG_DEBUG_REGISTER_PC_EOF BIT(14)
#define REG_DEBUG_REGISTER_PC_INT BIT(15)
#define REG_DEBUG_REGISTER_PC_SUSP BIT(16)
#define REG_DEBUG_REGISTER_PC_OVR BIT(17)
#define REG_DEBUG_REGISTER_PC_SOF BIT(18)

/*  YOLO_REG registers */
#define REG_YOLO_REG_YOLO_VAL GENMASK(31, 0)

/*  TIMESTAMP_LOW registers */
#define REG_TIMESTAMP_LOW_TIMESTAMP_LOW GENMASK(31, 0)

/*  TIMESTAMP_HIGH registers */
#define REG_TIMESTAMP_HIGH_TIMESTAMP_HIGH GENMASK(31, 0)

#endif
