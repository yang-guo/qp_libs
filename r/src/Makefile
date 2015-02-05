# linux rserver makefile

CC=gcc
CFLAGS=-g -O3 -fPIC $(CARCH) -shared -D KXVER=3

R_HOME=/usr/local/lib/R
R_SHARE=/usr/local/lib/R
REXE=$(R_HOME)/bin/R CMD

INCLUDES=-I. -I$(R_SHARE)/include -I$(R_SHARE)/include/i386 -I$(R_SHARE)/include/x86_64
LIBS=-lpthread -L$(R_HOME)/lib -lR

SRC=base.c
TGT=r.so

all:
	$(REXE) $(CC) $(CFLAGS) $(INCLUDES) $(SRC) $(LIBS) -o $(TGT)

clean:
	rm -rf $(TGT)

install:
	mkdir -p ../$(KXARCH)
	cp $(TGT) ../$(KXARCH)