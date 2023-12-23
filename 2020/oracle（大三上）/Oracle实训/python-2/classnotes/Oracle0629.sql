模式:用户以及用户所创建的数据库对象，统称为模式
select * from emp;
select * from scott.emp;--模式.数据库对象名
----第五章 数据库对象：同义词、序列、视图
---1.同义词：给表名起一个别名（永久性）：synonym

--为了后续进行表连接或者子查询方便，给表临时起别名
select * from emp e0;
select * from user_tables;
select * from salgrade;--薪资等级表

--创建私有同义词（需要授权）
grant create synonym to scott;
--创建私有同义词，只能自己使用
create synonym sg for salgrade;--创建salgrade表的同义词,默认创建的是私有同义词
--创建公有同义词，可以让其他用户访问（授权）
create public synonym sg1 for salgrade;
grant create public synonym to scott;--授予公有同义词的权限
--删除私有同义词（不需要授权）
drop synonym sg;
--删除公有同义词（授权）
grant drop public synonym to scott;
drop public synonym sg1;

--可以自己给自己的表起别名去访问，也可以给别的用户的表创建同义词访问
---使用普通用户qst访问scott用户的emp表
select * from scott.emp;

grant select on scott.emp to qst;--访问scott用户的访问emp表的权限给qst

grant create synonym to qst;
grant create public synonym to qst;
grant drop public synonym to qst;

create synonym e1 for scott.emp;---私有同义词e1
create public synonym e2 for scott.emp;--公有同义词e2
select * from e2;---e1替代了scott.emp
--------------------------------------
---总结：同义词：给表起别名
--create synonym 同义词名 for 表名;        创建私有同义词，需要授权
--create public synonym 同义词名 for 表名; 创建公有同义词，需要授权
--drop synonym 同义词名;
--drop public synonym 同义词名;            删除公有同义词，需要授权

grant create/drop public synonym to 用户;

--2.序列：给某一列自动生成序号
--创建序列
create sequence 序列名
start with 10001---序列的起始值
increment by 1  ----序列的增量
maxvalue 10100  ---序列的最大值
minvalue 00001  ---序列的最小值
cycle           ---序列可循环，nocycle不循环
cache 30;       ---nocache没有缓存

---创建一个简单的序列
create sequence sq1
start with 10001
increment by 1;

drop table test1;
create table test1
(
tid number(5),---学号
tname varchar2(20)---姓名
)segment creation immediate;

insert into test1 values(10001,'张三');
insert into test1 values(10002,'张三');
insert into test1 values(10003,'张三');
--通过序列自动生成学号
insert into test1 values(sq1.nextval,'张3');
insert into test1 values(sq1.nextval,'李4');
insert into test1 values(sq1.nextval,'王5');
insert into test1 values(sq1.nextval,'赵6');
insert into test1 values(sq1.nextval,'周杰伦');
insert into test1 values(sq1.nextval);
select * from test1;

alter system set deferred_segment_creation=false;--取消延迟段技术

---序列的应用
--1.创建序列
--2.创建表：取消延迟段技术
--3.表中插入数据：序列名.nextval
select sq1.nextval from dual;---查看序列的下一个值
select sq1.currval from dual;---查看序列的当前值

--删除序列
drop sequence sq1;
--修改序列:不能修改start with的值，maxvalue的值必须要比最小值大才能改
alter sequence sq1 maxvalue 10100;

---3.视图：让不同的人对同一张表有不同的视角，不同的权限
----------不同的人看同一张表，看到的内容不一样

select * from emp;--员工表
select * from dept;--部门表
--内连接
--让财务部领导看到下表
select * from emp natural join dept where deptno=10;
--让研究部领导看到下表
select * from emp natural join dept where deptno=20;
--让销售部领导看到下表
select * from emp natural join dept where deptno=30;

---创建视图(需要授权)
grant create view to scott;

create view 视图名
as
查询语句;

create view emp_dept_acc
as
select * from emp natural join dept where deptno=10;

--可以通过视图查询原来那张表
select * from emp_dept_acc;
---可以把视图当成虚拟表，进行增删改查操作（有限制条件）




