/*1.  [5 marks] Use a correlated subquery to determine which criminals have had at least one probation period assigned. */

SELECT * 
FROM criminals 
WHERE EXISTS (
    SELECT 1
    FROM crimes
    WHERE crimes.criminal_id = criminals.criminal_id AND criminals.p_Status = 'Y'
)

/* 2. [5 marks] Brewbean's application page was modified so that an employee can enter a customer number that would cause an error.
An exception handler needs to be added to the block that displays the message 
"Invalid Shopper Id" onscreen. Use an initialized variable named lv_shopper_name to provide a shopper id. Test the block with shopper id 99.*/

DECLARE
   rec_shopper NUMBER ;
   lv_shopper_num NUMBER := 99;
   ex_invalid_id EXCEPTION;
BEGIN
   SELECT count(*)
      INTO rec_shopper
      FROM bb_shopper
      WHERE idShopper = lv_shopper_num;

   IF rec_shopper = 0 THEN
      RAISE ex_invalid_id;
   END IF;

EXCEPTION
   WHEN ex_invalid_id THEN
      dbms_output.put_line('Invalid Shopper ID');
   WHEN OTHERS THEN
      dbms_output.put_line('Other possible error!');
END;

/* 3. [5 marks] Brewbean's wants to send a promotion via email to shoppers.
A shopper who has purchased more than $50 at the site receives a $5 coupon for his or her next purchase over $25. 
A shopper who has spent more than $100 receives a free shopping coupon.*/
DECLARE
   CURSOR cur_shopper IS
      SELECT a.idShopper, a.promo, b.total
      FROM bb_shopper a
      JOIN (
         SELECT b.idShopper, SUM(bi.quantity * bi.price) total
         FROM bb_basketitem bi
         JOIN bb_basket b ON bi.idBasket = b.idBasket
         GROUP BY b.idShopper
      ) b ON a.idShopper = b.idShopper
      FOR UPDATE OF a.promo NOWAIT;

   lv_promo_txt CHAR(1);
   
BEGIN
   FOR rec_shopper IN cur_shopper LOOP
      lv_promo_txt := 'X';
      
      IF rec_shopper.total > 100 THEN
         lv_promo_txt := 'A';
      ELSIF rec_shopper.total BETWEEN 50 AND 99 THEN
         lv_promo_txt := 'B';
      END IF;
      
      IF lv_promo_txt <> 'X' THEN
         UPDATE bb_shopper
         SET promo = lv_promo_txt
         WHERE CURRENT OF cur_shopper;
      END IF;
   END LOOP;

   COMMIT;
   
END;
/

SELECT s.idShopper, s.promo, SUM(bi.quantity * bi.price)
FROM bb_shopper s
JOIN bb_basket b ON s.idShopper = b.idShopper
JOIN bb_basketitem bi ON b.idBasket = bi.idBasket
GROUP BY s.idShopper, s.promo;