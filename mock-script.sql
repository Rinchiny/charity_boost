DELETE FROM task;
DELETE FROM user;

INSERT INTO user VALUES 
(1, 'Логан', 'Гримнар', 'greatwolf@mailinator.com', 'password', null, 1, now(), null , 1),
(2, 'Катаринья', 'Грейфакс', 'inquisitor@mailinator.com', 'password', null, 2, now(), null , 1),
(3, 'Святая', 'Селестина', 'livingsaint@mailinator.com', 'password', null, 3, now(), null , 1),
(4, 'Робут', 'Гиллеман', 'avengingson@mailinator.com', 'password', null, 4, now(), null , 1);

INSERT INTO task VALUES
(1, 'Моя первая таска', 'Я стесняюсь, но хочу сделать мир лучше', null, null, 3, 1, null, 1, null, null, now(), null, null, 1),
(2, 'Таска ожидает исполнения', 'Жду, пока кто-то возьмет меня в работу', null, null, 5, 5, null, 1, 2, null, now(), null, null, 1),
(3, 'Таска ожидает проверки выполнения', 'Посмотрите, что мы можем сделать вместе!', null, null, 4, 20, null, 1, 2, 3, now(), null, null, 1);