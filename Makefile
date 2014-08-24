all: cmdq_test

cmdq_test: cmdq_test.adb priority_queue.o
	gnatmake -f -g -D obj -Isrc cmdq_test

priority_queue.o: priority_queue.ad[sb]

# C版本
tq: tq.o

# C++ 版本
tqpp: tqpp.o
	$(CXX) -o $@ $<

tq.o: tq.c

tqpp.o: tqpp.cc

clean:
	rm -rf *.ali *.o b~* *~ cmdq_test priority_queue.ad[sb] tq tqpp obj/*


%.ad[sb]: %.ada
	test -d obj || mkdir obj
	test -d src || mkdir src
	gnatchop -r -w $< src
