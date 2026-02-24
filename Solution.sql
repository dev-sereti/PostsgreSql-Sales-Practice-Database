--Rows in each table

select 'customers' as table_name, count (*) as total_rows from customers
union all 
select 'products', count(*) from products
union all
select 'orders', count(*) from orders
union all 
select 'order_items', count(*) from order_items;

--Customers with NULL or empty email
select * from customers where email is null or TRIM(email ) = '';

--Customers whose email looks invalid (does not contain “@”).

select * from customers where email is not null and position('@' in email ) =0;

--List all distinct customer_segment values.
select distinct customer_segment from customers order by customer_segment;

--Use TRIM and INITCAP to clean casing and whitespace.
select initcap(TRIM(first_name)) as firstname, 
initcap(TRIM(last_name)) as lastname from customers;

-- Standardize country to “USA” when it appears as US, U.S.A., United States, etc