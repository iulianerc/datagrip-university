call init_db();

drop procedure if exists ex6;
delimiter |
create procedure ex6($zbor_cod_pentru_modificare varchar(32))
begin
    DECLARE $count INT unsigned default 0;
    DECLARE $price INT unsigned;
    DECLARE $total_price INT unsigned default 0;
    DECLARE $done INT DEFAULT FALSE;
    DECLARE $cursor CURSOR FOR (
                               select Rezervari.price
                               from (
                                    select
                                        Zboruri_disponibile.*
                                    from Zboruri_disponibile
                                    where zbor = $zbor_cod_pentru_modificare
                                    ) as zd
                                   join Rezervari on Rezervari.zbor = zd.zbor and Rezervari.date = zd.date
                               );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET $done = TRUE;


    OPEN $cursor;
    read_loop:
    LOOP
        FETCH $cursor INTO $price;
        IF $done THEN
            LEAVE read_loop;
        END IF;

        set $count = $count + 1;
        set $total_price = $total_price + $price;

    END LOOP;
    CLOSE $cursor;

    select $total_price, $count;

end |

delimiter ;

call ex6('zbor004');

# ---------------------------------------------------------------------------------------------
