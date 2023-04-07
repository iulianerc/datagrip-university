create database if not exists examination_06_04_23;
use examination_06_04_23;

delimiter $$
drop procedure if exists init_db;
CREATE PROCEDURE init_db()
begin

    # Create
    SET foreign_key_checks = 0;

    drop table if exists Aeroporturi;
    create table Aeroporturi
    (
        cod  varchar(32) primary key,
        oras varchar(255)
    );

    drop table if exists Zbor_cod;
    create table Zbor_cod
    (
        cod                   varchar(32) primary key,
        denumire_aviocompanie varchar(255)
    );

    drop table if exists Zboruri;
    create table Zboruri
    (
        punct_plecare varchar(32) references Aeroporturi (cod) on DELETE RESTRICT,
        punct_sosire  varchar(32) references Aeroporturi (cod) on DELETE RESTRICT,
        ora_plecare   datetime,
        ora_sosire    datetime,
        cod           varchar(32) references Zbor_cod (cod) on DELETE RESTRICT
    );

    drop table if exists Zboruri_disponibile;
    create table Zboruri_disponibile
    (
        zbor             varchar(32) references Zboruri (cod) on DELETE RESTRICT,
        date             date,
        nr_locuri_libere smallint unsigned,
        price            int unsigned,
        primary key (zbor, date)
    );

    drop table if exists Rezervari;
    create table Rezervari
    (
        zbor         varchar(32) references Zboruri (cod) on DELETE RESTRICT,
        date         date,
        nume_pasager varchar(255),
        price        int unsigned,
        foreign key (zbor, date) references Zboruri_disponibile (zbor, date)
    );

    SET foreign_key_checks = 1;

    #  Insert

    insert into Aeroporturi(cod, oras)
    values ('gg001', 'Chisinau'),
           ('gg002', 'Balti'),
           ('gg003', 'Kiev'),
           ('gg004', 'Moskow'),
           ('gg005', 'Dombas'),
           ('gg000', 'test');

    insert into Zbor_cod(cod, denumire_aviocompanie)
    values ('zbor001', 'Chisinau Departe hoooo'),
           ('zbor002', 'Balti Departe hoooo'),
           ('zbor003', 'Kiev Departe hoooo'),
           ('zbor004', 'Moskow Departe hoooo'),
           ('zbor005', 'Dombas Departe hoooo'),
           ('zbor000', 'Test zbor');

    insert into Zboruri(punct_plecare, punct_sosire, ora_plecare, ora_sosire, cod)
    values ('gg001', 'gg003', DATE_ADD(now(), interval 4 day), DATE_ADD(now(), interval 4 hour), 'zbor001'),
           ('gg003', 'gg002', DATE_ADD(now(), interval 6 day), DATE_ADD(now(), interval 1 hour), 'zbor002'),
           ('gg004', 'gg005', DATE_ADD(now(), interval 6 day), DATE_ADD(now(), interval 1 hour), 'zbor003'),
           ('gg004', 'gg003', DATE_ADD(now(), interval 11 day), DATE_ADD(now(), interval 2 hour), 'zbor004'),
           ('gg001', 'gg004', DATE_ADD(now(), interval 99 day), DATE_ADD(now(), interval 3 hour), 'zbor005'),
           ('gg000', 'gg001', now(), DATE_ADD(now(), interval 3 hour), 'zbor000');

    insert into Zboruri_disponibile(zbor, date, nr_locuri_libere, price)
    values ('zbor001', DATE_ADD(now(), interval 4 day), 5, 1111),
           ('zbor002', DATE_ADD(now(), interval 6 day), 423, 2222),
           ('zbor003', DATE_ADD(now(), interval 6 day), 887, 3333),
           ('zbor004', DATE_ADD(now(), interval 11 day), 999, 8888),
           ('zbor005', DATE_ADD(now(), interval 99 day), 1213, 525),
           ('zbor000', now(), 1213, 525);

    insert into Rezervari(zbor, date, nume_pasager, price)
    values ('zbor001', DATE_ADD(now(), interval 4 day), 'pas001', 1111),
           ('zbor002', DATE_ADD(now(), interval 6 day), 'pas002', 2222),
           ('zbor003', DATE_ADD(now(), interval 6 day), 'pas003', 3333),
           ('zbor004', DATE_ADD(now(), interval 11 day), 'pas004', 8888),
           ('zbor004', DATE_ADD(now(), interval 11 day), 'pas004', 1212),
           ('zbor004', DATE_ADD(now(), interval 11 day), 'pas004', 1),
           ('zbor005', DATE_ADD(now(), interval 99 day), 'pas005', 525);

end
$$
delimiter ;

call init_db();
