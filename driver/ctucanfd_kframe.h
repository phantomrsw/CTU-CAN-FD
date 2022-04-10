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

#ifndef __CTU_CAN_FD_CAN_FD_FRAME_FORMAT__
#define __CTU_CAN_FD_CAN_FD_FRAME_FORMAT__

#include <linux/bits.h>

/* CAN_Frame_format memory map */
enum ctu_can_fd_can_frame_format {
	CTUCANFD_FRAME_FORMAT_W       = 0x0,
	CTUCANFD_IDENTIFIER_W         = 0x4,
	CTUCANFD_TIMESTAMP_L_W        = 0x8,
	CTUCANFD_TIMESTAMP_U_W        = 0xc,
	CTUCANFD_DATA_1_4_W          = 0x10,
	CTUCANFD_DATA_5_8_W          = 0x14,
	CTUCANFD_DATA_61_64_W        = 0x4c,
};
/* CAN_FD_Frame_format memory region */

/*  FRAME_FORMAT_W registers */
#define REG_FRAME_FORMAT_W_DLC GENMASK(3, 0)
#define REG_FRAME_FORMAT_W_RTR BIT(5)
#define REG_FRAME_FORMAT_W_IDE BIT(6)
#define REG_FRAME_FORMAT_W_FDF BIT(7)
#define REG_FRAME_FORMAT_W_BRS BIT(9)
#define REG_FRAME_FORMAT_W_ESI_RSV BIT(10)
#define REG_FRAME_FORMAT_W_RWCNT GENMASK(15, 11)
#define REG_FRAME_FORMAT_W_CPRM GENMASK(20, 16)
#define REG_FRAME_FORMAT_W_FSTC BIT(21)
#define REG_FRAME_FORMAT_W_FCRC BIT(22)
#define REG_FRAME_FORMAT_W_SDLC BIT(23)

/*  IDENTIFIER_W registers */
#define REG_IDENTIFIER_W_IDENTIFIER_EXT GENMASK(17, 0)
#define REG_IDENTIFIER_W_IDENTIFIER_BASE GENMASK(28, 18)

/*  TIMESTAMP_L_W registers */
#define REG_TIMESTAMP_L_W_TIME_STAMP_L_W GENMASK(31, 0)

/*  TIMESTAMP_U_W registers */
#define REG_TIMESTAMP_U_W_TIMESTAMP_U_W GENMASK(31, 0)

/*  DATA_1_4_W registers */
#define REG_DATA_1_4_W_DATA_1 GENMASK(7, 0)
#define REG_DATA_1_4_W_DATA_2 GENMASK(15, 8)
#define REG_DATA_1_4_W_DATA_3 GENMASK(23, 16)
#define REG_DATA_1_4_W_DATA_4 GENMASK(31, 24)

/*  DATA_5_8_W registers */
#define REG_DATA_5_8_W_DATA_5 GENMASK(7, 0)
#define REG_DATA_5_8_W_DATA_6 GENMASK(15, 8)
#define REG_DATA_5_8_W_DATA_7 GENMASK(23, 16)
#define REG_DATA_5_8_W_DATA_8 GENMASK(31, 24)

/*  DATA_61_64_W registers */
#define REG_DATA_61_64_W_DATA_61 GENMASK(7, 0)
#define REG_DATA_61_64_W_DATA_62 GENMASK(15, 8)
#define REG_DATA_61_64_W_DATA_63 GENMASK(23, 16)
#define REG_DATA_61_64_W_DATA_64 GENMASK(31, 24)

#endif
