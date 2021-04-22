---3.基本sql查询 
--一、简单查询：单表查询
---二、多表查询:把几张表连接在一起进行查询
select * from t_teacher;
select * from t_teachercourse;
-----表连接总结：内、外、交叉、自然、自连接
select * from 表1 join 表2 on 条件;--内:丢失数据
select * from 表1 left/right/full join 表2 on 条件;--外

select * from t_teacher t1 join t_teachercourse t2 on t1.tid=t2.tid;
select * from t_teacher t1 full join t_teachercourse t2 on t1.tid=t2.tid;
select * from t_teacher cross join t_teachercourse;

select * from 表1 cross join 表2;--交叉
select * from 表1 natural join 表2; --自然

--内连接
select * from t_student t1 join t_score t2 on t1.sid=t2.sid;
select * from t_student natural join t_score;
---三、分组查询
select * from t_score where sid='10001';
聚合函数：min(),max(),sum(),avg(),count()
---查询成绩表中所有学生所有科目的最低分，最高分，平均分，总分
select min(score),max(score),sum(score),avg(score) from t_score;
--------------------------------
---显示表中有sid值的记录数
select count(sid) from t_student;
---显示表中的全部记录数
select count(*) from t_student;

select * from t_student;
update t_student set stel='' where sid='10002';
select count(stel) from t_student;
select count(*) from t_student;

--查询每个学生的所有科目的最低分，最高分，平均分，总分
select score,sid,cid from t_score where sid='10003';

select sid,min(score),max(score),avg(score),sum(score) 
from t_score group by sid;

--查询每门课程的最高分，最低分，平均分
select cid,min(score),max(score),avg(score) from t_score group by cid;
--查询每个学生，每门课的最高分，最低分，平均分
select sid,cid,min(score),max(score),avg(score) from t_score group by sid,cid;

---having关键字
---查询每个学生的平均分
select sid,avg(score) from t_score group by sid;
---查询每个学生的平均分超过60分的学生学号和成绩
select sid,avg(score) from t_score group  by sid having avg(score)>60;
select sid,score from t_score where score>60;

select 列名,聚合函数 from  表名 group by 列名 having 条件过滤----分组查询
---四、子查询：简单查询的嵌套
--查询比张老师年龄大的教师信息


select tage from t_teacher where tname='张老师';
select * from t_teacher where tage>张老师的年龄;

select * from t_teacher where tage>
(select tage from t_teacher where tname='张老师');

--查询参加过课程编号为1的考试的学员
select sid from t_score where cid=1;  ---参加了1号课程考试的学生的学号       

select * from t_student where sid in
(select sid from t_score where cid=1); ---子表中返回多条记录，用in去查询

--查询没参加过课程编号为1的考试的学员
select * from t_student where sid not in
(select sid from t_score where cid=1); 

--查询所有已经安排教师上课的课程信息
select cid from t_teachercourse;

select * from t_course where cid in
 (select cid from t_teachercourse);

select * from t_course where exists
(select * from t_teachercourse
 where t_course.cid=t_teachercourse.cid);
 ---以上，都是在where后面添加子查询，作为条件进行子查询
 
 ---在from后面添加子查询
--在成绩表中查询出所有学生中平均分最低的是多少

--先求出来每个学生的所有课程的平均分
select sid,avg(score) from t_score group by sid;

select min(avgs) from (select sid,avg(score) avgs from t_score group by sid);

--在select语句后面添加子查询
select * from t_score;
--显示学生姓名，课程名和成绩

---三表的内连接实现
select sname,cname,score from t_student t1 join t_score t2 on t1.sid=t2.sid
join t_course t3 on t2.cid=t3.cid;

select * from 表1 join 表2 on 表1.列=表2.列
join 表3 on 表1.列=表3.列;

--子查询实现
select sname,cname,score from t_score;

select 
(select sname from t_student where t_student.sid=t_score.sid),
(select cname from t_course where t_course.cid=t_score.cid),
score from t_score;

select cname from t_course where t_course.cid=t_score.cid;
---------------------
第三章 基本sql语句
--单表查询
--多表查询
--分组查询
--子查询



