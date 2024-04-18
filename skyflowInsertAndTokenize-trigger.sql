DROP TRIGGER skyflowInsertAndTokenizeTrigger;

CREATE OR REPLACE TRIGGER skyflowInsertAndTokenizeTrigger
BEFORE INSERT OR UPDATE OF ssn ON PERSON2
FOR EACH ROW
DECLARE
  v_token VARCHAR2(4000);
BEGIN
  v_token := skyflowInsertAndTokenize(:new.ssn);
  :new.ssn := v_token;
END;
/