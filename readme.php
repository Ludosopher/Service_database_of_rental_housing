<?php
/*
 База данных "rent_apartments" предназначена для сервиса размещения объявлений о сдаче жилья в аренду для физических лиц.
Примером послужил соответствующий раздел сайта "avito.ru". Сервис предоставляет возможность зарегистрированным пользователям
размещать объявления
о сдаче жилья, искать жилые помещения для аренды по множеству различных параметров, общаться между собой и оценивать друг друга
как участников
рынка. База включает две основные сущности - это пользователи и объявления о сдаче жилья в аренду. Информация о пользователях
сервиса
размещена в таблицах "users" и "profiles"; об объявлениях - в "rent_apartments_ads" и "ads_profiles". Кроме этого есть следующие
таблицы:
photos (фотографии), phones (телефоны), social_networks (социальные сети), users_accounts (аккаунты пользователей в социальных
сетях),
notices (уведомления пользователей от сервиса), messages (сообщения между пользователями), feedback (отзывы пользователей друг
о друге),
citys (города), regions (регионы), home_types (типы домов), favorite_users (избранные пользователи), favorite_ads
(избранные объявления),
transactions (заключённые сделки), mutualy_favorites (взаимно избранные пользователи).
В файле create.sql размещены скрипты для создания таблиц; в insert.sql для заполнения таблиц условными данными
(с помощью сервиса filldb.info); в select.sql для выборок; в stored_prosidures.sql для хранимых процедуор; в views.sql
для представлений.
 * */
