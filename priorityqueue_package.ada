with Interfaces; use Interfaces;

generic
   type Obj is private ;
   with function "<"(X,Y : in Obj) return Boolean;
   with function Nul return Obj; -- for 0

package PriorityQueue_Package is

   -- 定义一个例外，当队列为空时抛出
   Queue_Underflow: exception;
   
   -- 定义一个常量来表示优先队列的最大容量
   constant MaxSize: Positive := 1024;

   -- 定义PriorityQueue记录类型
   type PriorityQueue is record
      Elements: array (1 .. MaxSize) of Obj;  -- 存储元素的数组，索引从1到MaxSize
      Count: Natural := 0;                        -- 当前队列中的元素数量
   end record;

   -- 初始化优先队列
   procedure InitializeQueue(Q: in out PriorityQueue);

   -- 检查队列是否为空
   function IsEmpty(Q: PriorityQueue) return Boolean;

   -- 向队列中插入一个元素
   procedure Insert(Q: in out PriorityQueue; Item: Obj);

   -- 从队列中提取最大值
   function ExtractMax(Q: in out PriorityQueue) return Obj;

end PriorityQueue_Package;

package body PriorityQueue_Package is

   -- 初始化优先队列，清空数组并将计数器设为0
   procedure InitializeQueue(Q: in out PriorityQueue) is
   begin
      Q.Count := 0;
      for I in Elements'Range of Q loop
         Q.Elements(I) := 0;  -- 假设计0表示空位
      end loop;
   end InitializeQueue;

   -- 检查队列是否为空
   function IsEmpty(Q: PriorityQueue) return Boolean is
   begin
      return Q.Count = 0;
   end IsEmpty;

   -- 向优先队列中插入一个元素，保持堆的性质
   procedure Insert(Q: in out PriorityQueue; Item: Obj) is
   begin
      if Q.Count >= MaxSize then
         raise Queue_Overflow;  -- 队列已满，抛出例外
      end if;
      Q.Count := Q.Count + 1;
      Index := Q.Count;  -- 新元素的位置
      
      -- 将新元素上移，直到父节点不小于当前元素
      while Index > 1 and Q.Elements(Index / 2) < Item loop
         Swap(Q.Elements(Index), Q.Elements(Index / 2));
         Index := Index / 2;
      end loop;
   end Insert;

   -- 提取优先队列中的最大值，并保持堆的性质
   function ExtractMax(Q: in out PriorityQueue) return Obj is
      Result: Obj;
   begin
      if IsEmpty(Q) then
         raise Queue_Underflow;  -- 队列为空，抛出例外
      end if;
      Result := Q.Elements(1);  -- 取得根节点的值
      
      -- 将最后一个元素放到根位置，并进行堆化操作
      Q.Elements(1) := Q.Elements(Q.Count);
      Q.Count := Q.Count - 1;  -- 减少计数器
      
      Index := 1;
      
      -- 确保堆的性质保持，找到合适的位置插入最后一个元素
      while Index * 2 <= Q.Count loop
         -- 找到较大的子节点
         Child := Index * 2;
         if Child + 1 <= Q.Count and Q.Elements(Child) < Q.Elements(Child + 1) then
            Child := Child + 1;
         end if;
         
         -- 如果当前元素不大于子节点，则交换并继续循环
         if Q.Elements(Index) < Q.Elements(Child) then
            Swap(Q.Elements(Index), Q.Elements(Child));
            Index := Child;
         else
            exit;  -- 堆的性质保持，退出循环
         end if;
      end loop;
      
      return Result;
   end ExtractMax;

end PriorityQueue_Package;
