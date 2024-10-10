/*Добавьте в этот файл все запросы, для создания схемы сafe и
 таблиц в ней в нужном порядке*/

/*create schema cafe*/
CREATE SCHEMA cafe;

/*Создаем тип данных enum c типом заведений*/
CREATE TYPE cafe.restaurant_type AS ENUM 
	('coffee_shop', 'restaurant', 'bar', 'pizzeria');

/*создаем таблицу таблицу справоник с заведениями сети*/
CREATE TABLE cafe.restaurants (
	restaurant_uuid uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	cafe_name TEXT,
	cafe_type cafe.restaurant_type,
	menu jsonb
);

/*создаем таблицу справочник с менеджерами */
CREATE TABLE cafe.managers (
	manager_uuid uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	manager varchar,
	manager_phone varchar
);

/*создаем таблицу с днями работы менджерор*/
CREATE TABLE  cafe.restaurant_manager_work_dates (
	restaurant_uuid uuid REFERENCES cafe.restaurants (restaurant_uuid),
	manager_uuid uuid REFERENCES cafe.managers (manager_uuid),
	start_work_at date,
	finish_work_at date,
	PRIMARY KEY (restaurant_uuid, manager_uuid)
);

/*сщздаем таблицу sales*/
CREATE TABLE cafe.sales(
	date date,
	restaurant_uuid uuid REFERENCES cafe.restaurants (restaurant_uuid),
	avg_check NUMERIC(6, 2)
)