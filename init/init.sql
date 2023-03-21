create database if not exists sgbd;
use sgbd;


delimiter $$
drop procedure if exists init_db;
CREATE PROCEDURE init_db()
begin

    # Create
    SET foreign_key_checks = 0;

    drop table if exists articole;
    create table articole
    (
        idarticol  INT,
        denarticol VARCHAR(50),
        PRIMARY KEY (idarticol)
    );

    drop table if exists universitate;
    CREATE TABLE universitate
    (
        iduniversitate  INT(11)  NOT NULL,
        denuniversitate TINYTEXT NOT NULL,
        PRIMARY KEY (iduniversitate)
    );

    drop table if exists cercetatori;
    CREATE TABLE cercetatori
    (
        idcercetator   INT(11)  NOT NULL,
        numecercetător TINYTEXT NOT NULL,
        iduniversitate INT(11)  NOT NULL,
        PRIMARY KEY (idcercetator)
    );

    drop table if exists autori;
    CREATE TABLE autori
    (
        IdCercetator INT(11) NOT NULL,
        IdArticol    INT(11) NOT NULL
    );

    drop table if exists persoane;
    CREATE TABLE persoane
    (
        idPersoana INT PRIMARY key,
        Nume       VARCHAR(50),
        Varsta     INT
    );

    drop table if exists rude;
    CREATE TABLE rude
    (
        idPersoana1 INT REFERENCES persoane (idpersoana),
        idPersoana2 INT REFERENCES persoane (idpersoana)
    );

    drop table if exists amici;
    CREATE TABLE amici
    (
        idPersoana1 INT REFERENCES persoane (idpersoana),
        idPersoana2 INT REFERENCES persoane (idpersoana)
    );

    SET foreign_key_checks = 1;

#  Insert

    insert into articole (idarticol, denarticol)
    VALUES (1, 'Articol1'),
           (2, 'Articol2'),
           (3, 'Articol3'),
           (4, 'Articol4'),
           (5, 'Articol5');


    INSERT INTO universitate (iduniversitate, denuniversitate)
    VALUES (5, 'ARB'),
           (6, 'UTM'),
           (7, 'Asem');

    INSERT INTO cercetatori (idcercetator, numecercetător, iduniversitate)
    VALUES (1, 'Dodu Petru', 1),
           (2, 'Lungu Vasile', 2),
           (3, 'Vrabie Maria', 1),
           (4, 'Ombun Bogdan', 3);


    INSERT INTO autori
        (IdCercetator, IdArticol)
    VALUES (1, 1),
           (2, 2),
           (3, 3),
           (4, 4);


    INSERT INTO persoane (idPersoana, Nume, Varsta)
    VALUES (1, 'Elvi', 19),
           (2, 'Farouk', 19),
           (3, 'Sam', 19),
           (4, 'Tiany', 19),
           (5, 'Nadia', 14),
           (6, 'Chris', 12),
           (7, 'kris', 10),
           (8, 'Bethany', 16),
           (9, 'Louis', 17),
           (10, 'Austin', 22),
           (11, 'Gabriel', 21),
           (12, 'Jessica', 20),
           (13, 'John', 16),
           (14, 'Alfred', 19),
           (15, 'Samantha', 17),
           (16, 'Craig', 17);


    INSERT INTO rude (idPersoana1, idPersoana2)
    VALUES (4, 6),
           (2, 4),
           (9, 7),
           (7, 8),
           (11, 9),
           (13, 10),
           (14, 5),
           (12, 13);


    INSERT INTO amici (idPersoana1, idPersoana2)
    VALUES (1, 2),
           (1, 3),
           (2, 4),
           (2, 6),
           (3, 9),
           (4, 9),
           (7, 5),
           (5, 8),
           (6, 10),
           (13, 6),
           (7, 6),
           (8, 7),
           (9, 11),
           (12, 9),
           (10, 15),
           (12, 11),
           (12, 15),
           (13, 16),
           (15, 13),
           (16, 14);


end $$
delimiter ;

call init_db();
