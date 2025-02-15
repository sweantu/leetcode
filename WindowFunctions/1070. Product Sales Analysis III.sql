Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Create table If Not Exists Product (product_id int, product_name varchar(10));
Truncate table Sales;
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');
Truncate table Product;
insert into Product (product_id, product_name) values ('100', 'Nokia');
insert into Product (product_id, product_name) values ('200', 'Apple');
insert into Product (product_id, product_name) values ('300', 'Samsung');


select * from sales s ;

-- windown functions o(nlogn)
with cte as (
	select 
		s.product_id,
		min(year) over(partition by product_id) as first_year,
		s.quantity,
		s.price,
		s.year
	from sales s
)
select product_id, first_year, quantity, price from cte
where year = first_year;


-- group + join optimize o(n)

select
	s.product_id,
	s.year,
	s.quantity,
	s.price
from sales s 
join 
(select product_id , min(year) as first_year
from sales s
group by product_id) temp
on s.product_id  = temp.product_id and s.year = temp.first_year;
