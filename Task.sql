----Creating Database-----

CREATE DATABASE Task
USE Task
-------CREATE Table------

CREATE TABLE CustomerPurchases (customer_id VARCHAR (25), product_id VARCHAR (25), purchase_date DATE, price DECIMAL, payment_status VARCHAR (50),
PRIMARY KEY (customer_id, product_id))

CREATE TABLE Sales (sale_id VARCHAR (25) PRIMARY KEY, product_id VARCHAR (25), sale_date DATE, amount DECIMAL, promotion_id VARCHAR (25))


CREATE TABLE Promotions (promotion_id VARCHAR(25) PRIMARY KEY, [start_date] DATE, end_date DATE, discount_rate DECIMAL (5,2))


CREATE TABLE Categories (category_id VARCHAR(25) PRIMARY KEY, category_name VARCHAR(100))

CREATE TABLE Products (product_id VARCHAR(25) PRIMARY KEY, product_name VARCHAR(100), category_id VARCHAR(25),
FOREIGN KEY (category_id) REFERENCES Categories(category_id))




----INSERT DATA----



INSERT INTO CustomerPurchases(customer_id, product_id, purchase_date, price, payment_status)
VALUES ('C001', 'A', '2024-01-01', '50.00', 'Paid')
,('C001', 'B', '2024-01-05', '30.00', 'Paid')
,('C002', 'A', '2024-01-10', '50.00', 'Paid')
,('C003', 'C', '2024-01-15', '20.00', 'Paid')
,('C002', 'B', '2024-01-20', '30.00', 'Unpaid')
,('C004', 'A', '2024-01-25', '50.00', 'Paid')
,('C004', 'B', '2024-01-30', '30.00', 'Paid')


INSERT INTO Sales (sale_id, product_id, sale_date, amount, promotion_id)
VALUES
 ('S001', 'A', '2024-01-01', '45.00', 'P001')
,('S002', 'B', '2024-01-02', '25.00', 'P002')
,('S003', 'A', '2024-01-03', '50.00', 'None')
,('S004', 'C', '2024-01-04', '18.00', 'P001')
,('S005', 'B', '2024-01-05', '30.00', 'None')

INSERT INTO Promotions(promotion_id, [start_date], end_date, discount_rate)
VALUES
('P001', '2024-01-01', '2024-01-07', CAST(REPLACE('10%', '%', '') AS DECIMAL(5, 2)) / 100)
,('P002', '2024-01-02', '2024-01-08', CAST(REPLACE('15%', '%', '') AS DECIMAL(5, 2)) / 100)


INSERT INTO Categories (category_id, category_name)
VALUES
 ('C1', 'Electronics')
,('C2', 'Clothing')
,('C3', 'Home Appliances')



INSERT INTO Products (product_id, product_name, category_id)
 VALUES
 ('P001', 'Product A', 'C1')
,('P002', 'Product B', 'C2')
,('P003', 'Product C', 'C3')




---------------------------------------------------------------------------------

[Question no.1]

WITH CustomerPurchasesAB AS (
SELECT DISTINCT a.customer_id 
FROM CustomerPurchases a
INNER JOIN CustomerPurchases b ON b.customer_id = a.customer_id
WHERE a.product_id = 'A' and a.payment_status = 'paid'
AND b.product_id = 'B' and b.payment_status = 'paid'
)

SELECT
(SELECT  count(*) FROM CustomerPurchasesAB) * 100.0/
(SELECT COUNT(DISTINCT customer_id) FROM CustomerPurchases WHERE payment_status = 'paid') AS PERCENTAGE

----------Second Approach-------

SELECT DISTINCT a.customer_id 
INTO #TEMP FROM CustomerPurchases a
INNER JOIN CustomerPurchases b ON b.customer_id = a.customer_id
WHERE a.product_id = 'A' and a.payment_status = 'paid'
AND b.product_id = 'B' and b.payment_status = 'paid'

SELECT
(SELECT COUNT(*) FROM #TEMP) * 100.0/
(SELECT COUNT(DISTINCT customer_id) FROM CustomerPurchases WHERE payment_status = 'paid') AS PERCENTAGE
---------------------------------------------------------------------------------
[Question no.2]

SELECT 
    p.promotion_id,
    p.discount_rate,
    s.amount, 
    (p.discount_rate * s.amount) AS percentage,
    CASE 
        WHEN s.sale_date = p.start_date THEN 'FirstDay'
        WHEN s.sale_date = p.end_date THEN 'LastDay'
        ELSE 'MiddleDay'
    END AS sale_day
FROM 
    Promotions p
INNER JOIN 
    Sales s ON s.promotion_id = p.promotion_id
ORDER BY 
    p.promotion_id, 
    s.sale_date
---------------------------------------------------------

[Question no.3]

SELECT TOP 5  REPLACE(REPLACE(REPLACE(cp.product_id,'A','P001'),'B','P002'),'C','P003') AS productid,p.product_name,COUNT(*) AS PurchaseCount
from CustomerPurchases cp 
INNER JOIN Products p on p.product_id = REPLACE(REPLACE(REPLACE(cp.product_id,'A','P001'),'B','P002'),'C','P003')
WHERE cp.product_id = 'A'
AND cp.[payment_status] = 'paid'
GROUP BY cp.product_id, p.product_name


