--
--                       _oo0oo_
--                      o8888888o
--                      88" . "88
--                      (| -_- |)
--                      0\  =  /0
--                    ___/`---'\___
--                  .' \\|     |-- '.
--                 / \\|||  :  |||-- \
--                / _||||| -:- |||||- \
--               |   | \\\  -  --/ |   |
--               | \_|  ''\---/''  |_/ |
--               \  .-\__  '-'  ___/-. /
--             ___'. .'  /--.--\  `. .'___
--          ."" '<  `.___\_<|>_/___.' >' "".
--         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
--         \  \ `_.   \_ __\ /__ _/   .-` /  /
--     =====`-.____`.___ \_____/___.-`___.-'=====
--                       `=---='
--
--
--     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
--               佛祖保佑         永无BUG
--
--
--

------------------------------------------------------
-- 
--  优先队列测试程序
--
--  ERC32-Ada 任务版本
--
--  姚飞
------------------------------------------------------
with System;
package Cmdq_Test_Erc32 is 
   task Cmdq_Test_Task is
      pragma Priority(System.Default_Priority + 10);
      --pragma Storage_Size(512*1024);
   end;
end;

with XGC.Text_IO;   use XGC.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Xgc.Tasking.Delays; use Xgc.Tasking.Delays;

with Priority_Queue;  -- 堆实现
with PriQue;          -- 线性表实现
with Interfaces; use Interfaces;

package body Cmdq_Test_ERC32 is 
   
   -- 用户对象
   type MyObject is 
      record 
	 ID: Integer;
	 Val1, Val2, Val3, Val4: Integer;
      end record;
   
   -- 0元
   function Nul return MyObject is 
   begin
      return (others=>0);
   end;
   
   -- 重载 大于等于 运算符 
   function GE(P, Q : in MyObject) return Boolean is 
   begin
      return (P.ID >= Q.ID);
   end GE;
   
   -- 队列实例化
   -- 堆实现
   package Cmd_Queue is new Priority_Queue(Obj=>MyObject, 
				     ">=" => GE,  
				     Nul => Nul);
   use Cmd_Queue;
   
   --
   -- 线性表实现
   package Cmd_Queue_List is new PriQue(Obj=>MyObject, 
					">=" => GE,  
					Nul => Nul);
   use Cmd_Queue_List;
   
   -------------
   -- Test Cases
   -------------
   Test_Data : array(0..511) of Integer := 
     (11, 10, 9, 6, 7, 8,        -- reverse
      10,                        -- repeat
      64,                        -- far bigger 
      45, 46, 47, 48,            -- forward
      1, 2, 3, 4,                -- another reverse
      25, 24, 23, 22,            -- far bigger and reverse
      100, 101, 102,             -- far bigger and forward 
      10,                        -- 3rd repeat 
      15, 15, 15,                -- continue repeat 
      16,                        -- forward
      13, 14, 15, 16,            -- back and forward, 4th repeat
      others=>0);
      
   task body Cmdq_Test_Task is 
      TmpObj   : MyObject;
      I, A, B  : Integer;
      Test_Len : Integer;
      Start    : Time;
      Time1, Time2 : Time_Span;
   begin
      
      Test_Len := 32;
      
      -- 构造伪随机测试数据
      for I in 32..Test_Data'Last loop 
	 Test_Data(I) := (Test_Data(I-1) + 257) mod 511; 
      end loop;
      
      Put_Line("Test length  Period Heap         List          Speed"); 
      Put_Line("----------------------------------------------------");

      loop 
	 TmpObj := Nul;
	 
	 -- 先测试堆实现
	 Start := Clock;
	 for I in Test_Data'First..Test_Len loop 
	    TmpObj.ID := Test_Data(I);
	    Cmd_Queue.Insert(TmpObj);
	 end loop;
	 Time1 := Clock - Start;
	 
	 -- 再对比测试线性表实现
	 Start := Clock;
	 for I in Test_Data'First..Test_Len  loop 
	    TmpObj.ID := Test_Data(I);
	    Cmd_Queue_List.Insert(TmpObj);
	 end loop;
	 Time2 := Clock - Start;
	 
	 -- 抽取队列比对结果，如果有差异则报错
	 I:=0;
	 while (not (Cmd_Queue_List.IsEmpty and Cmd_Queue.IsEmpty)) loop
	    A := Cmd_Queue.Get.ID;
	    B := Cmd_Queue_List.Get.ID;
	    
	    if (A /= B) then   
	       	 Put("No.     Heap    List"); New_Line;
		 Put("------------------------"); New_Line;
		 
		 Put(Integer'Image(I));
		 Put(" ->");
		 Put(ASCII.HT);
		 Put(Integer'Image(A)); 
		 Put(ASCII.HT);
		 Put(Integer'Image(B)); 
		 New_Line;
		 Put("------------------------"); New_Line;	 	 
	    end if;
	    I := I + 1;
	 end loop;

	 --
	 -- 测量并打印每次任务运行时间 
	 --
	 Put(Integer'Image(Test_Len)); 
	       
	 Put(ASCII.HT);	 Put(ASCII.HT);
	 Put(Integer'Image(Time1 / Ada.Real_Time.Tick )); 
	 Put(ASCII.HT);	 Put(ASCII.HT);
	 Put(Integer'Image(Time2 / Ada.Real_Time.Tick )); 
	 Put(ASCII.HT);	 Put(ASCII.HT);	
	 Put(Integer'Image(Time2/Time1));
	 New_Line;
	 
	 -- 增加测试数据长度
	 Test_Len := Test_Len +32;
	 if Test_Len > Test_Data'Last then 
	    Test_Len :=32 ;
	    New_Line; New_Line;
	    Put_Line("Test length  Period Heap         List          Speed"); 
	    Put_Line("----------------------------------------------------");
	 end if;
      end loop;
   end;
   
end Cmdq_Test_Erc32;
