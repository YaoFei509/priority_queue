#------------------------------------------------------
#-- 
#--  优先队列测试程序
#--
#--  姚飞
#------------------------------------------------------

VER=
# For leon-ada
#XGC    = /opt/leon-ada$(VER)/bin/
#prefix = $(XGC)leon-elf

# for ERC32-Ada
XGC    = /opt/erc32-ada$(VER)/bin/
prefix = $(XGC)erc-elf

CC       = $(prefix)-gcc
LD    	 = $(prefix)-ld
GMAKE 	 = $(prefix)-gnatmake
GNATCHOP = $(prefix)-gnatchop
OBJCOPY  = $(prefix)-objcopy
OBJDUMP  = $(prefix)-objdump
RUN      = $(prefix)-run

HOSTCC   = clang      # or gcc 
HOSTCXX  = clang++    # or g++

CFLAGS   = -g -Isrc
#LDFLAGS  = -largs -T erc32_ram.x

TARGETS  = cmdq_leon
SOURCES  = cmdq_erc32.adb cmdq_test_erc32.o priority_queue.o  prique.o

all: cmdq_test tq tqpp run

# Linux 本机运行版本
cmdq_test: cmdq_test.adb priority_queue.o  prique.o
	gnatmake -f -g -D obj -Isrc cmdq_test


# LEON 版本
cmdq_leon: 	$(SOURCES)
	$(GMAKE) -f -o $@ cmdq_erc32 $(CFLAGS) $(LDFLAGS) 

# 模拟器运行
run:	cmdq_leon
	$(RUN) -bc $<

# HEX文件
ihex: $(TARGETS)
	$(OBJCOPY) -O ihex $< $<.hex

# C版本
tq: tq.o
	$(HOSTCC) -g -o $@ $<

# C++ 版本
tqpp: tqpp.o
	$(HOSTCXX) -g -o $@ $<

##########################################################3

cmdq_test_erc32.o: cmdq_test_erc32.ad[sb]

priority_queue.o: priority_queue.ad[sb]

prique.o: prique.ad[sb]

tq.o: tq.c

tqpp.o: tqpp.cc

clean:
	-rm -rf *.ali *.o b~* *~ *.hex cmdq_test cmdq_leon tq tqpp obj/*

log:
	git pull
	git log --format=short --graph > ChangeLog

%.o: %.cc
	$(CXX) -g -c $<

%.o: %.c
	gcc -g -c $<

%.ad[sb]: %.ada
	test -d src || mkdir src
	test -d obj || mkdir obj
	gnatchop -r -w $< src
