create database if not exists database_nik;
use database_nik;

delimiter $$
drop procedure if exists init_db;
CREATE PROCEDURE init_db()
begin

    # Create
    SET foreign_key_checks = 0;



    SET foreign_key_checks = 1;

#  Insert

end$$
delimiter ;

call init_db();
