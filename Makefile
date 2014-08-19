all: cmdq_test

cmdq_test: cmdq_test.adb priority_queue.o
	gnatmake -f -g -D obj -Isrc cmdq_test

priority_queue.o: priority_queue.ad[sb]

tq: tq.o

tq.o: tq.c

clean:
	rm -rf *.ali *.o b~* *~ cmdq_test priority_queue.ad[sb] tq obj/*


%.ad[sb]: %.ada
	test -d obj || mkdir obj
	test -d src || mkdir src
	gnatchop -r -w $< src
