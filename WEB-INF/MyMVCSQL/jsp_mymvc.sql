---------- **** JSP & Servelt **** ---------

---------- **** MyMVC **** ----------

show user;
-- USER이(가) "MYORAUSER"입니다.

----- 1. 한줄 메모장 -----
create table jsp_memo
(idx         number(8)     not null        -- 글번호(시퀀스로 입력)
,userid      varchar2(20)  not null        -- 회원아이디
,name        varchar2(20)  not null        -- 작성자이름
,msg         varchar2(100)                 -- 메모내용
,writedate   date default sysdate          -- 작성일자
,cip         varchar2(20)                  -- 클라이언트 IP 주소
,status      number(1) default 1 not null  -- 글삭제유무
,constraint  PK_jsp_memo_idx primary key(idx)
,constraint  FK_jsp_memo_userid foreign key(userid)
                                  references jsp_member(userid)
,constraint  CK_jsp_memo_status check(status in(0,1) )  
);

create sequence jsp_memo_idx
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


select *
from jsp_memo
order by idx desc;

select *
from jsp_member
order by idx desc;


select A.idx, A.msg
      , to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS WRITEDATE
      , A.cip, B.name, B.email
from jsp_memo A join jsp_member B
on A.userid = B.userid
order by A.idx desc;

-- *** 성별 컬럼 추가 *** --
alter table jsp_member
add gender char(1); -- 남자 : 1 / 여자 : 2

update jsp_member set gender = '2'
where name like '%정화%' or 
      name like '%태희%';

update jsp_member set gender = '1'
where not (name like '%정화%' or 
           name like '%태희%');
      
commit;      

-- *** 성년월일 컬럼 추가 *** --
alter table jsp_member
add birthday varchar2(8); 

update jsp_member set birthday = '19850420'
where idx between 1 and 30;

update jsp_member set birthday = '19900825'
where idx between 31 and 60;

update jsp_member set birthday = '19931001'
where idx between 61 and 90;

update jsp_member set birthday = '19950515'
where idx between 91 and 120;

update jsp_member set birthday = '19970925'
where idx between 121 and 150;

update jsp_member set birthday = '20010220'
where idx between 151 and 180;

update jsp_member set birthday = '20021210'
where idx between 181 and 210;

commit;

select *
from jsp_member
order by idx desc;


---------------------------------------------------------
 -- *** 페이징 처리를 위해서 회원을 많이 가입시켜본다. *** --

 declare
   v_cnt number(3) := 1;
 begin
   loop
      insert into jsp_memo(idx, userid, name, msg, writedate, cip, status)
      values(jsp_memo_idx.nextval, 'leess', '이순신', v_cnt || '안녕하세요? 이순신입니다.', default, '127.0.0.1', default);      
      v_cnt := v_cnt + 1;
   exit when v_cnt > 100;
   end loop;
 end;
 
commit; 


select A.idx, A.msg
      , to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS WRITEDATE
      , A.cip, B.name, B.email
from jsp_memo A join jsp_member B
on A.userid = B.userid
order by A.idx desc;


 select A.idx, A.msg 
	    , to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS WRITEDATE 
		  , A.cip, B.name 
		  , case B.gender when '1' then '남' else '여' end AS GENDER 
		  , extract(year from sysdate) - to_number(substr(birthday, 1, 4)) + 1 AS AGE 
	    , B.email 
 from jsp_memo A join jsp_member B 
 on A.userid = B.userid 
 where A.status = 1 
 order by A.idx desc;
 
 
select idx, msg, writedate, cip, name, gender, age, email
from
(
 select rownum as RNO
      , idx, msg, writedate, cip, name, gender, age, email
 from
 (
   select A.idx, A.msg 
        , to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS WRITEDATE 
        , A.cip, B.name 
        , case B.gender when '1' then '남' else '여' end AS GENDER 
        , extract(year from sysdate) - to_number(substr(birthday, 1, 4)) + 1 AS AGE 
        , B.email 
   from jsp_memo A join jsp_member B 
   on A.userid = B.userid 
   where A.status = 1 
   order by A.idx desc
 ) V
) T
where T.RNO between 1 and 10;
 
 
select idx, msg, writedate, cip, name, gender, age, email
from
(
 select rownum as RNO
      , idx, msg, writedate, cip, name, gender, age, email
 from
 (
   select A.idx, A.msg 
        , to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS WRITEDATE 
        , A.cip, B.name 
        , case B.gender when '1' then '남' else '여' end AS GENDER 
        , extract(year from sysdate) - to_number(substr(birthday, 1, 4)) + 1 AS AGE 
        , B.email 
   from jsp_memo A join jsp_member B 
   on A.userid = B.userid 
   where A.status = 1 
   order by A.idx desc
 ) V
) T
where T.RNO between 11 and 20;


select idx, userid, name, pwd, email, hp1, hp2, hp3
      , post1, post2, addr1, addr2
      , to_char(registerday, 'yyyy-mm-dd') AS registerday 
      , status, gender, birthday
 from jsp_member
 where status = 1
 and userid = 'leess' and pwd = 'qwer1234$';



 select userid
 from jsp_member
 where status = 1 and
       name = '이순신' and 
       trim(hp1) || trim(hp2) || trim(hp3) = '01034567890';
       
 update jsp_member set email = 'hanmailrg@naver.com'
 where userid = 'leess';
 
 commit;
 
 
 ---------------------------------------------------------------------------
                 ---- *** 쇼핑몰 *** ----
/*
   카테고리 테이블명 : jsp_category

   컬럼정의 
     -- 카테고리 대분류 번호  : 시퀀스(seq_jsp_category_cnum)로 증가함.(Primary Key)
     -- 카테고리 코드(unique) : ex) 전자제품  '100000'
                                  의류      '200000'
                                  도서      '300000' 
     -- 카테고리명(not null)  : 전자제품, 의류, 도서           
  
*/ 
 
create table jsp_category
(cnum    number(8)     not null  -- 카테고리 대분류 번호
,code    varchar2(20)  not null  -- 카테고리 코드
,cname   varchar2(100) not null  -- 카테고리명
,constraint PK_jsp_category_cnum primary key(cnum)
,constraint UQ_jsp_category_code unique(code)
);

create sequence seq_jsp_category_cnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into jsp_category values(seq_jsp_category_cnum.nextval, '100000', '전자제품');
insert into jsp_category values(seq_jsp_category_cnum.nextval, '200000', '의류');
insert into jsp_category values(seq_jsp_category_cnum.nextval, '300000', '도서');

commit;

select *
from jsp_category;


---- *** 제품 테이블 : jsp_product *** ----
create table jsp_product
(pnum           number(8) not null       -- 제품번호(Primary Key)
,pname          varchar2(100) not null   -- 제품명
,pcategory_fk   varchar2(20)             -- 카테고리코드(Foreign Key)
,pcompany       varchar2(50)             -- 제조회사명
,pimage1        varchar2(100) default 'noimage.png' -- 제품이미지1   이미지파일명
,pimage2        varchar2(100) default 'noimage.png' -- 제품이미지2   이미지파일명 
,pqty           number(8) default 0      -- 제품 재고량
,price          number(8) default 0      -- 제품 정가
,saleprice      number(8) default 0      -- 제품 판매가(할인해서 팔 것이므로)
,pspec          varchar2(20)             -- 'HIT', 'BEST', 'NEW' 등의 값을 가짐.
,pcontent       clob                     -- 제품설명  varchar2는 varchar2(4000) 최대값이므로
                                         --          4000 byte 를 초과하는 경우 clob 를 사용한다.
                                         --          clob 는 최대 4GB 까지 지원한다.
                                         
,point          number(8) default 0      -- 포인트 점수                                         
,pinputdate     date default sysdate     -- 제품입고일자
,constraint  PK_jsp_product_pnum primary key(pnum)
,constraint  FK_jsp_product_pcategory_fk foreign key(pcategory_fk)
                                         references jsp_category(code)
);

create sequence seq_jsp_product_pnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '스마트TV', '100000', '삼성',
       'tv_samsung_h450_1.png','tv_samsung_h450_2.png',
       100,1200000,800000,'HIT','42인치 스마트 TV. 기능 짱!!', 50);


insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북', '100000', '엘지',
       'notebook_lg_gt50k_1.png','notebook_lg_gt50k_2.png',
       150,900000,750000,'HIT','노트북. 기능 짱!!', 30);  
       

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '바지', '200000', 'S사',
       'cloth_canmart_1.png','cloth_canmart_2.png',
       20,12000,10000,'HIT','예뻐요!!', 5);       
       

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '남방', '200000', '버카루',
       'cloth_buckaroo_1.png','cloth_buckaroo_2.png',
       50,15000,13000,'HIT','멋져요!!', 10);       
       

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '세계탐험보물찾기시리즈', '300000', '아이세움',
       'book_bomul_1.png','book_bomul_2.png',
       100,35000,33000,'HIT','만화로 보는 세계여행', 20);       
       
       
insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '만화한국사', '300000', '녹색지팡이',
       'book_koreahistory_1.png','book_koreahistory_2.png',
       80,130000,120000,'HIT','만화로 보는 이야기 한국사 전집', 60);
       
commit;       

select * from jsp_product; 

update jsp_product set pspec = 'HIT';
  
commit;       

-------- **** 장바구니 테이블 생성하기 **** ----------

 desc jsp_member;
 desc jsp_product;

 create table jsp_cart
 (cartno  number               not null   --  장바구니 번호
 ,userid  varchar2(20)         not null   --  사용자ID
 ,pnum    number(8)            not null   --  제품번호 
 ,oqty    number(8) default 0  not null   --  주문량
 ,status  number(1) default 1             --  삭제유무
 ,constraint PK_jsp_cart_cartno primary key(cartno)
 ,constraint FK_jsp_cart_userid foreign key(userid)
                                references jsp_member(userid) 
 ,constraint FK_jsp_cart_pnum foreign key(pnum)
                                references jsp_product(pnum)
 ,constraint CK_jsp_cart_status check( status in(0,1) ) 
 );

 create sequence seq_jsp_cart_cartno
 start with 1
 increment by 1
 nomaxvalue
 nominvalue
 nocycle
 nocache;

 comment on table jsp_cart
 is '장바구니 테이블';

 comment on column jsp_cart.cartno
 is '장바구니번호(시퀀스명 : seq_jsp_cart_cartno)';

 comment on column jsp_cart.userid
 is '회원ID  jsp_member 테이블의 userid 컬럼을 참조한다.';

 comment on column jsp_cart.pnum
 is '제품번호 jsp_product 테이블의 pnum 컬럼을 참조한다.';

 comment on column jsp_cart.oqty
 is '장바구니에 담을 제품의 주문량';

 comment on column jsp_cart.status
 is '장바구니에 담겨져 있으면 1, 장바구니에서 비우면 0';

 select *
 from user_tab_comments;

 select column_name, comments
 from user_col_comments
 where table_name = 'JSP_CART';
 
 select *
 from jsp_cart;
 
 insert into jsp_cart(cartno, userid, pnum, oqty)
 values(seq_jsp_cart_cartno.nextval, ?, ?, ?);

 update jsp_cart set status = 0
 where cartno = 1;
 
 update jsp_cart set status = 0
 where cartno = 3;

 commit;
 
 select *
 from jsp_cart
 order by cartno desc;
 
 select *
 from jsp_product;
 
 select B.cartno, B.userid, B.pnum,
        A.pname, A.pcategory_fk, A.pimage1, 
        A.price, A.saleprice, B.oqty, A.point, B.status
 from jsp_product A join jsp_cart B
 on A.pnum = B.pnum
 where B.userid = 'leess' and
       B.status = 1
 order by B.cartno desc;
 
 
 select B.cartno, B.userid, B.pnum,
        A.pname, A.pcategory_fk, A.pimage1, 
        A.price, A.saleprice, B.oqty, A.point, B.status
 from jsp_product A join jsp_cart B
 on A.pnum = B.pnum
 where B.userid = 'eom' and
       B.status = 1
 order by B.cartno desc;
 
 
 select B.cartno, B.userid, B.pnum,
        A.pname, A.pcategory_fk, A.pimage1, 
        A.price, A.saleprice, B.oqty, A.point, B.status
 from jsp_product A join jsp_cart B
 on A.pnum = B.pnum
 where B.userid = 'hansk' and
       B.status = 1
 order by B.cartno desc;
 
 
 +"SELECT B.cartno, " 
+"  B.userid, " 
+"  B.pnum, " 
+"  A.pname, " 
+"  A.pcategory_fk, " 
+"  A.pimage1, " 
+"  A.price, " 
+"  A.saleprice, " 
+"  B.oqty, " 
+"  A.point, " 
+"  B.status " 
+"FROM jsp_product A " 
+"JOIN jsp_cart B " 
+"ON A.pnum      = B.pnum " 
+"WHERE B.userid = 'hansk' " 
+"AND B.status   = 1 " 
+"ORDER BY B.cartno DESC"
 

 select userid, name, "addr1", "addr2" 
 from jsp_member
 where userid = 'leess' and pwd = 'qwer1234$';
 
 desc jsp_member;
 
 alter table jsp_member
 rename column addr1 to "addr1";

 alter table jsp_member
 rename column addr2 to "addr2"; 
 
 alter table jsp_member
 rename column "addr1" to addr1;

 alter table jsp_member
 rename column "addr2" to addr2;

 select userid, name, addr1, addr2 
 from jsp_member
 where userid = 'leess' and pwd = 'qwer1234$';
 

select cartno, userid, pnum,
       pname, pcategory_fk, pimage1, 
       price, saleprice, oqty, point, status
from 
(
 select rownum as RNO,
        cartno, userid, pnum,
        pname, pcategory_fk, pimage1, 
        price, saleprice, oqty, point, status
 from  
 (
   select B.cartno, B.userid, B.pnum,
          A.pname, A.pcategory_fk, A.pimage1, 
          A.price, A.saleprice, B.oqty, A.point, B.status
   from jsp_product A join jsp_cart B
   on A.pnum = B.pnum
   where B.userid = 'leess' and
         B.status = 1
   order by B.cartno desc
 ) V
) T 
where T.rno between 1 and 2; 


select cartno, userid, pnum,
       pname, pcategory_fk, pimage1, 
       price, saleprice, oqty, point, status
from 
(
 select rownum as RNO,
        cartno, userid, pnum,
        pname, pcategory_fk, pimage1, 
        price, saleprice, oqty, point, status
 from  
 (
   select B.cartno, B.userid, B.pnum,
          A.pname, A.pcategory_fk, A.pimage1, 
          A.price, A.saleprice, B.oqty, A.point, B.status
   from jsp_product A join jsp_cart B
   on A.pnum = B.pnum
   where B.userid = 'leess' and
         B.status = 1
   order by B.cartno desc
 ) V
) T 
where T.rno between 3 and 4; 
 

select cartno, userid, pnum,
       pname, pcategory_fk, pimage1, 
       price, saleprice, oqty, point, status
from 
(
 select rownum as RNO,
        cartno, userid, pnum,
        pname, pcategory_fk, pimage1, 
        price, saleprice, oqty, point, status
 from  
 (
   select B.cartno, B.userid, B.pnum,
          A.pname, A.pcategory_fk, A.pimage1, 
          A.price, A.saleprice, B.oqty, A.point, B.status
   from jsp_product A join jsp_cart B
   on A.pnum = B.pnum
   where B.userid = 'leess' and
         B.status = 1
   order by B.cartno desc
 ) V
) T 
where T.rno between 5 and 6; 


select count(*) AS CNT 
from jsp_cart 
where status = 1 and 
      userid = 'leess';

update jsp_cart set status = 1
where cartno in(11,10);

commit;

 --- *** jsp_member 테이블에 컬럼 coin, point 추가하기 *** ---
 
 alter table jsp_member
 add coin number default 0 not null;

 alter table jsp_member
 add point number default 0 not null; 

 update jsp_member set coin = 90000000
 where userid = 'leess';

 update jsp_member set coin = 10000000
 where userid = 'eom'; 

 commit;
 
select *
from jsp_product
order by pnum asc;

--- >>> 하나의 제품속에 여러개의 이미지 파일 넣어주기 ------------------------
create table jsp_product_imagefile
(imgfileno    number        not null    -- 시퀀스로 입력받음.
,fk_pnum      number(8)     not null    -- 제품번호(foreign key)
,imgfilename  varchar2(100) not null    -- 제품이미지파일명
,constraint PK_jsp_product_imagefile primary key(imgfileno)
,constraint FK_jsp_product_imagefile foreign key(fk_pnum)
                                     references jsp_product(pnum) 
);

create sequence seq_imgfileno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


insert into jsp_product_imagefile(imgfileno, fk_pnum, imgfilename)
values(seq_imgfileno.nextval, 3, 'cloth_canmart_3.png');

insert into jsp_product_imagefile(imgfileno, fk_pnum, imgfilename)
values(seq_imgfileno.nextval, 3, 'cloth_canmart_4.png');

insert into jsp_product_imagefile(imgfileno, fk_pnum, imgfilename)
values(seq_imgfileno.nextval, 4, 'cloth_buckaroo_3.png');

insert into jsp_product_imagefile(imgfileno, fk_pnum, imgfilename)
values(seq_imgfileno.nextval, 4, 'cloth_buckaroo_4.png');

insert into jsp_product_imagefile(imgfileno, fk_pnum, imgfilename)
values(seq_imgfileno.nextval, 4, 'cloth_buckaroo_5.png');

commit;

select imgfileno, fk_pnum, imgfilename
from jsp_product_imagefile
where fk_pnum = 4
order by imgfileno desc;











-- 주문의 간단한 정보를 보여주는 주문 일반 테이블
create table tbl_order
(
  odrcode        varchar(30)   not null,  -- 회원의 주문번호
  fk_userid      varchar(30)   not null,  -- 회원 테이블에서 참조한 회원ID
  odrtotalPrice  number     not null,     -- 해당 주문번호에 대한 주문 총 금액
  odrtotalPoint  number     not null,     -- 해당 주문번호에 대한 적립될 총 포인트
  odrdate        date       default sysdate,  -- 해당 주문 일자
  constraint PK_tbl_order_odrcode primary key(odrcode),  -- 기본키
  constraint FK_tbl_order_fk_userid foreign key(fk_userid) -- tbl_userinfo의 userid를 참조하는 외래키
                                    references tbl_userinfo(userid) 
);  


-- 주문의 자세한 정보를 보여주는 주문 상세 테이블
create table tbl_order_detail
(
  odrdetailno    number      not null,  -- 주문 상세에 대한 항목들의 일련번호
  pcode          varchar(30) not null,  -- 주문한 물품의 제품코드
  odrcode        varchar(30) not null,  -- 주문한 물품들에 해당하는 주문번호
  odrprice       number      not null,  -- 주문할 당시의 가격
  oqty           number      not null,  -- 주문량
  deliverStatus  number      not null,  -- 배송상태
  deliverDate    date        default sysdate,  -- 배송완료 일자
  constraint PK_tbl_order_detail_odrdetailno primary key(odrdetailno),  -- 기본키
  constraint FK_tbl_order_detail_pcode foreign key(pcode) -- tbl_product의 pcode를 참조하는 외래키
                                       references tbl_userinfo(tbl_product),
  constraint FK_tbl_order_detail_odrcode foreign key(odrcode) -- tbl_order의 odrcode를 참조하는 외래키
                                         references tbl_userinfo(tbl_order)
);                                  


-- 주문 상세 테이블의 일련번호를 위한 시퀀스
create sequence seq_odrdetailno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


-- 카테고리에 대한 정보들을 보여주는 테이블
create table tbl_category
(
  cnum    number       not null,  -- 카테고리 테이블에 대한 일련번호
  code    varchar(30)  not null,  -- 카테고리별 번호(1000, 2000.. 코멘트 참조)
  cname   varchar(100) not null,  -- 카테고리별 이름
  constraint PK_tbl_category_cnum primary key(cnum) -- 기본키
);

-- 주문 상세 테이블의 일련번호를 위한 시퀀스
create sequence seq_cnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


 -- comment of table tbl_order
 comment on table tbl_order
 is '주문의 간단한 정보를 보여주는 주문 일반 테이블';
 comment on column tbl_order.odrcode
 is '회원의 주문번호';
 comment on column tbl_order.fk_userid
 is '회원 테이블에서 참조한 회원ID';
 comment on column tbl_order.odrtotalPrice
 is '해당 주문번호에 대한 주문 총 금액'; 
 comment on column tbl_order.odrtotalPoint
 is '해당 주문번호에 대한 적립될 총 포인트'; 
 comment on column tbl_order.odrdate
 is '해당 주문 일자'; 
 comment on column tbl_order.PK_tbl_order_odrcode
 is 'tbl_order 테이블의 기본키'; 
 comment on column tbl_order.FK_tbl_order_fk_userid
 is 'tbl_product의 pcode를 참조하는 외래키';
 comment on column tbl_order.FK_tbl_order_detail_odrcode
 is 'tbl_order의 odrcode를 참조하는 외래키';
 
 
 -- comment of tbl_order_detail
 comment on column tbl_order_detail.odrdetailno    
 is '주문 상세에 대한 항목들의 일련번호';
 comment on column tbl_order_detail.pcode    
 is '주문한 물품의 제품코드';
 comment on column tbl_order_detail.odrcode    
 is '주문한 물품들에 해당하는 주문번호';
 comment on column tbl_order_detail.odrprice    
 is '주문할 당시의 가격';
 comment on column tbl_order_detail.oqty    
 is '주문량';
 comment on column tbl_order_detail.deliverStatus    
 is '배송상태';
 comment on column tbl_order_detail.deliverDate    
 is '배송완료 일자(기본값 sysdate)';
 comment on column tbl_order_detail.PK_tbl_order_detail_odrdetailno    
 is '테이블 tbl_order_detail의 기본키';
 comment on column tbl_order_detail.FK_tbl_order_detail_pcode    
 is 'tbl_product의 pcode를 참조하는 외래키';
 comment on column tbl_order_detail.FK_tbl_order_detail_odrcode    
 is 'tbl_order의 odrcode를 참조하는 외래키';
 
 
  -- comment of tbl_category
 comment on column tbl_category.cnum 
 is '카테고리 테이블에 대한 일련번호';
 comment on column tbl_category.code 
 is '1000:outer / 2000:top / 3000:bottom / 4000:ACC / 5000:suit';
 comment on column tbl_category.cname 
 is '카테고리별 이름';
 comment on column tbl_category.PK_tbl_category_cnum   
 is '테이블 tbl_category의 기본키';
 
 