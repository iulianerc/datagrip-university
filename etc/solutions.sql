call init_db();

# Ex 1

select persons.id,
       persons.name,
       persons.surname,
       (persons.mother_id is not null and persons.father_id is not null) as 'has_both_parents'
from persons
;


# Ex 2

delimiter $$

create function ex_2 (mother_id, father_id)
    begin


delimiter ;

