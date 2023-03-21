# call init_db();

# Ex 1

/*select persons.id,
       persons.name,
       persons.surname,
       (persons.mother_id is not null and persons.father_id is not null) as 'has_both_parents'
from persons
;*/


# Ex 2
# ----------------------------------------------------------------------

drop function if exists have_children;

delimiter |
create function have_children(first_person_id bigint unsigned, second_person_id bigint unsigned) returns bool
begin

    declare have_children bool;

    select count(*)
    into have_children
    from persons
    where (persons.father_id = first_person_id and persons.mother_id = second_person_id)
       or (persons.mother_id = first_person_id and persons.father_id = second_person_id);

    return have_children && have_children;

end |
delimiter ;

# select have_children(2, 13);
# select have_children(13, 2);

# Ex 3
# ----------------------------------------------------------------------

drop function if exists marriage_count;

delimiter |
create function marriage_count(person_id bigint unsigned) returns tinyint
begin

    declare marriage_count tinyint;

    select count(*)
    into marriage_count
    from persons as partener
    where have_children(person_id, partener.id);

    return marriage_count;

end |
delimiter ;

# select marriage_count(9);

# Ex 4
# ----------------------------------------------------------------------

drop procedure if exists person_grands;

delimiter |
create procedure person_grands(person_id bigint unsigned)
begin
    select grands.id, grands.name, grands.surname
    from (
         select *
         from persons
         where id = person_id
         ) as person
        join persons as parent on parent.id = person.mother_id or parent.id = person.father_id
        join persons as grands on grands.id = parent.mother_id or grands.id = parent.father_id;
end |
delimiter ;

# call person_grands(12);


#                               Testing ground
# ----------------------------------------------------------------------
