



-- ako veterinar vec postoji, ovo ce ga izbrisat

-- sve se radi kao SYS osim ku ne pise drugacije

DROP USER veterinar_sys CASCADE /
DROP TABLESPACE veterinar  /
DROP ROLE vet_sys/
DROP ROLE racunovoda/
DROP ROLE doktor/
DROP ROLE voditelj_odjela/

DROP USER mirkomirkec3 CASCADE /
-----------------------------------------


-- Kao SYS

-----------------------------------------


-- Još Uvijek KAO SYS


--ROLES
--Kreiranje uloga
------------------------------------------------------------------
create role vet_sys/

grant CREATE SESSION, ALTER SESSION, CREATE DATABASE LINK, CREATE MATERIALIZED VIEW, CREATE PROCEDURE,
      CREATE PUBLIC SYNONYM, CREATE ROLE, CREATE SEQUENCE, CREATE SYNONYM, CREATE TABLE, CREATE TRIGGER,
      CREATE TYPE, CREATE VIEW, UNLIMITED TABLESPACE,GRANT ANY ROLE,GRANT ANY PRIVILEGE,ALTER USER,CREATE USER, CREATE TABLESPACE, CREATE ANY SYNONYM to vet_sys;

create user veterinar_sys identified by 1234 /
grant vet_sys to veterinar_sys/
------------------------------------------------------------------


--SAD KAO VETERINAR_SYS

------------------------------------------------------------------
-- PRVO SE MORAJU KREIRATI TABLICE I SL. PRIJE DODAVANJA OSTaLIH ULOGA, tablice se dodaju kao veterinar_sys

-- SAD KAO veterinar_sys DODAVANJE ULOGA I KORISNIKA, samo da izgleda kao da ih je on napravio


--jos ce se to promijenit ali samo za testiranje je tako

-- maknuti komentar od DATAFILE, 1. je za linx, 2. je za win
CREATE TABLESPACE veterinar --LOGGING
    DATAFILE '/lib/oracle/oradata/XE/veterinar.ora'
  --DATAFILE 'C:\oraclexe\app\oracle\oradata\xe\veterinar.ora'
    SIZE 500M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
    EXTENT MANAGEMENT LOCAL
/


ALTER USER veterinar_sys  DEFAULT TABLESPACE veterinar/
ALTER USER veterinar_sys  QUOTA UNLIMITED ON veterinar;


------------------------------------------------------------------


--SAD KAO VETERINAR_SYS STVORITI TABLICE PA NASTAVIT OVDJE DALJE

------------------------------------------------------------------






create role racunovoda/

grant CREATE SESSION to racunovoda/  --da bi se mogao taj user spojiti na bazu
grant create synonym to racunovoda/
grant select on ZAPOSLENIK to racunovoda/
grant select on RADNI_STATUS to racunovoda/
grant select on RADNI_STATUS_TIP to racunovoda/
grant select on ZAPOSLENICI_DOLAZAK to racunovoda/
grant select on ZAPOSLENICI_ODSUTNOST to racunovoda/
grant select on ODSUTNOST_TIP to racunovoda/

------------------------------------------------------------------

create role doktor/

grant CREATE SESSION to racunovoda/  --da bi se mogao taj user spojiti na bazu

------------------------------------------------------------------

create role voditelj_odjela/

grant CREATE SESSION to racunovoda/  --da bi se mogao taj user spojiti na bazu




--USERI

-- mirkomirkec# :

-- 1 - voditelj
-- 2 - doktor
-- 3 - racunovoda

-- useri koji su racunovode
----------------------------------------------------------------------
create user mirkomirkec3 identified by 1234  DEFAULT TABLESPACE veterinar/
grant racunovoda to mirkomirkec3/
ALTER USER mirkomirkec3  QUOTA UNLIMITED ON veterinar;  -- dajemo useru max memoriju na alociranje ?

/*
select * from ZAPOSLENIK;
create synonym ZAPOSLENIK for VETERINAR_SYS.ZAPOSLENIK;
*/
----------------------------------------------------------------------

-- koji su doktori
----------------------------------------------------------------------
create user mirkomirkec2 identified by 1234  DEFAULT TABLESPACE veterinar/
grant doktor to mirkomirkec2/
ALTER USER mirkomirkec2  QUOTA UNLIMITED ON veterinar;  -- dajemo useru max memoriju na alociranje ?


----------------------------------------------------------------------


-- useri koji su voditelj_odjela
----------------------------------------------------------------------
create user mirkomirkec1 identified by 1234  DEFAULT TABLESPACE veterinar/
grant voditelj_odjela to mirkomirkec1/
ALTER USER mirkomirkec1  QUOTA UNLIMITED ON veterinar;  -- dajemo useru max memoriju na alociranje ?


----------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE create_user_racunovoda
    (user_name IN Varchar,passwd IN Varchar)
    AS
    BEGIN
        EXECUTE IMMEDIATE
            'create user ' || user_name || ' identified by ' || passwd || ' DEFAULT TABLESPACE  veterinar';
        EXECUTE IMMEDIATE
            'grant racunovoda to ' :user_name;
    end;





--ROLE UPITI to je za program da ne zaboravim


--kao sys vraca role od svakog
SELECT *
  FROM USER_ROLE_PRIVS ;


-- trebao bi vratiti role, TAJ !!!!
select * from USER_ROLE_PRIVS where USERNAME= USER;


-- neznam
select * from USER_TAB_PRIVS where Grantee = USER;


-- upit koji vraca privilegije trenutnog usera, neradi na useru, nebitno,nmvz
select * from USER_SYS_PRIVS where USERNAME = USER;



--OVO NE TREBA !!!!!!!!!!!!!!!!!!!

-- veterinar_sys je (izmišljeni) admin u veterinarskoj stanici a vet_tester je za nas, nebitno koji koristite, isti su
----------------------------------------------------------------------

-- veterinar  tester ce uvijek biti dostupan kao user sa admin privilegijama, ako oni role naredbe nešto zeznu ("backwards compatability") ili tak neš
create user veterinar_tester identified by 1234  DEFAULT TABLESPACE veterinar;

grant CREATE SESSION, ALTER SESSION, CREATE DATABASE LINK, CREATE MATERIALIZED VIEW, CREATE PROCEDURE, CREATE PUBLIC SYNONYM, CREATE ROLE, CREATE SEQUENCE, CREATE SYNONYM, CREATE TABLE, CREATE TRIGGER, CREATE TYPE, CREATE VIEW, UNLIMITED TABLESPACE  to veterinar_tester;

ALTER USER veterinar_tester  QUOTA UNLIMITED ON veterinar;
----------------------------------------------------------------------
