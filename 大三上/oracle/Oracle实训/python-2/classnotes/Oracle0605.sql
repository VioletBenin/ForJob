--1.2 Oracle用户管理
--一、Oracle默认用户
--1.sys：超级管理员，具有最高权限，默认密码是manager
--2.system:普通的系统管理员，可以认为是sys创建出来的普通管理员，默认密码是manager
--3.scott：普通的示例用户，默认给我们创建了一些数据库的表，默认密码是tiger，scott第一次访问的时候，账户是锁定的

--二、用户的创建、修改、删除(需要以管理员的权限下进行，或者需要有相应的权限的用户才能执行)
--1.用户的创建：在实际使用中，仅仅用默认的3个账户是不够的，需要自己创建账户：

语法：create user 用户名 identified by 密码;

create user zhangsan identified by 123456;
select * from all_users;-----查看系统中的所有用户


--3.删除用户：
语法：drop user 用户名;

drop user zhangsan;
drop user lisi;---在用户下面没有数据库资源的时候，可以直接drop删除用户；如果用户下面有数据库表等资源，没法直接删除
drop user lisi cascade;---级联删除用户，以及用户下面的所有资源

--2.修改用户
--1）修改用户密码
语法：alter user 用户名 identified by 密码;

alter user zhangsan identified by 111;

--2）修改用户状态
加锁语法：alter user 用户名 account lock;
解锁语法：alter user 用户名 account unlock;

--给scott用户解锁
alter user scott account unlock;
--给scott用户加锁
alter user scott account lock;


---三、用户的权限管理
--1.授予权限
管理员创建的普通用户，是没有任何权限的:连访问数据库的权限都没有，需要在管理员状态下进行权限的授予

grant 权限 to 用户;----授予权限

grant create session to zhangsan;----创建会话/连接数据库的权限
grant create table to zhangsan;---创建表的权限
grant select on scott.emp to zhangsan; ---查询其他用户的某张表的权限


---2.收回权限/角色
revoke 权限/角色 from 用户; 
revoke create session from zhangsan;---收回连接数据库的权限

revoke connect from lisi;---收回连接数据库的角色



--3.授予角色
为了多这么多权限进行管理，引入了角色的概念：角色：一系列权限的统称
学生的角色：上传作业，查看课件，查看成绩，提交选课等等
---对于数据库来说，有三个常用的角色：connect,resource,dba
---对于创建的普通用户来说，授予connect,resource两个角色，这个用户就可以正常访问数据库

grant 角色名  to  用户;
grant connect,resource to lisi;---可以连接数据库，并进行基本的增删改查操作


grant dba to li;-------------给用户授予了系统管理员的角色，这个用户就与system管理员相同


举例：
create user lisi identified by 123456;
grant connect,resource to lisi;


--如果没有system系统管理员的同学，可以用以下方式创建系统管理员system
create user system identified by 123456;
grant dba to system;


--4.创建角色
create role 角色名;
create role student;---创建学生的角色
grant 权限 to 角色名;---给角色授权
grant create session,create table to student;

grant student to lisi;--把学生的角色授予lisi

--5.删除角色
drop role 角色名;
drop role student;---删除角色

---补充：
--1.授权的时候，可以进行权限的传递
grant connect,resource to lisi;
grant select on scott.emp to lisi;----给lisi访问scott用户的emp表的权限，但是lisi不能把这个权限再给别人

grant select on scott.emp to lisi with grant option;----给lisi访问scott用户的emp表的权限，同时lisi可以把权限传递给别人

select * from scott.emp;


select * from test;-----lisi创建过test表
grant select on lisi.test to zhangsan;--lisi可以把自己的表的查看权限授予别人
grant select on scott.emp to zhangsan;--lisi不能把自己可以看的scott用户的表的访问权限给别人


create table test
(
tno number(4),
tname varchar2(20)
);
select * from test;


select * from scott.emp;

------------------总结
用户创建修改删除
create user 用户名 identified by 密码;
drop user 用户名;
drop user 用户名 cascade;
alter user 用户名 identified by 密码;
alter user 用户名 account lock/unlock;

权限/角色的授予和收回
grant  权限/角色 to 用户;
grant  权限/角色 to 用户 with grant option;

revoke 权限/角色 from  用户;

create role 角色名;
grant 权限1，权限2，…… to 角色名;
drop role 角色名;








