/* Подбор 2-4 комнатных квартир в панельных или монолитных домах, которые сдаются в настоящее время в регионах Main и Oregon. 
Сортировка по рейтингу автора объявления.*/
SELECT 
	rent_apartment_ads.head AS head, home_types.home_type AS home_type, ads_profiles.rooms, regions.region AS region, citys.city AS city, 
    rent_apartment_ads.price AS price, rent_apartment_ads.deposit AS deposit, users.first_name AS ad_author, users.rating AS author_rating
FROM users
INNER JOIN rent_apartment_ads ON users.id = rent_apartment_ads.id_user
INNER JOIN ads_profiles ON rent_apartment_ads.id = ads_profiles.id_ad
INNER JOIN citys ON ads_profiles.id_city = citys.id
INNER JOIN regions ON citys.id_region = regions.id
INNER JOIN home_types ON ads_profiles.id_home_type = home_types.id
LEFT JOIN transactions ON rent_apartment_ads.id = transactions.id_ad
WHERE 
	transactions.id IS NULL 
    AND regions.region IN ('Maine', 'Oregon')
    AND home_types.home_type IN ('monolithic', 'panel')
    AND ads_profiles.rooms BETWEEN 2 AND 4
ORDER BY rating DESC;
-- ---------------------------------------------------------------------
/* Вывод средних цен по регионам аренды двухкомнатных квартир в кирпичных домах на этажах со 2-го по 9-ый, 
которые сдаются в данный момент */
SELECT 
	regions.region, ROUND(avg(rent_apartment_ads.price), 2) AS average_price
FROM rent_apartment_ads
INNER JOIN ads_profiles ON rent_apartment_ads.id = ads_profiles.id_ad
LEFT JOIN transactions ON rent_apartment_ads.id = transactions.id_ad
INNER JOIN citys ON ads_profiles.id_city = citys.id
INNER JOIN regions ON citys.id_region = regions.id
INNER JOIN home_types ON ads_profiles.id_home_type = home_types.id
WHERE 
	transactions.id IS NULL
    AND ads_profiles.rooms = 2
    AND home_types.home_type = 'brick' 
    AND ads_profiles.floor BETWEEN 2 AND 9
GROUP BY regions.region;
-- ----------------------------------------------------------------------
/* Вывод избранных объявлений и объявлений избранных пользователей заданного пользователя №1, по которым уже была заключена сделка*/
SELECT 
	rent_apartment_ads.id AS id_ad, rent_apartment_ads.head, ads_profiles.adress, home_types.home_type, ads_profiles.rooms, regions.region, 
    citys.city, rent_apartment_ads.price, rent_apartment_ads.deposit, transactions.transaction_date
FROM rent_apartment_ads
INNER JOIN ads_profiles ON rent_apartment_ads.id = ads_profiles.id_ad
INNER JOIN citys ON ads_profiles.id_city = citys.id
INNER JOIN regions ON citys.id_region = regions.id
INNER JOIN home_types ON ads_profiles.id_home_type = home_types.id
LEFT JOIN transactions ON rent_apartment_ads.id = transactions.id_ad

WHERE (rent_apartment_ads.id_user IN (
	SELECT users.id
	FROM users
	INNER JOIN favorite_users ON users.id = favorite_users.id_electing_user
	WHERE favorite_users.id_elected_user = 1
		UNION
	SELECT users.id
	FROM users
	INNER JOIN favorite_users ON users.id = favorite_users.id_elected_user
	WHERE favorite_users.id_electing_user = 1
    )
    OR rent_apartment_ads.id IN (SELECT favorite_ads.id_elected_ad FROM favorite_ads WHERE id_electing_user = 1 AND is_election = 1))
    AND transactions.id IS NOT NULL;
    -- ---------------------------------------------------------------------------------------
    -- Динамика цен аренды двухкомнатных квартир по месяцам 2020 года по резульататам заключённых сделок
    SELECT
		MONTHNAME(transactions.transaction_date) AS months_of_2020,
        ROUND(avg(rent_apartment_ads.price), 2) AS average_price
    FROM rent_apartment_ads
    INNER JOIN ads_profiles ON rent_apartment_ads.id = ads_profiles.id_ad
    LEFT JOIN transactions ON rent_apartment_ads.id = transactions.id_ad
    WHERE 
		YEAR(transactions.transaction_date) = 2020
        AND ads_profiles.rooms = 2
        AND transactions.id IS NOT NULL
    GROUP BY months_of_2020
    ORDER BY MONTH(transactions.transaction_date);
    -- -------------------------------------------------------------------------------------------
    -- Вывод списка всех моих сообщений и отзывов с указанием вида (сообщение или отзыв) целевого пользователя и даты. Сортировано по дате. 
    SELECT 
		CONCAT('feedback') AS `type`, 
        feedback.body, 
        CONCAT(users.first_name, ' ', users.last_name) AS target_user, 
        feedback.created_at AS `date`
	FROM feedback
    JOIN users ON users.id = feedback.id_target
    WHERE feedback.id_author = 7
    
		UNION
    
    SELECT 
		CONCAT('message'), 
        messages.body, 
        CONCAT(users.first_name, ' ', users.last_name) AS target_user, 
        messages.created_at 
	FROM messages
    JOIN users ON users.id = messages.id_target
    WHERE messages.id_author = 7
        
    ORDER BY `date` DESC;
		
