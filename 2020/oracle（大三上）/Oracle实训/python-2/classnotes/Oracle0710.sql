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
	/*IF SQL%FOUND  THEN
		DBMS_OUTPUT.PUT_LINE('表已更新');*/
  IF SQL%rowcount>0  THEN
		DBMS_OUTPUT.PUT_LINE('表已更新');
  END IF;
  
  if sql%isopen then
    DBMS_OUTPUT.PUT_LINE('游标已打开');
  else
    DBMS_OUTPUT.PUT_LINE('游标已关闭');
	END IF;
END;
----------------------------------
BEGIN
    UPDATE emp SET deptno=20 WHERE empno=7111;  
    IF SQL%NOTFOUND THEN
      DBMS_OUTPUT.PUT_LINE('编号未找到');
 	  ELSE
		DBMS_OUTPUT.PUT_LINE('数据已更新');
	END IF;
     END;

select * from emp where empno=7839;
---2.显式游标：实现查询结果的循环遍历，显示多行查询结果
--显式游标需要显式地定义，打开，运行，关闭

--循环显示emp表中的员工姓名
declare
 v_ename emp.ename%type;
 --1.定义显式游标:cursor 游标名 is 查询语句;
 cursor c_ename is select ename from emp; 
begin
  --2.打开游标
  open c_ename;
  --查询结果不止一行
  loop
  --3.提取游标值，存到变量
  fetch c_ename into v_ename;
  dbms_output.put_line('员工姓名是：'||v_ename);
  exit when c_ename%notfound;
  end loop;
  --4.关闭游标
  close c_ename;
end;

---带参数的显式游标
--查询部门编号是20的员工编号，姓名和薪资
declare
cursor c_emp(dno number) is select empno,ename,sal from emp where deptno=dno;
--游标行中存储了几列数据，下面就需要定义几个变量去接收
v_empno emp.empno%type;
v_ename emp.ename%type;
v_sal emp.sal%type;
begin
  open c_emp(20);
  loop
    fetch c_emp into v_empno,v_ename,v_sal;
    dbms_output.put_line('员工编号是：'||v_empno||'姓名是：'||v_ename||'薪资是：'||v_sal);
    exit when c_emp%notfound;
  end loop;
  close c_emp;
end;

----引入游标行变量
declare
cursor c_emp(dno number) is select empno,ename,sal from emp where deptno=dno;
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
cursor c_emp(dno number) is select empno,ename,sal from emp where deptno=dno;
begin
  for r_emp in c_emp(20)
    loop
      dbms_output.put_line('员工编号是：'||r_emp.empno||'姓名是：'||r_emp.ename||'薪资是：'||r_emp.sal);
    end loop;    
end;
---用游标来更新、删除行（看明白即可）
--给emp表中的员工加薪，薪资最高的不加钱，第二高的加100，以此类推

DECLARE 
--用游标更新/删除行时，需要在select后面加上for update
   CURSOR c_emp IS
     SELECT empno,ename,sal FROM emp ORDER BY sal DESC FOR UPDATE;    
   v_increase NUMBER:=0; --增加的工资数
   v_new_sal NUMBER;     --新工资
BEGIN
   FOR r_emp IN c_emp 
     LOOP
     v_new_sal:=r_emp.sal+v_increase;
     --用游标做更新操作，需要末尾加上where current of 游标名
     UPDATE emp SET sal=v_new_sal WHERE CURRENT OF c_emp;
     DBMS_OUTPUT.PUT_LINE(r_emp.empno||'的员工初始薪资为：'
     ||r_emp.sal||'，涨后的薪资为：'||v_new_sal);
     v_increase:=v_increase+100;
   END LOOP;
END;
------显式游标：用于进行表中数据的循环打印
--实现步骤：
--1.在declare中声明游标：cursor 游标名（参数名 数据类型） is  查询语句；
                 --     cursor 游标名 is  查询语句；
--2.在begin中打开游标：open 游标名(参数);
                    --open 游标名;
--3.在loop循环中提取游标数据存到变量：fetch 游标名 into 变量;
--4.在end前，关闭游标，close 游标名；    
    
 --for循环中：1）声明游标
          --  2）使用游标：for 变量名 in 游标名


---3.REF游标（了解）：定义一个游标，在具体使用的时候根据需要去指向具体的表;

------第八章 存储过程和函数
--1.存储过程：起了名字的plsql语句块
--定义存储过程语法：
        create procedure 过程名
        as|is
        --变量的声明
        begin
        --语句块;
        exception
        --异常处理;
        end 过程名;
---调用存储过程语法：
 begin 
   过程名；
 end;
-----------定义无参的存储过程:打印hello world
CREATE PROCEDURE ss_helloWorld
AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello World!');
END ss_helloWorld; 

--调用存储过程
begin 
  ss_helloWorld;
end;







