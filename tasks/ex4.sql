call init_db();

drop function if exists ex4;
delimiter |
create function ex4(zbor_cod varchar(32), data_decolarii date) returns int unsigned
    not deterministic
begin
    declare $nr_locuri_libere int unsigned;
    declare $nr_locuri_rezervari int unsigned default 0;

    select
        nr_locuri_libere
    into $nr_locuri_libere
    from Zboruri_disponibile
    where zbor = zbor_cod
      and date = data_decolarii;

    select
        count(*)
    into $nr_locuri_rezervari
    from Rezervari
    where zbor = zbor_cod
      and date = data_decolarii;


    return $nr_locuri_libere - $nr_locuri_rezervari;

end |
delimiter ;

select ex4('zbor004', DATE(DATE_ADD(now(), interval 11 day)));

# ---------------------------------------------------------------------------------------------
