#!/usr/bin/make -f

-include Makefile.conf

setup:Makefile.conf

PROJECT:=libadalangTemplateGenerator.gpr
GPRBUILDFLAGS:=

all:compile test install

Makefile.conf:  # IGNORE
	echo "export PREFIX?=$(shell dirname $(shell dirname $(shell which gnat)))" >${@}
	echo "export PATH:=${PATH}" >>${@}


compile:
	gprbuild  -P ${PROJECT} ${GPRBUILDFLAGS}
	${MAKE} install
install:
	rm -rf ${HOME}/.gnatstudio/templates/libadalang_project
	bin/libadalangtemplategenerator-main
	tar -cz libadalang_project |  tar -C ${HOME}/.gnatstudio/templates -xz
clean:
	git clean -xdf

test:
