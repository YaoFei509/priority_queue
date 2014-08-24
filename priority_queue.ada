-----------------------------------------------------------
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
--               ���汣��         ����BUG
--
--
----------------------------------------------------------

--------------------------------------------------
--  �������ȶ�������
--  
--  ʹ�ö�����㷨
--
--  Yao Fei
--------------------------------------------------
with Interfaces; use Interfaces;

generic
   type Obj is private ;
   with function ">="(X,Y : in Obj) return Boolean;
   with function Nul return Obj; -- for 0 
   
package Priority_Queue is
   
   MAXCMDNUM    : constant := 512;
   type Queueptr is range 0..MAXCMDNUM-1;
   
   -- ��ʼ���ն���
   procedure Flush;
   
   -- ����һ��Ԫ��
   procedure Insert(Cmd_Data : in Obj);
   
   -- �鿴����ͷ
   function  Top     return Obj;
   
   -- ȡ������ͷ
   function  Get     return Obj;
   
   -- ���
   function  Depth   return Integer;
   
   -- �ж��п�
   function  IsEmpty return Boolean ;
   
   -- �ж�����
   function  IsFull  return Boolean;

end Priority_Queue;

with System; use System;
package body Priority_Queue is
   
   --
   --  ������ʵ��
   --
   type QueueType is array(Queueptr) of Obj;
   
   Queue: QueueType;
   QSize: Queueptr;
   
   -- ָ������޸Ĳ���ͨ���ñ����������
   protected Queue_Mux is        
      entry Lock ;      
      procedure Release ;      
   private 
      Queue_Idle : Boolean := True ;
   end Queue_Mux ;
   
   protected body Queue_Mux is  
      
      entry Lock when Queue_Idle is
      begin
	 Queue_Idle := False;
      end Lock;
      
      procedure Release is
      begin
	 Queue_Idle := True;
      end Release;
      
   end Queue_Mux ;

   
   function IsEmpty return Boolean is
   begin
      return QSize = 0 ;
   end;
   
   function IsFull return Boolean is
   begin
      return QSize = (MAXCMDNUM-1);
   end;
   
   function Depth return Integer is
   begin
      return Integer(QSize); 
   end;
   
   -- ����һ���¶������˲���
   procedure Insert(Cmd_Data : in Obj) is
      Parent, Child : QueuePtr;      
   begin
      if not IsFull then 
	 Queue_Mux.Lock;
	 Child := QSize;
	 QSize := QSize+1;
	 
	 loop 
	    Parent := (Child-1)/2;
	    exit when (Child = 0) or (Cmd_Data >= Queue(Parent));
	    -- else :
	    Queue(Child) := Queue(Parent);
	    Child := Parent;
	 end loop;
	 Queue(Child) := Cmd_Data;
	 
	 Queue_Mux.Release;
      else
	 null; -- raise Constraint_Error;
      end if;
   end Insert;
   
   
   -- ���˲���, ί���ѽṹ
   procedure Remove_Heap is
      Parent, Child : QueuePtr;
      Tmp : Obj;
   begin
      Queue_Mux.Lock;
      QSize := QSize -1 ;

      if (QSize > 0)  then
	 Queue(0) := Queue(QSize);
	 Parent := 0;
	 Child := 1;

	 while( Child < QSize) loop 
	    if Queue(Child) >= Queue(Child + 1) then 
	       Child := Child + 1;
	    end if;

	    if Queue(Parent) >= Queue(Child) then
	       -- swap parent and child
	       Tmp := Queue(Parent);
	       Queue(Parent) := Queue(Child);
	       Queue(Child) := Tmp;
	       
	       Parent := Child;
	       Child := 2*Child +1;
	    else
	       Child := QSize; -- end of loop
	    end if;
	 end loop;
      end if;
      Queue_Mux.Release;
   end Remove_Heap;
   
   
   -- ���˲��� another version
   procedure Delete_Heap is 
      Hole, Child : QueuePtr;
      Last : Obj;
   begin
      Queue_Mux.Lock;

      Qsize := Qsize -1 ;
      Last  := Queue(QSize);
      
      Hole  := 0;
      Child := 1;
      while (Child < QSize) loop 

	 if (Child /= QSize-1) and (not (Queue(Child+1) >= Queue(Child))) then 
	    Child := Child + 1;  --  Right leaf
	 end if;
	 
	 if (Last >= Queue(Child)) then
	    Queue(Hole) := Queue(Child);
	    Hole := Child;
	    Child := Hole*2+1; -- left leaf   
	 else
	    Child := QSize;
	 end if;
      end loop;
      
      Queue(Hole) := Last;
      
      Queue_Mux.Release;
   end;
   
   function Top return Obj is
   begin
      if IsEmpty then
	 return Nul;
      else
	 return Queue(0);
      end if;
   end Top;
   
   function Get return Obj is
      Temp : Obj ;
   begin
      if IsEmpty then
	 Temp := Nul; 
      else 
	 Temp := Queue(0);
	 --Remove_Heap; 
	 Delete_Heap;
      end if;
      return Temp;
   end Get;
   
   procedure Flush is
   begin
      Qsize := 0;
   end;
   
begin
   Flush;
end Priority_Queue;
