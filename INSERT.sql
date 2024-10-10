/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/

/*заполняем данными таблицу restaurant_type*/
INSERT INTO cafe.restaurants (cafe_name, cafe_type, menu)
SELECT 
	s.cafe_name,
	s."type" ::cafe.restaurant_type,
	m.menu 
FROM raw_data.sales s
LEFT JOIN raw_data.menu m USING (cafe_name)
GROUP BY s.cafe_name, s."type"::cafe.restaurant_type, m.menu;

/*Заполняем таблицу  менеджеров данными*/
INSERT INTO cafe.managers(manager, manager_phone)
SELECT 
	manager,
	manager_phone 
FROM raw_data.sales s
GROUP BY manager , manager_phone ;

/*заполним таблицу с длительностью работ менеджеров по заведениям*/
INSERT INTO cafe.restaurant_manager_work_dates(restaurant_uuid, manager_uuid, start_work_at, finish_work_at)
SELECT 
	r.restaurant_uuid,
	m.manager_uuid,
	min(s.report_date) AS start_work_at,
	max(s.report_date) AS finish_work_at
FROM  raw_data.sales s
LEFT JOIN 
	cafe.restaurants r ON s.cafe_name = r.cafe_name 
LEFT JOIN 
	cafe.managers m ON s.manager = m.manager 
GROUP BY 
	r.restaurant_uuid,
	m.manager_uuid;

/*Заполним таблицу sales данными*/
INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT 
	s.report_date,
	restaurant_uuid, 
	s.avg_check 
FROM raw_data.sales s
LEFT JOIN 
	cafe.restaurants r ON s.cafe_name = r.cafe_name;
