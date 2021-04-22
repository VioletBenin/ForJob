grant connect,resource to yihan;
 
-------------tb_user表(用户信息表)
 create sequence s1 start with 1000 increment by 1;
create table tb_user(
   userId number(10) not null primary key,
   name varchar2(10) unique not null,
   password varchar2(30) not null,
   email varchar2(20),
   provinceId number(10),
   cityId number(10),
   telephone char(11),
   sex char(3) default '男',
   age number(10),
   birthday date,
   money number(10) default 0,
   photo varchar2(500),
   dsp varchar2(200),
   qq varchar2(15),
   msn varchar2(100),
   loveBook varchar2(100),
   loveMusic varchar2(100),
   loveMovie varchar2(100),
   loveSport varchar2(100),
   loveGame varchar2(100),
   constraint fk_cityId foreign key(cityId) references tb_city(cityId)
   )
   
   insert into tb_user values(s1.nextval,'yiyi','123456','123456789',1001,1003,15455556666,
     '男',20,to_date('2014-02-14','yyyy-mm-dd'),10000,'1005','5656','1566','44545','5555','5666','5555','5555','55666');
     insert into tb_user values(s1.nextval,'yi','123456','123456789',1002,1004,15455556666,
     '男',20,to_date('2014-02-14','yyyy-mm-dd'),10000,'1005','5656','1566','44545','5555','5666','5555','5555','55666');
  
   select * from tb_user;
   -----------tb_product表(商品信息表)---
   create sequence s2 start with 1000 increment by 1; 
   create table tb_product(
      productId number(10) not null primary key,
      userId number(10) not null,
      productName varchar2(50) not null,
      typeId number(10) not null,
      price number(10) not null,
      photo varchar2(500),
      information varchar2(500),
      constraint fk_userId foreign key(userId) references tb_user(userId),
      constraint fk_typeId foreign key(typeId) references tb_productType(productTypeId)
      )
      
      
     
      
      insert into tb_product values(s2.nextval,1002,'小苹果',1001,1000,'s55s5','zixi');
       insert into tb_product values(s2.nextval,1004,'小苹果',1001,1000,'s55s5','zixi');
       
       select * from tb_product;
       
       select * from tb_product where productName='小苹果';
       
       select * from tb_product tp join tb_user tu on tp.userId=tu.userId;
       
      --------tb_productType表（商品类型表）--
      create sequence s3 start with 1000 increment by 1;
      create table tb_productType(
          productTypeId number(10) not null primary key,
          productTypeName varchar2(100)
          );
      -----------为此表插入数据-----
      
      insert into tb_productType values(s3.nextval,'饼干');
      insert into tb_productType values(s3.nextval,'雪糕'); 
      
      select * from tb_productType;    
          
        --------/*用户在商城以商品类型查询一件商品的名称*/-----
        select * from tb_product tp join tb_productType tp1 on tp.typeId=tp1.productTypeId;  
          
          
          
          ----tb_order表（订单表）----
       create sequence s4 start with 1000 increment by 1;
       create table tb_order(
          orderId number(10) not null primary key,
          toId number(10) not null,
          colorId number(10),
          productId number(10),
          address varchar2(100),
          telephone char(13),
          orderState number(10),
          count number(10),
          price number(10),
          orderDate date,
          consignmentDate date,
          constraint fk_toId foreign key(toId) references tb_user(userId),
          constraint fk_colorId foreign key(colorId) references tb_productColor(productColorId),
          constraint fk_productId11 foreign key(productId) references tb_product(productId)
          );
          -------为tb_order表插入数据----
          insert into tb_order values(s4.nextval,1002,1001,1001,'青岛','18699996666',1566,4444,10000,to_date('2018-08-08','yyyy-mm-dd'),to_date('2018-08-09','yyyy-mm-dd'));
           insert into tb_order values(s4.nextval,1004,1001,1001,'青岛','18699996666',1566,4444,10000,to_date('2018-08-08','yyyy-mm-dd'),to_date('2018-08-09','yyyy-mm-dd'));
          select * from tb_order;
          ---------/*用户在商城可以查询已知用户(或卖家)的基本信息*/
          
          select * from tb_order tor join tb_user tu on tor.toid=tu.userid;
         
          
          
          -----/*定义变量,用于存储本次订单的物品单价*/----
           declare 
             this_price number(10);
           begin
             select price into this_price from tb_order where orderId=1002;
             dbms_output.put_line(this_price);
           end;
          ------/*定义变量,用于存储本次订单的物品ID*/---
          
           declare
              this_product varchar2(20);
           begin
              select productName into this_product from tb_order tbo join tb_product tp on  
              tbo.productId=tp.productId where orderId=1002;
              dbms_output.put_line(this_product);
           end;
           
          -----------/*定义变量,用于存储本次订单的颜色ID*/---
          declare
             this_productColor varchar2(20);
          begin
             select productColor into this_productColor from tb_order tbo join tb_productColor tp on 
             tbo.colorId=tp.productcolorid where orderId=1002;
             dbms_output.put_line(this_productColor);
          end;
          -------/*定义变量,用于存储本次订单的买家ID*/----
          
           declare
             this_userId number(10);
           begin
             select userId into this_userId from tb_order tbo join tb_user tu on 
             tbo.toId=tu.userId where orderId=1002;
             dbms_output.put_line(this_userId);
           end;
           -----/*定义变量,用于存储流水表的用户ID*/---
              
           declare
              this_userAccountId number(10);
           begin
               select userAccountId into this_userAccountId from tb_userAccount where orderId=1002;
               dbms_output.put_line(this_userAccountId);
           end;
           
select * from tb_user;
           ----------------------总的部分-------
 
----------
 
declare
  this_userId number;
  this_productColorId number;
  this_productId number;
  this_count number;
  this_stockPile number;
  this_price number;
  this_money number;
  this_phone char(11);
  Ordernum number;------------当前订单编号---
begin
  this_userid:='&买家id';
  this_productColorId:='&颜色Id';
  this_productId:='&商品id';
  this_count:='&数量';
  select telephone into this_phone from tb_user where userId=this_userId;
  select price into this_price from tb_product where productId=this_productId;
  ----------/*用户****将订单信息填入到tb_order表中*/
  insert into tb_order values(s4.nextval,this_userid,this_productcolorid,this_productid,'默认地址',this_phone,0,this_count,(this_count*this_price),sysdate,(sysdate+3));
  -------/*下订单后减少商品库存*/---
  select stockpile into this_stockPile from tb_productColor where productColorId=this_productColorId;
  if this_stockPile>this_count then
     begin
       update tb_productColor set stockPile=stockPile-this_count where productColorId=this_productColorId;
     end;
  else
      raise_application_error(-20002, '库存不足');  
  end if;
  ---------/*确认付款后减少用户余额*/
  
  select money into this_money from tb_user where userId=this_userId;
  if this_money>this_count*this_price then
    begin
      update tb_user set money=this_money-this_count*this_price where userId=this_userid;
    end;
  else
    raise_application_error(-20002, '账户余额不足');
  end if;
  
  select s4.currval into ordernum from dual;------获取当前订单编号---
  
  ------/*将用户付款的订单状态改为已付款  1代表"已付款"*/
  update tb_order set orderState=1 where orderId=orderNum;
  
  ------/*用户账户上的钱转账完成后建立用户资金流水表一条买家购买商品支出记录*/
  
  insert into tb_useraccount values(s5.nextval,this_userId,ordernum,this_productColorId,sysdate);
      dbms_output.put_line('操作成功');
  commit;
  
  exception 
  when no_data_found then
 -- begin
      dbms_output.put_line('数据未找到，操作失败');
  rollback;
 -- end; 
end;
  
  
  select * from tb_user;
  select * from tb_product;
  select * from tb_productColor;
  
  ----------------练习12----
 
select * from tb_order;
declare
   this_orderId number;
   this_address varchar2(20);
   this_telephone char(11);
   this_orderState number;
   this_colorId number;
   this_price number;
   this_count number;
   this_bef_price number;
   this_old_productColorId number;
begin
  
  ------ 根据订单编号来修改----
  this_orderId:=&订单编号Id;
  ----/*修改tb_order表中的送货地址*/--
  this_address:='&送货地址';
  update tb_order set address=this_address where  orderId=this_orderId;
  dbms_output.put_line('送货地址已修改');
  
  -----------/*修改tb_order表中的联系方式*/----;
  this_telephone:='&联系方式';
  update tb_order set telephone=this_telephone where orderId=this_orderId;
  dbms_output.put_line('联系方式已修改');
  
  -----------/*修改tb_order表中的状态*/----
  this_orderState:=&修改状态;
  ------若卖家因故不能发货，但已付款则卖家可修改订单状态为'延后'
  update tb_order set orderState=this_orderState where orderId=this_orderId;
  dbms_output.put_line('订单状态已修改');
  -----------/*修改tb_order表中的商品颜色*/----
  ----先获取修改之前的订单商品的颜色----
  
  select colorId into this_old_productColorId from tb_order where orderId=this_orderId;
  ------获取此订单颜色的数量---
  
  select count into this_count from tb_order where orderId=this_orderId; 
  -----------新的颜色----
  
  this_colorId:='&颜色id';
  update tb_order set colorId=this_colorId where orderId=this_orderId;
  
  --------------  /*修改颜色后要将之前选择的颜色库存加一再将修改后的颜色库存减一*/---
  update tb_productcolor set stockPile =stockPile-this_count where productColorId=this_orderId;  
  update tb_productColor set stockPile=stockPile+this_count where productColorId=this_old_productColorId;
  
  dbms_output.put_line('商品颜色已修改');
  -------------/*修改tb_order表中的商品总价*/-----
  
  select price into this_bef_price from tb_order where orderId=this_orderId;
  this_price:='&当前价格';
  
  update tb_order set price=this_price where orderId=this_orderId;
  
  -----------若和买家商议后买家同意降价，但商品信息上还是不修改的，就可以在订单总价上修改，付款后卖家修改总价，差价打回买家账户余额内
  -------将之前的差价补回原账户----
  
  update tb_user set money=money+this_bef_price-this_price where userId=(select toId from tb_order where orderId=this_orderId);
  dbms_output.put_line('商品总价已修改');
  dbms_output.put_line('操作成功');
  commit;
  
  exception 
  when no_data_found then
   dbms_output.put_line('数据未找到，操作失败');
  rollback;
end;
  
  ----------------------
  
  ------------十二、订单完成进行转账---------
  
declare
  this_userId number;
  this_sellerId number;
  this_price number;
  this_orderId number;
begin
  this_orderId:='&订单号';
  ----------/*买家收到商品后，修改tb_order表中的状态*/---
  update tb_order set orderState=3 where orderId=this_orderId;
  dbms_output.put_line('订单状态已完成');
  
  ---------- /*订单状态为'完成'后建立用户资金流水表一条卖家出售商品收入记录*/
  
  select userId into this_sellerId from tb_product where productId=(select productId from tb_order where 
    orderId=this_orderId);
  insert into tb_useraccount values(s5.nextval,this_sellerid,this_orderId,1,sysdate);
  dbms_output.put_line('用户资金流水表插入一条卖家出售商品收入记录');
  
    --------- /*交易成功后卖家账户余额增加*/
    select price into this_price from tb_order where orderId=this_orderId;
    
    update tb_user set money=money+this_price where userId=this_sellerId;
    dbms_output.put_line('卖家账户余额增加');
    dbms_output.put_line('操作成功');
    COMMIT;
exception
when no_data_found then
  dbms_output.put_line('数据未找到，操作失败');
rollback;
  
end;
   
 
-----------------十三、货物丢件进行退款----  
declare
  this_sellerId number;
  this_userId number;
  this_orderId number;
  this_price number;
begin
  this_orderId:='&订单编号';
  -------------/*卖家确认商品丢件后，修改tb_order表中的状态*/---
  update tb_order set orderState=5 where orderId=this_orderId;
  dbms_output.put_line('订单状态:撤销');
  ------- /*订单状态为'撤销'后建立用户资金流水表一条买家商品退款收入记录*/--
  select toid into this_userId from tb_order where orderId=this_orderId;
  insert into tb_useraccount values(s5.nextval,this_userId,this_orderId,1,sysdate);
  dbms_output.put_line('用户资金流水表插入一条买家商品退款收入记录');
  
  
  
  -------------/*撤销成功后买家账户余额恢复*/---
  select price into this_price from tb_order where orderId=this_orderId;
  update tb_user set money=money+this_price where userId=this_userId;
  dbms_output.put_line('买家账户余额恢复');
  dbms_output.put_line('操作成功');
  commit;
  
exception
when no_data_found then
    dbms_output.put_line('数据未找到，操作失败');
    rollback;
end;
  
 
------------------------------------十四、视图
-----------------------------------/*多表查询*/------------------
 
 
-----------------------/*用户在商城以商品类型查询一件商品的名称*/-----
drop view view_Name;
create view view_Name
as
   select * from tb_product tp ,tb_productType tpt where tp.typeid=tpt.producttypeid;
   
declare
   name varchar2(20);
   dname varchar2(20);
   cursor cur(xname varchar2) 
   is 
     select productName from view_Name where productTypeName=xname;
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
 
--------------/*用户在商城以商品名称查询一件商品的所有信息*/
 
create view this_view
as 
   select productcolorid,productcolor,stockpile,
   c.productsizeid,productsize,s.productid,userid,productname,typeid,price,photo,information 
   from tb_productcolor c 
   join tb_productsize s on c.productsizeid=s.productsizeid
   join tb_product p on p.productid=s.productid;
   
declare
dm  this_view%rowtype;
pname varchar2(50);
cursor cur_t (product_name in varchar2)
is
 select *  from this_view
   where productname=product_name;
begin
   pname:='&商品名称';
   open cur_t(pname);
   loop
   fetch cur_t into dm;
   exit when cur_t%notfound;
    dbms_output.put_line(
    '商品id：'||dm.productid||
    '  商品名字：'||dm.productname||
    '  商品颜色id：'||dm.productcolorid||
    '  商品颜色：'||dm.productcolor||
    '  商品库存：'||dm.stockpile||
    '  商品型号id：'||dm.productsizeid||
    '  商品型号：'||dm.productsize||
    '  商品卖家id：'||dm.userid||
    '  商品类型id：'||dm.typeid||
    '  商品价格：'||dm.price||
    '  商品图片路径：'||dm.photo||
    '  商品简介：'||dm.information
   );
    end loop;
   close cur_t;
exception
   when no_data_found then
   dbms_output.put_line('没有发现您要找的数据！');
end;
 
---------------------/*用户在商城可以查询已知用户(或卖家)的基本信息*/-----------
declare
   yonghuId tb_user.userId%type;
   yonghu tb_user%rowtype;
begin
  yonghuId:='&用户ID';
  select * into yonghu from tb_user where userId=yonghuId;
  dbms_output.put_line(
   '用户id：'||yonghu.userid||
    '  用户名：'||yonghu.name||
    '  邮箱：'||yonghu.email||
    '  所在省份id：'||yonghu.provinceid||
    '  所在城市id：'||yonghu.cityid||
    '  手机号：'||yonghu.telephone||
    '  性别：'||yonghu.sex||
    '  年龄：'||yonghu.age||
    '  生日：'||yonghu.birthday
   );
exception
   when no_data_found then
   dbms_output.put_line('没有发现您要找的数据！');
end;
 
-------------------十五、用户登录--------------
--------------------------/*用户登录(应用存储过程)*/---
create or replace procedure login(login_name in varchar2,login_password in varchar2)
as
  huoqu_password varchar2(30);
begin
  select password into huoqu_password from tb_user where name=login_name;
  if huoqu_password=login_password then 
    dbms_output.put_line('欢迎登陆！');
  else 
    dbms_output.put_line('密码错误！');
  end if;
  EXCEPTION
     when no_data_found then
       dbms_output.put_line('该用户尚未注册！');
end login;
 
begin
  login('yiyi','123456');
end;
 
begin
  login('yi','123456');
end;
 
 
   
           
          -------创建tb_userAccount---（用户资金流水表）
          create sequence s5 start with 1000 increment by 1;
          drop table tb_userAccount;
          create table tb_userAccount(
              userAccountId number(10) primary key,
              userId number(10),
              orderId number(10),
              type number(10),
              time date,
              constraint fk_userId1 foreign key(userId) references tb_user(userId),
              constraint fk_orderId foreign key(orderId) references tb_order(orderId)
          );
          
          insert into tb_userAccount values(s5.nextval,1002,1002,666,to_date('1997-09-07','yyyy-mm-dd'));
          insert into tb_userAccount values(s5.nextval,1004,1003,666,to_date('1997-09-07','yyyy-mm-dd'));
          select * from tb_userAccount;
          ---------创建tb_review（评论表）
          
          create sequence s6 start with 1000 increment by 1;
        
          create table tb_review (
             reviewId number(10) primary key,
             review varchar2(200),
             isReply number(1) default 0,
             isDel number(1) default 0,
             senderId number(10),
             productId number(10),
             addTime date,
             replyId  number(10),
             constraint fk_senderId foreign key(senderId) references tb_user(userId),
             constraint fk_productId1 foreign key(productId) references tb_product(productId)
             
           );
           ----------- tb_province表（省份数据字典）
            create sequence s7 start with 1000 increment by 1;
           create table tb_province(
              provinceId number(10) not null primary key,
              provinceName varchar2(30)
           );
           
           ---------为tb_province插入数据-----
           
           insert into tb_province values(s7.nextval,'山东省');
           insert into tb_province values(s7.nextval,'浙江省');
           
           select * from tb_province;
           
           ----------tb_city表（城市数据字典
            create sequence s8 start with 1000 increment by 1;
           create table tb_city(
              cityId number(10) not null primary key,
              provinceId number(10),
              cityName varchar2(30),
              constraint fk_provinceId foreign key(provinceId) references tb_province(provinceId)
             );
           -----为tb_city添加数据----
           insert into tb_city values(s8.nextval,1001,'青岛市');
           insert into tb_city values(s8.nextval,1002,'烟台市');
           select * from tb_city;
             
             ------------tb_productSize表（商品型号表
             create sequence s9 start with 1000 increment by 1;
             
             create table tb_productSize(
                 productSizeId number(10) not null primary key,
                 productSize varchar2(20) not null,
                 productId number(10),
                 constraint fk_productId foreign key(productId) references tb_product(productId)
                 );
            ----------为tb_productSize添加数据-----
            insert into tb_productSize values(s9.nextval,'XXX',1001);
            insert into tb_productSize values(s9.nextval,'XXL',1002);
            
            select tb_productSize.Productsize,tb_product.
            
            select * from tb_productSize;
                 
               ----------tb_productColor表（商品颜色表）
               create sequence s10 start with 1000 increment by 1; 
              create table tb_productColor(
                 productColorId number(10) primary key,
                 productColor varchar2(20),
                 stockPile number(10),
                 productSizeId number(10),
                 constraint fk_productSizeId foreign key(productSizeId) references tb_productSize(productSizeId)
                 )
             
               insert into tb_productColor values(s10.nextval,'red',1000,1001);
               insert into tb_productColor values(s10.nextval,'yellow',1000,1002);
               select * from tb_productColor;
               select productColor,productSize,productName from tb_productColor tpc,tb_productSize tps,
                tb_product tp,tb_user tu 
                where tpc.productSizeId=tps.productSizeId and tps.productId=tp.productId 
                and tp.userId=tu.userId and tu.name='yi'; 