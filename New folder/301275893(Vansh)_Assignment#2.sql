/*1.	[3 marks] The Brewbean’s application contains a page displaying order summary information, including IDBASKET, SUBTOTAL, SHIPPING, TAX and TOTAL
columns from BB_BASKET table. Create a PL/SQL block with scalar variables to retrieve this data and then display it. An initialized variable should
provide the IDBASKET value. Test the block using any existing basket ID*/ 
DECLARE
  N_BASKET NUMBER := 9;
  
  BASKET BB_BASKET.IDBASKET%TYPE;
  SUB_TOTAL BB_BASKET.SUBTOTAL%TYPE;
  SHIPPING_COST BB_BASKET.SHIPPING%TYPE;
  TAX_AMOUNT BB_BASKET.TAX%TYPE;
  TOTAL_AMOUNT BB_BASKET.TOTAL%TYPE;

BEGIN
  SELECT IDBASKET, SUBTOTAL, SHIPPING, TAX, TOTAL 
  INTO BASKET, SUB_TOTAL, SHIPPING_COST, TAX_AMOUNT, TOTAL_AMOUNT
  FROM BB_BASKET 
  WHERE IDBASKET = N_BASKET;
  
  DBMS_OUTPUT.PUT_LINE(
    'BASKET NO. ' || BASKET || ' HAS A SUBTOTAL OF ' || TO_CHAR(SUB_TOTAL, '$99.99')
    || ', SHIPPING IS ' || TO_CHAR(SHIPPING_COST, '$99.99') || ',' || CHR(10) 
    || 'TAX IS ' || TO_CHAR(TAX_AMOUNT, '$99.99') 
    || ', AND THE TOTAL IS ' || TO_CHAR(TOTAL_AMOUNT, '$99.99') || '.'
  );
END;


/* 2. An organization has committed to matching pledge amounts based on the donor type and pledge amount.
Donor types include I (for Individual), B (for Business organization), and G (for Grant funds). The matching percentage is shown below:*/


SET SERVEROUTPUT ON
DECLARE
DONOR_TYPE CHAR(1):= 'B';
PLEDGE_AMT NUMBER(10):=500;
MATCHING_AMT NUMBER(10):= 0;
BEGIN
IF DONOR_TYPE = 'I' THEN
IF PLEDGE_AMT >=100 AND PLEDGE_AMT <= 299 THEN
 MATCHING_AMT := PLEDGE_AMT * 0.5;
 /* CALCULATING THE MATCHING AMOUNT */
 ELSIF PLEDGE_AMT >= 300 AND PLEDGE_AMT <= 499 THEN
 MATCHING_AMT := PLEDGE_AMT * 0.4;
 ELSIF PLEDGE_AMT >= 500 THEN
 MATCHING_AMT := PLEDGE_AMT * 0.3;
 END IF;

 ELSIF DONOR_TYPE = 'B' THEN
 IF PLEDGE_AMT >=100 AND PLEDGE_AMT <= 499 THEN
 MATCHING_AMT := PLEDGE_AMT * 0.4;
 ELSIF PLEDGE_AMT >= 500 AND PLEDGE_AMT <= 999 THEN
 MATCHING_AMT := PLEDGE_AMT * 0.2;
 ELSIF PLEDGE_AMT >= 1000 THEN
 MATCHING_AMT := PLEDGE_AMT * 0.1;
 END IF;

 ELSIF DONOR_TYPE = 'G' THEN
 IF PLEDGE_AMT >= 100 THEN
 MATCHING_AMT := PLEDGE_AMT * 0.1;
 END IF;
END IF;
DBMS_OUTPUT.PUT_LINE('DONOR TYPE: ' || DONOR_TYPE || CHR(10) ||
'PLEDGE AMOUNT: ' || PLEDGE_AMT ||
 CHR(10) ||'MATCHING AMOUNT: ' || MATCHING_AMT);
END;

/* 3. Create a PL/SQL anonymous block to insert a new project in DoGood Donor database. Create and use a sequence to handle generating and
populating the project ID. The first number issue by the sequence should be 800, and no caching should be used. Use a record variable to handle the data to be added.
Data for the new row should be the following: project name is “Covid-19 relief fund”, start date:
Feb 1, 2023, end date: Jun 30, 2023, and fundraising goal is half million. Any columns not addressed in the data list are currently unknown */
CREATE SEQUENCE DD_PROJID_SEQ
 START WITH 600
 NOCACHE;

DECLARE
  TYPE PROJECT_INFO IS RECORD(
    PROJECT_NAME DD_PROJECT.PROJNAME%TYPE,
    PROJECT_START DD_PROJECT.PROJSTARTDATE%TYPE,
    PROJECT_END DD_PROJECT.PROJENDDATE%TYPE,
    FUNDRAISING_GOAL DD_PROJECT.PROJFUNDGOAL%TYPE
  );

  NEW_PROJECT PROJECT_INFO;
BEGIN
  NEW_PROJECT.PROJECT_NAME := 'Covid-19 relief fund';
  NEW_PROJECT.PROJECT_START := TO_DATE('01-FEB-2022', 'DD-MON-YYYY');
  NEW_PROJECT.PROJECT_END := TO_DATE('30-JUN-2022', 'DD-MON-YYYY');
  NEW_PROJECT.FUNDRAISING_GOAL := 500000;

  INSERT INTO DD_PROJECT(IDPROJ, PROJNAME, PROJSTARTDATE, PROJENDDATE, PROJFUNDGOAL)
  VALUES(DD_PROJID_SEQ.NEXTVAL, NEW_PROJECT.PROJECT_NAME, NEW_PROJECT.PROJECT_START, NEW_PROJECT.PROJECT_END, NEW_PROJECT.FUNDRAISING_GOAL);

  COMMIT;
END;

/*4.  Create anonymous block to retrieve and display data for all pledges made in a specified month. One row of output should be displayed for each pledge. More specifically, each row include:
a.	Pledge ID, donor ID, and pledge amount
b.	If the pledge is being paid in a lump sum, display “Lump Sum”
c.	If the pledge is being paid in monthly, display “Monthly ** ” followed by number of months for payment
d.	The list should be sorted to display all lump sum pledges first */

SET SERVEROUTPUT ON;

DECLARE
  CURSOR pledge_cursor IS
    SELECT 
      IDPLEDGE, 
      IDDONOR, 
      PLEDGEAMT, 
      CASE
        WHEN PAYMONTHS = 0 THEN 'Lump Sum.'
        ELSE 'Monthly - ' || PAYMONTHS
      END AS MONTHLY_PAYMENT
    FROM 
      DD_PLEDGE 
    WHERE 
      PLEDGEDATE BETWEEN TO_DATE('01-OCT-12', 'DD-MON-YY') AND TO_DATE('31-OCT-12', 'DD-MON-YY')
    ORDER BY 
      PAYMONTHS;

  pledge_record pledge_cursor%ROWTYPE;

BEGIN
  OPEN pledge_cursor;
  LOOP
    FETCH pledge_cursor INTO pledge_record;
    EXIT WHEN pledge_cursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      'Pledge ID: ' || pledge_record.IDPLEDGE ||
      ', Donor ID: ' || pledge_record.IDDONOR ||
      ', Pledge Amount: ' || TO_CHAR(pledge_record.PLEDGEAMT, '$9999.99') ||
      ', Monthly Payments: ' || pledge_record.MONTHLY_PAYMENT
    );
  END LOOP;
  CLOSE pledge_cursor;
END;
