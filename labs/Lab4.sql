call init_db();

# Ex 1 ---------------------------------------------------------------------------------------------

delimiter $$
drop trigger if exists trig1;
CREATE TRIGGER trig1
    AFTER INSERT
    ON persoane
    FOR EACH row
BEGIN
    INSERT INTO amici(idpersoana1, idpersoana2)
    VALUES (NEW.idPersoana, (
                            SELECT persoane.idPersoana
                            FROM persoane
                            WHERE persoane.Nume = 'Elvi'
                            ));
END $$
delimiter ;

/*INSERT INTO persoane
VALUES (17, 'Dan', 21);*/


# Ex 2 ---------------------------------------------------------------------------------------------

DELIMITER $$
drop trigger if exists trig2;
CREATE TRIGGER trig2
    before INSERT
    ON persoane
    FOR EACH ROW
BEGIN
    IF EXISTS(
            SELECT * FROM persoane WHERE Nume = NEW.Nume
        ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Atenție! Așa persoană există!';
    END IF;
END $$
DELIMITER ;

/*INSERT INTO persoane
VALUES (19, 'Dan', 21);*/


# Ex 3 ---------------------------------------------------------------------------------------------

DELIMITER $$
drop trigger if exists trig3;
CREATE TRIGGER trig3
    BEFORE INSERT
    ON rude
    FOR EACH ROW
BEGIN
    IF EXISTS(
            SELECT *
            FROM rude r
                LEFT JOIN amici a ON (r.idPersoana1 = a.idPersoana1 AND r.idPersoana2 = a.idPersoana2) OR
                                     (r.idpersoana1 = a.idPersoana2 AND r.idpersoana2 = a.idPersoana1)
            WHERE (r.idPersoana1 = NEW.idPersoana1 AND r.idPersoana2 = NEW.idPersoana2)
               OR (r.idPersoana1 = NEW.idPersoana2 AND r.idPersoana2 = NEW.idPersoana1)
               OR (a.idPersoana1 = NEW.idPersoana1 AND a.idPersoana2 = NEW.idPersoana2)
               OR (a.idPersoana1 = NEW.idPersoana2 AND a.idPersoana2 = NEW.idPersoana1))
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Asa pereche exista.';
    ELSE
        INSERT INTO amici (idPersoana1, idPersoana2) VALUES (NEW.idPersoana1, NEW.idPersoana2);
    END IF;
END $$
DELIMITER ;

/*INSERT INTO rude
VALUES (9, 9);*/

# Ex 4 ------------------------------------------------------------------------------------

delimiter $$
drop trigger if exists trig4;
CREATE TRIGGER trig4
    AFTER DELETE
    ON rude
    FOR EACH ROW
BEGIN
    DELETE
    FROM amici
    WHERE (amici.idpersoana1 = OLD.idpersoana1 AND amici.idpersoana2 = OLD.idpersoana1)
       OR (amici.idpersoana1 = OLD.idpersoana2 AND amici.idpersoana2 = OLD.idpersoana1);
END $$
delimiter ;

/*DELETE
FROM rude
WHERE idpersoana1 = 9
  AND idpersoana2 = 9*/;


# Ex 5 ---------------------------------------------------------------------------------------


delimiter $$
drop trigger if exists trig5;
CREATE TRIGGER trig5
    BEFORE DELETE
    ON persoane
    FOR EACH ROW
BEGIN
    DELETE
    FROM rude
    WHERE OLD.idPersoana = rude.idpersoana1
       OR OLD.idPersoana = rude.idpersoana2;
    DELETE
    FROM amici
    WHERE OLD.idPersoana = amici.idpersoana1
       OR OLD.idPersoana = amici.idpersoana2;
END $$
delimiter ;

DELETE
FROM persoane
WHERE idPersoana = 10;

# Ex 6 ------------------------------------------------------------------------------------------

delimiter $$
drop trigger if exists trig6;
CREATE TRIGGER trig6
    BEFORE INSERT
    ON amici
    FOR EACH ROW
BEGIN
    if NOT EXISTS(SELECT *
                  FROM persoane
                      INNER JOIN persoane p
                  WHERE p.idPersoana = NEW.Idpersoana1
                    AND p.idPersoana = NEW.Idpersoana2)
    Then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una sau ambele persoane nu exista';
    END if;
END $$
delimiter ;

/*INSERT INTO amici (idPersoana1, idPersoana2)
VALUES (50, 90);*/

# Ex 7 ------------------------------------------------------------------------------------------

delimiter $$
drop trigger if exists trig7;
CREATE TRIGGER trig7
    AFTER UPDATE
    ON persoane
    FOR EACH ROW
BEGIN

    UPDATE amici
    SET amici.idpersoana1 = NEW.idPersoana
    WHERE amici.idpersoana1 = OLD.idPersoana;

    UPDATE amici
    SET amici.idpersoana2 = NEW.idPersoana
    WHERE amici.idpersoana2 = OLD.idPersoana;

END $$
delimiter ;

/*UPDATE persoane
SET persoane.idPersoana = 201
WHERE persoane.idPersoana = 1;*/

# Ex 8 ---------------------------------------------------------------------------------------------

delimiter $$
drop trigger if exists trig8;
CREATE TRIGGER trig8
    BEFORE DELETE
    ON persoane
    FOR EACH ROW
BEGIN
    DELETE
    FROM amici
    WHERE amici.idpersoana1 = OLD.idPersoana
       OR amici.idpersoana2 = OLD.idPersoana;
END $$
delimiter ;

DELETE
FROM persoane
WHERE persoane.idPersoana = 15;
