call init_db;

drop table if exists cercetatori_copy;
CREATE TABLE cercetatori_copy LIKE cercetatori;

INSERT INTO cercetatori_copy
SELECT *
FROM cercetatori;

# ex1

delimiter $$
drop procedure if exists p_c;
CREATE PROCEDURE p_cursor1(p_iduniv INT)
BEGIN
    DECLARE finisare INT DEFAULT 0;
    DECLARE v_idcerc INT;
    DECLARE contor INT DEFAULT 0;
    DECLARE c_stergere CURSOR for
        SELECT idcercetator
        FROM cercetatori_copy
        WHERE iduniversitate = p_iduniv;

    DECLARE CONTINUE handler
        FOR NOT FOUND SET finisare = 1;

    OPEN c_stergere;
    et1:
    loop
        fetch c_stergere INTO v_idcerc;
        if finisare = 1 then
            leave et1;
        END if;
        DELETE
        FROM cercetatori_copy
        WHERE idcercetator = v_idcerc;
        SET contor = contor + 1;
    END loop et1;

    close c_stergere;

    SELECT contor;
END;
$$
delimiter ;

#  crearea cursor_2

# ------------------------------------------------------------------------------------

CREATE TABLE tab_temp
(
    nume    VARCHAR(50),
    univers VARCHAR(50)
);

# Definim cursorul pentru cercetatorii care au cel putin doua articole
DELIMITER $$
DROP PROCEDURE IF EXISTS curs_2;
CREATE PROCEDURE curs_2()
BEGIN
    DECLARE Nume VARCHAR(255);
    DECLARE Univers VARCHAR(255);
    DECLARE done bool DEFAULT FALSE;

    # Definim cursorul pentru cercetatorii care au cel putin doua articole
    DECLARE cursor_articole CURSOR FOR
        SELECT c.`numecercetător`, u.denuniversitate
        FROM cercetatori C
                 left JOIN autori A ON C.idcercetator = A.idcercetator
                 LEFT JOIN universitate U ON C.iduniversitate = U.iduniversitate
        GROUP BY C.`numecercetător`, U.denuniversitate
        HAVING COUNT(A.idarticol) >= 2;


    # Definim cursorul pentru cercetatorii care au un articol
    DECLARE cursor_un_articol CURSOR FOR
        SELECT c.`numecercetător`, u.denuniversitate
        FROM cercetatori C
                 left JOIN autori A ON C.idcercetator = A.idcercetator
                 LEFT JOIN universitate U ON C.iduniversitate = U.iduniversitate
        GROUP BY C.`numecercetător`, U.denuniversitate
        HAVING COUNT(A.idarticol) = 1;

    DECLARE CONTINUE handler
        FOR NOT FOUND SET done = 1;
    # Afisam antetul pentru primul cursor
    INSERT INTO tab_temp SELECT 'cercetatori ', 'cu cel putin doua articole:';

    # Deschidem primul cursor si afisam rezultatele

    OPEN cursor_articole;
    read_loop:
    LOOP
        FETCH cursor_articole INTO Nume, Univers;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO tab_temp SELECT Nume, Univers;
    END LOOP;
    CLOSE cursor_articole;

    # Afisam o linie intre cele doua antete

    INSERT INTO tab_temp SELECT '----------------------------', '------------------------';

    # Afisam antetul pentru al doilea cursor

    INSERT INTO tab_temp SELECT 'cercetatori', ' cu un singur articol:';

    set done = FALSE;
    # Deschidem al doilea cursor si afisam rezultatele
    OPEN cursor_un_articol;
    read_loop:
    LOOP
        FETCH cursor_un_articol INTO Nume, Univers;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO tab_temp SELECT Nume, Univers;
    END LOOP;
    CLOSE cursor_un_articol;
END;
$$

DELIMITER ;

# Apelam procedura
CALL curs_2;

# afisam datele din tabel temporar
SELECT *
FROM tab_temp

# stergem datele din tabel
DELETE
FROM tab_temp



/*
DROP PROCEDURE IF EXISTS curs_3;

DELIMITER $$
CREATE PROCEDURE curs_3()
BEGIN
    DECLARE nume1 VARCHAR(255) DEFAULT '';
    DECLARE nume2 VARCHAR(255) DEFAULT '';
    DECLARE nume3 VARCHAR(255) DEFAULT '';
    DECLARE done BOOL DEFAULT false;

    # Definim cursorul pentru primele nume a cercetatorilor ordonati crescator
    DECLARE curs_cercetatori CURSOR FOR
    SELECT `numecercetător`
    FROM cercetatori
    ORDER BY `numecercetător` ASC
    LIMIT 3;

    DECLARE CONTINUE HANDLER
	 FOR NOT FOUND SET done = 1;

    # Deschidem cursorul și afișăm numele cercetătorilor
    OPEN curs_cercetatori;
    read_loop: LOOP
        FETCH curs_cercetatori INTO nume1;
        IF done THEN
            LEAVE read_loop;
        END IF;
        FETCH curs_cercetatori INTO nume2;
        IF done THEN
            LEAVE read_loop;
        END IF;
        FETCH curs_cercetatori INTO nume3;
        IF done THEN
            LEAVE read_loop;
        END IF;

        # Afisam mesajele insoțite de numele cercetatorilor
        SELECT CONCAT('primul nume = ', nume1) union
        SELECT CONCAT('al doilea nume = ', nume2) union
        SELECT CONCAT('al treilea nume = ', nume3);
    END LOOP;
    CLOSE curs_cercetatori;

END$$
DELIMITER ;

CALL curs_3;

*/


/* cursor_4
creem tabel temporar pentru datele temp

CREATE TABLE tab_temp4(
nume VARCHAR(250)
)



DROP PROCEDURE IF EXISTS curs_4;

DELIMITER $$

CREATE PROCEDURE curs_4()
BEGIN
    DECLARE done BOOL DEFAULT false;
    DECLARE nume_cercetator VARCHAR(255);
    DECLARE prenume_cercetator VARCHAR(255);
    DECLARE numar_articole INT;
    DECLARE rezultat VARCHAR(255);

    # Definim cursorul pentru fiecare cercetător
    DECLARE curs_cercetator CURSOR FOR
    SELECT SUBSTRING_INDEX(`numecercetător`, ' ', 1),
       SUBSTRING_INDEX(`numecercetător`, ' ', -1),
       COUNT(autori.idarticol)
		FROM cercetatori
	 RIGHT JOIN autori ON autori.IdCercetator = cercetatori.idcercetator
	 GROUP BY numecercetător;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    # Deschidem cursorul și afișăm numărul de articole pentru fiecare cercetător
    OPEN curs_cercetator;
    read_loop: LOOP
        FETCH curs_cercetator INTO nume_cercetator, prenume_cercetator, numar_articole;
        IF done THEN
            LEAVE read_loop;
        END IF;
        # Afisam informatiile despre cercetator si numarul de articole
        INSERT INTO tab_temp4 SELECT CONCAT('Nume - ', nume_cercetator, ', prenume - ', prenume_cercetator, ', articole - ', numar_articole);

    END LOOP;
    CLOSE curs_cercetator;

END$$

DELIMITER ;

# Apelam cursor
CALL curs_4;

# afisam datele din tabel temporar
SELECT * FROM tab_temp4

# stergem datele din tabel
DELETE FROM tab_temp4

*/


# cursor_5
# creem tabel temporar pentru datele temp

CREATE TABLE tab_temp5
(
    nume VARCHAR(250)
);

DROP PROCEDURE IF EXISTS curs_5;
DELIMITER $$

CREATE PROCEDURE curs_5()
BEGIN
    DECLARE done BOOL DEFAULT false;
    DECLARE nume_cercetator VARCHAR(255);
    DECLARE nume_articol VARCHAR(255);

    # Definim cursorul pentru fiecare cercetător
    DECLARE curs_articole CURSOR FOR
        SELECT denarticol, `numecercetător`
        FROM autori
                 INNER JOIN articole ON articole.idarticol = autori.IdArticol
                 INNER JOIN cercetatori ON cercetatori.idcercetator = autori.IdCercetator;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    # Deschidem cursorul și afișăm numărul de articole pentru fiecare cercetător
    OPEN curs_articole;
    read_loop:
    LOOP
        FETCH curs_articole INTO nume_cercetator, nume_articol;
        IF done THEN
            LEAVE read_loop;
        END IF;
        # Afisam informatiile despre cercetator si numarul de articole
        INSERT INTO tab_temp5 SELECT CONCAT('Denumirea articolului - ', nume_cercetator, ', autori - ', nume_articol);

    END LOOP;
    CLOSE curs_articole;

END$$

DELIMITER ;


# Apelam cursor

CALL curs_5;

# afisam datele din tabel temporar

SELECT *
FROM tab_temp5;

# stergem datele din tabel

DELETE
FROM tab_temp5;



