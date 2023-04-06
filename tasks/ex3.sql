call init_db();

drop procedure if exists ex3;
delimiter |
create procedure ex3(cod_aeroport varchar(32))
begin

    select
        zd.*
    from (
         select *
         from Zboruri
         where punct_sosire = cod_aeroport
         ) as destinatie_zboruri
        join Zboruri_disponibile as zd on zd.zbor = destinatie_zboruri.cod;
end |
delimiter ;

call ex3('gg003')
