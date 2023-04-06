call init_db();

drop trigger if exists ex4;
delimiter |
create trigger rezervare_adaugata
    before insert
    ON Rezervari
    FOR EACH ROW
begin
    declare $nr_locuri_libere int unsigned;
    declare $price int unsigned default 0;

    select
        nr_locuri_libere,
        price
    into $nr_locuri_libere, $price
    from Zboruri_disponibile
    where zbor = NEW.zbor
      and date = NEW.date;

    if ($nr_locuri_libere = 0) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nu sunt locuri disponibile pentru rezervare';
    end if;

    update Zboruri_disponibile
    set nr_locuri_libere = nr_locuri_libere - 1,
        price            = price - 100
    where zbor = NEW.zbor
      and date = NEW.date;

    set NEW.price = $price;

end |
delimiter ;

insert into Rezervari (zbor, date, nume_pasager)
values ('zbor001', DATE_ADD(now(), interval 4 day), 'pas006');

# ---------------------------------------------------------------------------------------------
