--*** 1.  What are the top 2 sales in Georgia? ***

select product_name, sum as sold
from product as p
inner join (select product_id, sum(quantity)
from order_made
where client_id = (select client_id
       from client 
natural join state
where state_name = 'GA')
		group by product_id
		order by sum desc
		limit 2) as q
on p.product_id = q.product_id
order by sold desc

--*** 2. What Month has the most Champagne sells? List the month and show the sales count respectively. ***

select extract(month from order_date)as Month, count(order_date) as sold
from (select order_date, product_id
    from order_made) as q1
      inner join (select product_id
            from product
            where p_type_id = (select distinct p_type_id
				        from product_type
        natural join state
				        where type_name = 'Champagne' )) as q2
      on q1.product_id = q2.product_id
      group by order_date
      order by sold desc



--*** 3. In what location of what state does white wine outsell red wine?   ***

select state_name, location
from client c1
natural join(select q8.client_id
  from(select q7.client_id, red_sum, white_sum
  	from(select client_id, sum(quantity) as Red_sum
from (select client_id, type_name, quantity
           from order_made as q1
           inner join has_type as q2
     on q1.product_id = q2.product_id
inner join product_type as q3
on q2.p_type_id = q3.p_type_id)as q4
where type_name = 'Red Wine'
group by client_id) q6
inner join (select client_id, sum(quantity) as White_sum
      from (select client_id, type_name, quantity
	    from order_made as q1
	     inner join has_type as q2
	     on q1.product_id = q2.product_id
      inner join product_type as q3
      on q2.p_type_id = q3.p_type_id) as q5
				      where type_name = 'White Wine'
				      group by client_id)q7
			on q6.client_id = q7.client_id) as q8
where q8.red_sum < q8.white_sum)c2
natural join
state

--*** 4. find products that has ABV lower than 13% and price cheaper than $15 in all locations in Florida ***

select product_name, abv, price, state_name, location
from (select client_id, q4.product_id, product_name,state_name,abv,price
    from (select q1.client_id, q1.product_id,q3.state_id, q3.state_name
  from order_made as q1
  inner join locate_at as q2
  on q1.client_id = q2.client_id
  inner join state as q3	
     	  on q2.state_id = q3.state_id
     	  where q3.state_name = 'FL') as q4
    inner join(select product_id,product_name, abv, price
     	         from product
    	         where abv < 13 And price < 15)  as q5
    on q4.product_id = q5.product_id) as c1
inner join client c2
on c1.client_id = c2.client_id

--*** 5. From the Product, find the items that never ordered from any store ***

select q1.product_id, product_name, q2.product_id
from product as q1
left join (select distinct product_id
	         from order_made) as q2
on q1.product_id = q2.product_id 
where q2.product_id is null
