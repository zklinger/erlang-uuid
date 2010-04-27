/**************************************************************************
**
** uuid_gen.h
**
** Header file for the linked-in UUID generator port driver
**
** Copyright 2010 Zoltan Klinger <zoltan dot klinger at gmail dot com>
**
** This program is free software: you can redistribute it and/or modify 
** it under the terms of the GNU General Public License as published by 
** the Free Software Foundation, either version 3 of the License, or 
** (at your option) any later version. 
** 
** This program is distributed in the hope that it will be useful, 
** but WITHOUT ANY WARRANTY; without even the implied warranty of 
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
** GNU General Public License for more details. 
** 
** You should have received a copy of the GNU General Public License 
** along with this program. If not, see <http://www.gnu.org/licenses/>. 
**
**************************************************************************/
#ifndef UUID_GEN_H_
#define UUID_GEN_H_

const static int CMD_RANDOM = 0;
const static int CMD_TIME = 1;
const static int BUFFSIZE = 37;

char* uuid_r();
char* uuid_tm();
char* uuid_gen(int);

#endif

