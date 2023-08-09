/* question 1 */

CREATE OR REPLACE FUNCTION totalSpending(shopperid bb_basket.idshopper%type)
RETURN bb_basket.subtotal%type IS
  total bb_basket.subtotal%type;
BEGIN
  SELECT SUM(subtotal) 
  INTO total 
  FROM bb_basket
  WHERE idshopper = shopperid 
  GROUP BY idshopper;

  RETURN total;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/

SELECT firstname, 
       lastname, 
       totalSpending(idshopper)
FROM bb_shopper;

/* question 2 */

create or replace procedure status_ship_sp
 (p_id in bb_basketstatus.idbasket%type,
 p_date in bb_basketstatus.dtstage%type,
 p_shipper in bb_basketstatus.shipper%type,
 p_track in bb_basketstatus.shippingnum%type)
 is
begin
 insert into bb_basketstatus
 (idstatus, idbasket, idstage, dtstage, shipper, shippingnum)
 values (bb_status_seq.nextval, p_id, 3, p_date, p_shipper, p_track);
 commit;
end;
/
execute status_ship_sp(3, '20-FEB-07', 'UPS', 'zw2384yxk4957');
/
select idstatus, idbasket,idstage,
 dtstage, shipper, shippingnum
from bb_basketstatus;

/* question 3 */

create or replace function orderupdate(productid bb_basketitem.idproduct%type, 
unitprice bb_basketitem.price%type, 
quantities bb_basketitem.quantity%type, 
basketid bb_basketitem.idbasket%type, 
basketitemid bb_basketitem.idbasketitem%type)
return number
is
begin
insert into bb_basketitem (idproduct, price, quantity, idbasket, idbasketitem)
values(productid, unitprice, quantities, basketid, basketitemid);
dbms_output.put_line('Success');
return 1;
exception when OTHERS then dbms_output.put_line(' NO Success');
end orderupdate;
/
declare
var1 number;
begin
var1:=orderupdate(6,1,2,3,48);
end;
/
select * from bb_basketitem;

/* question 4 */
CREATE OR REPLACE FUNCTION total_calculator(projectid dd_pledge.idproj%type)
RETURN dd_pledge.pledgeamt%type IS
  total dd_pledge.pledgeamt%type;
BEGIN
  SELECT SUM(pledgeamt) 
  INTO total 
  FROM dd_pledge
  WHERE idproj = projectid
  GROUP BY idproj;
  
  RETURN total;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/

SELECT TO_CHAR(total_calculator(d.idproj),'L9G99') AS TotalAmount, 
       d.idproj, 
       d.projname 
FROM dd_project d 
GROUP BY d.idproj, d.projname;

/* question 5 */

create or replace procedure basket_add_sp
 (p_id in bb_basketitem.idbasket%type,
 p_prod in bb_basketitem.idproduct%type,
 p_price in bb_basketitem.price%type,
 p_qnty in bb_basketitem.quantity%type)
 is
 
begin -- insert into table
 insert into bb_basketitem (idbasketitem, idbasket,
 idproduct, price, quantity)
 values (bb_idbasketitem_seq.nextval, p_id, p_prod,
 p_price, p_qnty);
 commit;
end;
/
Column description heading 'description' format A50;
select idproduct, description from bb_product;
/

