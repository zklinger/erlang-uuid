##########################################################################
##
## Makefile for the UUID generator shared library
##
## Copyright 2010 Zoltan Klinger <zoltan dot klinger at gmail dot com>
##
## This program is free software: you can redistribute it and/or modify 
## it under the terms of the GNU General Public License as published by 
## the Free Software Foundation, either version 3 of the License, or 
## (at your option) any later version. 
## 
## This program is distributed in the hope that it will be useful, 
## but WITHOUT ANY WARRANTY; without even the implied warranty of 
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
## GNU General Public License for more details. 
## 
## You should have received a copy of the GNU General Public License 
## along with this program. If not, see <http://www.gnu.org/licenses/>. 
##
##########################################################################

TARGETS = uuid_gen_drv
CC = gcc
CFLAGS = -shared -fpic
CLIBS =  -L /usr/lib/e2fsprogs -luuid 
CINCL =  -I /usr/local/lib/erlang/usr/include

all : $(TARGETS)

uuid_gen_drv: src/uuid_gen.c src/port_driver.c
	$(CC) $(CFLAGS) src/uuid_gen.c src/port_driver.c  $(CLIBS) $(CINCL) -o lib/uuid_gen_drv.so
 
clean :
	rm -f src/*.o 
	rm -f lib/* 


