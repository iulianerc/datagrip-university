call init_db();

#  Procedure 1

delimiter $$
drop procedure if exists proc_lista_articole1;
CREATE PROCEDURE  proc_lista_articole1(IN id_cerc_param INT)
BEGIN
    SELECT denarticol
    FROM articole
             INNER JOIN autori
                        ON articole.idarticol = autori.idarticol
    WHERE idcercetator = id_cerc_param
    order by articole.denarticol;
END;
$$
DELIMITER ;

# CALL proc_lista_articole1(4);

# __________________________________________________________________________________________________

#  Procedure 2

delimiter $$
drop procedure if exists proc_lista_cercet;
CREATE PROCEDURE proc_lista_cercet(IN id_univ INT)
BEGIN
    select cercetatori.numecercetător, articole.denarticol
    from cercetatori
             inner join autori on autori.IdCercetator = cercetatori.idcercetator
             inner join articole on articole.idarticol = autori.IdArticol
    where cercetatori.iduniversitate = id_univ;
END;
$$
DELIMITER ;

# CALL proc_lista_cercet(1);

# __________________________________________________________________________________________________

#  Procedure 3

delimiter $$
drop procedure if exists proc_cerc_art;
CREATE PROCEDURE proc_cerc_art(id_univ INT)
BEGIN
    select cercetatori.numecercetător, articole.denarticol
    from articole
             INNER join autori on articole.idarticol = autori.IdArticol
             RIGHT join cercetatori on autori.IdCercetator = cercetatori.idcercetator
    WHERE cercetatori.iduniversitate = id_univ;
END;
$$
DELIMITER ;

# CALL proc_cerc_art(2);

# __________________________________________________________________________________________________

#  Procedura 4

delimiter $$
drop procedure if exists proc_raiting;
CREATE PROCEDURE proc_raiting()
BEGIN
    DECLARE num_articole INT DEFAULT (select count(*) from articole);

    select cercetatori.numecercetător,
           count(autori.IdArticol) / num_articole * 100 as 'reitingul general',
           count(autori.IdArticol) / temp.reiting * 100 as 'reitingul pe universitate'
    from cercetatori
             LEFT join autori on autori.IdCercetator = cercetatori.idcercetator
             inner join (select iduniversitate, count(iduniversitate) as reiting
                         from cercetatori
                                  inner join autori on autori.IdCercetator = cercetatori.idcercetator
                         group by cercetatori.iduniversitate) as temp
                        on temp.iduniversitate = cercetatori.iduniversitate
    group by cercetatori.idcercetator;
END;
$$
DELIMITER ;

# CALL proc_raiting();

# __________________________________________________________________________________________________

# Procedura 5

alter table cercetatori
    drop column if exists calificativ;
alter table cercetatori
    add column Calificativ VARCHAR(30) default NULL;

delimiter $$
drop procedure if exists proc_calificativ;
CREATE PROCEDURE proc_calificativ()
BEGIN
    Declare counter Int;
    Declare art_cercet Int;
    select count(idcercetator)
    into counter
    from cercetatori;
    While counter > 0
        DO
            SELECT count(idcercetator)
            INTO art_cercet
            from autori
            WHERE idcercetator = counter;
            if art_cercet > 25 then
                update cercetatori
                set cercetatori.Calificativ = 'foarte bine'
                where cercetatori.idcercetator = counter;
                set counter = counter - 1;
            ELSEIF art_cercet >= 15 and art_cercet <= 25 then
                update cercetatori
                set cercetatori.Calificativ = 'bine'
                where cercetatori.idcercetator = counter;
                set counter = counter - 1;
            ELSEIF art_cercet >= 5 and art_cercet < 15 then
                update cercetatori
                set cercetatori.Calificativ = 'suficient'
                where cercetatori.idcercetator = counter;
                set counter = counter - 1;
            else
                update cercetatori
                set cercetatori.Calificativ = 'insuficient'
                where cercetatori.idcercetator = counter;
                set counter = counter - 1;
            end if;
        End while;

END;
$$
DELIMITER ;

# CALL proc_calificativ();

delimiter $$
drop procedure if exists proc_stergere;
CREATE PROCEDURE proc_stergere(n_cerc VARCHAR(20))
BEGIN
    DECLARE v_rez VARCHAR(70);
    SELECT IF(EXISTS(
                      SELECT numecercetător, idcercetator
                      FROM cercetatori
                      WHERE n_cerc = numecercetător
                        AND idcercetator NOT IN (SELECT idcercetator FROM autori)
                  ), true, 'Nu exista asa cercetator sau sunt articole legate cu el')
    INTO v_rez;
END;
$$
DELIMITER ;

# CALL proc_stergere("Dodu Petru");

# __________________________________________________________________________________________________

# Procedure 6

delimiter $$
drop function if exists func_c_in_univ;
CREATE FUNCTION func_c_in_univ(v_cercet VARCHAR(50), v_univ INT)
    RETURNS BOOL
    DETERMINISTIC
BEGIN
    DECLARE v_rez BOOL DEFAULT FALSE;
    SELECT IF(EXISTS(
                      SELECT *
                      FROM universitate
                               inner join cercetatori on cercetatori.iduniversitate = universitate.iduniversitate
                      WHERE universitate.iduniversitate = v_univ
                        and cercetatori.numecercetător = v_cercet), true, false)
    into v_rez;
    return v_rez;
END;
$$
DELIMITER ;

# select func_c_in_univ("Dodu Petru",1);

#  procedura incercare

delimiter $$
drop procedure if exists prod_incerc;
CREATE PROCEDURE prod_incerc()
BEGIN
    Declare counter Int DEFAULT 0;
    SELECT count(idcercetator)
    into counter
    from cercetatori;
END;
$$
DELIMITER ;

# CALL prod_incerc();

# ---------------------------Functions-------------------------------

#  Function ex 7

delimiter $$
drop function if exists func_un;
CREATE FUNCTION func_un(
    p_idcercet INT
)
    RETURNS VARCHAR(20)
    DETERMINISTIC
BEGIN
    DECLARE v_denumire VARCHAR(20);

    SELECT denuniversitate
    INTO v_denumire
    FROM universitate AS U
             INNER JOIN cercetatori AS C ON U.iduniversitate = C.idcercetator
    WHERE C.idcercetator = p_idcercet;
    RETURN v_denumire;
END;
$$
DELIMITER ;

# SELECT func_un(1);

# __________________________________________________________________________________________________

# Function 8

DELIMITER $$
drop function if exists func_id_calif;
CREATE FUNCTION func_id_calif(p_id_cerc INT)
    RETURNS VARCHAR(20)
    DETERMINISTIC
BEGIN
    DECLARE v_calif VARCHAR(20);
    SELECT calificativ
    INTO v_calif
    FROM cercetatori
    WHERE idcercetator = p_id_cerc;
    RETURN v_calif;
END;
$$
DELIMITER ;

# SELECT func_id_calif(1)

# __________________________________________________________________________________________________

# Function ex 9

DELIMITER $$
drop function if exists func_by_denuniversitate;
CREATE FUNCTION func_by_denuniversitate(p_denuniver VARCHAR(20))
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE v_totalCercet INT;
    SELECT COUNT(cercetatori.iduniversitate) AS num_cercetatori
    INTO v_totalCercet
    FROM cercetatori
             INNER JOIN universitate ON cercetatori.iduniversitate = universitate.iduniversitate
    WHERE denuniversitate = p_denuniver;
    RETURN v_totalCercet;
END;
$$
DELIMITER ;

# SELECT func_by_denuniversitate('USARB');

# __________________________________________________________________________________________________

# Function ex 10

DELIMITER $$
drop function if exists func_total_articole;
CREATE FUNCTION func_total_articole(p_iduniver INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE v_totalArticole INT;
    SELECT COUNT(autori.idarticol) AS num_articole
    INTO v_totalArticole
    FROM cercetatori
             INNER JOIN autori ON cercetatori.idcercetator = autori.idcercetator
             INNER JOIN universitate ON universitate.iduniversitate = cercetatori.iduniversitate
    WHERE universitate.iduniversitate = p_iduniver;
    RETURN v_totalArticole;
END;
$$
DELIMITER ;

# SELECT func_total_articole(3);

# __________________________________________________________________________________________________

# Function ex 11

DELIMITER $$
drop function if exists func_articole_by_cercetator;
CREATE FUNCTION func_articole_by_cercetator(p_numcercet VARCHAR(100))
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE v_totalArticole INT;
    SELECT COUNT(autori.idarticol) AS num_articole
    INTO v_totalArticole
    FROM cercetatori
             INNER JOIN autori ON cercetatori.idcercetator = autori.idcercetator
    WHERE cercetatori.numecercetător = p_numcercet;
    RETURN v_totalArticole;
END;
$$
DELIMITER ;

# SELECT func_articole_by_cercetator('Dodu Petru');

# __________________________________________________________________________________________________

# Function ex 12

delimiter $$
drop function if exists func_c_in_univ;
CREATE FUNCTION func_c_in_univ(v_cercet VARCHAR(50), v_univ INT)
    RETURNS BOOL
    DETERMINISTIC
BEGIN
    DECLARE v_rez BOOL DEFAULT FALSE;
    SELECT IF(EXISTS(
                      SELECT *
                      FROM universitate
                               inner join cercetatori on cercetatori.iduniversitate = universitate.iduniversitate
                      WHERE universitate.iduniversitate = v_univ
                        and cercetatori.numecercetător = v_cercet), true, false)
    into v_rez;
    return v_rez;
END;
$$
DELIMITER ;

# select func_c_in_univ('Dodu Petru',3);
