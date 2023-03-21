create database if not exists evaluation_21_03_23;
use evaluation_21_03_23;

delimiter $$
drop procedure if exists init_db;
CREATE PROCEDURE init_db()
begin

    # Create
    SET foreign_key_checks = 0;

    drop table if exists persons;
    create table persons
    (
        id        bigint unsigned primary key,
        name      VARCHAR(50),
        surname   VARCHAR(50),
        mother_id bigint unsigned null references persons (id),
        father_id bigint unsigned null references persons (id)
    );

    SET foreign_key_checks = 1;

#  Insert

    INSERT INTO persons (id, name, surname, mother_id, father_id)
    VALUES (1, 'Popa', 'Alba', null, null),
           (16, 'Popa', 'Viorel', null, null),
           (2, 'Mihai', 'Maria', 1, 16),
           (3, 'Chistol', 'Ina', null, null),
           (4, 'Chistol', 'Sergiu', null, null),
           (13, 'Mihai', 'Ion', null, null),
           (5, 'Chistol', 'Marius', 3, 4),
           (12, 'Babuta', 'Angela', null, null),
           (6, 'Dodu', 'Mircea', null, null),
           (7, 'Chisol', 'Emilia', 3, 4),
           (8, 'Mihai', 'Mihai', 2, 13),
           (9, 'Dosoftei', 'Sorina', 2, 13),
           (10, 'Dodu', 'Iana', 9, 6),
           (17, 'Babuta', 'Sergiu', null, null),
           (11, 'Babuta', 'Dorina', 12, 17),
           (15, 'Dragan', 'Vasile', null, null),
           (19, 'Fistic', 'Andrei', null, null),
           (20, 'Fistic', 'Vadim', 9, 19),
           (21, 'Babuta', 'Ana', 9, 17),
           (14, 'Babuta', 'Sofia', 9, 17),
           (18, 'Dragan', 'Laurentiu', 7, 15),
           (22, 'Dont have father', '--', 3, null),
           (23, 'Dont have Mother', '--', null, 21);
end$$
delimiter ;

call init_db();
