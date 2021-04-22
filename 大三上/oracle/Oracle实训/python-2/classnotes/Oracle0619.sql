---3.基本sql查询 
--一、简单查询：单表查询
select * from 表名;
select * from 表名 where 条件;
select 列1，列2 from 表名 where 条件;
select 列1 (as) 别名1，列2 (as) 别名2 from 表名 where 条件;
select * from 表名 order by 列名 (asc)/desc;
select * from 表名 where 条件 like '%_';
select distinct 列名 from 表名；

---补充：旧表生成新表：create table 新表名 as select *  from 旧表名;
select * from t_student;
--创建一张t_student结构一致，数据也一致的表，作为t_student表的备份
create table tt_student as (select * from t_student);
---创建一张与t_student表结构一致的空表
create table tt_student1 as (select * from t_student where 1=2);  
create table tt_student2 as (select * from t_student where sid='10001');  
select * from tt_student2;
drop table tt_student;


---二、多表查询:把几张表连接在一起进行查询
select * from t_student;
select * from t_score;
---1.内连接:把2张表中符合条件的数据筛选出来。
--语法1：select * from 表1 join 表2 on 表1.列=表2.列;(常用)
select t_score.sid,sname,score from t_student 
join t_score on t_student.sid=t_score.sid;
--语法2：select * from 表1，表2 where 表1.列=表2.列;
select * from t_student,t_score where t_student.sid=t_score.sid;

---2.外连接：
select * from 表1 left/right/full join 表2 表1.列=表2.列；

select * from t_teacher;
select * from t_teachercourse;

---1.内连接：
select * from t_teacher join t_teachercourse on 
t_teacher.tid=t_teachercourse.tid;
---2.外连接
---想把t_teacher表数据都显示
select * from t_teacher left join t_teachercourse on 
t_teacher.tid=t_teachercourse.tid;
---想把t_teachercourse表数据都显示
select * from t_teacher right join t_teachercourse on 
t_teacher.tid=t_teachercourse.tid;
---想把2张表数据都显示
select * from t_teacher full join t_teachercourse on 
t_teacher.tid=t_teachercourse.tid;
----3.交叉连接：把表1中的每条记录与表2中的每条记录做笛卡尔积
--语法1：select * from 表1 cross join 表2;
--语法2：select * from 表1，表2;
select * from t_student cross join t_teacher;
----4.自然连接：等值的内连接
select * from 表1 natural join 表2;
select * from 表1 join 表2 on 条件;

select * from 表1 join 表2 on 表1.id=表2.sid;---
select * from 表1 natural join 表2；---两张表需要有公共列，自动匹配并显示

---5.自连接：自己与自己进行连接
--以scott用户的emp表为例去看：

select * from user_tables;
select * from emp;
select * from dept;
---自连接的应用：查询emp表中员工编号，员工姓名，上级领导编号，以及上级领导姓名
select empno 员工编号,ename 员工姓名 ,mgr 上级领导编号 from emp;

select e1.empno,e1.ename,e1.mgr,e2.ename from emp e1 join emp e2 on e1.mgr=e2.empno;

-----表连接总结：内、外、交叉、自然、自连接
select * from 表1 join 表2 on 条件;--内
select * from 表1 left/right/full join 表2 on 条件;--外
select * from 表1 cross join 表2;--交叉
select * from 表1 natural join 表2; --自然

---给表起别名
select * from 表1 表别名1 join 表2 表别名2 on 条件;--给表起别名不能加as


select * from t_student t1 join t_score t2 on t1.sid=t2.sid;
select * from t_student t1 join t_score t2 on t1.sid!=t2.sid;
select * from t_student t1 natural join t_score t2;


---三、分组查询

---四、子查询






          
               
















