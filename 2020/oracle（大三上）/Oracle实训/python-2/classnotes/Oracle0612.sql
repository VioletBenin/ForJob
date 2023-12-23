---二、基本数据结构及SQL语法
create/alter/drop/truncate table 表名……--ddl语句

insert into/update/delete from/select 表名 …… ---dml语句
insert into 表名(列1，列2，……) values(列值1，列值2，……);

delete from 表名 where 条件;
delete from t_student where sid='10001';

update 表名 set 列名=列值 where 条件;
update t_studnet set sname='张三' where sid='10002';

select 列1，列2，…… from 表名 where 条件；
select sid,sname from t_student where sclass=1;
--------------------------复习举例
select * from user_tables;
select * from tt;
insert into tt values(001,'张三');
insert into tt values(002,'张三丰');
---选择性地插入某几列数据
insert into tt(tno) values(003);

update tt set tname='孙燕姿';
update tt set tname='周杰伦' where tno=3;

delete from tt;
delete from tt where tname='孙燕姿';


select * from tt;
select * from tt where tno=3;
select tno,tname from tt;
-------3.DCL语句：数据控制语言：对数据进行访问控制的语句：授予权限/角色及收回权限/角色
grant 权限/角色 to 用户；
revoke 权限/角色 from 用户;

-------4.TCL语句：事务控制语言：对事务进行管理和控制的语句
--事务：把一系列的增删改查操作作为一个整体去处理，这个整体就称为一个事务
insert into tt values(004,'王力宏');
insert into tt values(005,'陈奕迅');
update tt set tno=100 where tname='周杰伦';
delete from tt where tno=2;----以上四个操作默认作为一个整体执行，称为一个事务

---事务特性：原子性、一致性、隔离性、持久性（ACID属性）

---事务控制语句：
                commit;---提交整个事务：之前做的一系列的增删改查操作；
                rollback;---回滚整个事务
                savepoint 保存点名称;---设置保存点
                rollback to 保存点名称; ---回滚到某一保存点
                
select * from tt;  
          
update tt set tno=101 where tname='王力宏';
update tt set tno=102 where tname='陈奕迅'; 
commit;     ---提交以上事务
delete from tt where tno=1;  
rollback;  ---撤销事务：上面的删除操作


insert into tt values(105,'易烊千玺');
insert into tt values(106,'迪丽热巴');
savepoint p1;
insert into tt values(106,'李现');
delete from tt where tname='陈一';
savepoint p2;
delete from tt;
savepoint p3;
insert into tt values(108,'杨紫');

select * from tt;
rollback;
rollback to p1;
rollback to p2;
rollback to p3;               
-------------------------------------------------
--ddl 数据定义语言：create/alter/drop/truncate table……，rename
--dml 数据操纵语言：insert/update/delete/select
--dcl 数据控制语言：grant/revoke
--tcl:事务控制语言：commit/rollback/savepoint/rollback to

---补充：约束：约束表中的数据格式/存储方式
Oracle五大约束：主键约束：唯一且非空
                唯一约束：唯一
                非空约束：不能为空
                检查约束：表中插入的数据必须符合检查的条件才能插入
                外键约束：一张表的某一列依赖于另一张表当中的数据
--创建表的时候可以添加约束
create table t_student
(
sid number(5),
sname varchar2(20),
ssex char(1),
sclass number(1) 
);



---t_student表是带有约束的表
create table t_student1
(
sid number(5) primary key,----主键约束
sname varchar2(20) unique,----唯一约束
ssex char(1) check(ssex='f' or ssex='m'),--检查约束：性别只能式f或者m
sclass number(1) check(sclass in(1,2)),--检查约束的另一种写法
saddr varchar2(50) not null   ---非空约束
);


insert into t_student1 values(10001,'张三丰','m',1,'山东青岛');
insert into t_student1 values(10001,'张三','m',1,'山东青岛');--学号违反主键要求，插入失败
insert into t_student1 values(10002,'张三','m',1,'山东青岛');
insert into t_student1 values(10003,'张三','m',1,'山东青岛');--违反唯一约束，姓名重复
insert into t_student1 values(10003,'章子怡','r',1,'山东青岛');--性别违反检查约束
insert into t_student1 values(10003,'章子怡','f',5,'山东青岛');--班级违反检查约束
insert into t_student1 values(10003,'章子怡','f',1,'');---地址违反非空约束


insert into t_student1(sid) values(10008);--表中的列有非空约束的话，插入数据的时候，就必须要
                                          --往不能为空的表列中插入数据
                                          
insert into t_student1(sid,saddr) values(10008,'山东济南');

select * from t_student1;

-----添加外键约束：两张表才能设置外键约束
create table t_score
(
sid number(5) primary key,
score number(3)
);

----给t_score表的sid列添加外键约束，依赖于t_student1表的sid列
alter table t_score add constraint FK_t_score_sid foreign key(sid) 
references t_student1(sid); 

insert into t_score values(10001,100);
insert into t_score values(10002,90);
insert into t_score values(10003,80);---10003在主表中没有，所以违反外键约束





--后期添加约束
                
               
















