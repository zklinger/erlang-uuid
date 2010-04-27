##########################################################################
##
## Makefile for the UUID generator 
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

.SUFFIXES: .erl .beam .yrl

.erl.beam:
	erlc -I include -W -o ./ebin $<

# Modules to compile
MODS =  ./src/uuid   \

ERL = erl -boot start_clean 

# Targets
all:	compile

	
compile: uuid_gen_drv app

app:	${MODS:%=%.beam}

uuid_gen_drv:
	$(MAKE) -C priv

clean:
	rm -rf ./ebin/*.beam
	rm -rf ./src/*.beam
	rm -rf ./priv/lib/*.so
	
