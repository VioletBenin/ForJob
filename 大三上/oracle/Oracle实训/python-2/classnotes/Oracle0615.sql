---二、基本数据结构及SQL语法
---补充：约束：约束表中的数据格式/存储方式
Oracle五大约束：主键约束：唯一且非空
                唯一约束：唯一
                非空约束：不能为空
                检查约束：表中插入的数据必须符合检查的条件才能插入
                外键约束：一张表的某一列依赖于另一张表当中的数据
                
---一、创建表的时候给表添加约束

----1.列级约束
create table t_student1
(
sid number(5) primary key,----主键约束
sname varchar2(20) unique,----唯一约束
ssex char(1) check(ssex='f' or ssex='m'),--检查约束：性别只能式f或者m
sclass number(1) check(sclass in(1,2)),--检查约束的另一种写法
saddr varchar2(50) not null,   ---非空约束
---ssid  number(5) references t_student2(sid)
);-----------------以上约束称为列级约束：约束只对某一列起作用

----2.表级约束：创建表的时候添加的约束，约束可能对多个列起作用
drop table t_student2;

create table t_student2
(
sid number(5),
sname varchar2(20),
ssex char(1),
sclass number(1),
saddr varchar2(50),
sage number(3),
---表级约束
primary key（sid,sname）,
unique(saddr),
check(ssex='f'and sclass=1),
foreign key(sid) references t_student1(sid)
);---非空约束不能写成表级约束



--二、先创建表，后期添加约束
select * from user_constraints;--查看用户下面的所有约束
--默认创建表时候添加的约束，默认名：SYS_C随机编号，不好辨别到底是什么约束，可以在后期添加约束，同时给约束命名


对约束进行命名的规则：
主键约束：PK_表名_列名
唯一约束：UK_表名_列名
非空约束：NN_表名_列名
检查约束：CK_表名_列名
外键约束：FK_从表名_列名
---创建一个没有约束的表
create table t_student2
(
sid number(5),
sname varchar2(20),
ssex char(1),
sclass number(1),
saddr varchar2(50),
sage number(3)
);
--语法：alter table 表名 add constraint 约束名 具体约束;
alter table t_student2 add constraint PK_t_student2_sid primary key(sid);--主键约束
alter table t_student2 add constraint UK_t_student2_sname unique(sname);--唯一约束
alter table t_student2 add constraint CK_t_student2_ssex check(ssex='f');--检查约束

--外键约束语法：alter table 表名 add constraint 约束名 foreign key(从表表列) references 主表名（表列）；
alter table t_score add constraint FK_t_score_sid foreign key(sid) 
references t_student1(sid); 

---非空约束语法：
alter table 表名 modify 列名 constraint 约束名 not null;
alter table t_student2 modify saddr constraint NN_t_student2_saddr not null;

----删除约束
alter table 表名 drop constraint 约束名;
alter table t_student2 drop constraint NN_t_student2_saddr;

----重命名约束
alter table 表名 rename constraint 旧约束名 to 新约束名; 
alter table t_student2 rename constraint CK_t_student2_ssex to CK_t_student2_sex;

---3.基本sql查询 


--一、简单查询：单表查询

--1.查询表中的全部记录：select * from 表名;
select * from t_student;
select * from t_course;
select * from t_score;
select * from t_teacher;
select * from t_teachercourse;

--2.带条件查询:select * from 表名 where 条件;
---从学生表中检索出2班性别为女性的学生信息
select * from t_student where ssex='f' and sclass=2;

--3.查询表中的某几列:select 列1，列2 from 表名 where 条件;
---从学生表中检索出2班性别为女性的学生的学号和姓名
select sid,sname from t_student where ssex='f' and sclass=2;

---查询表中某几列数据的时候，可以给列起别名：select 列1 as 别名1，列2 as 别名2 from 表名 where 条件；---as可省略
select sid as 学号,sname as 姓名 from t_student where ssex='f' and sclass=2;--给表列临时起别名，并没有真正给列改名
select sid 学号,sname 姓名 from t_student where ssex='f' and sclass=2;

---4.查询表中不重复的记录：select distinct 列名 from 表名;
select * from t_score;
select sid from t_score;
select distinct sid from t_score;


select score,sid from t_score;
---显示每个学生的所有成绩，学号不重复
select score,distinct sid from t_score;---报错：score有28条记录，distinct sid就四条
select distinct sid,score from t_score;

----5.查询表中的数据，按某一列排序
select * from t_score;
--对t_score表按成绩排序：select * from 表名 order by 列名 asc/desc;

select * from t_score order by score;---对t_score表按照score进行升序排列
select * from t_score order by score asc;---对t_score表按照score进行升序排列,asc可以省略
select * from t_score order by score desc;---对t_score表按照score进行降序排列

---6.模糊查询：like   %  _
select * from 表名 where 列名 like '值%';
select * from 表名 where 列名 like '值_';
--正常查询：查询学生表中名字是杨澜的学生信息；
select * from t_student where sname='杨澜';
--模糊查询：查询学生表中名字姓张的学生信息；
select * from t_student where sname like '张%';--%表示当前位置有0个或者多个字符
select * from t_student where sname like '张_';--_表示当前位置有且只有1个字符

select * from t_student;
insert into t_student values('10010','张咪','f','10-9月-1970','13012341234',2);
insert into t_student values('10011','阳光','f','10-9月-1970','13012341234',2);
--查询学生表的名字中含有“阳”字的学生信息，以下哪种是正确的？
select * from t_student where sname like '阳%';--查询名字首位是阳
select * from t_student where sname like '%阳';--查询名字末尾是阳
select * from t_student where sname like '%阳%';---对
select * from t_student where sname like '阳_';
select * from t_student where sname like '_阳';
select * from t_student where sname like '_阳_';

---补充：旧表生成新表
select * from t_student;
--创建一张t_student结构一致，数据也一致的表，作为t_student表的备份
create table tt_student as select * from t_student;

select * from tt_student;

---二、多表查询

---三、分组查询

---四、子查询






          
               
















