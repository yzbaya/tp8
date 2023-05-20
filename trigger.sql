--EX1
create table T1(
numm number(10),
coll varchar2(50)
);
CREATE OR REPLACE TRIGGER autoincrement
before INSERT ON T1
FOR EACH ROW
DECLARE
   colmax NUMBER(10);
   nb NUMBER(10);
BEGIN
   SELECT COUNT(*), MAX(numm)
   INTO nb, colmax
   FROM T1;

   IF nb = 0 THEN
      :new.numm := 20;
   ELSE
      :new.numm := colmax + 1;
   END IF;
END;
/

BEGIN
insert into T1 values(1,'test1');
 insert into T1 (Coll) values ('test2');
  insert into T1 (Coll) values ('test3');
END;

select * from T1;




--EX2
--:new.salaire>(:old.salaire)*2
--:new.salaire=:old.salaire
create or replace trigger salairetrig before update Of salaire on jouer
for EACH ROW
begin
if (:new.salaire)>(2*:old.salaire) then 
dbms_output.put_line('error update');
   :new.salaire := :old.salaire;
else
:new.salaire := :new.salaire;
end if;
end;

BEGIN
  update jouer SET salaire=1100 where jouer.codea=1000;
END;
select * from jouer;



--EX3
create table log (
nomTab varchar2(20),
dateLog  date,
nomUser varchar2(20),
action varchar2(20)
);
--sys_context('USERENV', 'CURRENT_USER');
--create or replace trigger logtrigger  after update or insert or delete on jouer
--for EACH ROW
--begin

--end;

CREATE OR REPLACE TRIGGER logtrigger after insert OR update OR delete on jouer
FOR EACH ROW
DECLARE
   action VARCHAR2(100);
BEGIN
   IF INSERTING THEN
      action := 'Insertion';
   ELSIF UPDATING THEN
      action := 'Mise à jour';
   ELSIF DELETING THEN
      action := 'Suppression';
   END IF;
END;
/

begin
   INSERT INTO log( nomTab,dateLog,nomUser,action)values ('jouer',SYSTIMESTAMP, sys_context('USERENV', 'CURRENT_USER'), action);
END;
DROP TRIGGER logtrigger;
