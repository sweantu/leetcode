Create table If Not Exists orders (order_number int, customer_number int);
Truncate table orders;
insert into orders (order_number, customer_number) values ('1', '1');
insert into orders (order_number, customer_number) values ('2', '2');
insert into orders (order_number, customer_number) values ('3', '3');
insert into orders (order_number, customer_number) values ('4', '3');


select customer_number
from orders o
group by customer_number 
order by count(*) desc
limit 1;

select *
from orders o ;


with cte as (
	select distinct 
		customer_number,
		count(*) over(partition by customer_number ) as total_order
	from orders o
)
select customer_number
from cte
order by total_order desc
limit 1;


-- optimize
with customer_order_counts as (
	select customer_number, count(*) as order_count
	from orders o 
	group by o.customer_number
)
select customer_number
from customer_order_counts
where order_count = (select max(order_count) from customer_order_counts);


explain analyze with customer_order_ranks as (
	select 
	customer_number,
	dense_rank() over( order by count(*) desc) as rnk
from orders o 
group by customer_number
)
select customer_number
from customer_order_ranks
where rnk = 1;



