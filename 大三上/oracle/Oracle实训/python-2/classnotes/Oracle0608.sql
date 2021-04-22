
------------------总结
1.用户创建
create user 用户名 identified by 密码;
create user zs identified by 123456;

2.用户修改
1)alter user 用户名 identified by 密码;

alter user zs identified by 111111;

2)alter user 用户名 account lock/unlock;

alter user zs account lock;

3.用户删除
drop user 用户名;
drop user 用户名 cascade;--用户下面如果有表，不能直接删除

drop user zs;




权限/角色的授予和收回
grant  权限/角色 to 用户;
grant create session to zhangsan;
grant connect to zhangsan;

revoke connect from zhangsan;
revoke create session from zhangsan;

grant  权限/角色 to 用户 with grant option;

revoke 权限/角色 from  用户;

create role 角色名;
grant 权限1，权限2，…… to 角色名;
drop role 角色名;



创建50个学生，每个学生都有20个权限；
创建有10个老师，每个老师都有15个权限；
grant 1,2,3,4,55,6， ……20 to s1;
grant 1,2,3,4,55,6， ……20 to s2;
grant 1,2,3,4,55,6， ……20 to s3;


create role student;
grant  1,2,3,4,55,6， ……20  to student;

grant student to s1,s2,s3,s4……s50;

create role teacher;
-------------------------------------------------
----系统常用的角色：connect,resource,dba

---用户的创建，修改和删除
create user ……
alter user ……
drop user……
---角色的创建，删除
create role ……
drop role……
---权限授予、收回
grant ……to ……
revoke …… from ……

grant dba to zhangsan;
--------------------------------------------------------

---二、基本数据结构及SQL语法
--1.SQL语句及数据结构
---1）SQL语句：结构化查询语句
select * from user_tables;--scott用户，默认自带4张表
select * from emp;---雇员表
select * from dept;
select * from bonus;
select * from salgrade;


---2）数据类型：字符，数值，日期时间类型
------1 字符类型：
            char(n)：固定长度的字符串,n表示字符串长度
            varchar2(n),可变长度的字符串，n表示字符串长度
-----2 数值类型：
            number(n):表示n位整数，最大38位
            number(a,b):表示存小数，a为数据长度，b为小数位数，举例：number(5,2)，其中数据一共是5位，2位是小数
            
---Oracle可以兼容其他数据库的int类型（相当于number(22)），varchar类型

-----3.日期时间类型：date,timestamp
select sysdate  from dual;--date类型，存储的是年月日时分秒
select systimestamp from dual;---timestamp类型，存储的是年月日时分秒，秒精确到小数点后六位，再加上时区信息

select * from dual;

--补充：sysdate表示当前系统时间；
      --  dual系统自带一张一行一列的伪表，可以用于进行数值的显示，不能修改表中数据;
 -----------------------------------------------------
        
----以zhangsan的用户身份，创建表      
create table test1
(
tno number(10),--学号
tname varchar2(5)--姓名，5位长度
);
select * from test1;


--------------------------------------------
create table test2
(
tno number(5,2),--学号
tname varchar2(5)--姓名，5位长度
);

insert into test2 values (10000.51,'tom');
insert into test2 values (100.51,'tom');

select * from test2;


create table test3
(
tno number(5),--学号
tname varchar2(5),--姓名，5位长度
tbirth date
);


insert into test3 values(10001,'james','19-7月-2000');

select * from test3;
-----------------------------
1.总结sql数据类型：1）字符：char(5),varchar2(5)
                2）数值:number(10),number(10,2)
                3）日期时间类型:date
                
                
---2.常用的SQL语句：DDL、DML、DCL、TCL
--1）DDL语言：数据定义语言：创建、修改、删除数据库对象
select * from test2;

-------1.创建表
create table 表名
(
列1名 数据类型 约束,
列2名 数据类型 约束,
列3名 数据类型 约束,
……
列n名 数据类型 约束
);

---创建t_student学生表
create table t_student
(
sid char(5) primary key,
sname varchar2(10),
ssex char(1),
sbirthday date,
stel varchar2(13),
sclass number(1)
);


drop table t_student;
insert into t_student(sid) values('10001');
select * from t_student;




 
alter table
drop table
truncate table



























