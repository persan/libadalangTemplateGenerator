#!/usr/bin/make -f

-include Makefile.conf

setup:Makefile.conf

PROJECT:=@_project_name_@.gpr
GPRBUILDFLAGS:=-p

Makefile.conf:  # IGNORE
	echo "export PREFIX?=$(shell dirname $(shell dirname $(shell which gnat)))" >${@}
	echo "export PATH:=${PATH}" >>${@}


compile:
	gprbuild  -P ${PROJECT} ${GPRBUILDFLAGS}

test:
	${MAKE} -C test all

install:
	gprinstall  -P ${PROJECT} ${GPRBUILDFLAGS} --prefix=${DESTDIR}${PREFIX}

clean:
	git clean -xdf


