------第八章 存储过程和函数
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
   
--补充：scott创建一个存储过程sp_hello,这个存储过程默认只有scott可以用
如果希望其他的普通用户也能使用这个存储过程：
grant execute on 存储过程名 to 用户名;--该用户可以访问其他人写的存储过程
grant execute on 存储过程名 to public;--所有用户可以访问当前的存储过程

--删除
drop procedure 过程名;
----------------二、函数：带返回值的plsql语句块
--语法：
--定义函数
create or replace function 函数名(参数名 数据类型)--参数只能是in类型，数据类型只能是基本类型
return 返回值类型
as|is
声明变量
begin
  语句块
  return 返回值；
exception
  异常处理;
end;
--调用语法：
--用plsql语句接收
begin
  函数名（参数）； 
end;
--用dual伪表进行显示
select 函数名（参数） from dual；

----通过调用函数实现字符串的显示（无参函数）
CREATE OR REPLACE FUNCTION func_hello
RETURN  VARCHAR2
as
BEGIN
  RETURN '朋友，您好';
END;

select func_hello from dual;

--plsql
declare
 v_hello varchar2(20);
begin
  v_hello:=func_hello;
  dbms_output.put_line(v_hello);
end;

begin
  dbms_output.put_line(func_hello);
end;

---带参数的函数实现：在dept表中查找部门编号对应的部门名称 
   create or replace function func_dept(v_deptno number)
   return varchar2
   as
   v_name varchar2(20);
   begin
     select dname into v_name from dept where deptno=v_deptno;
     return v_name;
   exception
     when others then
       dbms_output.put_line('出现异常');
   end;       
---调用
 select func_dept(50) from dual;  
 
---存储过程   
 create or replace procedure sp_dept(v_deptno number,v_name out varchar2)
   as
   begin
     select dname into v_name from dept where deptno=v_deptno;
   exception
     when others then
       dbms_output.put_line('出现异常');
   end;
--调用
declare
v_name varchar2(20);
begin 
  sp_dept(50,v_name);
  dbms_output.put_line(v_name);        
end;   
--存储过程和函数的语法区别
create or replace procedure 过程名(参数名 in/out/in out 数据类型)
as|is
变量声明
begin
  语句块
exception 
  异常处理
end 过程名;
--函数语法
create or replace function 函数名(参数名 数据类型)
return 返回值类型
as|is
变量声明
begin
  语句块
  return 返回值;
exception 
  异常处理
end 函数名;

---调用的区别：
存储过程：plsql语句调用
函数：plsql语句调用，dual调用

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

--触发器实现的效果：每次对表emp做sal列的更新时，触发触发器，往另一张表中把薪资的涨幅记录下来

---DML行级触发器语法
create or replace trigger 触发器名
before/after 增删改语句 for each row---触发器在增删改操作之前触发，用before,否则用after
begin
  语句块;
end 触发器名;

----DML行级触发器：before类型
---给员工加薪,最多不能加薪10%
update emp set sal=sal+2000 where empno=7369;

create or replace trigger tri_emp_sal
before update of sal on emp for each row
declare
   v_scale number(5,1);
begin
   v_scale:=(:NEW.sal-:OLD.sal)/:OLD.sal;--涨幅
   IF  v_scale>0.1  THEN
      DBMS_OUTPUT.PUT_LINE('对不起，员工的加薪比例不能超过10%！');
      :NEW.sal:=:OLD.sal*1.1;
   END IF;
end tri_emp_sal;
----------------以上，相当于给emp表的sal列做更新时，添加一个约束
select * from emp;

update emp set sal=5000 where empno=7934;
update scott.emp set sal=sal+5 where empno=7934;

--语句级触发器（看懂）
--如果当前不是scott操作emp表，报异常
----before类型的dml语句级触发器：

CREATE OR REPLACE TRIGGER  tr_emp_bef
BEFORE INSERT OR UPDATE OR DELETE ON emp----对表做了增加，修改，删除操作，触发触发器
BEGIN
  IF user <> 'SCOTT' THEN
     RAISE_APPLICATION_ERROR(-20001,'您无权修改EMP表');
  END IF;
END tr_emp_bef;

---after类型的dml语句级触发器：
--不论对emp表哪一列做了增删改操作，具体操作数据存到另一张表

CREATE OR REPLACE TRIGGER tr_emp_aft
AFTER INSERT OR UPDATE OR DELETE ON emp
BEGIN
CASE 
     WHEN  INSERTING  THEN
        INSERT INTO t_emp_dml values(user,sysdate,'INSERT');
     WHEN  UPDATING  THEN
        INSERT INTO t_emp_dml values(user,sysdate,'UPDATE');
     WHEN  DELETING  THEN
        INSERT INTO t_emp_dml values(user,sysdate,'DELETE');
   END CASE;
END tr_emp_aft;


---对emp表做了增删改操作之后，数据存在下表中
CREATE TABLE t_emp_dml
(
  who varchar2(10), --用户
  when date,   --时间
  operater varchar2(10) --操作类型
);

--对emp表做增删改操作，都会触发tr_emp_aft语句级触发器，往表中填入数据
delete from emp where empno=7934;

select * from t_emp_dml;--删除数据的信息存在了该表中
select * from emp;
----------------------------
create table t_student
(
sid char(5),
sname varchar2(15),
……
);
-----创建带有输出参数的存储过程:输出dept表中的记录数
create or replace procedure sp_count(v_count out number)
as
begin
  select count(*) into v_count from t_student;
end sp_count;

--调用
declare
v_count number(10);
begin
  sp_count(v_count);
  dbms_output.put_line(v_count);
end;

----引入游标行变量
declare
cursor c_emp is select * from t_student;
r_emp c_emp%rowtype;--游标行变量，存储三列数据
begin
  open c_emp(20);--打开游标的时候传参
  loop
    fetch c_emp into r_emp;
    dbms_output.put_line('员工编号是：'||r_emp.empno||'姓名是：'||r_emp.ename||'薪资是：'||r_emp.sal);
    exit when c_emp%notfound;
  end loop;
  close c_emp;
end;
--引入for循环打印游标:存储游标中的值的变量不需要声明，游标的打开，提取和关闭都不需要了
declare 
cursor c_emp is select * from t_student;
begin
  for r_emp in c_emp(20)
    loop
      dbms_output.put_line('学号：'||r_emp.sid||'姓名是：'||r_emp.sname);
    end loop;    
end;






