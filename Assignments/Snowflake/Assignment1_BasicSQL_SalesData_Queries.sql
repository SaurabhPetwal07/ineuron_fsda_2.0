CREATE OR REPLACE TABLE SBP_SALES 
(
    order_id VARCHAR(30),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(40),
    customer_name VARCHAR(40),
    segment VARCHAR(40),
    state VARCHAR2(50),
    country	VARCHAR(50),
    market VARCHAR(30),
    region VARCHAR(40),
    product_id VARCHAR(40),
    category VARCHAR(40),
    sub_category VARCHAR(40),
    product_name VARCHAR(400),
    sales NUMBER(10,2),
    quantity NUMBER(10,2),
    discount NUMBER(10,2),
    profit NUMBER(10,2),
    shipping_cost NUMBER(10,2),
    order_priority VARCHAR(20),
    year VARCHAR(10)  
);

DESCRIBE TABLE SBP_SALES;

----checking table---

SELECT * FROM SBP_SALES LIMIT 10;

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1 .SET PRIMARY KEY--

ALTER TABLE SBP_SALES 
ADD PRIMARY KEY (ORDER_ID);

DESCRIBE TABLE SBP_SALES;

----------------------------------------------------------------------------------------------------------------------------------------------------------
--2. CHECK THE ORDER DATE AND SHIP DATE TYPE AND THINK IN WHICH DATA TYPE YOU HAVE TO CHANGE--

/* to change the Datatype from "VARCHAR" to "DATE", create an alias/ replica of the original table and set the date columns i.e "ORDER_DATE" and "SHIP_DATE"
to DATE datatype*/

---method 1

CREATE OR REPLACE TABLE SBP_SALES_COPY AS

    SELECT 
            order_id,
            TO_DATE(order_date,'DD-MM-YYYY') AS ORDER_DATE, --CHANGED DATATYPE FROM VARCHAR TO DATE
            TO_DATE(ship_date, 'DD-MM-YYYY') AS SHIP_DATE,  --CHANGED DATATYPE FROM VARCHAR TO DATE
            ship_mode,
            customer_name,
            segment,
            state,
            country,
            market,
            region,
            product_id,
            category,
            sub_category,
            product_name,
            sales,
            quantity,
            discount,
            profit,
            shipping_cost,
            order_priority,
            year 
    from SBP_SALES;
    
-- CHECKING THE DATATYPE OF ORDER_DATE AND SHIP_DATE COLUMN
DESCRIBE TABLE SBP_SALES_COPY;

SELECT * FROM SBP_SALES_COPY;


---method 2
/* select all columns at once using * and columns 'SHIP_DATE' and 'ORDER_DATE' to create new using alias with date datatype and dropping original columns*/
CREATE OR REPLACE TABLE SBP_SALES_COPY1 AS

    SELECT *,
            TO_DATE(order_date,'DD-MM-YYYY') AS ORDER_DATE_1, --CHANGED DATATYPE FROM VARCHAR TO DATE
            TO_DATE(ship_date, 'DD-MM-YYYY') AS SHIP_DATE_1  --CHANGED DATATYPE FROM VARCHAR TO DATE
            
    from SBP_SALES;
   
/*dropping the original columns of VARCHAR datatypes*/   
ALTER TABLE SBP_SALES_COPY1 DROP COLUMN ORDER_DATE, SHIP_DATE; 

/*CHECKING THE DATATYPE OF ORDER_DATE_1 AND SHIP_DATE_1 COLUMN*/
DESCRIBE TABLE SBP_SALES_COPY1;

-----------------------------------------------------------------------------------------------------------------------------------------------------------
--3. EXTRACT THE LAST NUMBER AFTER THE - AND CREATE OTHER COLUMN AND UPDATE IT from ORDER_ID


/* creating a new blank column(without data) using ALTER command*/
ALTER TABLE SBP_SALES_COPY ADD COLUMN SPLITTED_ORDER_ID VARCHAR(10); 

/* adding 'data' as required to the new column 'SPLITTED_ORDER_ID' using UPDATE command and SPLIT_PART function*/
UPDATE SBP_SALES_COPY SET  SPLITTED_ORDER_ID = SPLIT_PART(ORDER_ID, '-' , 3);

/* checking the updated column ('SPLITTED_ORDER_ID') values in table*/
SELECT * FROM SBP_SALES_COPY LIMIT 10;

-----------------------------------------------------------------------------------------------------------------------------------------------------------
--4. FLAG ,IF DISCOUNT IS GREATER THEN 0 THEN  YES ELSE FALSE AND PUT IT IN NEW COLUMN FROM EVERY ORDER ID.

SELECT ORDER_ID, 
       DISCOUNT,
                CASE 
                     WHEN DISCOUNT > 0 THEN 'YES'
                     ELSE 'FALSE'
                END AS DISCOUNT_FLAG     
                
FROM SBP_SALES_COPY; 

-----------------------------------------------------------------------------------------------------------------------------------------------------------

--5.  FIND OUT THE FINAL PROFIT AND PUT IT IN COLUMN FOR EVERY ORDER ID.

/*Profit column is already available in given dataset table*/


-----------------------------------------------------------------------------------------------------------------------------------------------------------

--6.  FIND OUT HOW MUCH DAYS TAKEN FOR EACH ORDER TO PROCESS FOR THE SHIPMENT FOR EVERY ORDER ID.

SELECT ORDER_ID,
       ORDER_DATE,
       SHIP_DATE,
       DATEDIFF(DAYS,ORDER_DATE, SHIP_DATE) AS SHIPMENT_PROCESSED_DAYS  
       
FROM SBP_SALES_COPY;
       
-----------------------------------------------------------------------------------------------------------------------------------------------------------

/* 
7. FLAG THE PROCESS DAY AS BY RATING IF IT TAKES 
   LESS OR EQUAL 3  DAYS MAKE 5,
   LESS OR EQUAL THAN 6 DAYS BUT MORE THAN 3 MAKE 4,
   LESS THAN 10 BUT MORE THAN 6 MAKE 3,
   MORE THAN 10 MAKE IT 2 FOR EVERY ORDER ID.
   
*/


SELECT ORDER_ID,
       ORDER_DATE,
       SHIP_DATE,
       DATEDIFF(DAYS,ORDER_DATE, SHIP_DATE) AS SHIPMENT_PROCESSED_DAYS,
              CASE 
                   WHEN SHIPMENT_PROCESSED_DAYS <= 3 THEN 5
                   WHEN SHIPMENT_PROCESSED_DAYS > 3 AND SHIPMENT_PROCESSED_DAYS <=6 THEN 4
                   WHEN SHIPMENT_PROCESSED_DAYS > 6 AND SHIPMENT_PROCESSED_DAYS <=10 THEN 3
                   ELSE 2
              END AS RATING_FLAG       
       
FROM SBP_SALES_COPY;
       