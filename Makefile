#
# PF_RING
#
PFRINGDIR  = ../lib
LIBPFRING  = ${PFRINGDIR}/libpfring.a

#
# PF_RING aware libpcap
#
PCAPDIR    = ../libpcap
LIBPCAP    = ${PCAPDIR}/libpcap.a

#
# Search directories
#
PFRING_KERNEL=../../kernel
INCLUDE    = -I${PFRINGDIR} -I${PFRING_KERNEL} -I${PCAPDIR} `../lib/pfring_config --include`

#
# User and System libraries
#
LIBS       = ${LIBPFRING} `../lib/pfring_config --libs` ../libpcap/libpcap.a `../libpcap/pcap-config --additional-libs --static` -lpthread   -lrt -ldl

#
# C compiler and flags
#
CC         = ${CROSS_COMPILE}gcc
CFLAGS     = -Wall -Wno-unused-function -Wno-format-truncation -O2  ${INCLUDE}  -D HAVE_PF_RING_FT

%.o: %.c zutils.c
	${CC} ${CFLAGS} -c $< -o $@

#
# Main targets
#
PFPROGS   = 

ifneq (-D HAVE_PF_RING_ZC,)
	PFPROGS += zflow 
endif

TARGETS   =  ${PFPROGS}

all: ${TARGETS}

zflow: zflow.o ${LIBPFRING} Makefile
	${CC} ${CFLAGS} zflow.o ${LIBS} -o $@

install:
ifneq (-D HAVE_PF_RING_ZC,)
	mkdir -p $(DESTDIR)/usr/bin
	cp $(TARGETS) $(DESTDIR)/usr/bin/
endif

clean:
	@rm -f ${TARGETS} *.o *~ config.*
