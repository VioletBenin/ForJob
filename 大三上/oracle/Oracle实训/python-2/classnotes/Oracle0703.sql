---3.视图：让不同的人对同一张表有不同的视角，不同的权限
----------不同的人看同一张表，看到的内容不一样
---创建视图(需要授权)
grant create view to scott;

create view 视图名
as
查询语句;
---把表连接的查询语句用视图代替
create view emp_dept_acc
as
select * from emp natural join dept where deptno=10;

--可以通过视图查询原来那张表
select * from emp_dept_acc;

create or replace view 视图名
as
查询语句;
-----------创建或者替换视图
create or replace view emp_dept_acc
as
select * from emp natural join dept where deptno=10;

---把排序结果做成视图
create or replace view emp_dept_acc
as
select * from emp natural join dept where deptno=10 
order by sal asc;

select * from emp_dept_acc;

---把分组查询的结果做成视图:视图中要求把聚合函数生成的列起别名
create view emp_dept_avg
as
select deptno,avg(sal) avgs from emp natural join dept
group by deptno;

---把表连接的查询结果做成视图的时候，如果表连接之后有公共的列，
---不能直接创建视图
create or replace view ed
as
select emp.*,dept.dname from emp join dept on emp.deptno=dept.deptno;

select * from ed;


----修改视图
select * from emp_dept_acc;---查询财务部的员工信息和部门信息

---可以对原始表做更新操作，原始表数据变，视图数据跟着变
update emp set ename='张三' where empno=7934;
update dept set dname='财务部' where deptno=10;

---也可以在视图中对数据直接做增删改
update emp_dept_acc set ename='张三丰' where empno=7934;
select * from emp;

update emp_dept_acc set dname='金融中心' where deptno=10;
---emp_dept_acc视图由两张表结合而成，emp+dept===>
---视图中的主键empno，是在emp中，emp表称为键保留表，键保留表中的数据可以在视图中做增删改操作

---with check option:在视图中插入/修改数据时，会检查条件是否满足
--不满足where条件的数据，不能插入到视图中
create or replace view emp_clerk
as
select * from emp where job='CLERK'
with check option;

---视图中查的是clerk的员工信息，对视图进行修改或者插入数据的时候，
--如果不是clerk的数据不允许做修改

---在视图中插入数据
insert into emp_clerk values(1111,'张33','SALES',7369,
'12-7月-1981',8000,100,40);

select * from emp;

select * from emp_clerk;
---force:把某张表，或者某几张表的表连接的查询结果做成视图，而基表还没有创建，
--可以通过force强制创建视图
create or replace force view test
as
select * from aa natural join bb where aa.no=1000;

--删除视图
drop view ed;
------------视图的总结：
--作用：1.常用的一些复杂的查询结果，做成视图比较方便；
--      2.可以隐藏基表
--1.创建(需要授权)：
          create or replace view 视图名 
          as
          查询结果;
--2.删除：drop view 视图名

----第六章 PL/SQL语句
--在Oracle中，提供了PL/SQL语句块，在执行的时候，可以把语句块作为整体提交到服务器
--可以把一些语句作为整体执行

--语法结构：
declare---声明部分(可以省略)
begin--语句块
exception--异常处理（可以省略）
end;


begin
  DBMS_OUTPUT.PUT_LINE('hello pl/sql');--控制台打印输出
end;

--完整的pl/sql语句块
declare
--变量名 数据类型（数据范围）;
  v_empno number(10):=1000;
  v_empno1 number(10) default 2000;
  v_empno2 number(10);
  PI constant number(3,2):=3.14;--常量
begin
  dbms_output.put_line('v_empno的值为'||v_empno);
  dbms_output.put_line('PI的值为'||PI);
exception
  when others then
    dbms_output.put_line('出现异常');
end;
---对于plsql中的变量的数据类型，可以使用sql语句中的数据类型：varchar2，char,number,date;
--除此之外，还可以使用两种属性类型：%type,%rowtype
declare
v_empno number(10):=1234;
v_ename varchar2(20);
begin 
  select ename into v_ename from emp where empno=v_empno;
  dbms_output.put_line('员工姓名为：'||v_ename);  
end;


declare
v_empno emp.empno%type:=1234;
v_ename emp.ename%type;
begin 
  select ename into v_ename from emp where empno=v_empno;
  dbms_output.put_line('员工姓名为：'||v_ename);  
end;

select ename from emp where empno=1234;
  
