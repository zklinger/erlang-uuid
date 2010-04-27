/**************************************************************************
**
** uuid_gen.c
**
** Generate a UUID string using libuuid library functions.
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

#include <stdio.h>
#include <stdlib.h>
#include <uuid/uuid.h>

#include "uuid_gen.h"

/* 
** Crate a UUID string based on random values 
*/
char* uuid_r() { return uuid_gen(CMD_RANDOM); }

/* 
** Crate a UUID string based on time and MAC address values
*/
char* uuid_tm() { return uuid_gen(CMD_TIME); }

/* 
** Helper function to generate the desired type of UUID string 
*/
char* uuid_gen(int how)
{
  uuid_t r;
  char *buff = (char *) malloc(BUFFSIZE);
  if (buff == 0)
  {
    return "false";
  }
  else
  {
    (how == CMD_RANDOM) ? uuid_generate(r) : uuid_generate_time(r);
    uuid_unparse(r, buff);
  }

  return buff;
}

/*
** main() for testing
*/
int main()
{
  printf("%s\n", uuid_r());
  printf("%s\n", uuid_tm());
  return 0;
}
