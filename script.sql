DROP DATABASE IF EXISTS `kdc`;
CREATE DATABASE `kdc` CHARACTER SET `utf8` COLLATE `utf8_general_ci`;

USE kdc;

DROP TABLE IF EXISTS uploaded_file;
DROP TABLE IF EXISTS task;
DROP TABLE IF EXISTS task_type;
DROP TABLE IF EXISTS task_status;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS role;

CREATE TABLE task_status (
               id BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
               name VARCHAR(127) NOT NULL COMMENT 'Отображаемое имя статуса',
               title VARCHAR(127) NOT NULL COMMENT 'Служебное наименование',
               description VARCHAR(255) NULL COMMENT 'Описание статуса',
               is_active BIT(1) NOT NULL DEFAULT 1 COMMENT 'Если запись удалена - false',
               PRIMARY KEY(id)
) COLLATE 'utf8_general_ci' COMMENT='Статусы тасок';

CREATE TABLE task_type (
               id BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
               name VARCHAR(127) NOT NULL COMMENT 'Отображаемое имя типа таски',
               title VARCHAR(127) NOT NULL COMMENT 'Служебное наименование',
               description VARCHAR(255) NULL COMMENT 'Описание типа',
               is_active BIT(1) NOT NULL DEFAULT 1 COMMENT 'Если запись удалена - false',
               PRIMARY KEY(id)
) COLLATE 'utf8_general_ci' COMMENT='Типы (категории) тасок';

CREATE TABLE task (
            id BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
            name VARCHAR(127) NOT NULL COMMENT 'Отображаемое имя таски',
            description VARCHAR(1023) NOT NULL COMMENT 'Описание таски',
            location VARCHAR(127) NULL COMMENT 'Опционально: место выполнения таски',
            comment VARCHAR(255) NULL COMMENT 'Опционально: комментарий к таске',
            task_type_id BIGINT NOT NULL COMMENT 'Идентификатор типа таски',
            task_status_id BIGINT NOT NULL COMMENT 'Идентификатор статуса таски',
            parent_task_id BIGINT NULL COMMENT 'Опционально: родительская таска',
            reporter_id BIGINT NOT NULL COMMENT 'Идентификатор создателя таски',
            moderator_id BIGINT NULL COMMENT 'Идентификатор модератора таски',
            executor_id BIGINT NULL COMMENT 'Идентификатор исполнителя таски',
            create_date DATETIME(3) NOT NULL COMMENT 'Дата и время создания',
            update_date DATETIME(3) NULL COMMENT 'Дата и время обновления',
            expiration_date DATETIME(3) NULL COMMENT 'Дата и время дедлайна таски',
            is_active BIT(1) NOT NULL DEFAULT 1 COMMENT 'Если запись удалена - false',
            PRIMARY KEY(id),
            FOREIGN KEY(task_type_id) REFERENCES task_type(id),
            FOREIGN KEY(task_status_id) REFERENCES task_status(id),
            FOREIGN KEY(parent_task_id) REFERENCES task(id)
) COLLATE 'utf8_general_ci' COMMENT='Файлы вложений';

CREATE TABLE role (
            id BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
            name VARCHAR(127) NOT NULL COMMENT 'Отображаемое имя роли',
            title VARCHAR(127) NOT NULL COMMENT 'Служебное наименование',
            description VARCHAR(255) NULL COMMENT 'Описание роли',
            is_active BIT(1) NOT NULL DEFAULT 1 COMMENT 'Если запись удалена - false',
            PRIMARY KEY(id)
) COLLATE 'utf8_general_ci' COMMENT='Роли пользователей';

CREATE TABLE user (
            id BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
            first_name VARCHAR(127) NOT NULL COMMENT 'Имя пользователя',
            last_name VARCHAR(127) NOT NULL COMMENT 'Фамилия пользователя',
            email VARCHAR(127) NOT NULL COMMENT 'Электронная почта пользователя',
            password VARCHAR(255) NOT NULL COMMENT 'Хэш пароля пользователя',
            avatar BLOB NULL COMMENT 'Аватарка пользователя',
            role_id BIGINT NOT NULL COMMENT 'Идентификатор роли пользователя',
            create_date DATETIME(3) NOT NULL COMMENT 'Дата и время создания',
            update_date DATETIME(3) NULL COMMENT 'Дата и время обновления',
            is_active BIT(1) NOT NULL DEFAULT 1 COMMENT 'Если запись удалена - false',
            PRIMARY KEY(id)
) COLLATE 'utf8_general_ci' COMMENT='Роли пользователей';

CREATE TABLE uploaded_file (
                 id BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
                 task_id BIGINT NOT NULL COMMENT 'Идентификатор таски, к которой относится вложение',
                 user_id BIGINT NOT NULL COMMENT 'Идентификатор загрузившего пользователя',
                 value BLOB NOT NULL COMMENT 'Бинарное представление файла',
                 create_date DATETIME(3) NOT NULL COMMENT 'Дата и время создания',
                 update_date DATETIME(3) NULL COMMENT 'Дата и время обновления',
                 is_active BIT(1) NOT NULL DEFAULT 1 COMMENT 'Если запись удалена - false',
                 PRIMARY KEY(id),
                 FOREIGN KEY(task_id) REFERENCES task(id),
                 FOREIGN KEY(user_id) REFERENCES user(id)
) COLLATE 'utf8_general_ci' COMMENT='Файлы вложений';

INSERT INTO role (id, name, title, description, is_active) values (1, 'Создатель задачи', 'reporter', 'Роль пользователя, создающего задания', 1),
                                  (2, 'Модератор','moderator', 'Роль пользователя, модерирующего задания', 1),
                                  (3, 'Исполнитель задачи','executor', 'Роль пользователя, выполняющего задания', 1),
                                  (4, 'Одмен','admin', 'Роль суперпользователя', 1);


INSERT INTO task_status (id, name, title, description, is_active) values (1, 'Новая задача', 'new', 'Новая задача, не прошедшая модерацию', 1),
                                     (5, 'Проверенная новая задача', 'readyForExecution', 'Задача, прошедшая модерацию и готовая к исполнению', 1),
                                     (10, 'Не прошедшая модерацию задача', 'needsCorrection', 'Задача требует корректировки постановки', 1),
                                     (15, 'В исполнении', 'inProgress', 'Задача взята в работу', 1),
                                     (20, 'Ожидает проверки', 'readyForReview', 'Задача, требующая проверки выполнения', 1),
                                     (25, 'Проверенная выполненная задача', 'completed', 'Полностью выполненная задача, успешно прошедшая проверку', 1),
                                     (30, 'Не прошедшая проверку выполнения задача', 'needsWork', 'Задача требует корректировки результата', 1);

INSERT INTO task_type (id, name, title, description, is_active) VALUES (1, 'Волонтерские', 'volunteer', 'Волонтерские задачи', 1),
                                     (2, 'Донорские', 'donor', 'Донорские задачи', 1),
                                     (3, 'Пожертвования', 'donation', 'Пожертвования', 1),
                                     (4, 'Профессиональные', 'professional', 'Проведение мастер-классов', 1),
                                     (5, 'Экологические', 'eco', 'Экологические задачи', 1),
                                     (6, 'Другие', 'other', 'Прочие задачи', 1);

