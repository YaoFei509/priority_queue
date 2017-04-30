//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//               佛祖保佑         永无BUG
//
//
//



/**
*
    　　　┏┓　　　┏┓
    　　┏┛┻━━━┛┻┓
    　　┃　　　　　　　┃
    　　┃　　　━　　　┃
    　　┃　┳┛　┗┳　┃
    　　┃　　　　　　　┃
    　　┃　　　┻　　　┃
    　　┃　　　　　　　┃
    　　┗━┓　　　┏━┛
    　　　　┃　　　┃
    　　　　┃　　　┃
    　　　　┃　　　┗━━━┓
    　　　　┃　　　　　　　┣┓
    　　　　┃　　　　　　　┏┛
    　　　　┗┓┓┏━┳┓┏┛
    　　　　　┃┫┫　┃┫┫
    　　　　　┗┻┛　┗┻┛
    ━━━━━━神兽出没━━━━━━ */


/**

    　　　　　　　　┏┓　　　┏┓
    　　　　　　　┏┛┻━━━┛┻┓
    　　　　　　　┃　　　　　　　┃ 　
    　　　　　　　┃　　　━　　　┃
    　　　　　　　┃　＞　　　＜　┃
    　　　　　　　┃　　　　　　　┃
    　　　　　　　┃...　⌒　...　┃
    　　　　　　　┃　　　　　　　┃
    　　　　　　　┗━┓　　　┏━┛
    　　　　　　　　　┃　　　┃　Code is far away from bug with the animal protecting　　　　　　　　　　
    　　　　　　　　　┃　　　┃ 神兽保佑,代码无bug
    　　　　　　　　　┃　　　┃　　　　　　　　　　　
    　　　　　　　　　┃　　　┃ 　　　　　　
    　　　　　　　　　┃　　　┃
    　　　　　　　　　┃　　　┃　　　　　　　　　　　
    　　　　　　　　　┃　　　┗━━━┓
    　　　　　　　　　┃　　　　　　　┣┓
    　　　　　　　　　┃　　　　　　　┏┛
    　　　　　　　　　┗┓┓┏━┳┓┏┛
    　　　　　　　　　　┃┫┫　┃┫┫
    　　　　　　　　　　┗┻┛　┗┻┛ */


/**
*　　　　　　　　┏┓　　　┏┓+ +
*　　　　　　　┏┛┻━━━┛┻┓ + +
*　　　　　　　┃　　　　　　　┃ 　
*　　　　　　　┃　　　━　　　┃ ++ + + +
*　　　　　　　┃　████━████ ┃+
*　　　　　　　┃　　　　　　　┃ +
*　　　　　　　┃　　　┻　　　┃
*　　　　　　　┃　　　　　　　┃ + +
*　　　　　　　┗━┓　　　┏━┛
*　　　　　　　　　┃　　　┃　　　　　　　　　　　
*　　　　　　　　　┃　　　┃ + + + +
*　　　　　　　　　┃　　　┃　　　　Code is far away from bug 
*　　　　　　　　　┃　　　┃　　　　with the animal protecting　　　　　　　
*　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug　　
*　　　　　　　　　┃　　　┃
*　　　　　　　　　┃　　　┃　　+　　　　　　　　　
*　　　　　　　　　┃　 　　┗━━━┓ + +
*　　　　　　　　　┃ 　　　　　　　┣┓
*　　　　　　　　　┃ 　　　　　　　┏┛
*　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
*　　　　　　　　　　┃┫┫　┃┫┫
*　　　　　　　　　　┗┻┛　┗┻┛+ + + +
*/


#include <iostream>
#include <queue>
#include <deque>
using namespace std;

// Using priority_queue with deque
// Use of function greater sorts the items in ascending order
typedef deque<int, allocator<int> > INTDQU;
typedef priority_queue<int,INTDQU, greater<int> > INTPRQUE;

const int NUM_OF_TEST = 512;
int test_data[NUM_OF_TEST] = {
	11, 10, 9, 6, 7, 8, 
	10, 
	64, 
	45, 46, 47, 48, 
	1, 2, 3, 4, 
	25, 24, 23, 22, 
	100, 101, 102, 
	10, 
	15, 15, 15, 
	16, 
	13, 14, 15, 16
};


int main(void)
{
	int size_q;
	INTPRQUE   q;

        // 构造伪随机测试数据
	for (int i=32; i<NUM_OF_TEST; i++) {
		test_data[i] = ( test_data[i-1] + 257) % 511;
	}
      
	// Insert items in the priority_queue(uses deque)
	for (int i=0; i<NUM_OF_TEST; i++) {
		q.push(test_data[i]);
	}

	// Output the item at the top using top()
	cout << q.top() << endl;
	// Output the size of priority_queue
	size_q = q.size();
	cout << "size of q is:" << size_q << endl;
	// Output items in priority_queue using top()
	// and use pop() to get to next item until
	// priority_queue is empty

	size_q = 0;
	while (!q.empty()) {
		cout << size_q++ << " ->\t" << q.top() << endl;
		q.pop();
	}

	return 0;
}
