/**************************************************************************
**
** port_driver.c
**
** Linked in port driver for generating a UUID from within Erlang.
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
#include <string.h>
#include "erl_driver.h"
#include "uuid_gen.h"

typedef struct {
    ErlDrvPort port;
} uuid_gen_data;

static ErlDrvData uuid_gen_drv_start(ErlDrvPort port, char *buff)
{
    uuid_gen_data* d = (uuid_gen_data*)driver_alloc(sizeof(uuid_gen_data));
    d->port = port;
    return (ErlDrvData)d;
}

static void uuid_gen_drv_stop(ErlDrvData handle)
{
    driver_free((char*)handle);
}

static void uuid_gen_drv_output(ErlDrvData handle, char *buff, int bufflen)
{
    uuid_gen_data* d = (uuid_gen_data*)handle;
    char fn = buff[0];
    char* res;
    if (fn == CMD_RANDOM) 
    {
      res = (char*) uuid_r();
    } 
    else if (fn == CMD_TIME) 
    {
      res = (char*) uuid_tm();
    }

    driver_output(d->port, res, strlen(res));
}

ErlDrvEntry uuid_gen_driver_entry = {
    NULL,     /* F_PTR init, N/A */
    uuid_gen_drv_start,    /* L_PTR start, called when port is opened */
    uuid_gen_drv_stop,   /* F_PTR stop, called when port is closed */
    uuid_gen_drv_output,   /* F_PTR output, called when erlang has sent */
    NULL,     /* F_PTR ready_input, called when input descriptor ready */
    NULL,     /* F_PTR ready_output, called when output descriptor ready */
    "uuid_gen_drv",    /* char *driver_name, the argument to open_port */
    NULL,     /* F_PTR finish, called when unloaded */
    NULL,     /* F_PTR control, port_command callback */
    NULL,     /* F_PTR timeout, reserved */
    NULL      /* F_PTR outputv, reserved */
};

DRIVER_INIT(uuid_gen_drv) /* must match name in driver_entry */
{
    return &uuid_gen_driver_entry;
}

