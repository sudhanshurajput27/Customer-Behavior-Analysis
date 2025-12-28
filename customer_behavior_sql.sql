-- Total Revenue Male Vs Female

SELECT gender, sum(purchase_amount) from csm
group by gender;

-- Customers who used discount but spent more than average purchase

select customer_id, purchase_amount 
from csm
where discount_applied = "Yes" and purchase_amount >= (select avg(purchase_amount) from csm);

-- Top 5 Products with highest average review rating

select item_purchased, avg(review_rating) as avgr from csm
group by item_purchased
order by avgr desc limit 5;

-- Avg purchase amount between standard and express shipping

select shipping_type , avg(purchase_amount) from csm 
where shipping_type in ("Standard","Express")
group by shipping_type;

-- Do subscribed customer spend more? Comaparison of Average spend and total revenue between subs and non subs

select subscription_status, count(customer_id), avg(purchase_amount), sum(purchase_amount) 
from csm
group by subscription_status;

-- 5 products with highest percentage of purchases with discount

select item_purchased,
round(sum(case when discount_applied = "YES" then 1 else 0 end) /count(*) * 100,2) as discount_rate
from csm
group by item_purchased
order by discount_rate desc
limit 5;

select * from csm;
-- Customers segmentation into New, Returning and Loyal based on number of previous purchases

with customer_type as (
select customer_id,  previous_purchases,
case
	when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	else 'Loyal'
	end as customer_segment
from csm
)

select customer_segment,count(*) as "number of customer"
from customer_type
group by customer_segment;

-- Top 3 purchased products from each category

with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from csm
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <=3 ;

-- if customers who are repeat buyers are likely to subscribe?

select subscription_status,
count(customer_id) as repeat_buyers
from csm
where previous_purchases > 5
group by subscription_status;

-- Revenue contribution of each group

select age_group,
sum(purchase_amount) as total_revenue
from csm
group by age_group
order by total_revenue desc;
 
