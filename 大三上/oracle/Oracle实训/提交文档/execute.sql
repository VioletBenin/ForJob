



-- conn adm/adm@orcl as sysdba;


drop sequence tb_review_reviewID_seq;
drop table tb_review;
drop sequence tb_Account_AccountID_seq;
drop table tb_userAccount;
drop sequence tb_order_orderID_seq;
drop table tb_order;
drop sequence tb_prodColor_prodColorID_seq;
drop table tb_productColor;
drop sequence tb_prodSize_prodSizeID_seq;
drop table tb_productSize;
drop sequence tb_product_productID_seq;
drop table tb_product;
drop sequence tb_prodType_prodTypeID_seq;
drop table tb_productType;
drop sequence tb_user_userID_seq;
drop table tb_user;
drop sequence tb_city_cityID_seq;
drop table tb_city;
drop sequence tb_province_provinceID_seq;
drop table tb_province;


-- conn sys/1@orcl as sysdba;
-- drop user adm;
-- drop user usr;

-- conn sys/1@orcl as sysdba;

-- conn sys/1@orcl as sysdba;

-- create user adm identified by adm;


-- create user usr identified by usr;


-- grant connect, resource, dba  to adm;

-- grant create table,create session  to adm;

-- -- conn adm/adm@orcl as sysdba;
-- grant connect, resource  to usr;
-- grant create table,create session,create view to usr;

-- alter user usr account unlock;

-- conn usr/usr@orcl;



-- -- -- conn sys/1@orcl as sysdba;


-- /*创建tb_province表*/
create table tb_province(
provinceID number primary key,
provinceName varchar2(30) not null	
);
create sequence tb_province_provinceID_seq
increment by 1 
start with 0
MINVALUE 0;

-- /*创建tb_city表*/
create table tb_city(
cityID number primary key,
 provinceID number not null,
cityName varchar2(30) not null
);
create sequence tb_city_cityID_seq
increment by 1 
start with 0
MINVALUE 0;

 
-- /*创建tb_user表*/
create table tb_user(
userID number primary key,
name varchar2(10) unique,
password varchar2(30) not null,
email varchar2(30),
provinceID number,	
cityID number,
telephone char(11),
sex char(3) default('男'),
age number	,
birthday date,
money number default 0,
photo varchar2(500),
dsp varchar2(200),
qq	 varchar2(15),
msn varchar2(50),
loveBook varchar2(200),	
loveMusi varchar2(200),	
loveMovi varchar2(200),	
loveSpor varchar2(200),	
loveGame varchar2(200)
);
create sequence tb_user_userID_seq
increment by 1 
start with 0
MINVALUE 0;

-- /*创建tb_productType表*/
create table tb_productType(
productTypeID number primary key,
productTypeName	 varchar2(100) not null
);
create sequence tb_prodType_prodTypeID_seq
increment by 1 
start with 0
MINVALUE 0;
 
-- /*创建tb_product表*/
create table tb_product(
productID number primary key,
userID number not null,
productName varchar2(50) not null,
typeID number not null,
price number not null, 
photo varchar2(500)	,
information varchar2(500)
);
create sequence tb_product_productID_seq
increment by 1 
start with 0
MINVALUE 0;

-- /*创建tb_productSize表*/
create table tb_productSize(
productSizeID number primary key,
productSize varchar2(20) not null,	
productID number not null
);
create sequence tb_prodSize_prodSizeID_seq
increment by 1 
start with 0
MINVALUE 0;
 
-- /*创建tb_productColor表*/
create table tb_productColor(
productColorID number primary key,
productColor varchar2(20) not null,
stockpile number not null,
productSizeID number not null
);
create sequence tb_prodColor_prodColorID_seq
increment by 1 
start with 0
MINVALUE 0;
 
 -- /*创建tb_order表(orderState,orderID)*/
create table tb_order(
orderID number primary key,
toID number references tb_user(userID) not null,
colorID number not null,
productID number not null,
address	varchar2(100) not null,	
telephone char(11) not null,
orderState number not null,
count number not null,
price number not null,
orderDate date not null,
consignmentDate date not null
);
create sequence tb_order_orderID_seq
increment by 1
start with 0
MINVALUE 0;

/*创建tb_userAccount表*/
create table tb_userAccount(
userAccountID number primary key,
userID	number not null,
orderID	number not null,
type number not null,
time date  not null
);
create sequence tb_Account_AccountID_seq
increment by 1 
start with 0
MINVALUE 0;
 
-- /*创建tb_review表*/
create table tb_review(
reviewID number	primary key,
review	 varchar2(250)	not null,
isReply	 char default(0) not null,
isDel	 char default(0) not null,
senderID number not null,
productID  number not null,
addTime date not null,
replyID number
);
create sequence tb_review_reviewID_seq
increment by 1 
start with 0
MINVALUE 0;


alter table tb_city add constraint fk_cityID_provinceID foreign key(provinceID) references tb_province(provinceID) on delete cascade;
alter table tb_user add constraint fk_userID_cityID foreign key(cityID) references tb_city(cityID) on delete cascade;
alter table tb_product add constraint fk_productID_userID foreign key(userID) references tb_user(userID) on delete cascade;
alter table tb_product add constraint fk_productID_productTypeID foreign key(typeID) references  tb_productType(productTypeID) on delete cascade;
alter table tb_productSize add constraint fk_SizeID_productID foreign key(productID) references  tb_product(productID) on delete cascade;
alter table tb_productColor add constraint fk_ColorID_productSizeID foreign key(productSizeID) references  tb_productSize(productSizeID) on delete cascade;
alter table tb_userAccount add constraint fk_AccountID_userID foreign key(userID) references  tb_user(userID) on delete cascade;
alter table tb_userAccount add constraint fk_AccountID_orderID foreign key(orderID) references  tb_order(orderID) on delete cascade;
alter table tb_review add constraint fk_reviewID_userID foreign key(senderID) references  tb_user(userID) on delete cascade;
alter table tb_review add constraint fk_reviewID_productID foreign key(productID) references  tb_product(productID) on delete cascade;

insert into tb_productType values(tb_prodType_prodTypeID_seq.nextval,'食品');
insert into tb_productType values(tb_prodType_prodTypeID_seq.nextval,'生活用品');
insert into tb_productType values(tb_prodType_prodTypeID_seq.nextval,'服饰');
insert into tb_productType values(tb_prodType_prodTypeID_seq.nextval,'书籍');
insert into tb_productType values(tb_prodType_prodTypeID_seq.nextval,'数码');

insert into tb_province values(tb_province_provinceID_seq.nextval,'山东');
insert into tb_province values(tb_province_provinceID_seq.nextval,'山西');
insert into tb_province values(tb_province_provinceID_seq.nextval,'河南');
insert into tb_province values(tb_province_provinceID_seq.nextval,'河北');
insert into tb_province values(tb_province_provinceID_seq.nextval,'四川');

insert into tb_city values(tb_city_cityID_seq.nextval,1,'济南');
insert into tb_city values(tb_city_cityID_seq.nextval,1,'青岛');
insert into tb_city values(tb_city_cityID_seq.nextval,1,'潍坊');
insert into tb_city values(tb_city_cityID_seq.nextval,1,'烟台');
insert into tb_city values(tb_city_cityID_seq.nextval,1,'日照');

insert into tb_user values(tb_user_userID_seq.nextval,'张三','zs','zs@163.com',1,1,'12300000000','男',11,to_date('1999-7-15','yyyy-MM-dd'),500,'1.jpg','无个性不签名','999999','44444','book1','music1','movie1','sport1','game1');
insert into tb_user values(tb_user_userID_seq.nextval,'李四','ls','ls@163.com',1,2,'12311111111','男',22,to_date('1999-3-11','yyyy-MM-dd'),500,'2.jpg','无个性不签名','888888','44444','book2','music2','movie2','sport2','game2');
insert into tb_user values(tb_user_userID_seq.nextval,'王五','ww','ww@163.com',1,3,'12333333333','男',33,to_date('1993-7-28','yyyy-MM-dd'),500,'3.jpg','无个性不签名','777777','44444','book3','music3','movie3','sport3','game3');
insert into tb_user values(tb_user_userID_seq.nextval,'赵六','zl','zl@163.com',1,4,'12344444444','女',44,to_date('1996-6-12','yyyy-MM-dd'),500,'4.jpg','无个性不签名','666666','44444','book4','music4','movie4','sport4','game4');
insert into tb_user values(tb_user_userID_seq.nextval,'刘七','lq','lq@163.com',1,5,'12355555555','女',55,to_date('1999-7-21','yyyy-MM-dd'),500,'5.jpg','无个性不签名','555555','44444','book5','music5','movie5','sport5','game5');

insert into tb_product values(tb_product_productID_seq.nextval,1,'面包',2,100,'2.jpg','jianjie');
insert into tb_product values(tb_product_productID_seq.nextval,2,'胶带',3,200,'3.jpg','jianjie');
insert into tb_product values(tb_product_productID_seq.nextval,3,'鞋子',4,300,'4.jpg','jianjie');
insert into tb_product values(tb_product_productID_seq.nextval,4,'杂志',5,500,'5.jpg','jianjie');
insert into tb_product values(tb_product_productID_seq.nextval,5,'手机',1,600,'1.jpg','jianjie');

insert into tb_productSize values(tb_prodSize_prodSizeID_seq.nextval,'type1',1);
insert into tb_productSize values(tb_prodSize_prodSizeID_seq.nextval,'type2',2);
insert into tb_productSize values(tb_prodSize_prodSizeID_seq.nextval,'type3',3);
insert into tb_productSize values(tb_prodSize_prodSizeID_seq.nextval,'type4',4);
insert into tb_productSize values(tb_prodSize_prodSizeID_seq.nextval,'type5',5);

insert into tb_productColor values(tb_prodColor_prodColorID_seq.nextval,'红',10,5);
insert into tb_productColor values(tb_prodColor_prodColorID_seq.nextval,'橙',20,4);
insert into tb_productColor values(tb_prodColor_prodColorID_seq.nextval,'蓝',30,3);
insert into tb_productColor values(tb_prodColor_prodColorID_seq.nextval,'绿',40,2);
insert into tb_productColor values(tb_prodColor_prodColorID_seq.nextval,'紫',50,1);

-- -测试语句- --
select * from tb_review;
select * from tb_userAccount;
select * from tb_order;
select * from tb_productColor;
select * from tb_productSize;
select * from tb_product;
select * from tb_productType;
select * from tb_user;
select * from tb_city;
select * from tb_province;



要删除的用户

declare
-- variable
v_id number;
begin
v_id:='&id';
-- v_id:=&'要删除的用户id';
-- v_id:='&delete user id';
delete from tb_user where userID=v_id;
if sql%notfound then 
dbms_output.put_line('删除失败!');
else
dbms_output.put_line('删除成功!');
end if;
end;
/


set define on;



-- declare
--    v_id number;
-- begin
--    v_id:='&delete user id';
--   delete from tb_user where  userID=v_id;
--   -- alter table tb_user disable novalidate constraint constraint_name;
--   if sql%notfound then 
--      dbms_output.put_line('error!');
--   else
--     dbms_output.put_line('deleted sucessfully!');
--   end if;
-- end;
-- /







-- -- /*用户信息查询*/
-- -- /*用户在商城可以查询已知用户(或卖家)的基本信息*/
-- declare
--   cursor c_user is
--     select * from tb_user;
--   user_info c_user%rowtype;
-- begin
--   open c_user;
--   loop
--     FETCH c_user
--       INTO user_info;
--     EXIT WHEN c_user%NOTFOUND;
--     dbms_output.put_line('学号：' || user_info.userID ||
-- 	 ',姓名：' ||  user_info.name|| 
--      ',密码：' ||  user_info.password||                
--      ',email：' ||  user_info.email||                
--      ',省份：' ||  user_info.provinceID||                
--      ',城市：' ||  user_info.cityID||                
--      ',电话：' ||  user_info.telephone||                
--      ',性别：' ||  user_info.sex||                
--      ',年龄：' ||  user_info.age||                
--      ',生日：' ||  user_info.birthday||                
--      ',余额：' ||  user_info.money||                
--      ',照片：' ||  user_info.photo||                
--      ',签名：' ||  user_info.dsp||                
--      ',qq：' ||  user_info.qq||                
--      '，喜欢的书：' ||  user_info.loveBook||                
--      '，喜欢的音乐：' ||  user_info.loveMusi||                
--      '，喜欢的电影：' ||  user_info.loveMovi||                
--      '，喜欢的运动：' ||  user_info.loveSpor||                              
--      '，喜欢的游戏：' ||  user_info.loveGame          
--       );  					 
--   end loop;
--   close c_user;
-- end;
-- /



-- /*用户下订单并确认付款*/
-- declare
--   this_userId number;
--   this_productColorId number;
--   this_productId number;
--   this_count number;
--   this_stockPile number;
--   this_price number;
--   this_money number;
--   this_phone char(11);
--   Ordernum number;
-- begin
--   this_userid:='&买家id';
--   this_productColorId:='&颜色Id';
--   this_productId:='&商品id';
--   this_count:='&数量';
--   select telephone into this_phone from tb_user where userId=this_userId;
--   select price into this_price from tb_product where productId=this_productId;
-- -- /*用户****将订单信息填入到tb_order表中*/
--     --orderState订单状态为用户选择填入下订单(买家付款后自动转为已付款,买家付款后卖家可选择修改为延后,卖家发货后选择修改为发货,买家未付款时卖家可选择修改为撤销,买家收到货物后可选择修改为完成)
-- insert into tb_order values
-- (tb_order_orderID_seq.nextval,this_userid,this_productcolorid,this_productid,'默认地址',this_phone,0,this_count,(this_count*this_price),sysdate,(sysdate+3));
-- -- /*下订单后减少商品库存*/
-- select stockpile into this_stockPile from tb_productColor where productColorId=this_productColorId;
--   if this_stockPile>this_count then
--      begin
--        update tb_productColor set stockPile=stockPile-this_count where productColorId=this_productColorId;
--      end;
--   else
--       dbms_output.put_line('错误！库存不足');  
--   end if;
-- -- /*确认付款后减少用户余额*/
-- select money into this_money from tb_user where userId=this_userId;
--   if this_money>this_count*this_price then
--     begin
--       update tb_user set money=this_money-this_count*this_price where userId=this_userid;
--        dbms_output.put_line('交易成功');
--     end;
--   else
--      dbms_output.put_line( '错误！账户余额不足');
--   end if;
--   commit;
-- end;

-- select * from tb_order;





-- -- /*卖家对订单信息进行修改*/
-- select * from tb_order;


-- declare
--    this_orderId number;
--    this_address varchar2(20);
--    this_telephone char(11);
--    this_orderState number;
--    this_colorId number;
--    this_price number;
--    this_count number;
--    this_bef_price number;
--    this_old_productColorId number;
-- begin
--    this_orderId:=&订单编号Id;
-- -- /*修改tb_order表中的送货地址*/  
--   this_address:='&送货地址';
--   update tb_order set address=this_address where  orderId=this_orderId;
--   dbms_output.put_line('送货地址已修改');
-- -- /*修改tb_order表中的联系方式*/
--   this_telephone:='&联系方式';
--   update tb_order set telephone=this_telephone where orderId=this_orderId;
--   dbms_output.put_line('联系方式已修改');
-- -- /*修改tb_order表中的状态*/
-- 	--若卖家因故不能发货，但已付款则卖家可修改订单状态为'延后'
--  this_orderState:=&修改状态;
--    update tb_order set orderState=this_orderState where orderId=this_orderId;
--   dbms_output.put_line('订单状态已修改');
-- -- /*修改tb_order表中的商品颜色*/
--   select colorId into this_old_productColorId from tb_order where orderId=this_orderId;
--   select count into this_count from tb_order where orderId=this_orderId;   
--   this_colorId:='&颜色id';
--   update tb_order set colorId=this_colorId where orderId=this_orderId;  

-- -- /*修改tb_order表中的商品总价*/
-- -- 	--若和买家商议后买家同意降价，但商品信息上还是不修改的，就可以在订单总价上修改，付款后卖家修改总价，差价打回买家账户余额内

--   select price into this_bef_price from tb_order where orderId=this_orderId;
--   this_price:='&当前价格';
  
-- -- /*将与之前的差价加回买家账户余额内*/
-- -- /*修改tb_user表中买家的账户余额*/
--   update tb_user set money=money+this_bef_price-this_price where userId=(select toId from tb_order where orderId=this_orderId);
--   dbms_output.put_line('商品总价已修改');
--   dbms_output.put_line('操作成功');

-- -- /*修改颜色后要将之前选择的颜色库存加一再将修改后的颜色库存减一*/
--   update tb_productcolor set stockPile =stockPile-this_count where productColorId=this_orderId;  
--   update tb_productColor set stockPile=stockPile+this_count where productColorId=this_old_productColorId;  
--   dbms_output.put_line('商品颜色已修改');

--   commit;
  
--   exception 
--   when no_data_found then
--    dbms_output.put_line('数据未找到，操作失败');
--   rollback;
-- end;
-- /



-- /*订单完成进行转账*/
-- /*定义变量,用于存储流水表的用户ID*/
-- declare
--   this_userId number;
--   this_sellerId number;
--   this_price number;
--   this_orderId number;
-- begin
--   this_orderId:='&订单号';
  
-- -- /*买家收到商品后，修改tb_order表中的状态*/
--   update tb_order set orderState=3 where orderId=this_orderId;
--   dbms_output.put_line('订单状态已完成');
  
-- -- /*订单状态为'完成'后建立用户资金流水表一条卖家出售商品收入记录*/  
--   select userId into this_sellerId from tb_product where productId=
--   (select productId from tb_order where orderId=this_orderId);
--   insert into tb_useraccount values(tb_Account_AccountID_seq.nextval,this_sellerid,this_orderId,1,sysdate);
--   dbms_output.put_line('用户资金流水表插入一条卖家出售商品收入记录');
  
-- -- /*交易成功后卖家账户余额增加*/
--     select price into this_price from tb_order where orderId=this_orderId;    
--     update tb_user set money=money+this_price where userId=this_sellerId;
--     dbms_output.put_line('卖家账户余额增加');
--     dbms_output.put_line('操作成功');
--     COMMIT;
-- exception
-- when no_data_found then
--   dbms_output.put_line('数据未找到，操作失败');
-- rollback;  
-- end; 
-- /



-- /*货物丢件进行退款*/
-- /*前提条件:订单为发货状态，但物流出现丢件情况，由物流赔偿卖家，卖家确认丢件情况发生后，可进行退款操作*/
-- /*定义变量,用于存储流水表的用户ID*/
-- declare
--   this_sellerId number;
--   this_userId number;
--   this_orderId number;
--   this_price number;
-- begin
--   this_orderId:='&订单编号';
-- -- /*卖家确认商品丢件后，修改tb_order表中的状态*/
--   update tb_order set orderState=5 where orderId=this_orderId;
--   dbms_output.put_line('订单状态:撤销');
-- -- /*订单状态为'撤销'后建立用户资金流水表一条买家商品退款收入记录*/
--   select toid into this_userId from tb_order where orderId=this_orderId;
--   insert into tb_useraccount values(tb_Account_AccountID_seq.nextval,this_userId,this_orderId,1,sysdate);
--   dbms_output.put_line('用户资金流水表插入一条买家商品退款收入记录');
-- -- /*撤销成功后买家账户余额恢复*/
--   select price into this_price from tb_order where orderId=this_orderId;
--   update tb_user set money=money+this_price where userId=this_userId;
--   dbms_output.put_line('买家账户余额恢复');
--   dbms_output.put_line('操作成功');
--   commit;
  
-- exception
-- when no_data_found then
--     dbms_output.put_line('数据未找到，操作失败');
--     rollback;
-- end;
-- /










-- 视图
-- --/*多表查询*/
-- --/*用户在商城以商品类型查询一件商品的名称*/

--drop view prodname_view;
create view prodname_view
as
   select * from tb_product tp ,tb_productType tpt where tp.typeid=tpt.producttypeid;   
declare
   name varchar2(20);
   dname varchar2(20);
   cursor cur(xname varchar2) 
   is 
     select productName from prodname_view where productTypeName=xname;
begin
  dname:='&商品类型';
  open cur(dname);
    loop
      fetch cur into name;
      exit when cur%notfound;
      dbms_output.put_line('商品名称: '||name);
    end loop;
 close cur;
end;
/
--/*用户在商城以商品名称查询一件商品的所有信息*/
--drop view allinfo_view;
-- create view allinfo_view
-- as 
--    select productcolorid,productcolor,stockpile,
--    c.productsizeid,productsize,s.productid,userid,productname,typeid,price,photo,information 
--    from tb_productcolor c 
--    join tb_productsize s on c.productsizeid=s.productsizeid
--    join tb_product p on p.productid=s.productid;   
-- declare
-- dm  allinfo_view%rowtype;
-- pname varchar2(50);
-- cursor cur_t (product_name in varchar2)
-- is
--  select *  from allinfo_view
--    where productname=product_name;
-- begin
--    pname:='&商品名称';
--    open cur_t(pname);
--    loop
--    fetch cur_t into dm;
--    exit when cur_t%notfound;
--     dbms_output.put_line(
--     '商品id：'||dm.productid||
--     '商品名字：'||dm.productname||
--     '商品颜色id：'||dm.productcolorid||
--     '商品颜色：'||dm.productcolor||
--     '商品库存：'||dm.stockpile||
--     '商品型号id：'||dm.productsizeid||
--     '商品型号：'||dm.productsize||
--     '商品卖家id：'||dm.userid||
--     '商品类型id：'||dm.typeid||
--     '商品价格：'||dm.price||
--     '商品图片路径：'||dm.photo||
--     '商品简介：'||dm.information
--    );
--     end loop;
--    close cur_t;
-- exception
--    when no_data_found then
--    dbms_output.put_line('无数据！');
-- end;
--/*用户信息查询*/
--/*用户在商城可以查询已知用户(或卖家)的基本信息*/
declare
   userId0 tb_user.userId%type;
   user tb_user%rowtype;
begin
  userId0:='&用户ID';
  select * into user from tb_user where userId=userId0;
  dbms_output.put_line(
   '用户id：'||user.userid||
   '，用户名：'||user.name||
   '，邮箱：'||user.email||
   '，所在省份id：'||user.provinceid||
   '，所在城市id：'||user.cityid||
   '，手机号：'||user.telephone||
   '，性别：'||user.sex||
   '，年龄：'||user.age||
   '，生日：'||user.birthday
   );
exception
   when no_data_found then
   dbms_output.put_line('没有发现您要找的数据！');
end;
/








-- declare
--    login_name varchar2(10);
-- begin
--    login_name:='&用户名';
--    login_password:='&密码';
--   select password into get_password from tb_user where name=login_name;
--   if get_password=login_password then 
--     dbms_output.put_line(login_name||',欢迎登陆！');
--   else 
--     dbms_output.put_line('密码错误！');
--   end if;
--   EXCEPTION
--      when no_data_found then
--        dbms_output.put_line('该用户尚未注册！');
-- end login;




-- declare
--    login_name varchar2(10);
--    login_password varchar2(30);
--    get_password varchar2(30);
-- begin
--    login_name:='&用户名';
--    login_password:='&密码';
--   select password into get_password from tb_user where name=login_name;
--   if get_password=login_password then 
--     dbms_output.put_line(login_name||',欢迎登陆！');
--   else 
--     dbms_output.put_line('密码错误！');
--   end if;
--   EXCEPTION
--      when no_data_found then
--        dbms_output.put_line('该用户尚未注册！');
-- end login;
-- /


-- 云端使用
-- conn sys/manager as sysdba;
-- create user adm identified by adm;

-- 实例密码root：123violetBENIN
-- oracle:1


-- 撤销 u   恢复：ctrl r
-- 清空：ggdG
-- @/tmp/test.sql  



-- The Oracle base for ORACLE_HOME=/data2/oracle/app/product/11.2.0/dbhome_1 is /data2/oracle/app




-- 总结：为了在SQLPLUS中看到PL/SQL 程序 执行的结果，需要：

-- 1 . set serveroutput on

-- 2. 在PL/SQL语句块末尾使用 "/" 执行PL/SQL语句块1




-- set declare on;