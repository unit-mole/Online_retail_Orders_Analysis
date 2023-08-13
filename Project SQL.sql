show databases;

use orders;


# 1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) as per the following criteria 
# and sort them in descending order of category: 
# a. If the category is 2050, increase the price by 2000
# b. If the category is 2051, increase the price by 500 
# c. If the category is 2052, increase the price by 600. 

SELECT P.PRODUCT_CLASS_CODE, P.PRODUCT_ID, P.PRODUCT_DESC,
CASE P.PRODUCT_CLASS_CODE
WHEN 2050 THEN P.product_price + 2000
WHEN 2051 THEN P.product_price + 500
WHEN 2052 THEN P.product_price + 600
ELSE P.PRODUCT_PRICE
END PRODUCT_PRICE
FROM PRODUCT P
INNER JOIN PRODUCT_CLASS PC
ON P.PRODUCT_CLASS_CODE=PC.PRODUCT_CLASS_CODE
ORDER BY P.PRODUCT_CLASS_CODE desc;



# 2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show inventory status of products as
# For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, 
# show 'Enough stock's below as per their available quantity:
# a. For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock'
# b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' 
# c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'. 


show tables;

select * from address limit 2;
select * from carton limit 2;
select * from online_customer limit 2;
select * from order_header limit 2;
select * from order_items limit 2;
select * from product limit 10;
select * from product_class limit 20;
select * from shipper limit 2;

select distinct product_class_desc from product_class;

select product_class_code, product_class_desc from product_class
where product_class_desc in ('Electronics', 'Computer','Stationery','Clothes');
select pc.product_class_desc, p.product_id, p.product_desc, 
	case 
		when pc.product_class_code in (2050,2053)
			then 
				case 
					when p.product_quantity_avail <=10 then 'Low Stock'
                    when p.product_quantity_avail >=11 and p.product_quantity_avail<=30  then 'In Stock'
                    when p.product_quantity_avail >=31 then 'enough Stock'
                    when p.product_quantity_avail = 0 then 'Out of stock'
				end
		when pc.product_class_code in (2052,2056)
			then
				case 
					when p.product_quantity_avail <=20 then 'Low Stock'
                    when p.product_quantity_avail >=21 and p.product_quantity_avail<=80  then 'In Stock'
                    when p.product_quantity_avail >=81 then 'enough Stock'
                    when p.product_quantity_avail = 0 then 'Out of stock'
				end
		else
				case 
					when p.product_quantity_avail <=15 then 'Low Stock'
                    when p.product_quantity_avail >=16 and p.product_quantity_avail<=50  then 'In Stock'
                    when p.product_quantity_avail >=51 then 'enough Stock'
                    when p.product_quantity_avail = 0 then 'Out of stock'
				end			
	END AS 'Inventory Status'
from product p
join product_class pc
on p.product_class_code = pc.product_class_code;


# 3. Write a query to show the number of cities in all countries other than USA & MALAYSIA, with more than 1 city,
# in the descending order of CITIES. (2 rows)

SELECT COUNT(CITY) AS Count_of_Cities,
COUNTRY AS Country
FROM ADDRESS
GROUP BY COUNTRY
HAVING COUNTRY NOT IN ('USA','Malaysia') AND COUNT(CITY)
ORDER BY Count_of_Cities DESC
LIMIT 2;


# 4. Write a query to display the customer_id,customer full name ,city,pincode,and order details (order id, product class desc, 
# product desc, subtotal(product_quantity * product_price)) for orders shipped to cities whose pin codes do not have any 0s in them. 
# Sort the output on customer name and subtotal. (52 ROWS)


select * from online_customer limit 5;
select * from address limit 5;
select * from order_header limit 5;
select * from order_items limit 5;
select * from product limit 5;

select oc.customer_id, concat(oc.customer_fname,' ',oc.customer_lname) as customer_fullname, a.city, a.pincode, oh.order_id, p.product_desc, oi.product_quantity*p.product_price as total
from online_customer oc
join  address a
on a.address_id = oc.address_id 
join order_header oh
on oc.customer_id = oh.customer_id
join order_items oi
on oh.order_id = oi.order_id
join product p
on oi.product_id = p.product_id
where convert(a.pincode,char) not like '%0%'
	AND oh.ORDER_STATUS = 'Shipped';            



# 5. Write a Query to display product id,product description,totalquantity(sum(product quantity) for a given item 
# whose product id is 201 and which item has been bought along with it maximum no. of times. Display only one record which has the 
# maximum value for total quantity in this scenario.

SELECT OI.PRPDUCT_ID, P.PRODUCT_DESC, SUM(OI.PRODUCT_QUANTITY) AS Total_quantity
FROM ORDER_ITEMS OI
INNER JOIN PRODUCT P ON P.PRODUCT_ID = OI.PRPDUCT_ID 
WHERE OI.ORDER_ID IN 
(
SELECT DISTINCT
ORDER_ID 
FROM 
ORDER_ITEMS A
WHERE 
PRODUCT_ID = 201
)

AND OI.PRODUCT_ID <> 201
GROUP BY OI.PRODUCT_ID
ORDER BY Total_Quantity DESC
LIMIT 1;



# 6. Write a query to display the customer_id,customer name, email and order details (order id, product desc,product qty, 
# subtotal(product_quantity * product_price)) for all customers even if they have not ordered any item.

select * from online_customer limit 5;
select * from order_header limit 5;
select * from order_items limit 5;
select * from product limit 5;

select oc.customer_id, concat(oc.customer_fname,' ',oc.customer_lname) as customer_fullname, oc.customer_email, oh.order_id, p.product_desc, oi.product_quantity, 
	oi.product_quantity*p.product_price
from online_customer oc
left join order_header oh
on oc.customer_id = oh.customer_id
join order_items oi
on oh.order_id = oi.order_id
join product p
on oi.product_id = p.product_id;



# 7. Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton 
# (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) 
# for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box).


SELECT 
C.CARTON_ID, (C.LEN*C.WIDTH*C.HEIGHT) AS VOL
FROM ORDERS.CARTON C 
WHERE (C.LEN*C.WIDTH*C.HEIGHT) >= (
SELECT 
SUM(P.LEN*P.WIDTH*P.HEIGHT*PRODUCT_QUANTITY) AS VOL
FROM ORDERS.ORDER_HEADER OH
INNER JOIN ORDERS.ORDER_ITEMS OI ON OH.ORDER_ID = OI.ORDER_ID
INNER JOIN ORDERS.PRODUCT P ON OI.PRODUCT_ID = P.PRODUCT_ID
WHERE OH.ORDER_ID = 10006  ## FILTERED THE ONLY ADDRESS
)
ORDER BY (C.LEN*C.WIDTH*C.HEIGHT) ASC
LIMIT 1;




# 8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten 
# (i.e. total order qty) products with credit card or Net banking as the mode of payment per shipped order.

SELECT OC.CUSTOMER_ID AS Customer_ID,
CONCAT(CUSTOMER_FNAME,'',CUSTOMER_LNAME) AS Customer_FullName,
OH.ORDER_ID AS Order_ID,
SUM(OI.PRODUCT_QUANTITY) AS Total_Order_Quantity
FROM ONLINE_CUSTOMER OC
INNER JOIN ORDER_HEADER OH ON OH.CUSTOMER_ID = OC.CUSTOMER_ID  -- TO CONNECT THE ORDER AND CUSTOMER DETAILS
INNER JOIN ORDER_ITEMS OI ON OI.ORDER_ID = OH.ORDER_ID -- TO FETCH THE PRODUCT QUANTITY
WHERE OH.ORDER_STATUS = 'Shipped'  -- TO CHECK FOR ORDER_STATUS WHETHER IT IS SHIPPED
GROUP BY OH.ORDER_ID
HAVING Total_Order_Quantity > 10 -- TO CHECK THE TOTAL QUANTITY IS GREATER THAN 10 
ORDER BY CUSTOMER_ID;





# 9. Write a query to display the order_id, customer id and cutomer full name of customers starting with the alphabet "A" along with 
# (product_quantity) as total quantity of products shipped for order ids > 10030. 

SELECT 
OC.CUSTOMER_ID AS Customer_ID,
CONCAT(CUSTOMER_FNAME,'',CUSTOMER_LNAME) AS Customer_FullName,
OH.ORDER_ID AS Order_ID,
SUM(OI.PRODUCT_QUANTITY) AS Total_Order_Quantity
FROM ONLINE_CUSTOMER OC
INNER JOIN ORDER_HEADER OH ON OH.CUSTOMER_ID = OC.CUSTOMER_ID                     -- TO CONNECT THE ORDER AND CUSTOMER DETAILS
INNER JOIN ORDER_ITEMS OI ON OI.ORDER_ID = OH.ORDER_ID                            -- TO FETCH THE PRODUCT QUANTITY
WHERE OH.ORDER_STATUS = 'Shipped' AND OH.ORDER_ID > 10060                         -- TO CHECK FOR ORDER_STATUS WHETHER IT IS SHIPPED
GROUP BY OH.ORDER_ID
ORDER BY Customer_FullName;



# 10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value 
# (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India 
# other than USA? Also show the total value of those items.

SELECT PC.PRODUCT_CLASS_CODE AS Product_Class_Code,
PC.PRODUCT_CLASS_DESC AS Product_Class_Description,
SUM(OI.PRODUCT_QUANTITY) AS Total_Quantity,
SUM(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) AS Total_Value
FROM ORDER_ITEMS OI
INNER JOIN ORDER_HEADER OH ON OH.ORDER_ID = OI.ORDER_ID                                ## JOIN TO CONNECT ONLINE CUSTOMER
INNER JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID = OH.CUSTOMER_ID
INNER JOIN PRODUCT P ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN PRODUCT_CLASS PC ON PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
INNER JOIN ADDRESS A ON A.ADDRESS_ID = OC.ADDRESS_ID
WHERE OH.ORDER_STATUS = 'Shipped' AND A.COUNTRY NOT IN('India','USA')
GROUP BY PC.PRODUCT_CLASS_CODE, PC.PRODUCT_CLASS_DESC
ORDER BY Total_Quantity DESC                                                          ## ORDER BY TOTAL_QUANTITY
LIMIT 1;









