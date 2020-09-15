/*Представление обо всех действующих объявлениях. Даётся полная информация кроме фотографий. Отсортировано по дате.*/
DROP VIEW IF EXISTS all_ads;
CREATE VIEW all_ads AS
	SELECT DISTINCT 
		ads.id AS id_ad, ads.head, regions.region, citys.city, prof.adress, prof.rooms, ads.price, ads.deposit, prof.created_at, 
        prof.location_map, home_types.home_type, prof.floors, prof.`floor`, prof.belconys, prof.total_area, prof.living_area,
        prof.kitchen_area, prof.beds, prof.sleeping_places, prof.is_wifi, prof.is_TV, prof.is_kitchen_stove, prof.is_microwave, 
        prof.is_fridge, prof.is_washer, prof.is_flatiron, prof.is_conditioner, prof.is_parking_space, prof.can_children, 
        prof.can_events, prof.can_smoke, prof.can_pets, prof.additional_description, ads.duration, ads.is_promotion, ads.payment,
        CONCAT(users.first_name, ' ', users.last_name) AS author
    FROM users
    INNER JOIN rent_apartment_ads AS ads ON users.id = ads.id_user
	INNER JOIN ads_profiles AS prof ON ads.id = prof.id_ad
	INNER JOIN citys ON prof.id_city = citys.id
	INNER JOIN regions ON citys.id_region = regions.id
	INNER JOIN home_types ON prof.id_home_type = home_types.id
    LEFT JOIN transactions ON ads.id = transactions.id_ad
    WHERE transactions.id IS NULL
    ORDER BY prof.created_at DESC;

SELECT * FROM all_ads;
-- ------------------------------------------------------------------------------------------------------------------
/*Представление обо всех пользователях сервиса с подсчётом числа объявлений у каждого из них. Отсортировано по рейтингу.*/
DROP VIEW IF EXISTS all_users;
CREATE VIEW all_users AS
	SELECT 
		u.id, CONCAT(u.first_name, ' ', u.last_name) AS author, p.gender, p.birthday, p.photo_avatar, u.email, p.settlement, 
        u.password_hash, u.wallet,
        (SELECT COUNT(*) FROM rent_apartment_ads WHERE id_user = u.id GROUP BY id_user) AS ads_number,
        u.rating, created_at
    FROM users AS u
    JOIN `profiles` AS p ON u.id = p.id_user
    ORDER BY u.rating DESC;
    
SELECT * FROM all_users;
-- ------------------------------------------------------------------------------------------------------------------
