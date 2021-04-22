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

begin
  DBMS_OUTPUT.PUT_LINE('hello pl/sql');--控制台打印输出
end;

---2.数据类型
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

---查询员工编号是1234的员工姓名
--用sql
select ename from emp where empno=1234;

--用pl/sql语句块
declare
v_empno number(10):=1234;
v_ename varchar2(20);
begin
  select ename into v_ename from emp where empno=v_empno;
  dbms_output.put_line('员工姓名为：'||v_ename);  
end;
---pl/qsl变量的数据类型：char,varchar2,number,date外，还有
--%type，%rowtype
select * from emp;
---%type:列类型 ------变量名 表名.列名%type;

declare
v_empno emp.empno%type:=1234;
v_ename emp.ename%type;
begin 
  select ename into v_ename from emp where empno=v_empno;
  dbms_output.put_line('员工姓名为：'||v_ename);  
end;
---%rowtype：行类型
---查询员工编号是1234的员工信息：ename,job,mgr,sal,deptno
  declare
v_empno emp.empno%type:=1234;
v_ename emp.ename%type;
v_job   emp.job%type;
v_mgr   emp.mgr%type;
v_sal   emp.sal%type;
v_deptno emp.deptno%type;
begin 
  select ename,job,mgr,sal,deptno 
  into v_ename,v_job,v_mgr,v_sal,v_deptno 
  from emp where empno=v_empno;
  dbms_output.put_line('员工姓名为：'||v_ename);  
  dbms_output.put_line('员工职位为：'||v_job); 
  dbms_output.put_line('员工领导编号为：'||v_mgr); 
  dbms_output.put_line('员工薪资为：'||v_sal);
  dbms_output.put_line('员工部门编号为：'||v_deptno);  
end;
----------------------------
declare
v_empno emp.empno%type:=1234;
v_emp emp%rowtype;--行类型：变量名 表名%rowtype;把表中的一行数据整体赋值给一个变量
begin 
  select * into v_emp
  from emp where empno=v_empno;
  dbms_output.put_line('员工姓名为：'||v_emp.ename);  
  dbms_output.put_line('员工职位为：'||v_emp.job); 
  dbms_output.put_line('员工领导编号为：'||v_emp.mgr); 
  dbms_output.put_line('员工薪资为：'||v_emp.sal);
  dbms_output.put_line('员工部门编号为：'||v_emp.deptno);  
end;

---3.流程控制语句
--1）if语句
--对某一编号的员工实现加薪操作：加薪原则：
--如果原工资小于1000，则加200元，如果原工资大于等于1000且小于2000，则加150元，否则加100元
declare
  v_sal emp.sal%type;--列类型：v_sal变量与emp表的sal列数据类型一致
begin 
  select sal into v_sal from emp where empno=7369;
  --对v_sal变量做操作
  if v_sal<1000 then
    --薪资+200
    update emp set sal=sal+200 where empno=7369;
  elsif v_sal>=1000 and v_sal<2000 then
    update emp set sal=sal+150 where empno=7369;
  else 
    update emp set sal=sal+100 where empno=7369;
  end if;
end;

select * from emp where empno=7369;
---if..else语法：
--单分支
if 条件 then
   语句块；
end if;

--双分支
if 条件 then 语句块；
else         语句块;
end if;

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
---加薪
declare
  v_sal emp.sal%type;--列类型：v_sal变量与emp表的sal列数据类型一致
begin 
  select sal into v_sal from emp where empno=7369;
  --对v_sal变量做操作
  case when v_sal<1000 then
    update emp set sal=sal+200 where empno=7369;
       when v_sal>=1000 and v_sal<2000 then
    update emp set sal=sal+150 where empno=7369;
       else 
    update emp set sal=sal+100 where empno=7369;
  end case;
end; 

--语法2:变量名=具体某些值的时候可以用以下语法  
case 变量名 when 值 then 语句块；
            when 值 then 语句块；
            when 值 then 语句块；
else 语句块;
end case;

declare
  v_sal emp.sal%type;--列类型：v_sal变量与emp表的sal列数据类型一致
begin 
  select sal into v_sal from emp where empno=7369;
  --对v_sal变量做操作
  case v_sal when 1000 then
    update emp set sal=sal+200 where empno=7369;
             when 1300 then
    update emp set sal=sal+150 where empno=7369;
             else 
    update emp set sal=sal+100 where empno=7369;
  end case;
end; 

---3）loop循环
loop
  循环语句;
  exit when 循环终止条件;
end loop；


create table test_loop1
(
id number(5),
name varchar2(20)
);
---往表中循环插入100条记录
declare
v_count number(5):=1;
begin
  loop
    insert into test_loop1 values(v_count,'name'||v_count);
    v_count:=v_count+1;
    exit when v_count>100;
  end loop;
end;

select * from test_loop1;
---4）while循环
--语法：while 循环条件
      loop 
      end loop；
      
declare
v_count number(5):=1;
begin
  while v_count<=100
  loop
    insert into test_loop1 values(v_count,'name'||v_count);
    v_count:=v_count+1;
  end loop;
end;
---5）for循环
--语法：for 变量名 in 1..100
        loop 语句块
        end loop;
        
begin
  for v_count in 1..100
  loop
    insert into test_loop1 values(v_count,'name'||v_count);
  end loop;
end; 

--6)goto语句：无条件跳转
--7）null语句    
DECLARE
    v_sal emp.sal%TYPE;
BEGIN
  select sal into v_sal from emp where empno=7369;
  IF  v_sal <2000  THEN
      GOTO UPDATION;--无条件跳转到某一个标签
  ELSE
      NULL;--空语句，什么都不执行
  END IF;
  --……省略了一些语句
  <<UPDATION>>  --<<标签名>>
  update emp set sal=2000 where empno=7369;
END;

  
        




