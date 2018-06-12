-----------******* JSP& Servelt*****-------------------------



show user;
--USER이(가) "MYORAUSER"입니다.

---------------------1.한줄메모장--------------------
create table jsp_memo
(idx  number(8) not null  --글번호 시퀀스로 입력
,userid varchar2(20)  not null  --회원아이디
,name varchar2(20)  not null  --회원명
,msg  varchar2(100) not null  --메모내용
,writedate  date  default sysdate --작성일자
,cip  varchar2(20)  --클라이언트 IP 주소
,status number(1) default 1 not null  --글 삭제 유무
,constraint PK_jsp_memo_idx primary key(idx)
,constraint FK_jsp_memo_userid foreign key(userid)
                              references jsp_member(userid)
,constraint CK_jsp_memo_status check(status in(0,1))
);

create sequence jsp_memo_idx
start with 1
increment by 1
nominvalue
nomaxvalue
nocycle
nocache;

select*
from jsp_memo
order by idx desc;

select*
from jsp_member
order by idx desc;



select A.idx, A.msg
, to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') as writedate 
, A.cip, B.name, B.email
from jsp_memo A join jsp_member B 
 on A.userid = B.userid
 where A.status=1
	order by A.idx desc ;
  

--***성별컬럼 추가***---
alter table jsp_member
add gender char(1);--남자 1 여자 2

--**생년월일 컬럼 추가***--
alter table jsp_member
add birthday varchar2(8);

update jsp_member set gender ='2'
where name like '%정화%'or
      name like '%태희%';

commit;

update jsp_member set gender ='1'
where not (name like '%정화%'or
           name like '%태희%');

commit;

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


select*
from jsp_member
order by idx desc;

-----------***페이징처리를 위해 회원을 많이 가입 시켜본다.*****---------------------

declare
  v_cnt number(3) := 1;
begin
 loop
  insert into jsp_memo(idx, userid, name, msg, writedate, cip, status)
values(jsp_memo_idx.nextval, 'leess', '이순신',v_cnt|| '안녕하세요? 이순신 입니다.', default, '127.0.0.1', default );
  v_cnt := v_cnt + 1;
 exit when v_cnt >100;
 end loop;
end;

commit;



select idx, msg,cip, name, gender, birthday, email
from
(
select rownum as RNO, idx, msg,cip, name, gender, birthday, email
from
(
select A.idx, A.msg
, to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') as writedate
, A.cip, B.name, B.email,  case B.gender when '1' then '남'  else '여' end AS gender, to_number(to_char(sysdate, 'yyyy'))-to_number(substr(B.birthday,1,4))+1 AS birthday
from jsp_memo A join jsp_member B 
on A.userid = B.userid 
where A.status=1 
order by A.idx desc
)V)T
where T.rno between 1 and 10



+"SELECT idx, " 
+"  msg, " 
+"  cip, " 
+"  name, " 
+"  gender, " 
+"  birthday, " 
+"  email " 
+"FROM " 
+"  (SELECT rownum AS RNO, " 
+"    idx, " 
+"    msg, " 
+"    cip, " 
+"    name, " 
+"    gender, " 
+"    birthday, " 
+"    email " 
+"  FROM " 
+"    (SELECT A.idx, " 
+"      A.msg , " 
+"      TO_CHAR(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS writedate , " 
+"      A.cip, " 
+"      B.name, " 
+"      B.email, " 
+"      CASE B.gender " 
+"        WHEN '1' " 
+"        THEN '남' " 
+"        ELSE '여' " 
+"      END                                                                     AS gender, " 
+"      to_number(TO_CHAR(sysdate, 'yyyy'))-to_number(SUBSTR(B.birthday,1,4))+1 AS birthday " 
+"    FROM jsp_memo A " 
+"    JOIN jsp_member B " 
+"    ON A.userid   = B.userid " 
+"    WHERE A.status=1 " 
+"    ORDER BY A.idx DESC " 
+"    )V " 
+"  )T " 
+"WHERE T.rno BETWEEN 1 AND 10"


select*
from jsp_memo
order by idx desc;


UPDATE jsp_memo SET status = 1 WHERE status= 0 
commit;



select idx, userid, name, pwd, email, hp1, hp2, hp3
      , post1,post2, addr1, addr2, to_char(registerday, 'yyyy-mm-dd')
      , status, gender, birthday 
from jsp_member
where status = 1
and userid='leess' and pwd='qwer1234$'

+"SELECT idx, " 
+"  userid, " 
+"  name, " 
+"  pwd, " 
+"  email, " 
+"  hp1, " 
+"  hp2, " 
+"  hp3 , " 
+"  post1, " 
+"  post2, " 
+"  addr1, " 
+"  addr2, " 
+"  TO_CHAR(registerday, 'yyyy-mm-dd') , " 
+"  status, " 
+"  gender, " 
+"  birthday " 
+"FROM jsp_member " 
+"WHERE status = 1 " 
+"AND userid   ='leess' " 
+"AND pwd      ='qwer1234$'"

select *
 from jsp_member 
 where status = 1 and 
 name = '이순신' and 
 trim(hp1) || trim(hp2) || trim(hp3) = '01054654564'
 
 update jsp_member set email='pup1210@naver.com'
 where userid='leess'
 
 commit;
 
 
 select*
 from jsp_member
 ------------------------------------------------------------------------------
                ----------*********쇼핑몰******-----------------
/*
  카테고리 테이블명 : jsp_category
  
  컬럼정의 
  -- 카테고리 대분류 번호   : 시퀀스(seq_jap_category_cnum)로 증가함(primary Key)
  -- 카테고리 코드(unique) : ex) 전자제품 '100000' 의류 '200000'  도서 '300000'
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

select * 
from jsp_product;     


update jsp_product set pspec='HIT';
commit;

------------------****장바구니 테이블 생성하기***---------------------
desc jsp_member;
desc jsp_product;

create table jsp_cart
(cartno number not null -- 장바구니 번호
,userid varchar2(20) not null --사용자 아이디
,pnum number(8) not null --제품번호
,oqty number(8) default 0 not null --주문량
,status number(1) default 1 --삭제유무
,constraint PK_jsp_cart_cartno primary key(cartno)
,constraint FK_jsp_cart_userid foreign key(userid)
                                references jsp_member(userid)
,constraint FK_jsp_cart_pnum foreign key(pnum)
                                references jsp_product(pnum)
,constraint CK_jsp_cart_status check(status in (0,1))
);

create sequence seq_jsp_cart_cartno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

comment on table jsp_cart
is'장바구니 테이블';

comment on column jsp_cart.cartno
is'장바구니 번호 (시퀀스명:seq_jsp_cart_cartno )';
comment on column jsp_cart.userid
is'회원 ID jsp_member 테이블의 userid 컬럼을 참조한다.';
comment on column jsp_cart.pnum
is'제품번호 jsp_produst 테이블의 pnum 컬럼을 참조한다.';
comment on column jsp_cart.oqty
is'장바구니에 담을 제품의 주문량이다.';
comment on column jsp_cart.status
is'장바구니에 담겨져 있으면 1, 비우면 0';

select*
from user_tab_comments;

select Column_Name,Comments,Table_Name
from user_col_comments
where table_name='JSP_CART';

select*
from jsp_cart
order by 1;

insert into jsp_cart(cartno, userid, pnum,oqty)
values(seq_jsp_cart_cartno.nextval,?,?,?)

+"INSERT " 
+"INTO jsp_cart " 
+"  ( " 
+"    cartno, " 
+"    userid, " 
+"    pnum, " 
+"    oqty " 
+"  ) " 
+"  VALUES " 
+"  ( " 
+"    seq_jsp_cart_cartno.nextval, " 
+"    ?, " 
+"    ?, " 
+"    ? " 
+"  )"

commit;

update jsp_cart set status = 0
where cartno = 3

commit;

select B.cartno, B.userid, B.pnum, A.pname, A.pcategory_fk, A.pimage1,
        A.price, A.saleprice, B.oqty, A.point, B.status
from jsp_product A join jsp_cart B
on A.pnum = B.pnum
where B.userid='leess' and
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
+"ON A.pnum     = B.pnum " 
+"WHERE B.userid='leess' " 
+"AND B.status  = 1 " 
+"ORDER BY B.cartno DESC;"

select *
from jsp_member

select*
from jsp_cart

select*
from jsp_member
-----------------------------------------------------------------------------------

select userid, name, addr1, addr2 
 from jsp_member
 where userid = 'leess' and pwd = 'a124578!';
 
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
 where userid = 'leess' and pwd = 'a124578!';
 

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

  update jsp_member set coin = 10000
  where userid = 'hansk';

 commit;

--->>>하나의 제품속에 여러개의 이미지 파일 넣어주기----------------
create table jsp_product_imagefile
(imgfileno number not null -- 시퀀스로 입력받음
,fk_pnum number(8) not null --제품번호 (foreign key)
,imgfilename varchar2(100) not null --제품이미지 파일명
,constraint pk_jsp_product_imagefile primary key(imgfileno)
,constraint FK_jsp_product_imagefile foreign key(fk_pnum)references jsp_product
);

create sequence seq_imgfileno
start with 1
increment by 1
nominvalue
nomaxvalue
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

 select *
 from jsp_product 
 where pcategory_fk = 100000 
 order by pnum desc;
 
 ----------------->>>주문관련 테이블<<<------------------------------------
 --[1]주문개요 테이블 : jsp_order
 --[2]주문 상세 테이블 : jsp_order_detail
 
 
 ----***"주문 개요 테이블" ***---
create table jsp_order
(odrcode varchar2(20) not null --주문코드(명세서번호) 주문코드 형식: s+날짜+sequence => s20180501-1,s20180501-2,s20180502-3
,fk_userid varchar2(20) not null --사용자 아이디
,odrtotalPrice number not null --주문총액
,odrtotalPoint number not null--주문 총 포인트
,odrdate date default sysdate not null --주문일자
,constraint PK_jsp_order_odrcode primary key(odrcode)
,constraint FK_jsp_order_fk_userid foreign key(fk_userid) references jsp_member(userid)
);

--"주문코드(명세서 번호)시퀀스 " 생성
create sequence seq_jsp_order
start with 1
increment by 1
nominvalue
nomaxvalue
nocycle
nocache;


select odrcode, fk_userid, odrtotalPrice, odrtotalPoint, to_char(odrdate,'yyyy-mm-dd hh24:mi:ss') as odrdate
from jsp_order
order by odrcode desc;

----***"주문 상세 테이블" ***---
create table jsp_order_detail
(odrseqnum number not null --주문상세 일련번호
,fk_odrcode varchar2(20) not null-- 주문코드
,fk_pnum number(8) not null --제품번호
,oqty number not null --주문량
,odrprice number not null --주문할 당시의 판매가 ==>insert 시 jsp_product테이블에서 해당제품의 saleprice컬럼값을 넣어주어야 한다.
,deliverStatus number(1) default 1 not null --배송상태( 1 : 주문만 받음, 2: 배송시작, 3 : 배송완료)
,deliverDate date --배송완료 일자 default는 null로함
,constraint PK_jsp_order_detail_odrseqnum primary key(odrseqnum)
,constraint FK_jsp_order_detail_fk_odrcode foreign key(fk_odrcode) references jsp_order(odrcode) on delete cascade
,constraint FK_jsp_order_detail_fk_pnum foreign key(fk_pnum) references jsp_product(pnum)
,constraint CK_jsp_order_detail check(deliverStatus in(1,2,3))
);
--"주문상세 일련 번호 시퀀스 " 생성
create sequence seq_jsp_order_detail
start with 1
increment by 1
nominvalue
nomaxvalue
nocycle
nocache;

select odrseqnum, fk_odrcode, fk_pnum, oqty, odrprice, deliverStatus, to_char(deliverDate,'yyyy-mm-dd hh24:mi:ss') as deliverDate
from jsp_order_detail;

select*
from jsp_product;

update jsp_product set pqty=10
where pnum = 2;

commit;

select*
from jsp_member

select*
from jsp_product

select*
from jsp_order

select odrcode,odrdate,pimage1, fk_pnum, pname, price, odrprice,
       point, oqty, odrtotalprice, odrtotalpoint, deliverstatus
       ,fk_userid
from
(
select A.odrcode, A.fk_userid, A.odrtotalprice, A.odrtotalpoint
      ,A.odrdate, B.odrprice, B.deliverstatus, B.fk_pnum, B.oqty, C.point, C.price
      ,C.pimage1, C.pname
from jsp_order A join jsp_order_detail B
on A.odrcode = B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
where fk_userid = 'leess'  
)V



+"SELECT V.odrcode, " 
+"  V.odrdate, " 
+"  C.pimage1, " 
+"  V.fk_pnum, " 
+"  C.pname, " 
+"  C.price, " 
+"  V.odrprice, " 
+"  c.point, " 
+"  V.oqty, " 
+"  V.odrtotalprice, " 
+"  V.odrtotalpoint, " 
+"  V.deliverstatus , " 
+"  V.fk_userid " 
+"FROM " 
+"  (SELECT A.odrcode, " 
+"    A.fk_userid, " 
+"    A.odrtotalprice, " 
+"    A.odrtotalpoint , " 
+"    A.odrdate, " 
+"    B.odrprice, " 
+"    B.deliverstatus, " 
+"    B.fk_pnum, " 
+"    B.oqty " 
+"  FROM jsp_order A " 
+"  JOIN jsp_order_detail B " 
+"  ON A.odrcode = B.fk_odrcode " 
+"  )v " 
+"JOIN jsp_product C " 
+"ON V.fk_pnum    = C.pnum " 
+"WHERE fk_userid = 'eom'"



+"SELECT odrcode, " 
+"  odrdate, " 
+"  pimage1, " 
+"  fk_pnum, " 
+"  pname, " 
+"  price, " 
+"  odrprice, " 
+"  point, " 
+"  oqty, " 
+"  odrtotalprice, " 
+"  odrtotalpoint, " 
+"  deliverstatus , " 
+"  fk_userid " 
+"FROM " 
+"  (SELECT A.odrcode, " 
+"    A.fk_userid, " 
+"    A.odrtotalprice, " 
+"    A.odrtotalpoint , " 
+"    A.odrdate, " 
+"    B.odrprice, " 
+"    B.deliverstatus, " 
+"    B.fk_pnum, " 
+"    B.oqty, " 
+"    C.point, " 
+"    C.price , " 
+"    C.pimage1, " 
+"    C.pname " 
+"  FROM jsp_order A " 
+"  JOIN jsp_order_detail B " 
+"  ON A.odrcode = B.fk_odrcode " 
+"  JOIN jsp_product C " 
+"  ON B.fk_pnum    = C.pnum " 
+"  WHERE fk_userid = 'eom' " 
+"  )V"




+"SELECT COUNT(*)AS CNT " 
+"FROM jsp_order A " 
+"JOIN jsp_order_detail B " 
+"ON A.odrcode = B.fk_odrcode " 
+"JOIN jsp_product C " 
+"ON B.fk_pnum    = C.pnum " 
+"WHERE fk_userid = 'eom'"




select rno,odrcode,odrdate,pimage1, fk_pnum, pname, price, odrprice,
       point, oqty, odrtotalprice, odrtotalpoint, deliverstatus
       ,fk_userid,year
from
(
select rownum as RNO, A.odrcode, A.fk_userid, A.odrtotalprice, A.odrtotalpoint
      ,A.odrdate, B.odrprice, B.deliverstatus, B.fk_pnum, B.oqty, C.point, C.price
      ,C.pimage1, C.pname,TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(to_char(A.odrdate,'yyyymmdd'))AS year
from jsp_order A join jsp_order_detail B
on A.odrcode = B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
where fk_userid = 'leess'
)V
where V.rno between 1 and 10



SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(to_char(odrdate,'yyyymmdd'))
from jsp_order



select rno,odrcode,odrdate,pimage1, fk_pnum, pname, price, odrprice,
       point, oqty, odrtotalprice, odrtotalpoint, deliverstatus
       ,fk_userid,year
from
(
select rownum as RNO, A.odrcode, A.fk_userid, A.odrtotalprice, A.odrtotalpoint
      ,A.odrdate, B.odrprice, B.deliverstatus, B.fk_pnum, B.oqty, C.point, C.price
      ,C.pimage1, C.pname,TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(to_char(A.odrdate,'yyyymmdd'))AS year
from jsp_order A join jsp_order_detail B
on A.odrcode = B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
)V
where V.rno between 1 and 12 and year = '1'

select*
from jsp_member

select *
from jsp_order A join jsp_member B
on A.fk_userid = B.userid
where odrcode = 's20183402-7'

+"SELECT * " 
+"FROM jsp_order A " 
+"JOIN jsp_member B " 
+"ON A.fk_userid = B.userid " 
+"WHERE odrcode  = 's20183402-7'"



 SELECT B.idx, B.name, B.userid, B.email, B.hp1, B.hp2, B.hp3, B.post1, B.post2, B.addr1,B.addr2 
 FROM jsp_order A  JOIN jsp_member B 
 ON A.fk_userid = B.userid 
 WHERE odrcode  = 's20183402-7'
 
+" SELECT B.idx, " 
+"  B.name, " 
+"  B.userid, " 
+"  B.email, " 
+"  B.hp1, " 
+"  B.hp2, " 
+"  B.hp3, " 
+"  B.post1, " 
+"  B.post2, " 
+"  B.addr1, " 
+"  B.addr2 " 
+"FROM jsp_order A " 
+"JOIN jsp_member B " 
+"ON A.fk_userid = B.userid " 
+"WHERE odrcode  = 's20183402-7'"


update jsp_order_detail set deliverstatus =2
where fk_odrcode||fk_pnum in('s20183402-75')

+"UPDATE jsp_order_detail SET deliverstatus =2 WHERE fk_odrcode||fk_pnum IN()"

rollback;




select rno,odrcode,odrdate,pimage1, fk_pnum, pname, price, odrprice,
       point, oqty, odrtotalprice, odrtotalpoint, deliverstatus 
       ,fk_userid,overday
from
(
select rownum as RNO, A.odrcode, A.fk_userid, A.odrtotalprice, A.odrtotalpoint
      ,A.odrdate, B.odrprice, B.deliverstatus, B.fk_pnum, B.oqty, C.point, C.price
      ,C.pimage1, C.pname,TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(to_char(A.odrdate,'yyyymmdd'))AS overday
from jsp_order A join jsp_order_detail B
on A.odrcode = B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
)V
where V.rno between 1 and 12 and overday < '365'



 SELECT COUNT(*)AS CNT 
 from(
 select TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(to_char(A.odrdate,'yyyymmdd'))AS overday, B.fk_pnum, A.fk_userid
 FROM jsp_order A  JOIN jsp_order_detail B 
 ON A.odrcode = B.fk_odrcode )V
 JOIN jsp_product C 
 ON V.fk_pnum    = C.pnum 
 where overday<'365' and fk_userid ='eom'
 
  +"SELECT COUNT(*)AS CNT " 
+"FROM " 
+"  (SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(TO_CHAR(A.odrdate,'yyyymmdd'))AS overday, " 
+"    B.fk_pnum, " 
+"    A.fk_userid " 
+"  FROM jsp_order A " 
+"  JOIN jsp_order_detail B " 
+"  ON A.odrcode = B.fk_odrcode " 
+"  )V " 
+"JOIN jsp_product C " 
+"ON V.fk_pnum  = C.pnum " 
+"WHERE overday <'365' " 
+"AND fk_userid ='eom'"


create table tbl_images
(userid varchar2(20) not null
,name varchar2(20) not null
,img varchar2(50) not null
,constraint  PK_tbl_images_userid primary key(userid));

insert into tbl_images(userid,name, img)
values('iyou','아이유','iyou.jpg');

insert into tbl_images(userid,name, img)
values('kimth','김태희','kimth.jpg');

insert into tbl_images(userid,name, img)
values('parkby','박보영','parkby.jpg');

commit;

select *
from tbl_images

create table tbl_ajaxnews
(seqtitleno   number not null
,title        varchar2(200) not null
,registerday  date default sysdate not null
,constraint PK_tbl_ajaxnews_seqtitleno primary key(seqtitleno)
);

create sequence seq_tbl_ajaxnews_seqtitleno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '''남달라'' 박성현 LPGA 투어 텍사스 클래식 우승, 시즌 첫 승' );
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '뼈아픈 연패-전패, 아직 한번도 못 이겼다고?' );
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '전설들과 어깨 나란히 한 김해림 "4연패도 노려봐야죠"');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '삼성·현대차 들쑤신 엘리엇, 이번엔 伊 최대통신사 삼켰다');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '"야구장, 어떤 음악으로 채우나" 응원단장들도 괴롭다');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '"공부 후 10분의 휴식, 기억력 높인다"');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '현대차, 쏘나타 ''익스트림 셀렉션'' 트림 출시… 사양과 가격은?');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '날씨무더위 계속…곳곳 강한 소나기');

commit;

select *
from tbl_ajaxnews;

update tbl_ajaxnews set registerday = registerday - 1
where seqtitleno in (1,2);

commit;

select seqtitleno
     , case when length(title) > 22 then substr(title, 1, 20)||'..'
       else title end as title
     , to_char(registerday, 'yyyy-mm-dd') as registerday
from tbl_ajaxnews
where to_char(registerday, 'yyyy-mm-dd') = to_char(sysdate, 'yyyy-mm-dd');


insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '서울에 첫 폭염경보…수도권과 영서도 경보로 강화');
commit;

insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '코스피, 외국인·기관 동반 매도에 1,990선 ''털썩''');
commit;

create table tbl_books
(subject        varchar2(200) not null
,title          varchar2(200) not null
,author         varchar2(200) not null
,registerday    date default sysdate
);

insert into tbl_books(subject, title, author) values('소설','해질무렵','황석영');
insert into tbl_books(subject, title, author) values('소설','마션','앤디위어');
insert into tbl_books(subject, title, author) values('소설','어린왕자','생텍쥐페리');
insert into tbl_books(subject, title, author) values('소설','당신','박범신');
insert into tbl_books(subject, title, author) values('소설','삼국지','이문열');
insert into tbl_books(subject, title, author) values('프로그래밍','ORACLE','이순신');
insert into tbl_books(subject, title, author) values('프로그래밍','자바','안중근');
insert into tbl_books(subject, title, author) values('프로그래밍','JSP Servlet','똘똘이');
insert into tbl_books(subject, title, author) values('프로그래밍','스프링','윤봉길');

commit;

select *
from tbl_books;

select subject, title, author, to_char(registerday, 'yyyy-mm-dd') as registerday 
from tbl_books
where to_date( to_char(sysdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') - to_date( to_char(registerday, 'yyyy-mm-dd'), 'yyyy-mm-dd') <= 7 
order by subject asc, registerday desc;

insert into tbl_books(subject, title, author) values('프로그래밍','영광자바','정영광');
commit;

delete from tbl_books
where title='영광자바'


update tbl_books set registerday = to_date('2018-04-01','yyyy-mm-dd')
where title in('마션','당신','자바','스프링');

commit;

update tbl_ajaxnews set registerday = registerday + 1;

commit;

-----------------------***통계차트 나의 주문 성향***-------------------------------
select *
from jsp_order;

select*
from jsp_order_detail;

select*
from jsp_product;

select*
from jsp_category;

select D.cname, B.oqty * B.odrPrice AS JUMUNPRICE
from jsp_order A join jsp_order_detail B
on A.odrcode =B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
join jsp_category D
on C.pcategory_fk = D.code
where A.fk_userid = 'leess';


select V.cname, sum(JUMUNPRICE) AS SUMJUMUNPRICE
from
(
select D.cname, B.oqty * B.odrPrice AS JUMUNPRICE
from jsp_order A join jsp_order_detail B
on A.odrcode =B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
join jsp_category D
on C.pcategory_fk = D.code
where A.fk_userid = 'leess'
)V
group by V.cname;

select 513000+4650000+244000
from dual;--5407000

select SUM( B.oqty * B.odrPrice) AS TOTAL
from jsp_order A join jsp_order_detail B
on A.odrcode =B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
join jsp_category D
on C.pcategory_fk = D.code
where A.fk_userid = 'leess';--5407000


select V.cname, sum(JUMUNPRICE) AS SUMJUMUNPRICE,round (sum(JUMUNPRICE)/()*100,1)AS PERCENT
from
(
select D.cname, B.oqty * B.odrPrice AS JUMUNPRICE
from jsp_order A join jsp_order_detail B
on A.odrcode =B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
join jsp_category D
on C.pcategory_fk = D.code
where A.fk_userid = 'leess'
)V
group by V.cname;


select V.cname, sum(JUMUNPRICE) AS SUMJUMUNPRICE
,round (sum(JUMUNPRICE)/(select SUM( B.oqty * B.odrPrice)
                          from jsp_order A join jsp_order_detail B
                          on A.odrcode =B.fk_odrcode
                          join jsp_product C
                          on B.fk_pnum = C.pnum
                          join jsp_category D
                          on C.pcategory_fk = D.code
                          where A.fk_userid = 'leess')*100,1)AS PERCENT
from
(
select D.cname, B.oqty * B.odrPrice AS JUMUNPRICE
from jsp_order A join jsp_order_detail B
on A.odrcode =B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
join jsp_category D
on C.pcategory_fk = D.code
where A.fk_userid = 'leess'
)V
group by V.cname
order by percent desc;



+"SELECT V.cname, " 
+"  SUM(JUMUNPRICE) AS SUMJUMUNPRICE , " 
+"  ROUND (SUM(JUMUNPRICE)/ " 
+"  (SELECT SUM( B.oqty   * B.odrPrice) " 
+"  FROM jsp_order A " 
+"  JOIN jsp_order_detail B " 
+"  ON A.odrcode =B.fk_odrcode " 
+"  JOIN jsp_product C " 
+"  ON B.fk_pnum = C.pnum " 
+"  JOIN jsp_category D " 
+"  ON C.pcategory_fk = D.code " 
+"  WHERE A.fk_userid = 'leess' " 
+"  )*100,1)AS PERCENT " 
+"FROM " 
+"  (SELECT D.cname, " 
+"    B.oqty * B.odrPrice AS JUMUNPRICE " 
+"  FROM jsp_order A " 
+"  JOIN jsp_order_detail B " 
+"  ON A.odrcode =B.fk_odrcode " 
+"  JOIN jsp_product C " 
+"  ON B.fk_pnum = C.pnum " 
+"  JOIN jsp_category D " 
+"  ON C.pcategory_fk = D.code " 
+"  WHERE A.fk_userid = 'leess' " 
+"  )V " 
+"GROUP BY V.cname " 
+"ORDER BY percent DESC;"

------------------***통계차트 -- 카테고리별 월별 판매 수량 총계****-------------------
select*
from jsp_order
order by odrdate desc

update jsp_order set odrdate = add_months(odrdate,-1)
where odrcode in('s20180902-15','s20180402-14','s20184402-13','s20181002-12');

commit;


select D.cname,
      sum(decode( to_char(A.odrdate,'mm'),'01',B.oqty,0))AS JAN,
       sum(decode( to_char(A.odrdate,'mm'),'02',B.oqty,0))AS FEB,
       sum(decode( to_char(A.odrdate,'mm'),'03',B.oqty,0))AS MAR,
       sum(decode( to_char(A.odrdate,'mm'),'04',B.oqty,0))AS APR,
       sum(decode( to_char(A.odrdate,'mm'),'05',B.oqty,0))AS MAY,
       sum(decode( to_char(A.odrdate,'mm'),'06',B.oqty,0))AS JUN,
       sum(decode( to_char(A.odrdate,'mm'),'07',B.oqty,0))AS JUL,
       sum(decode( to_char(A.odrdate,'mm'),'08',B.oqty,0))AS AUG,
       sum(decode( to_char(A.odrdate,'mm'),'09',B.oqty,0))AS SEP,
       sum(decode( to_char(A.odrdate,'mm'),'10',B.oqty,0))AS OCT,
      sum(decode( to_char(A.odrdate,'mm'),'11',B.oqty,0))AS NOV,
       sum(decode( to_char(A.odrdate,'mm'),'12',B.oqty,0))AS DEC
      
from jsp_order A join jsp_order_detail B
on A.odrcode =B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
join jsp_category D
on C.pcategory_fk = D.code
where to_char(A.odrdate,'yyyy') = to_char(sysdate,'yyyy')
group by D.cname;


+"SELECT D.cname, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'01',B.oqty,0))AS JAN, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'02',B.oqty,0))AS FEB, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'03',B.oqty,0))AS MAR, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'04',B.oqty,0))AS APR, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'05',B.oqty,0))AS MAY, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'06',B.oqty,0))AS JUN, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'07',B.oqty,0))AS JUL, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'08',B.oqty,0))AS AUG, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'09',B.oqty,0))AS SEP, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'10',B.oqty,0))AS OCT, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'11',B.oqty,0))AS NOV, " 
+"  SUM(DECODE( TO_CHAR(A.odrdate,'mm'),'12',B.oqty,0))AS DEC " 
+"FROM jsp_order A " 
+"JOIN jsp_order_detail B " 
+"ON A.odrcode =B.fk_odrcode " 
+"JOIN jsp_product C " 
+"ON B.fk_pnum = C.pnum " 
+"JOIN jsp_category D " 
+"ON C.pcategory_fk               = D.code " 
+"WHERE TO_CHAR(A.odrdate,'yyyy') = TO_CHAR(sysdate,'yyyy') " 
+"GROUP BY D.cname"



---- *** 특정제품의 좋아요, 싫어요 Ajax 로 구현하기 *** ----

desc jsp_member;
desc jsp_product;

create table jsp_like
(userid varchar2(20) not null,
 pnum number(8) not null,
 constraint PK_jsp_like primary key(userid, pnum), -- 복합 primary key
 constraint FK_jsp_like_userid foreign key(userid)
                               references jsp_member(userid),
 constraint FK_jsp_like_pnum foreign key(pnum)
                              references jsp_product(pnum)
);
 
 
create table jsp_dislike
(userid varchar2(20) not null,
 pnum number(8) not null,
 constraint PK_jsp_dislike primary key(userid, pnum), -- 복합 primary key
 constraint FK_jsp_dislike_userid foreign key(userid)
                               references jsp_member(userid),
 constraint FK_jsp_dislike_pnum foreign key(pnum)
                              references jsp_product(pnum)
);

--- *** 특정제품(예: 제품번호 3)에 대해 좋아요 갯수와 싫어요 갯수를 조회해 온다.
select (select count(*)
        from jsp_like
        where pnum = 3) AS LIKECNT,
        (select count(*)
        from jsp_dislike
        where pnum = 3) AS DISLIKECNT
from dual;

select *
from jsp_like

select *
from jsp_dislike

select *
from jsp_product A left outer join jsp_like B
on A.pnum = B.pnum
left outer join jsp_dislike C
on A.pnum = C.pnum


-- 제품별 좋아요 싫어요 통계 -
select A.pname,
       sum(case nvl(B.userid, '9999') when '9999' then 0 else 1 end) AS likecnt,
       sum(case nvl(C.userid, '9999') when '9999' then 0 else 1 end) AS dislikecnt
from jsp_product A left outer join jsp_like B
on A.pnum = B.pnum
left outer join jsp_dislike C
on A.pnum = C.pnum
group by A.pname


---------- *** ajax 를 사용하여 자동글 완성하기 *** ----------
create table jsp_wordsearchtest
(seq number not null,
 title varchar2(100) not null,
 content varchar2(4000) not null,
 constraint PK_jsp_wordsearchtest_seq primary key(seq)
);

create sequence seq_wordsearchtest
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into jsp_wordsearchtest(seq, title, content)
values(seq_wordsearchtest.nextval, 'AJAX' ,'Ajax(Asynchronous JavaScript and XML)');

insert into jsp_wordsearchtest(seq, title, content)
values(seq_wordsearchtest.nextval, 'ajax 프로그래밍', '비동기식 자바스크립트 XML 프로그래밍');

insert into jsp_wordsearchtest(seq, title, content)
values(seq_wordsearchtest.nextval, 'Java 프로그래밍', '자바가 재미있나요?');

insert into jsp_wordsearchtest(seq, title, content)
values(seq_wordsearchtest.nextval, 'JAVA Programing', '자바는 재미있습니다.');

insert into jsp_wordsearchtest(seq, title, content)
values(seq_wordsearchtest.nextval, '김시온 프로그래머', '훌륭한 프로그래머 입니다.');

insert into jsp_wordsearchtest(seq, title, content)
values(seq_wordsearchtest.nextval, '김시온 바둑기사', '알파고를 떄려눕히는 천재바둑기사');

insert into jsp_wordsearchtest(seq, title, content)
values(seq_wordsearchtest.nextval, '시온성 교회', '서울에 위치한 좋은교회');

insert into jsp_wordsearchtest(seq, title, content)
values(seq_wordsearchtest.nextval, '초보 java programing 완성', '자바를 처음 접한 분들에게 적합한 과정입니다.');

insert into jsp_wordsearchtest(seq, title, content)
values(seq_wordsearchtest.nextval, '내 친구 김시온 프로그래머 소개', '내 친구 김시온은 프로그래밍을 아주 잘합니다.');

commit;

select *
from jsp_wordsearchtest;

------ *** 좋아요, 싫어요 전체통계구하기 샘플 데이터 *** ------
 create table test_like
 (userid      varchar2(20) not null
 ,pnum        varchar2(20) not null
 ,constraint PK_test_like primary key(userid, pnum)
 );

 create table test_dislike
 (userid      varchar2(20) not null
 ,pnum        varchar2(20) not null
 ,constraint PK_test_dislike primary key(userid, pnum)
 );

 insert into test_like(userid, pnum) values('hansk', 'swk');
 insert into test_like(userid, pnum) values('dusk', 'swk');
 insert into test_like(userid, pnum) values('sesk', 'swk');
 insert into test_like(userid, pnum) values('hansk', 'kjk');
 insert into test_like(userid, pnum) values('dusk', 'kjk');
 insert into test_like(userid, pnum) values('hansk', 'ggk');

 insert into test_dislike(userid, pnum) values('dusk', 'ggk');
 insert into test_dislike(userid, pnum) values('sesk', 'ggk');
 insert into test_dislike(userid, pnum) values('nesk', 'kjk');
 insert into test_dislike(userid, pnum) values('hansk', 'bbr');
 insert into test_dislike(userid, pnum) values('dusk', 'bbr');
 insert into test_dislike(userid, pnum) values('sesk', 'bbr');

 commit;

 select 'like', userid, pnum
 from test_like
 union
 select 'dislike', userid, pnum
 from test_dislike;


 select pnum, likedislike, count(*) as cnt
 from 
 (
   select 'like' as likedislike, userid, pnum
   from test_like
   union
   select 'dislike', userid, pnum
   from test_dislike
 ) V
 group by pnum, likedislike
 order by pnum, likedislike; 


 create or replace view view_test_likedislike
 as
 select pnum, likedislike, count(*) as cnt
 from 
 (
   select 'like' as likedislike, userid, pnum
   from test_like
   union
   select 'dislike', userid, pnum
   from test_dislike
 ) V
 group by pnum, likedislike
 order by pnum, likedislike;

 select *
 from view_test_likedislike;

 create or replace view view_test_likedislike_total
 as
 select pnum, sum(cnt) as totalcnt
 from view_test_likedislike 
 group by pnum;

 select *
 from view_test_likedislike_total;

 select *
 from view_test_likedislike;

 select A.pnum, A.likedislike, round(A.cnt/B.totalcnt*100,1) as PERCENT
 from view_test_likedislike A join view_test_likedislike_total B
 on A.pnum = B.pnum
 order by pnum, likedislike;

select *
from jsp_product

select *
from
(
select row_number() over(order by pnum desc)AS rno, pnum, pname
      , pcategory_fk, pcompany, pimage1, pimage2, pqty, price
      , saleprice, pspec, pcontent, point, pinputdate
from jsp_product
where pspec ='HIT'
)V
where rno between 1 and 3;


+"SELECT * " 
+"FROM " 
+"  (SELECT row_number() over(order by pnum DESC)AS rno, " 
+"    pnum, " 
+"    pname , " 
+"    pcategory_fk, " 
+"    pcompany, " 
+"    pimage1, " 
+"    pimage2, " 
+"    pqty, " 
+"    price , " 
+"    saleprice, " 
+"    pspec, " 
+"    pcontent, " 
+"    point, " 
+"    pinputdate " 
+"  FROM jsp_product " 
+"  WHERE pspec ='HIT' " 
+"  )V " 
+"WHERE rno BETWEEN 1 AND 3"

update jsp_product set pspec = 'HIT';


commit;


 ------------------------------------------------------------------------------
      --- Google Map API 관련 ---

create table jsp_storemap
(storeno     number  not null  -- 점포no 
,storeName   varchar2(100)     -- 점포명
,latitude    number            -- 위도
,longitude   number            -- 경도
,zindex      number            -- 우선순위(z-index) 점포no로 사용됨.
,tel         varchar2(20)      -- 전화번호
,addr        varchar2(200)     -- 주소
,transport   varchar2(1000)    -- 오시는길 
,constraint PK_jsp_storemap_storeno primary key(storeno)
);

create sequence seq_storemap
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into jsp_storemap(storeno, storeName, latitude, longitude, zindex, tel, addr, transport) 
values(seq_storemap.nextval, 'KH 종로점', 37.567957, 126.983134, seq_storemap.currval
      ,'02-1234-5678', '서울특별시 중구 남대문로 120 대일빌딩 2F, 3F', '지하철 2호선 을지로입구역 3번출구 100M / 1호선 종각역 4번, 5번 출구 200M');

insert into jsp_storemap(storeno, storeName, latitude, longitude, zindex, tel, addr, transport)  
values(seq_storemap.nextval, '롯데백화점 본점', 37.564728, 126.981641, seq_storemap.currval
      ,'02-771-2500', '서울특별시 중구 소공동 남대문로 81', '지하철 2호선 을지로입구역 8번출구');

insert into jsp_storemap(storeno, storeName, latitude, longitude, zindex, tel, addr, transport)  
values(seq_storemap.nextval, '신세계백화점 본점', 37.560227, 126.980773, seq_storemap.currval
      ,'1588-1234', '서울특별시 중구 명동 소공로 63', '지하철 4호선 회현역 7번출구');

commit;

select storeno, storeName, latitude, longitude, zindex, tel, addr, transport 
from jsp_storemap
order by storeno;


create table jsp_storedetailImg
(seq         number not null    -- 일련번호
,fk_storeno  number not null    -- 점포no
,img         varchar2(500)      -- 매장이미지
,constraint PK_jsp_storedetailImg_seq primary key(seq)
,constraint FK_jsp_storedetailImg foreign key(fk_storeno)
                                  references jsp_storemap(storeno)
                                  on delete cascade
);

create sequence seq_storedetailImg
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 1, 'kh01.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 1, 'kh02.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 1, 'kh03.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 2, 'lotte01.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 2, 'lotte02.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 3, 'newworld01.png');
 
commit; 
 

select storeno, storeName, tel, addr, transport  
from jsp_storemap 
where storeno = 1;

select img
from jsp_storedetailImg
where fk_storeno = 1; 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

