----第六章 PL/SQL语句
--在Oracle中，提供了PL/SQL语句块，在执行的时候，可以把语句块作为整体提交到服务器
--可以把一些语句作为整体执行
--1.语法结构：
declare---声明部分(可以省略)
变量名 数据类型（长度）;
begin--语句块
语句块;
exception--异常处理（可以省略）
when 异常 then 异常处理;
end;
--2.属性类型：%type,%rowtype
  v_sal emp.sal%type;--列类型：v_sal变量与emp表的sal列数据类型一致
  v_emp emp%rowtype;--行类型
---3.流程控制语句:if,case,loop,while,for,goto,null
--1）if语句
--多分支
if    条件 then 语句块;
elsif 条件 then 语句块;
elsif 条件 then 语句块;
elsif 条件 then 语句块;
elsif 条件 then 语句块;
……
else 语句块;
end if;
----2)case...when...then 分支语句
--语法1：
case when 条件(v_sal<1000) then 语句块； 
     when 条件 then 语句块； 
     when 条件 then 语句块； 
……
     else 语句块；
end case;
--语法2:变量名=具体某些值的时候可以用以下语法  
case 变量名 when 值 then 语句块；
            when 值 then 语句块；
            when 值 then 语句块；
else 语句块;
end case;
---3）loop循环:相当于do..while循环
loop
  循环语句;
  
  exit when 循环终止条件;
end loop；
---4）while循环
--语法：
      while 循环条件
      loop 
        循环语句；
      end loop；
---5）for循环:变量不需要定义，循环语句执行完毕不需要写，i++；
--语法：
        for 变量名 in 1..100
        loop 
          循环语句;
        end loop;      
begin
  for v_count in 1..100
  loop
    insert into test_loop1 values(v_count,'name'||v_count);
  end loop;
end; 
---6）goto无条件跳转  goto <<标签名>>
---7）null空语句
-----------------------------------------
---4.异常处理:
--1)系统定义异常：   NO_DATA_FOUND 查不到数据
               --   TOO_MANY_ROWS 查询多行异常
               --   ZERO_DIVIDE除零异常

---除零操作异常
declare 
 v_num1 number(5);
 v_num2 number(5);
 v_num3 number(5);
begin
  v_num1:=&被除数;
  v_num2:=&除数;
  v_num3:=v_num1/v_num2;
  dbms_output.put_line(v_num3);
exception
 when zero_divide then
   dbms_output.put_line('除数为0异常');
 when others then
   dbms_output.put_line('其他异常'); 
end;

--找不到数据异常:查询编号是1111的员工信息
declare
v_emp emp%rowtype;--行变量
v_empno emp.empno%type;--列变量
begin
  v_empno:=&编号;
  select * into v_emp from emp where empno=v_empno;
  dbms_output.put_line('员工姓名为：'||v_emp.ename);
  dbms_output.put_line('员工职位为：'||v_emp.job);
exception
  when no_data_found then
    dbms_output.put_line('找不到数据'); 
  when others then
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);      
end;

select * from emp;

--找到多行异常
declare
v_emp emp%rowtype;
begin
  select * into v_emp from emp;
  dbms_output.put_line('员工姓名为：'||v_emp.ename);
  dbms_output.put_line('员工职位为：'||v_emp.job);
exception
  when no_data_found then
    dbms_output.put_line('找不到数据'); 
  when too_many_rows then
    dbms_output.put_line('返回多行');  
  when others then---其他异常一般写在异常处理的末尾
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);  
end;

---语法:系统定义异常
declare
begin
exception
  when 异常名 then 异常处理;
  when others then 异常处理;
end;

--2）用户自定义异常  
--步骤：
  1.在declare中声明异常:异常名 exception;
  2.在begin中抛出异常：raise 异常名;
  3.在exception中处理异常：when 异常名 then 异常处理;
  
declare
exc1 exception;--声明一个异常变量;
v_emp emp%rowtype;--行变量
v_count number(2):=0;--员工编号为某个值的员工数量
begin
 select count(*) into v_count from emp where empno=1111;
 if v_count<1 then
   raise exc1;--抛出数据找不到的异常
 end if;
 --正常的业务逻辑
 select * into v_emp from emp where empno=1111;
 dbms_output.put_line('员工姓名为：'||v_emp.ename);
 dbms_output.put_line('员工职位为：'||v_emp.job);
exception 
  when exc1 then
   dbms_output.put_line('员工不存在');
   --raise_application_error(-20001,'员工找不到异常');
end;

select * from emp where empno=1234;
select count(*) from emp where empno=1234;
----------------------------------


--第七章 游标的使用：可以理解为指针，实际上是一大块内存区域，
--可以把表中的一行数据存储在游标中做处理
---1.隐式游标:在pl/sql语句中执行增删改操作，以及单行查询的时候，
--会自动触发隐式游标，游标名叫sql
--隐式游标有如下属性：
%found:触发游标的增删改查操作是否被执行，执行了，返回true
%notfound
%rowcount:增删改查操作影响的行数
%isopen:判断游标是否被打开：隐式游标的%isopen属性永远为false

BEGIN
	update emp set ename='张三丰' where empno=7369;
	IF SQL%FOUND  THEN
		DBMS_OUTPUT.PUT_LINE('表已更新');
	END IF;
END;

BEGIN
    UPDATE emp SET deptno=20 WHERE empno=7111;  
    IF SQL%NOTFOUND THEN
      DBMS_OUTPUT.PUT_LINE('编号未找到');
 	  ELSE
		DBMS_OUTPUT.PUT_LINE('数据已更新');
	END IF;
     END;

select * from emp where empno=7839;
---2.显式游标

---3.REF游标（了解）





