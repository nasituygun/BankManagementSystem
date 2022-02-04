-- CREATE AND DESCRIBE THE RELATIONS INCLUDING PKs AND FKs -- 
CREATE TABLE bank(
    trade_reg_no  NUMBER(10), 
    bname         VARCHAR2(50) NOT NULL, 
    street_no     NUMBER, 
    street_name   VARCHAR2(20), 
    city          VARCHAR2(20), 
    state         VARCHAR2(20), 
    zip           NUMBER(5),

    CONSTRAINT    bank_pk PRIMARY KEY (trade_reg_no));
DESCRIBE bank


CREATE TABLE bank_phone(
    trade_reg_no NUMBER,
    phone        VARCHAR2(11),
    
    CONSTRAINT bank_phone_pk PRIMARY KEY (trade_reg_no, phone),

    CONSTRAINT bank_phone_trade_reg_no_fk FOREIGN KEY(trade_reg_no)
    REFERENCES bank(trade_reg_no) ON DELETE CASCADE);
DESCRIBE bank_phone


CREATE TABLE bank_mail(
    trade_reg_no NUMBER NOT NULL,
    mail         VARCHAR2(50),

    CONSTRAINT bank_mail_pk PRIMARY KEY (trade_reg_no, mail),

    CONSTRAINT bank_mail_trade_reg_no_fk FOREIGN KEY(trade_reg_no)
    REFERENCES bank(trade_reg_no) ON DELETE CASCADE);
DESCRIBE bank_mail


CREATE TABLE branch(
    id           NUMBER,
    bname        VARCHAR2(50) NOT NULL,
    street_no    NUMBER,
    street_name  VARCHAR2(20), 
    city         VARCHAR2(20), 
    state        VARCHAR2(20), 
    zip          NUMBER(5),
    trade_reg_no NUMBER,
    
    CONSTRAINT branch_pk PRIMARY KEY (id),

    CONSTRAINT branch_trade_reg_no_fk FOREIGN KEY(trade_reg_no)
    REFERENCES bank(trade_reg_no) ON DELETE CASCADE);
DESCRIBE branch


CREATE TABLE branch_phone(
    branch_id NUMBER, 
    phone     VARCHAR2(11),

    CONSTRAINT branch_phone_pk PRIMARY KEY (branch_id, phone),

    CONSTRAINT branch_phone_branch_id_fk FOREIGN KEY(branch_id)
    REFERENCES branch(id) ON DELETE CASCADE);
DESCRIBE branch_phone


CREATE TABLE branch_mail(
    branch_id NUMBER, 
    mail      VARCHAR2(50),

    CONSTRAINT branch_mail_pk PRIMARY KEY (branch_id, mail),

    CONSTRAINT branch_mail_branch_id_fk FOREIGN KEY(branch_id)
    REFERENCES branch(id) ON DELETE CASCADE);
DESCRIBE branch_mail


CREATE TABLE customer(
    id            NUMBER,
    trade_reg_no  NUMBER NOT NULL,
    ssn           NUMBER NOT NULL,
    f_name        VARCHAR2(50) NOT NULL, 
    m_name        VARCHAR2(50), 
    s_name        VARCHAR2(50) NOT NULL, 
    job           VARCHAR2(50),
    salary        NUMBER NOT NULL,
    date_of_birth DATE,
    street_no     NUMBER, 
    street_name   VARCHAR2(20), 
    city          VARCHAR2(20), 
    state         VARCHAR2(20), 
    zip           NUMBER,
    age number  AS (2022-TO_CHAR(date_of_birth,'YYYY')) CHECK (age>=18),


    CONSTRAINT customer_pk PRIMARY KEY (id),

    CONSTRAINT customer_trade_reg_no_fk FOREIGN KEY(trade_reg_no)
    REFERENCES bank(trade_reg_no) ON DELETE CASCADE);
DESCRIBE customer


CREATE TABLE customer_phone(
    customer_id NUMBER,
    phone       VARCHAR2(11),

    CONSTRAINT customer_phone_pk PRIMARY KEY (customer_id, phone),

    CONSTRAINT customer_phone_customer_id_fk FOREIGN KEY(customer_id)
    REFERENCES customer(id) ON DELETE CASCADE);
DESCRIBE customer_phone


CREATE TABLE customer_mail(
    customer_id NUMBER, 
    mail        VARCHAR2(50),

    CONSTRAINT customer_mail_pk PRIMARY KEY (customer_id, mail),

    CONSTRAINT customer_mail_customer_id_fk FOREIGN KEY(customer_id)
    REFERENCES customer(id) ON DELETE CASCADE);
DESCRIBE customer_mail


CREATE TABLE account(
    id          NUMBER, 
    type        VARCHAR2(12) NOT NULL,
    currency    VARCHAR2(10) NOT NULL,
    balance     NUMBER,
    status      VARCHAR2(10) NOT NULL,
    customer_id NUMBER NOT NULL,
    branch_id   NUMBER NOT NULL,

    CONSTRAINT account_pk PRIMARY KEY (id),

    CONSTRAINT account_customer_id_fk FOREIGN KEY(customer_id)
    REFERENCES customer(id) ON DELETE CASCADE,

    CONSTRAINT account_branch_id_fk FOREIGN KEY(branch_id)
    REFERENCES branch(id) ON DELETE CASCADE);
DESCRIBE account


CREATE TABLE manager(
    username VARCHAR2(50),
    password VARCHAR2(50),
    ministry VARCHAR2(50),

    CONSTRAINT manager_pk PRIMARY KEY (username));
DESCRIBE manager


CREATE TABLE interference(
    manager_name VARCHAR2(50),
    account_id   NUMBER,
    idate        TIMESTAMP,

    CONSTRAINT interference_pk PRIMARY KEY (manager_name, account_id, idate),

    CONSTRAINT interference_manager_name_fk FOREIGN KEY(manager_name)
    REFERENCES manager(username) ON DELETE CASCADE,

    CONSTRAINT interference_account_id_fk FOREIGN KEY(account_id)
    REFERENCES account(id) ON DELETE CASCADE);
DESCRIBE interference

    
CREATE TABLE transaction(
    sender_acc_id   NUMBER,
    receiver_acc_id NUMBER, 
    amount          NUMBER,  
    tdate           TIMESTAMP,
    status          VARCHAR2(10),

    CONSTRAINT transaction_pk
    PRIMARY KEY (sender_acc_id, receiver_acc_id, amount, tdate, status),

    CONSTRAINT transaction_sender_acc_id_fk FOREIGN KEY(sender_acc_id)
    REFERENCES branch(id) ON DELETE CASCADE,

    CONSTRAINT transaction_receiver_acc_id_fk FOREIGN KEY(receiver_acc_id)
    REFERENCES branch(id) ON DELETE CASCADE);
DESCRIBE transaction

    
CREATE TABLE loan(
    id             NUMBER,
    ldate          TIMESTAMP NOT NULL,
    amount         NUMBER NOT NULL,
    due_date       DATE NOT NULL,
    interest       NUMBER NOT NULL, 
    installment    NUMBER NOT NULL, 
    install_amount NUMBER NOT NULL,
    customer_id    NUMBER NOT NULL,  
    trade_reg_no   NUMBER NOT NULL,

    CONSTRAINT loan_pk PRIMARY KEY (id),

    CONSTRAINT loan_customer_id_fk FOREIGN KEY(customer_id)
    REFERENCES customer(id) ON DELETE CASCADE,

    CONSTRAINT loan_trade_reg_no_fk FOREIGN KEY(trade_reg_no)
    REFERENCES bank(trade_reg_no) ON DELETE CASCADE);
DESCRIBE loan


CREATE TABLE payment(
    customer_id  NUMBER, 
    trade_reg_no NUMBER,
    amount       NUMBER,
    pdate        TIMESTAMP,
    status       VARCHAR2(12),

    CONSTRAINT payment_pk
    PRIMARY KEY (customer_id, trade_reg_no, amount, pdate, status),

    CONSTRAINT payment_customer_id_fk FOREIGN KEY(customer_id)
    REFERENCES customer(id) ON DELETE CASCADE,

    CONSTRAINT payment_trade_reg_no_fk FOREIGN KEY(trade_reg_no)
    REFERENCES bank(trade_reg_no) ON DELETE CASCADE);
DESCRIBE payment


CREATE TABLE borrow(
    customer_id  NUMBER,
    trade_reg_no NUMBER,
    loan_id      NUMBER,

    CONSTRAINT borrow_pk PRIMARY KEY (customer_id, trade_reg_no),

    CONSTRAINT borrow_customer_id_fk FOREIGN KEY(customer_id)
    REFERENCES customer(id) ON DELETE CASCADE,

    CONSTRAINT borrow_trade_reg_no_fk FOREIGN KEY(trade_reg_no)
    REFERENCES bank(trade_reg_no) ON DELETE CASCADE,

    CONSTRAINT borrow_loan_id_fk FOREIGN KEY(loan_id)
    REFERENCES loan(id) ON DELETE CASCADE);    
DESCRIBE borrow


CREATE TABLE atm(
    id           NUMBER, 
    type     varchar2(10) not null,
    balance      NUMBER NOT NULL,
    street_no    NUMBER, 
    street_name  VARCHAR2(20), 
    city         VARCHAR2(20), 
    state        VARCHAR2(20), 
    zip          NUMBER, 
    trade_reg_no NUMBER,

    CONSTRAINT atm_pk PRIMARY KEY (id),

    CONSTRAINT atm_trade_reg_no_fk FOREIGN KEY(trade_reg_no)
    REFERENCES bank(trade_reg_no) ON DELETE CASCADE);
DESCRIBE atm


CREATE TABLE deposit(
    atm_id     NUMBER, 
    account_id NUMBER, 
    ddate      TIMESTAMP,
    amount     NUMBER,

    CONSTRAINT deposit_pk PRIMARY KEY (atm_id, account_id, ddate, amount),

    CONSTRAINT deposit_atm_id_fk
    FOREIGN KEY(atm_id) REFERENCES atm(id),

    CONSTRAINT deposit_account_id_fk FOREIGN KEY(account_id)
    REFERENCES account(id) ON DELETE CASCADE);
DESCRIBE deposit


CREATE TABLE withdraw(
    atm_id     NUMBER, 
    account_id NUMBER, 
    wdate      TIMESTAMP,
    amount     NUMBER,

    CONSTRAINT withdraw_pk PRIMARY KEY (atm_id, account_id, wdate, amount),

    CONSTRAINT withdraw_atm_id_fk
    FOREIGN KEY(atm_id) REFERENCES atm(id),

    CONSTRAINT withdraw_account_id_fk FOREIGN KEY(account_id)
    REFERENCES account(id) ON DELETE CASCADE);
DESCRIBE withdraw

        
CREATE TABLE card(
    no              NUMBER,
    type            VARCHAR2(6) NOT NULL,
    expiration_date DATE NOT NULL,
    status          VARCHAR2(10) NOT NULL,
    account_id      NUMBER,

    CONSTRAINT card_pk PRIMARY KEY (no),

    CONSTRAINT card_account_id_fk FOREIGN KEY(account_id)
    REFERENCES account(id) ON DELETE CASCADE);
DESCRIBE card


CREATE TABLE credit(
    no    NUMBER,
    limit NUMBER NOT NULL,

    CONSTRAINT credit_pk PRIMARY KEY (no),

    CONSTRAINT credit_no_fk FOREIGN KEY(no)
    REFERENCES card(no) ON DELETE CASCADE);
DESCRIBE credit


CREATE TABLE debit(
    no      NUMBER,
    balance NUMBER NOT NULL,

    CONSTRAINT debit_pk PRIMARY KEY (no),

    CONSTRAINT debit_no_fk FOREIGN KEY(no)
    REFERENCES card(no) ON DELETE CASCADE);
DESCRIBE debit

-- ADD OTHER CONSTRAINTS EXCLUDING FKs AND PKs TO THE RELATIONS -- 
ALTER TABLE bank ADD
CONSTRAINT bank_zip CHECK (length(zip) = 5 OR length(zip) = NULL);

-- ALTER TABLE bank_phone ADD
-- CONSTRAINT bank_phone_check CHECK (regexp_like (phone,'^(\d{11})$'));

-- ALTER TABLE branch_phone ADD
-- CONSTRAINT branch_phone_check CHECK (regexp_like (phone,'^(\d{11})$'));

ALTER TABLE customer ADD
CONSTRAINT customer_date_of_birth CHECK (TO_DATE('2003-01-01', 'YYYY-MM-DD') >= date_of_birth);

ALTER TABLE account ADD
CONSTRAINT account_status CHECK (status IN ('normal', 'blocked', 'suspended'));

ALTER TABLE loan ADD
CONSTRAINT loan_due_date CHECK (TO_DATE('2040-01-01', 'YYYY-MM-DD') >= due_date);

ALTER TABLE card ADD(
CONSTRAINT card_type CHECK (type IN ('debit', 'credit')),
CONSTRAINT card_expiration_date CHECK (expiration_date >= TO_DATE('2024-01-01', 'YYYY-MM-DD')));

ALTER TABLE transaction ADD(
CONSTRAINT transaction_status CHECK (status IN ('success', 'failure')),
CONSTRAINT transaction_amount CHECK (amount <= 10000));

ALTER TABLE withdraw ADD
CONSTRAINT withdraw_amount CHECK (amount <= 5000);

ALTER TABLE deposit ADD
CONSTRAINT deposit_amount CHECK (amount <= 5000);

ALTER TABLE credit ADD
CONSTRAINT credit_limit CHECK (limit BETWEEN 5000 AND 50000);

ALTER TABLE manager ADD
CONSTRAINT manager_ministry CHECK (ministry IN ('ministry of treasury', 'ministry of justice'));


-- ADD CONSTRAINTS ON MULTIPLE RELATIONS -- 

CREATE OR REPLACE TRIGGER loan_amount BEFORE INSERT OR UPDATE ON loan
FOR EACH ROW
DECLARE
    max_allowed_loan INTEGER;
BEGIN
    SELECT salary*50 INTO max_allowed_loan
    FROM customer
    WHERE customer.id = :new.customer_id;

    IF max_allowed_loan <= :new.amount 
    THEN
      RAISE_APPLICATION_ERROR(-20101, 'Loan amount is not permitted.');
      ROLLBACK;
    END IF;
END;

/

CREATE OR REPLACE TRIGGER withdraw_count BEFORE INSERT ON withdraw
FOR EACH ROW
DECLARE
    withdraw_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO withdraw_count
    FROM withdraw
    WHERE withdraw.account_id = :new.account_id AND CAST(withdraw.wdate AS DATE) = CAST(:new.wdate AS DATE);

    IF 3 <= withdraw_count 
    THEN
      RAISE_APPLICATION_ERROR(-20101, 'Withdraw is not permitted, because withdraw is made already 3 times today.');
      ROLLBACK;
    END IF;
END;

/

CREATE OR REPLACE TRIGGER deposit_count BEFORE INSERT ON deposit
FOR EACH ROW
DECLARE
    deposit_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO deposit_count
    FROM deposit
    WHERE deposit.account_id = :new.account_id AND CAST(deposit.ddate AS DATE) = CAST(:new.ddate AS DATE);

    IF 3 <= deposit_count 
    THEN
      RAISE_APPLICATION_ERROR(-20101, 'Deposit is not permitted, because deposit is made already 3 times today.');
      ROLLBACK;
    END IF;
END;

/

CREATE OR REPLACE TRIGGER transaction_amount BEFORE INSERT OR UPDATE ON transaction
FOR EACH ROW
DECLARE
    account_balance INTEGER;
BEGIN
    SELECT balance INTO account_balance
    FROM account
    WHERE account.id = :new.sender_acc_id;   

    IF account_balance < :new.amount THEN
      RAISE_APPLICATION_ERROR(-20101, 'Balance is not enough to make this transaction.');
      ROLLBACK;
     ELSE Update account set balance=balance-:new.amount where account.id = :new.sender_acc_id;
          Update account set balance=balance+:new.amount where account.id = :new.receiver_acc_id;    
    END IF;
    
END;

-- NOTE: WE CAN NOT USE CREATE ASSERTION AS IT IS NOT SUPPORTED BY ORACLE
-- CREATE ASSERTION loan_amount AS CHECK(
-- NOT EXISTS SELECT l.amount, c.salary
--            FROM loan l, customer c
--            WHERE l.customer_id = c.id AND c.salary*50 <= l.amount);

/

-- POPULATE THE TABLES

-- INSERT BANK VALUES INTO THE BANK TABLE --
INSERT INTO Bank VALUES(52021,'akbank',76108,'karanfil street','istanbul',NULL,34068);
INSERT INTO Bank VALUES(65221,'isbank',65421,'lale street','izmir',NULL,35768);
INSERT INTO Bank VALUES(98324,'finansbank',543141,'gul street','ankara',NULL,06012);


-- INSERT BANK_PHONE VALUES INTO THE ASSOCIATED TABLE --
INSERT INTO Bank_phone VALUES(52021,05657686363);
INSERT INTO Bank_phone VALUES(52021,05657686368);
INSERT INTO Bank_phone VALUES(52021,05657686360);

INSERT INTO Bank_phone VALUES(65221,05657686387);
INSERT INTO Bank_phone VALUES(65221,05657653465);
INSERT INTO Bank_phone VALUES(65221,05345764315);

INSERT INTO Bank_phone VALUES(98324,05438646284);
INSERT INTO Bank_phone VALUES(98324,05431425432);
INSERT INTO Bank_phone VALUES(98324,05455445467);


-- INSERT BANK_MAIL VALUES INTO THE ASSOCIATED TABLE --
INSERT INTO Bank_mail VALUES(52021,'destek@akbank.net');
INSERT INTO Bank_mail VALUES(52021,'support@akbank.net');
INSERT INTO Bank_mail VALUES(52021,'help@akbank.net');

INSERT INTO Bank_mail VALUES(65221,'destek@isbank.net');
INSERT INTO Bank_mail VALUES(65221,'support@isbank.net');
INSERT INTO Bank_mail VALUES(65221,'help@isbank.net');

INSERT INTO Bank_mail VALUES(98324,'destek@finansbank.net');
INSERT INTO Bank_mail VALUES(98324,'support@finansbank.net');
INSERT INTO Bank_mail VALUES(98324,'help@finansbank.net');


-- INSERT BRANCH VALUES INTO THE BRANCH TABLE --
INSERT INTO Branch VALUES(1,'karanfil branch',24142,'karanfil street','istanbul',Null,34086,52021);
INSERT INTO Branch VALUES(2,'papatya branch',24132,'papatya street','istanbul',Null,34083,52021);
INSERT INTO Branch VALUES(3,'cankaya branch',24142,'cankaya street','ankara',Null,06012,52021);

INSERT INTO Branch VALUES(4,'karanfil branch',24142,'karanfil street','istanbul',Null,34086,65221);
INSERT INTO Branch VALUES(5,'inonu branch',241,'inonu street','yozgat',Null,66100,65221);
INSERT INTO Branch VALUES(6,'cumhuriyet branch',58763,'cumhuriyer street','mersin',Null,33023,65221);

INSERT INTO Branch VALUES(7,'karanfil branch',24142,'karanfil street','istanbul',Null,34086,98324);
INSERT INTO Branch VALUES(8,'karanfil branch 2',24142,'karanfil street','istanbul',Null,34086,98324);
INSERT INTO Branch VALUES(9,'sisli branch',58763,'cumhuriyer street','istanbul',Null,34076,98324);


-- INSERT CUSTOMER VALUES INTO THE CUSTOMER TABLE --
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(1,'nasit','uygun','student',55435243764,9,'fevzi cakmak','hatay',Null,31070,52021,TO_DATE('06-JAN-1997'),0);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(2,'elif','uygun','student',84321432864,9,'fevzi cakmak','hatay',Null,31070,65221,TO_DATE('07-DEC-2002'),0);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(3,'simge','sonmez','student',78329432718,9,'konak','izmir',Null,34023,98324,TO_DATE('23-JAN-1982'),0);

INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(4,'muhammed','tecimen','engineer ',65452364328,9,'universite street','kilis',Null,79070,52021,TO_DATE('06-JAN-1997'),18000);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(5,'akin','demir','ANALYST',84321432864,9,'karahuseyinli','tunceli',Null,62465,65221,TO_DATE('17-NOV-1995'),15000);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(6,'hasan','deniz','student',78329432718,9,'patates street','yozgat',Null,66764,98324,TO_DATE('21-NOV-1999'),0);

INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(7,'ahmet','can','teacher',5432616325,9,'7 aralik street','nevsehir',Null,50897,52021,TO_DATE('06-JAN-1994'),4250);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(8,'mehmet','ada','MANAGER',26436345678,9,'5 ocak street','adana',Null,01000,65221,TO_DATE('12-JAN-1980'),20000);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(9,'fatih','candan','taxi driver',23579765432,9,'konak','izmir',Null,34023,98324,TO_DATE('23-FEB-1997'),7400);

INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(10,'muhammed','ali','CLERK',87642642689,9,'fevzi cakmak','hatay',Null,31070,52021,TO_DATE('16-JUN-1990'),12000);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(11,'ada','lale','chef',25437543247,9,'fevzi cakmak','hatay',Null,31070,65221,TO_DATE('07-DEC-1970'),8000);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(12,'yaren','ekin','student',87535678532,9,'konak','izmir',Null,34023,98324,TO_DATE('23-JAN-2000'),0);

INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(13,'berkan','bulut','chef',65432468653,9,'menekse street','mersin',Null,33232,52021,TO_DATE('06-APR-1992'),6540);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(14,'elif','ay','MANAGER',53267864324,9,'aydin street','aydin',Null,09023,65221,TO_DATE('07-DEC-1967'),23000);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(15,'ege','izmirli','retired ',87654323456,9,'konak','izmir',Null,34023,98324,TO_DATE('23-JAN-1950'),3300);

INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(16,'alev','koca','MANAGER',76435753255,9,'ataturk street','hatay',Null,31070,52021,TO_DATE('06-SEP-1973'),17000);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(17,'emir','guzel','student',98646789053,9,'erbasi street','bitlis',Null,13000,65221,TO_DATE('07-DEC-2002'),0);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(18,'ozcan','hatun','retired ',12809867234,9,'karbeyaz','gaziantep',Null,27021,98324,TO_DATE('23-JAN-1952'),3300);

INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(19,'sevgi','deniz','SALESMAN',65467854264,9,'tokdemir','bolu',Null,14086,52021,TO_DATE('06-JAN-1993'),6250);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(20,'ceren','huri','SALESMAN',13121456432,9,'fevzi cakmak','hatay',Null,31070,65221,TO_DATE('07-DEC-1995'),7300);
INSERT INTO customer(id,f_name,s_name,job,ssn,street_no,street_name, city,state,zip,trade_reg_no,date_of_birth,salary)
            VALUES(21,'onur','bado','student',87654368653,9,'konak','izmir',Null,34023,98324,TO_DATE('23-JAN-1998'),0);
            
            
-- INSERT CUSTOMER_PHONE VALUES INTO THE ASSOCIATED TABLE --
INSERT INTO Customer_phone VALUES(1,05332232211);
INSERT INTO Customer_phone VALUES(2,05345262211);
INSERT INTO Customer_phone VALUES(3,05324757132);

INSERT INTO Customer_phone VALUES(1,05345262212);
INSERT INTO Customer_phone VALUES(2,03264245465);
INSERT INTO Customer_phone VALUES(4,05345262243);

INSERT INTO Customer_phone VALUES(6,05332236343);
INSERT INTO Customer_phone VALUES(7,05345232213);
INSERT INTO Customer_phone VALUES(4,05338232212);

INSERT INTO Customer_phone VALUES(5,05445262212);
INSERT INTO Customer_phone VALUES(6,05732232210);
INSERT INTO Customer_phone VALUES(3,05348262235);

INSERT INTO Customer_phone VALUES(4,05347232232);
INSERT INTO Customer_phone VALUES(5,05354262234);
INSERT INTO Customer_phone VALUES(11,0555216322);

INSERT INTO Customer_phone VALUES(12,05312316354);
INSERT INTO Customer_phone VALUES(13,05328765336);
INSERT INTO Customer_phone VALUES(14,05563216434);

INSERT INTO Customer_phone VALUES(15,05556232713);
INSERT INTO Customer_phone VALUES(16,02124645684);
INSERT INTO Customer_phone VALUES(17,05333436566);

INSERT INTO Customer_phone VALUES(18,54544142152);
INSERT INTO Customer_phone VALUES(17,05058134701);
INSERT INTO Customer_phone VALUES(16,05355353535);

INSERT INTO Customer_phone VALUES(17,05449961233);
INSERT INTO Customer_phone VALUES(12,05347657667);
INSERT INTO Customer_phone VALUES(19,05322457688);

INSERT INTO Customer_phone VALUES(20,05055457932);
INSERT INTO Customer_phone VALUES(21,05342645787);
INSERT INTO Customer_phone VALUES(2,053345456422);


-- INSERT CUSTOMER_MAIL VALUES INTO THE ASSOCIATED TABLE --
INSERT INTO customer_mail VALUES(1,'nasitu@gmail.com');
INSERT INTO customer_mail VALUES(3,'simgesonmez@hotmail.com');
INSERT INTO customer_mail VALUES(6,'hdeniz@gmail.com');

INSERT INTO customer_mail VALUES(5,'akindemir@gmail.com');
INSERT INTO customer_mail VALUES(4,'muhtecimen@gmail.com');
INSERT INTO customer_mail VALUES(9,'fatihcandan@mynet.com');

INSERT INTO customer_mail VALUES(12,'yarenekin@yahoo.com');
INSERT INTO customer_mail VALUES(14,'elifay@gmail.com');
INSERT INTO customer_mail VALUES(18,'ozcanhatun@gmail.com');
INSERT INTO customer_mail VALUES(13,'berkanbulut@yahoo.com');


-- INSERT ACCOUNT VALUES INTO THE ACCOUNT TABLE --
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(1,'saving ','try',10000,1,1,'normal');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(2,'checking ','try',10000,2,4,'blocked');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(3,'saving ','try',10000,3,7,'normal');

INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(4,'checking ','try',10000,4,2,'blocked');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(5,'saving ','try',10000,5,4,'suspended');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(6,'checking ','try',10000,6,8,'suspended');

INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(7,'saving ','try',10000,7,2,'normal');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(8,'checking ','try',10000,8,4,'blocked');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(9,'saving ','try',10000,9,8,'normal');

INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(10,'saving ','try',10000,10,3,'suspended');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(11,'saving ','try',10000,11,4,'blocked');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(12,'saving ','try',10000,12,9,'normal');

INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(13,'checking ','try',10000,13,2,'blocked');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(14,'saving ','try',10000,14,4,'suspended');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(15,'checking ','try',10000,15,9,'blocked');

INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(16,'saving ','try',10000,16,3,'normal');
INSERT INTO account(id, type,currency,balance,customer_id,branch_id,status) VALUES(17,'checking ','try',10000,17,4,'normal');


-- INSERT MANAGER VALUES INTO THE MANAGER TABLE --
INSERT INTO manager VALUES('nasit', 'g12', 'ministry of treasury');
INSERT INTO manager VALUES('deniz', 'g12', 'ministry of treasury');
INSERT INTO manager VALUES('irem', 'g12', 'ministry of treasury');

INSERT INTO manager VALUES('egemen', 'g12', 'ministry of treasury');
INSERT INTO manager VALUES('simge', 'g12', 'ministry of treasury');
INSERT INTO manager VALUES('gizem', 'ayo', 'ministry of treasury');

INSERT INTO manager VALUES('sevgi', 'gezer', 'ministry of treasury');
INSERT INTO manager VALUES('ahmet', 'gezmez', 'ministry of treasury');
INSERT INTO manager VALUES('nebati', 'bakan', 'ministry of treasury');

INSERT INTO manager VALUES('zehra', 'dairebaskani', 'ministry of treasury');
INSERT INTO manager VALUES('abdulhamit', 'bakan', 'ministry of justice');
INSERT INTO manager VALUES('zekeriya', 'yardimci1', 'ministry of justice');

INSERT INTO manager VALUES('ugurhan', 'yardimci2', 'ministry of justice');
INSERT INTO manager VALUES('hasan', 'yardimci3', 'ministry of justice');
INSERT INTO manager VALUES('yakup', 'yardimci4', 'ministry of justice');

INSERT INTO manager VALUES('asuman', 'yardımci5', 'ministry of justice');
INSERT INTO manager VALUES('aycan', 'mudur1', 'ministry of justice');
INSERT INTO manager VALUES('aygun', 'mudur2', 'ministry of justice');

INSERT INTO manager VALUES('begum', 'mudur3', 'ministry of justice');
INSERT INTO manager VALUES('bahar', 'mudur4', 'ministry of justice');


-- INSERT INTERFERENCE VALUES INTO THE INTERFERENCE TABLE --
INSERT INTO interference VALUES('nebati', '1', SYSTIMESTAMP);
INSERT INTO interference VALUES('abdulhamit', '16', SYSTIMESTAMP);
INSERT INTO interference VALUES('abdulhamit', '16', SYSTIMESTAMP);

INSERT INTO interference VALUES('nebati', '2', SYSTIMESTAMP);
INSERT INTO interference VALUES('nebati', '1', SYSTIMESTAMP);
INSERT INTO interference VALUES('ugurhan', '1', SYSTIMESTAMP);

INSERT INTO interference VALUES('begum', '3', SYSTIMESTAMP);
INSERT INTO interference VALUES('begum', '4', SYSTIMESTAMP);
INSERT INTO interference VALUES('nebati', '5', SYSTIMESTAMP);

INSERT INTO interference VALUES('nebati', '17', SYSTIMESTAMP);
INSERT INTO interference VALUES('abdulhamit', '9', SYSTIMESTAMP);
INSERT INTO interference VALUES('abdulhamit', '16', SYSTIMESTAMP);

INSERT INTO interference VALUES('abdulhamit', '16', SYSTIMESTAMP);
INSERT INTO interference VALUES('aycan', '4', SYSTIMESTAMP);
INSERT INTO interference VALUES('nebati', '1', SYSTIMESTAMP);

INSERT INTO interference VALUES('ugurhan', '1', SYSTIMESTAMP);
INSERT INTO interference VALUES('begum', '3', SYSTIMESTAMP);
INSERT INTO interference VALUES('aygun', '2', SYSTIMESTAMP);

INSERT INTO interference VALUES('nebati', '5', SYSTIMESTAMP);
INSERT INTO interference VALUES('nebati', '17', SYSTIMESTAMP);
INSERT INTO interference VALUES('abdulhamit', '13', SYSTIMESTAMP);


-- INSERT TRANSACTION VALUES INTO THE TRANSACTION TABLE --
INSERT INTO transaction VALUES(1,3,1000,SYSDATE,'success');
INSERT INTO transaction VALUES(3,1,4000,SYSDATE,'success');
INSERT INTO transaction VALUES(6,2,150,SYSDATE,'success');

INSERT INTO transaction VALUES(7,8,400,SYSDATE,'success');
INSERT INTO transaction VALUES(5,2,800,SYSDATE,'success');
INSERT INTO transaction VALUES(2,3,4000,SYSDATE,'success');


-- INSERT LOAN VALUES INTO LOAN TABLE --
INSERT INTO loan VALUES(1,SYSDATE,8000,TO_DATE('20-JAN-2025'),14,48,400,4,52021);
INSERT INTO loan VALUES(2,SYSDATE,6000,TO_DATE('24-FEB-2025'),14,48,500,5,65221);
INSERT INTO loan VALUES(3,SYSDATE,4000,TO_DATE('24-FEB-2026'),14,48,500,7,52021);

INSERT INTO loan VALUES(4,SYSDATE,1000,TO_DATE('20-JAN-2027'),14,48,400,10,52021);
INSERT INTO loan VALUES(5,SYSDATE,20000,TO_DATE('24-FEB-2027'),14,48,500,11,65221);
INSERT INTO loan VALUES(6,SYSDATE,2000,TO_DATE('24-APR-2029'),14,48,500,15,98324);


-- INSERT BORROW VALUES INTO THE BORROW TABLE --
INSERT INTO borrow VALUES(4,52021,1);
INSERT INTO borrow VALUES(5,65221,2);
INSERT INTO borrow VALUES(7,52021,3);

INSERT INTO borrow VALUES(10,52021,4);
INSERT INTO borrow VALUES(11,65221,5);
INSERT INTO borrow VALUES(15,98324,6);


-- INSERT PAYMENT VALUES INTO THE PAYMENT TABLE --
INSERT INTO payment VALUES(4,52021,200,SYSDATE,'success');
INSERT INTO payment VALUES(5,65221,500,SYSDATE,'success');
INSERT INTO payment VALUES(7,52021,800,SYSDATE,'success');

INSERT INTO payment VALUES(10,52021,150,SYSDATE,'success');
INSERT INTO payment VALUES(11,65221,600,SYSDATE,'success');
INSERT INTO payment VALUES(15,98324,1200,SYSDATE,'success');


-- INSERT ATM VALUES INTO THE ATM TABLE --
INSERT INTO atm(id,balance,city,trade_reg_no,type) VALUES(1,100000,'izmir',52021,'try');
INSERT INTO atm(id,balance,city,trade_reg_no,type) VALUES(2,200000,'ankara',52021,'try');
INSERT INTO atm(id,balance,city,trade_reg_no,type) VALUES(3,1000,'istanbul',98324,'try');

INSERT INTO atm(id,balance,city,trade_reg_no,type) VALUES(4,560000,'hatay',52021,'try');
INSERT INTO atm(id,balance,city,trade_reg_no,type) VALUES(5,522000,'mersin',65221,'try');
INSERT INTO atm(id,balance,city,trade_reg_no,type) VALUES(6,645000,'adana',65221,'try');

INSERT INTO atm(id,balance,city,trade_reg_no,type) VALUES(7,547000,'antep',98324,'try');
INSERT INTO atm(id,balance,city,trade_reg_no,type) VALUES(8,100000,'kilis',52021,'try');


-- INSERT DEPOSIT VALUES INTO THE DEPOSIT TABLE --
INSERT INTO deposit VALUES(3,1,SYSDATE,1000);
INSERT INTO deposit VALUES(5,3,SYSDATE,3000);
INSERT INTO deposit VALUES(6,5,SYSDATE,1250);

INSERT INTO deposit VALUES(8,2,SYSDATE,5000);
INSERT INTO deposit VALUES(2,4,SYSDATE,1000);
INSERT INTO deposit VALUES(3,6,SYSDATE,100);

INSERT INTO deposit VALUES(1,7,SYSDATE,250);
INSERT INTO deposit VALUES(2,9,SYSDATE,1000);
INSERT INTO deposit VALUES(4,8,SYSDATE,700);


-- INSERT WITHDRAW VALUES INTO THE WITHDRAW TABLE --
INSERT INTO withdraw VALUES(3,1,SYSDATE,682);
INSERT INTO withdraw VALUES(6,10,SYSDATE,792);
INSERT INTO withdraw VALUES(5,6,SYSDATE,100);

INSERT INTO withdraw VALUES(8,7,SYSDATE,4250);
INSERT INTO withdraw VALUES(2,8,SYSDATE,620);
INSERT INTO withdraw VALUES(3,3,SYSDATE,739);

INSERT INTO withdraw VALUES(5,2,SYSDATE,125);
INSERT INTO withdraw VALUES(6,4,SYSDATE,700);


-- INSERT CARD VALUES INTO THE ASSOCIATED TABLES --
INSERT INTO card VALUES(542368756600,'credit',TO_DATE('21-JAN-2026'),'normal',3);
INSERT INTO credit VALUES(542368756600,5250);

INSERT INTO card VALUES(5423665434500,'debit',TO_DATE('27-FEB-2032'),'blocked',5);
INSERT INTO debit VALUES(5423665434500,0);

INSERT INTO card VALUES(357452453346,'credit',TO_DATE('03-APR-2026'),'normal',7);
INSERT INTO credit VALUES(357452453346,6350);

INSERT INTO card VALUES(1344336345352,'debit',TO_DATE('06-JUL-2026'),'normal',9);
INSERT INTO debit VALUES(1344336345352,3000);

INSERT INTO card VALUES(76543434564345,'credit',TO_DATE('16-OCT-2026'),'normal',4);
INSERT INTO credit VALUES(76543434564345,7000);

INSERT INTO card VALUES(1235322443532,'debit',TO_DATE('30-SEP-2026'),'normal',2);
INSERT INTO debit VALUES(1235322443532,6441);

INSERT INTO card VALUES(654345664323,'credit',TO_DATE('26-DEC-2026'),'normal',12);
INSERT INTO credit VALUES(654345664323,8000);

INSERT INTO card VALUES(753453467456464,'credit',TO_DATE('23-APR-2026'),'normal',5);
INSERT INTO credit VALUES(753453467456464,12000);

INSERT INTO card VALUES(54363463432421,'credit',TO_DATE('21-FEB-2026'),'normal',7);
INSERT INTO credit VALUES(54363463432421,19000);

CREATE USER G12 IDENTIFIED BY G12;
GRANT ALL ON ACCOUNT TO G12;
