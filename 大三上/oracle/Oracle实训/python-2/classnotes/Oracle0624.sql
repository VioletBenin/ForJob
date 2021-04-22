---第四章 操作符和函数
---一、SQL操作符：算术、比较、逻辑、集合、连接操作符
--1、算术操作符：+-*/
--检索出课程号是2的成绩+10分后的结果  
select sid 学号,cid 课程号,score+10 加10分后的成绩 from t_score where cid=2;
---把课程号是2的学生成绩都加10分
update t_score set score=score+10 where cid=2;
select * from t_score where cid=2;
---2.比较操作符：>,<,>=,<=,!=,<>,like,in,not in,between ...and..,is null
--检索1980年前出生的学生信息
select * from t_student where sbirthday<'1-1月-1980';
--检索1986年出生的学生信息
select * from t_student where sbirthday 
between '1-1月-1986' and '31-12月-1986';
--检索班级是1班或者2班的学生信息
select * from t_student where sclass in(1,2);

--检索不是2班的学生信息
select * from t_student where sclass !=2;
select * from t_student where sclass <>2;

---检索学生表中没有电话号的学生信息
select * from t_student where stel is null;

----3.逻辑操作符：not,and,or
select * from t_student where sclass=1 or sclass=2;
--检索班级是1班的女生
select * from t_student where sclass=1 and ssex='f';
--4.连接操作符：||
select * from t_student;

--学号是sid的学生是sname，性别是sex
select '学号是'||sid||'的学生姓名是'||sname 学生信息 from t_student;

---5.集合操作符：
--统计学习操作系统(1)或数据结构(2)的同学学号
----选修了第一门课的学生信息
select sid from t_score where cid=1;
----选修了第二门课的学生信息
select sid from t_score where cid=2;
insert into t_score values('10005',2,98);

--把两张表包含的记录进行显示，公共的部分删掉
select sid from t_score where cid=1
union
select sid from t_score where cid=2;

---显示两张表中的全部记录，重复的也显示
select sid from t_score where cid=1
union all
select sid from t_score where cid=2;
--统计操作系统(1)和数据结构(2)都为及格(60分以上)的同学学号
select sid from t_score where cid=1 and score>=60
intersect
select sid from t_score where cid=2 and score>=60;
---intersect,显示两张表的公共部分

--统计操作系统(1)达到70分但数据结构(2)未达到65的同学学号
select sid from t_score where cid=1 and score>70
minus
select sid from t_score where cid=2 and score>=65;
--minus：表1的查询结果-表2的查询结果，显示剩下的内容
---操作符的优先级：算术>连接||>比较>逻辑

---二、SQL函数
---函数：单行、聚合、分析函数

--1.单行函数：---借助于一张单行单列的伪表dual
select * from dual;

------1）字符函数
select initcap('hello') from dual;---首字母大写
select lower('FUN') from dual;---小写
select upper('sun') from dual;----大写
---清除左边/右边的空格或者内容
select '   abc   ' from dual;
select trim('   abc   ') from dual;
select '>>>'||trim('   abc   ')||'<<<' from dual;
select '>>>'||ltrim('   abc   ')||'<<<' from dual;
select'>>>'||rtrim('   abc   ')||'<<<' from dual;  

select ltrim( 'xyzadams','xyza') from dual;
select rtrim('xyzadams','ams') from dual;
---替换函数:translate,replace
--逐一替换：h--a,e--b,l--c
select translate('helloworld','hel','abc') from dual;
--整体替换：把hel换成abc
select replace('helloworld','hel','abc') from dual;
--第二个字符在字符串中第一次出现的位置，位置从1开始
select instr ('worldwide','d') from dual;
--从原来的字符串中提取子串，从第三个位置开始，提取2个长度的字符串 
select substr('abcdefg',3,2) from dual; 
--把字符串进行连接
select concat ('Hello','world') from dual; 
--显示数字对应的ascii码
select chr(97) from dual;
select chr(65) from dual;  
---补位函数
select  lpad('hello',10,'b')  "左补齐"  from  dual;
select  rpad('hello',10,'b')  "右补齐"  from  dual;

---以上，知道查询结果是什么即可

---查询t_student表,把性别为f的显示为女生，性别为m的显示为男生
select * from t_student;

select sid 学号,sname 姓名,ssex 性别 from t_student;
select sid 学号,sname 姓名,decode(ssex,'f','女','m','男') 
性别 from t_student;

---每个值去比较然后进行值的替换。
decode(列名，值1，替换，值2，替换，值3，替换……)

select * from t_score;
select sid,cid,score from t_score;
--trunc截取：把数值取整
decode(trunc(score/10),'10','优秀','9','优秀','8','良好','7','中等',
'6','及格','5','不及格')---替换上表中的score

select sid,cid,decode(trunc(score/10),'10','优秀','9','优秀','8','良好','7','中等',
'6','及格','5','不及格') from t_score;
