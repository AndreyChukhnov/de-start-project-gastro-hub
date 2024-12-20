/*Топ 3 заведения где чаще всего менялся менеджер */
SELECT 
	r.cafe_name , 
	count(manager_uuid)  
FROM cafe.restaurant_manager_work_dates rmwd 
LEFT JOIN cafe.restaurants r ON rmwd.restaurant_uuid = r.restaurant_uuid 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;
