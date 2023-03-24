SAVEPOINT without_indexes;

#                       Ex 2
# -----------------------------------------------------------------------------------------------------
#                       Q
/*
Scrieți o interogare pentru a găsi clientul care a achiziționat cele mai multe piese din
genul „Rock” și, pentru acel client, găsiți primele 5 piese cele mai populare din genul
„Rock” pe care le-a achiziționat.
*/
# ---------------------------------------------
create temporary table rock_tracks as
    (
    select
        T.*
    from Genre
        join Track T on Genre.GenreId = T.GenreId and Genre.Name = 'Rock'
    );



select
    Customer.CustomerId,
    Customer.FirstName,
    Customer.LastName,
    count(IL.Quantity),
    IL.*

from Customer
    join Invoice I on Customer.CustomerId = I.CustomerId
    join InvoiceLine IL on I.InvoiceId = IL.InvoiceId
where IL.TrackId in (
                    select
                        TrackId
                    from rock_tracks
                    )
group by I.CustomerId
order by count(IL.Quantity) DESC;

drop temporary table top_rock_customers;
create temporary table top_rock_customers as (
                                             select
                                                 Customer.CustomerId,
                                                 Customer.FirstName,
                                                 Customer.LastName,
                                                 count(IL.Quantity),
                                                 IL.*

                                             from Customer
                                                 join Invoice I on Customer.CustomerId = I.CustomerId
                                                 join InvoiceLine IL on I.InvoiceId = IL.InvoiceId
                                             where IL.TrackId in (
                                                                 select
                                                                     TrackId
                                                                 from rock_tracks
                                                                 )
                                             group by I.CustomerId
                                             order by count(IL.Quantity) DESC
                                             );
select *
from top_rock_customers;

drop temporary table top_one_rock_customer_tracks;
create temporary table top_one_rock_customer_tracks as (
                                                       select *
                                                       from rock_tracks
                                                       where rock_tracks.
                                                       );


create temporary table most_popular_rock_traks as (
                                                  select *
                                                  from Track
                                                  );

set @top_one_rock_customer_id = (
                                select
                                    CustomerId
                                from top_one_rock_customer
                                );


#                       P
/*
Scrieți o interogare pentru a găsi numărul mediu de melodii per album pentru fiecare
artist din baza de date și returnați rezultatele numai pentru artiștii care au cel puțin 5
albume.
*/
# ---------------------------------------------


#                       O
/*
Scrieți o interogare pentru a găsi veniturile totale generate de fiecare gen de muzică
din baza de date și, pentru fiecare gen, găsiți albumul care a generat cele mai multe
venituri.
*/
# ---------------------------------------------


#                       N
/*
Scrieți o interogare pentru a găsi primele 10 albume vândute în magazin și, pentru
fiecare album, găsiți clientul care a achiziționat cele mai multe piese din acel album.
*/
# ---------------------------------------------


#                       M
/*
Scrieți o interogare pentru a găsi clientul care a achiziționat melodii de la cel mai
mare număr de artiști diferiți.
*/
# ---------------------------------------------


#                       L
/*
Scrieți o interogare pentru a găsi primii 5 clienți care au cheltuit cei mai mulți bani în
magazin și, pentru fiecare client, găsiți cel mai scump album pe care l-au achiziționat.
*/
# ---------------------------------------------


ROLLBACK TO without_indexes;
