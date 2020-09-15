/*Процедура поиска действующего объявления по некоторым критериям. В данном случае - городу, количеству комнат, макимальной цене, 
этажу и наличию wi-fi. Поиск осуществляется в представлении "all_ads" */
DROP PROCEDURE IF EXISTS search_apartment;
DELIMITER //
CREATE PROCEDURE search_apartment(_city VARCHAR(30), _rooms TINYINT, max_price FLOAT, _floor TINYINT, _is_wifi BIT)
BEGIN
	SELECT *
    FROM all_ads
    WHERE
		city = _city
        AND rooms = _rooms
        AND price <= max_price
        AND floor = _floor
        AND is_wifi = _is_wifi;
END //

CALL search_apartment ('Jadenburgh', 1, 15000.00, 14, 0);
-- ---------------------------------------------------------------------------------
-- Процедура поиска пользователей взаимно включивших друг друга в избранные пользователи
DROP PROCEDURE IF EXISTS mutualy_favorites;
DELIMITER //
CREATE PROCEDURE mutualy_favorites()
BEGIN
	DECLARE i BIGINT;
    DECLARE is_end INT DEFAULT 0;
    DECLARE cur_fu CURSOR FOR SELECT id_electing_user AS i FROM favorite_users;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end = 1;
    OPEN cur_fu;
    cycle : LOOP
	FETCH cur_fu INTO i;
	IF is_end THEN LEAVE cycle;
	END IF;
		IF ((SELECT COUNT(*) FROM mutually_favorites WHERE id_second_favorite = i) = 0)  THEN
			INSERT mutually_favorites
				(id_first_favorite, id_second_favorite)
			SELECT
				id_elected_user,
				id_electing_user
			FROM favorite_users
			WHERE 
				id_electing_user IN (SELECT id_elected_user FROM favorite_users WHERE id_electing_user = i AND is_election = 1)
				AND id_elected_user = i
				AND is_election = 1;
		END IF;
    END LOOP cycle;
    CLOSE cur_fu;
END //

CALL mutualy_favorites();