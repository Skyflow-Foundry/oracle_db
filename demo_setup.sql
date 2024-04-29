-- Create Roles aligned to differing levels of PII access
CREATE ROLE C##_ROLE_PII_PLAINTEXT;     -- full access to PII in plain text
CREATE ROLE C##_ROLE_PII_MASKED;        -- masked access to PII e.g. (SSN last 4 only)
CREATE ROLE C##_ROLE_PII_REDACTED;      -- no access to PII

-- Grant each Role All Privileges over Users table (intentionally overscoped)
GRANT ALL PRIVILEGES ON C##_TEST_USER.USERS TO C##_ROLE_PII_PLAINTEXT;
GRANT ALL PRIVILEGES ON C##_TEST_USER.USERS TO C##_ROLE_PII_MASKED;
GRANT ALL PRIVILEGES ON C##_TEST_USER.USERS TO C##_ROLE_PII_REDACTED;

-- Grant Roles access to run Skyflow Tokenize and Detokenize Functions
GRANT EXECUTE ON skyflowDetokenize TO C##_ROLE_PII_PLAINTEXT;
GRANT EXECUTE ON skyflowDetokenize TO C##_ROLE_PII_MASKED;
GRANT EXECUTE ON skyflowDetokenize TO C##_ROLE_PII_REDACTED;
GRANT EXECUTE ON skyflowInsertAndTokenize TO C##_ROLE_PII_PLAINTEXT;
GRANT EXECUTE ON skyflowInsertAndTokenize TO C##_ROLE_PII_MASKED;
GRANT EXECUTE ON skyflowInsertAndTokenize TO C##_ROLE_PII_REDACTED;

-- Create Users aligned to differing levels of PII access
CREATE USER C##_USER_PII_PLAINTEXT IDENTIFIED BY s3cUr3_p4sSw0rD;
CREATE USER C##_USER_PII_MASKED IDENTIFIED BY s3cUr3_p4sSw0rD;
CREATE USER C##_USER_PII_REDACTED IDENTIFIED BY s3cUr3_p4sSw0rD;

-- Assign Roles to Users
GRANT CREATE SESSION TO C##_USER_PII_PLAINTEXT;
GRANT CREATE SESSION TO C##_USER_PII_MASKED;
GRANT CREATE SESSION TO C##_USER_PII_REDACTED;
GRANT C##_ROLE_PII_PLAINTEXT TO C##_USER_PII_PLAINTEXT;
GRANT C##_ROLE_PII_MASKED TO C##_USER_PII_MASKED;
GRANT C##_ROLE_PII_REDACTED TO C##_USER_PII_REDACTED;

-- Create Table and Function Synonyms
CREATE PUBLIC SYNONYM USERS FOR C##_TEST_USER.USERS;
CREATE PUBLIC SYNONYM skyflowDetokenize FOR SYS.SKYFLOWDETOKENIZE;
CREATE PUBLIC SYNONYM skyflowInsertAndTokenize FOR SYS.SKYFLOWINSERTANDTOKENIZE;

-- Create records in table with TOKENIZED Social Security Numbers
INSERT INTO USERS 
VALUES 
    (skyflowInsertAndTokenize('012-34-5678'), '112345678', 'Checking', 20000.00, TO_TIMESTAMP('2024-02-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 20000),
    (skyflowInsertAndTokenize('012-34-5678'), '212345678', 'Checking', 10000.00, TO_TIMESTAMP('2024-03-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10000),
    (skyflowInsertAndTokenize('123-45-6789'), '223456789', 'Savings', 1000.00, TO_TIMESTAMP('2024-03-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1000),
    (skyflowInsertAndTokenize('234-56-7890'), '334567890', 'Checking', 2000.00, TO_TIMESTAMP('2024-03-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2000),
    (skyflowInsertAndTokenize('345-67-8901'), '445678901', 'Savings', 3000.00, TO_TIMESTAMP('2024-03-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 3000),
    (skyflowInsertAndTokenize('456-78-9012'), '556789012', 'Checking', 4000.00, TO_TIMESTAMP('2024-03-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4000),
    (skyflowInsertAndTokenize('567-89-0123'), '667890123', 'Savings', 5000.00, TO_TIMESTAMP('2024-03-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5000),
    (skyflowInsertAndTokenize('678-90-1234'), '778901234', 'Checking', 6000.00, TO_TIMESTAMP('2024-03-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6000),
    (skyflowInsertAndTokenize('789-01-2345'), '889012345', 'Savings', 7000.00, TO_TIMESTAMP('2024-03-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7000),
    (skyflowInsertAndTokenize('890-12-3456'), '990123456', 'Checking', 8000.00, TO_TIMESTAMP('2024-03-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8000),
    (skyflowInsertAndTokenize('901-23-4567'), '101234567', 'Savings', 9000.00, TO_TIMESTAMP('2024-03-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9000),
    (skyflowInsertAndTokenize('123-45-6789'), '623456789', 'Savings', 11000.00, TO_TIMESTAMP('2024-03-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11000),
    (skyflowInsertAndTokenize('234-56-7890'), '434567890', 'Checking', 12000.00, TO_TIMESTAMP('2024-03-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12000),
    (skyflowInsertAndTokenize('345-67-8901'), '845678901', 'Savings', 13000.00, TO_TIMESTAMP('2024-03-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 13000),
    (skyflowInsertAndTokenize('456-78-9012'), '556789012', 'Checking', 14000.00, TO_TIMESTAMP('2024-03-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 14000),
    (skyflowInsertAndTokenize('567-89-0123'), '367890123', 'Savings', 15000.00, TO_TIMESTAMP('2024-02-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 15000),
    (skyflowInsertAndTokenize('678-90-1234'), '278901234', 'Checking', 16000.00, TO_TIMESTAMP('2024-02-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 16000),
    (skyflowInsertAndTokenize('789-01-2345'), '989012345', 'Savings', 17000.00, TO_TIMESTAMP('2024-02-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 17000),
    (skyflowInsertAndTokenize('890-12-3456'), '290123456', 'Checking', 18000.00, TO_TIMESTAMP('2024-02-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 18000),
    (skyflowInsertAndTokenize('901-23-4567'), '101234567', 'Savings', 19000.00, TO_TIMESTAMP('2024-02-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 19000);
COMMIT;

SELECT  SSN,
        AccountNumber,
        AccountType,
        AccountBalance,
        LoyaltyPoints
FROM USERS;

SELECT  skyflowDetokenize(SSN) AS SSN,
        AccountNumber,
        AccountType,
        AccountBalance,
        LoyaltyPoints
FROM USERS;

SELECT  SSN,
        skyflowDetokenize(SSN),
        AccountNumber,
        AccountType,
        AccountBalance,
        LoyaltyPoints
FROM USERS;



---- Drop Users, Roles, and Table Synonyms/Data
DROP USER C##_USER_PII_REDACTED;
DROP USER C##_USER_PII_PLAINTEXT;
DROP USER C##_USER_PII_MASKED;
DROP ROLE C##_ROLE_PII_REDACTED;
DROP ROLE C##_ROLE_PII_MASKED;
DROP ROLE C##_ROLE_PII_PLAINTEXT;
DELETE FROM C##_TEST_USER.USERS; COMMIT;
DROP PUBLIC SYNONYM USERS;
DROP PUBLIC SYNONYM skyflowDetokenize;
DROP PUBLIC SYNONYM skyflowInsertAndTokenize;


-- Query the DBA_NETWORK_ACLS view to get the ACLs
SELECT * FROM dba_network_acls;

-- Query the DBA_NETWORK_ACL_PRIVILEGES view to get the privileges
SELECT * FROM dba_network_acl_privileges;

SELECT * FROM DBA_NETWORK_ACLS;

BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host        => '*.skyflowapis.com',
        ace         => xs$ace_type(privilege_list => xs$name_list('connect', 'resolve'),
                                    principal_name => 'PUBLIC',
                                    principal_type => xs_acl.ptype_db));
    COMMIT;
END;
/
