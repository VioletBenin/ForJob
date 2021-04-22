------第八章 存储过程和函数
--1.存储过程：起了名字的plsql语句块
--定义存储过程语法：
        create or replace procedure 过程名
        as|is
        --变量的声明
        begin
        --语句块;
        exception
        --异常处理;
        end 过程名;
--最简单的存储过程语法
create procedure 过程名
as|is
begin
  语句块;
end;

---调用存储过程语法：
 begin    
   过程名；
 end;
-----------定义无参的没有变量的存储过程:打印hello world
CREATE or replace PROCEDURE ss_helloWorld
as
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello World!');
END ss_helloWorld; 

--调用存储过程
begin 
  ss_helloWorld;
end;
------定义带输入参数的存储过程
CREATE or replace PROCEDURE sp_hello(v_hello varchar2)
as
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_hello);
END sp_hello; 

--调用1
begin
sp_hello('hello');
end;
--调用2
declare
v_test varchar2(20);
begin
v_test:='&字符串：';
sp_hello(v_test);
end;

------定义带多个输入参数的存储过程
create or replace procedure sp_dept
(v_deptno number,v_name varchar2,v_loc varchar2)
as
begin
  --往dept表中插入一行数据
  insert into dept values(v_deptno,v_name,v_loc);
  --commit;
  exception
    when others then 
      dbms_output.put_line('插入的数据有误，数据回滚'||sqlerrm);
      --rollback;
end;

begin
sp_dept(50,'行政部','青岛');  
end;

select * from dept;

----通过声明变量的方式实现：输出dept表中的记录数，v_count不能在存储过程外使用
create or replace procedure sp_count
as
v_count varchar2(20);
begin
  select count(*) into v_count from dept;
  dbms_output.put_line(v_count);
end sp_count;

-----创建带有输出参数的存储过程:输出dept表中的记录数
create or replace procedure sp_count(v_count out number)
as
begin
  select count(*) into v_count from dept;
end sp_count;

--调用
declare
v_count number(10);
begin
  sp_count(v_count);
  dbms_output.put_line(v_count);
end;

---存储过程中，可以既有输入参数，也有输出参数
--v_deptno是输入参数，v_name,v_loc是输出参数
create or replace procedure sp_dept1
(v_deptno number,v_name out varchar2,v_loc out varchar2)
as
begin
  --把编号是v_deptno的部门名称和部门所在地传递出去
  select dname,loc into v_name,v_loc from dept where deptno=v_deptno;  
end sp_dept1;

--调用
declare
v_name varchar2(20);
v_loc varchar2(20);
begin
  sp_dept1(40,v_name,v_loc);
  dbms_output.put_line('部门名称是：'||v_name||',部门所在地在：'||v_loc);
end;

  
---存储过程中，参数既是输入参数，也是输出参数
create or replace procedure sp_value
(v_name in out varchar2)
as
v_count number(5);
begin
  select count(*) into v_count from dept where dname=v_name;
  if(v_count>0) then
    v_name:='存在';
  else
    v_name:='不存在';
  end if;    
end sp_value;
-------------------
--调用
declare
v_name varchar2(20):='财务部';
begin
 sp_value(v_name);  
 dbms_output.put_line('部门'||v_name);
end;

select count(*) from dept where dname='行政部';
----------------存储过程总结：
--1.语法结构
  ---定义
    create or replace procedure 过程名(参数列表)
    as|is
    ---变量的声明
    begin
    ---语句块
    exception
    ---异常处理
    end 过程名;
     
  ---调用
    begin
      过程名(参数);
    end;
--2.参数：in(输入参数，in可省略),out（输出参数，不能省略）,in out（参数既输入又输出）
   create or replace procedure 过程名（变量 in/out/in out 数据类型）
   
   --对带有输出参数的存储过程，调用的时候需要在declare中进行变量声明
   declare
   变量名 数据类型；
   begin
     ---存储过程是输出参数，变量的具体值需要执行完存储过程才能获取到
     过程名(变量名)； 
   end;
   
---第九章 触发器：比较复杂的约束：当特定事件发生的时候会自动触发的一种存储过程
--按触发事件的不同，触发器分为3类：DML触发器 ，instead of触发器，系统触发器
    
--DML触发器：对表进行增删改操作的时候添加的约束：
---行级触发器（影响一行）、语句级触发器（影响一整张表）
---行级触发器：after:进行完增删改操作之后激活触发器
           ---before：先激活触发器，再去判断增删改操作是否符合触发器的要求
 
--现要审计员工工资变动情况，用一个表来记录相关信息，利用AFTER行级触发器向表中插入数据

--emp表中有员工薪资sal,把员工的涨幅存在另一张表中
--创建工资涨幅表
CREATE TABLE t_emp_sal_change
(
  time DATE,     ---变动时间
  empno NUMBER(4),    ---员工编号
  oldsal NUMBER(7,2),    ---初始薪资
  newsal NUMBER(7,2)    ---涨后薪资
);

select * from emp;
update emp set sal=? where empno=7369;

---创建dml的after行级触发器
create or replace trigger 触发器名
after/before update of 列名 on 表 for each row
begin
  语句块;
end 触发器名;


----------------每次对emp表中的sal列做更新操作之后，做以下事情：
CREATE OR REPLACE TRIGGER tr_emp_aft_row
AFTER UPDATE OF sal ON emp FOR EACH ROW
BEGIN
   INSERT  INTO t_emp_sal_change
   VALUES(sysdate,:OLD.empno,:OLD.sal,:NEW.sal);
END tr_emp_aft_row;
