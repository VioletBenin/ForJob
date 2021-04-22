---二、基本数据结构及SQL语法
--1.SQL语句及数据结构
---1）SQL语句：结构化查询语句
---2）数据类型：字符，数值，日期时间类型
1.总结sql数据类型：1）字符：char(5),varchar2(5)
                  2）数值:number(10),number(10,2)
                  3）日期时间类型:date
                       
---2.常用的SQL语句：DDL、DML、DCL、TCL
--1）DDL语言：数据定义语言：创建、修改、删除数据库对象(表)

-------1.创建表
create table 表名
(
列1名 数据类型 约束,
列2名 数据类型 约束,
列3名 数据类型 约束,
……
列n名 数据类型 约束
);
---创建表
create table t_student 
(
sid varchar2(5),
sname varchar2(10),
ssex char(1),
sbirthday date,
stel number(11),
sclass number(2)
);

-----2.修改表：修改表的表结构
alter table 表名 ……

---1）增加表列
alter table 表名 add 列名 列数据类型;
alter table t_student add saddress varchar2(50);

---2）修改表列的数据类型
alter table 表名 modify 列名 新的数据类型;

alter table t_student modify saddress varchar2(80);

---3）重命名表列
alter table 列名 rename column 旧列名 to 新列名;

alter table t_student rename column saddress to saddr;

---4）删除表列
alter table 表名 drop column 列名;

alter table t_student drop column stel;

---5）给表列添加约束
alter table 表名 add constraint 约束名 具体约束;
alter table t_student add constraint uk_student_sname unique(sname);---给t_student表的sname列添加唯一约束

---6)给表列删除约束
alter table 表名 drop constraint 约束名;
alter table t_student drop constraint uk_student_sname;


---3.删除整张表
drop table 表名；

drop table t_student;---删除整张表，删除后的表不能恢复

--4.删除表内容，表结构能保留
truncate table 表名;

select * from user_tables;---user_tables是一张数据字典，存取的是当前用户创建的所有表

select * from test3;
truncate table test3;---表结构还存在，表中的内容删掉了

----truncate与drop的区别：truncate删除表内容，保留表结构；drop删除整张表，不保留表结构；
                      ---相同之处是，删除操作不写日志，一旦删除，数据不能恢复
                      
                      
--5.重命名表
rename 旧表名 to 新表名;
rename test to tt;

---------------------ddl语句总结：数据定义语言：创建、修改、删除数据库对象的语言
create table
alter table
drop  table
truncate table
rename 旧表名 to 新表名;
……


----------------------
create table t_student 
(
sid varchar2(5),
sname varchar2(10),
ssex char(1),
sbirthday date,
stel number(11),
sclass number(2)
);
---2）DML语言：数据操纵语言：增删改查语句

---插入数据


--给表中添加一条完整的记录
insert into 表名 values (列1值，列2值，列3值，……，列n值);

insert into t_student values('10001','张三','m','19-7月-2000',13012341234,01);
insert into t_student values('10002','李四','m','31-5月-2000',13012345678,02);

--只想给表中的某几列添加数据
insert into 表名(列1，列2) values（列1值，列2值）;

insert into t_student(sid,sname) values ('10003','王五');
insert into t_student(sid,ssex) values ('10004','f');

---更新数据
update 表名 set 列名=列值;

update t_student set sclass=3 ;--把表中所有记录的sclass都更新成3
update t_student set sclass=3 where sname='王五';--where条件作为一个筛选，把姓名是王五的同学的班级更新成3班


---删除数据
delete 表名;
delete from 表名;---删除表的内容

delete from t_student;---1）删除表内容,可以恢复
                      ---2）可以删除表中的某几条记录
delete from t_student where sid='10001'; --删除学号是10001的学生信息                

---ddl中也有删除表drop，truncate
truncate table t_student;
drop table t_student;

---delete,truncate.drop区别
--delete删除表内容（删除整张表内容，或者删除某几条记录），保留表结构；删除操作会写日志，删除的数据可以恢复；（灵活，不如truncate和drop删除速度快）
--truncate删除整张表内容，保留表结构；但是删除不写日志，不能恢复；
--drop删除整张表，不保留表结构；不写日志，删除不能恢复。


---查看数据
select * from 表名;---查看表中的全部信息
select 列名1，列名2 from 表名;---查看表中的某几列信息

select * from t_student;
select * from user_tables;


-----DML语句总结：数据操纵语言，对数据进行增删改查的语句

create/alter/drop/truncate table 表名……--ddl语句

insert into/update/delete from/select 表名 …… ---dml语句

insert into 表名(列1，列2，……) values(列值1，列值2，……);

delete from 表名 where 条件;
delete from t_student where sid='10001';

update 表名 set 列名=列值 where 条件;
update t_studnet set sname='张三' where sid='10002';

select 列1，列2，…… from 表名 where 条件；
select sid,sname from t_student where sclass=1;










