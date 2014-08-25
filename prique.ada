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

--------------------------------------------------
--  定义排序队列类属
--  线性表实现，O(n)复杂度
--------------------------------------------------
with Interfaces; use Interfaces;
with Unchecked_Conversion;
generic
   type Obj is private ;
   with function ">="(X,Y : in Obj) return Boolean;
--   with function "="(X,Y : in Obj) return Boolean;
   with function Nul return Obj; 
   
package PriQue is
   
   MAXCMDNUM    : constant := 512 ;
   type Queueptr is mod MAXCMDNUM;
   
   procedure Insert(Cmd_Data : in Obj);
   
   function  Look    return Obj;
   function  Get     return Obj;
   function  Depth   return Integer;
   function  IsEmpty return Boolean ;
   function  IsFull  return Boolean;
   procedure Flush;
   
end PriQue;

with System; use System;
package body PriQue is
   
   type QueueType is array(Queueptr) of Obj;
   Queue: QueueType;

   Rptr, Wptr : Queueptr;
   
   -- 指令队列修改操作通过该保护对象加锁
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
      return Rptr = Wptr ;
   end;
   
   function IsFull return Boolean is
      Temp : Queueptr;
   begin
      Temp := Wptr + 1;
      return Temp  = Rptr;
   end;
   
   procedure Append(Cmd_Data : in Obj) is
   begin
      if not IsFull then
	 Queue(Wptr) := Cmd_Data;
	 Wptr := Wptr +1 ;
      end if;
   end;   
   
   function Depth return Integer is
   begin
      return (MAXCMDNUM -Integer(Rptr)+Integer(Wptr)) mod MAXCMDNUM;
   end;
   
   procedure  Insert(Cmd_Data : in Obj) is
      P,Q   : QueuePtr;      
   begin
      Queue_Mux.Lock ;
      
      P     := Rptr; 
      if not IsFull then         
	 while ((P /= Wptr) and (Cmd_Data >= Queue(P)) ) loop
	    P := P+1;
	 end loop;
	 
	 if P /= Wptr then
	    Wptr := Wptr + 1;
	    Q    := Wptr;
	    while Q /= P loop
	       Queue(Q) := Queue(Q-1);
	       Q := Q-1;
	    end loop;
	    Queue(P) := Cmd_Data;
	 else
	    Append(Cmd_Data);
	 end if;
      end if;
      
      Queue_Mux.Release ;
   end;
   
   function Look return Obj is
   begin
      if IsEmpty then
	 return Nul;
      else
	 return Queue(Rptr);
      end if;
   end;
   
   function Get return Obj is
      Temp : Obj ;
   begin
      Queue_Mux.Lock ;
      
      if not IsEmpty then
	 Temp := Queue(Rptr);
	 Rptr := Rptr +1;
      else
	 Temp := Nul;
      end if;
      
      Queue_Mux.Release ;
      return Temp;
   end ;
   
   procedure Flush is
   begin
      Wptr := 0;
      Rptr := 0;
   end;
   
begin
   Wptr := 0;
   Rptr := 0;
end PriQue;
