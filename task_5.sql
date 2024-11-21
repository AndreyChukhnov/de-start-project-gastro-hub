/*Самая дорогая пицца в заведении*/
WITH menu_cte AS (
	SELECT 
	    r.cafe_name,
	    'Пицца' AS type_dish,
	    pizza.name AS pizza_name,
	    pizza.price::integer AS pizza_price
	FROM cafe.restaurants r,
	jsonb_each_text(r.menu -> 'Пицца') AS pizza(name, price)
	WHERE r.cafe_type = 'pizzeria'
),
menu_with_rank AS (
	SELECT 
		cafe_name,
		type_dish,
		pizza_name,
		pizza_price,
		ROW_NUMBER () OVER (PARTITION BY cafe_name ORDER BY pizza_price DESC) AS rank
	FROM menu_cte
)
SELECT 
	cafe_name,
	type_dish,
	pizza_name,
	pizza_price
FROM menu_with_rank
WHERE RANK = 1;
