all: cmdq_test

cmdq_test: cmdq_test.adb priority_queue.o
	gnatmake -f -Isrc -g cmdq_test

priority_queue.o: priority_queue.ad[sb]

tq: tq.o

tq.o: tq.c

clean:
	rm -rf *.ali *.o b~* *~ cmdq_test priority_queue.ad[sb] tq


%.ad[sb]: %.ada
	test -d src || mkdir src
	gnatchop -r -w $< src
