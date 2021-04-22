---二、SQL函数-------0625
---函数：单行、聚合、分析函数

--1.单行函数：---借助于一张单行单列的伪表dual
select * from dual;
------1）字符函数
decode(列名,列值1,'替代字符串1',……)

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

select sid,cid,
decode(trunc(score/10),'10','优秀','9','优秀','8','良好','7','中等',
'6','及格','5','不及格','4','不及格','3','不及格') 
from t_score;


------查询优良中差2：switch case语句实现:case  when   then..end
select sid,cid,score from t_score;
select sid,cid, case 
       when score>=90 then  '优秀' 
       when score>=80 then  '良好' 
       when score>=70 then  '中等' 
       when score>=60 then  '及格' 
       else '不及格' 
end 成绩
from t_score;
------2）数学函数
select abs(-15) from dual; --绝对值
---取整函数
select ceil(100.8) from dual; --取比当前值大的最小整数
select floor(100.8) from dual;--取比当前值小的最大整数
select round(100.8) from dual;---四舍五入
select round(100.256,2) from dual; ---按小数精度取整

select cos(180) from dual;  --余弦
select power(4,2) from dual; --求a的b次方
select mod(10,3) from dual; --求模
select sqrt(4) from dual; --开方
select sign(-30) from dual;--符号函数：负数是-1，正数是1,0是0

--3）日期函数 
select sysdate from dual;---查询当前系统时间
select sysdate+1 from dual;---查询第二天的日期
select sysdate-1 from dual;

select add_months(sysdate,1) from dual;--查询1个月后的日期
select add_months(sysdate,-1) from dual;---查询1个月前的日期

---比较第一个日期和第二个日期之间相差的月数
select months_between(sysdate,add_months(sysdate,-1)) 
from dual;
select months_between('1-1月-1970','20-1月-1971') 
from dual;
---------------------------------
--日期加1年
select add_months(sysdate,12) from dual;
--日期加1个月
select add_months(sysdate,1) from dual;
--日期加1周
select sysdate+7 from dual;
--日期加1天
select sysdate+1 from dual;
--日期加1小时
select sysdate+1/24 from dual;
--日期加1分钟
select sysdate+1/24/60 from dual;
---日期加1秒
select sysdate+1/24/60/60 from dual;

--显示当前所在月的最后一天
select last_day(sysdate) from dual;
--显示下一个星期几
select next_day(sysdate,1) from dual;--1表示下一个星期天
select next_day(sysdate, '星期日') from  dual;

select next_day(sysdate,7) from dual;
select next_day(sysdate,'星期六') from dual;
select next_day('5-12月-2020',7) from dual;

---日期的截取函数
trunc(具体日期，'年/月/季度')---截取当前日期所在年份/月份/季度的第一天

select trunc(sysdate,'year') from dual; 
select trunc(sysdate,'y') from dual; 
select trunc(sysdate,'month') from dual;
select trunc(sysdate,'q') from dual; 

-----查询当前日期所在的年份，月份，日期
select extract(year from sysdate)  from dual;
select extract(month from sysdate)  from dual;
select extract(day from sysdate)  from dual;
----------------------------------------------------------
---4）转换函数
---1)字符串转换成日期 to_date
select to_date('2020-07-28','yyyy/mm/dd') from dual;
---2）日期转换成字符串 to_char
select to_char(sysdate,'yyyy-mm-dd') from dual;
select to_char(sysdate,'yyyy/mm/dd') from dual;
---3）字符串转换成数值 to_number
select to_number('100') from dual;

---5）其他函数（处理空值的函数） nvl,nvl2,nullif

---如果两个参数值相同，显示null；否则显示第一个参数的值
select nullif(100,100) from dual;
select nullif(100,200) from dual;

select * from emp;
---处理空值的函数
select empno,ename,sal,comm,sal+comm from emp;
--把某一列的空值变成0进行操作：nvl(comm,0)
select empno,ename,sal,comm,sal+nvl(comm,0) from emp;
--判断某一列的值，如果有值，用第二个参数替换；如果为null，替换成0
select empno,ename,sal,comm,sal+nvl2(comm,comm+100,0) from emp;

---单行函数：字符，数学，日期*，转换*，其他函数
---聚合函数：min(),max(),sum(),avg(),count()
select sum(score) from t_score group by sid;

---分析函数:row_number(),rank(),dense_rank()
--查看员工的薪水，按降序排列
select * from emp order by sal desc;
---在表中新生成一列，按照排序结果给出排名
select row_number() over(order by sal desc),empno,ename,sal
from emp;--生成一列序号，序号连续，sal值相同序号也不相同
select rank() over(order by sal desc),empno,ename,sal
from emp;--生成一列序号，序号可能不连续，sal值相同的序号相同
select dense_rank() over(order by sal desc),empno,ename,sal
from emp;--生成一列序号，序号连续，sal值相同的序号相同
-----------------------------
---对表生成序号的时候，还可以按照一定的分组进行序号的生成
--对整张表按照sal进行排序，生成一列序号
select row_number() over(order by sal),empno,ename,sal from emp;
--还可以组内进行排序和编号:可以按照部门编号分组
select row_number() 
over(partition by deptno order by sal) 组内编号,
empno,ename,sal,deptno from emp;
---分析函数的要求：能理解和看懂
