create table Account
(
    branchName text not null,
    accountNo  text primary key,
    balance    int  not null

);


create table Owner
(
    account  text primary key,
    customer int not null
);


INSERT INTO Account VALUES ('UNSW', 'U-245', 1000);
INSERT INTO Account VALUES ('UNSW', 'U-291', 2000);
INSERT INTO Account VALUES ('Randwick', 'R-245', 20000);
INSERT INTO Account VALUES ('Coogee', 'C-123', 15000);
INSERT INTO Account VALUES ('Coogee', 'C-124', 25000);
INSERT INTO Account VALUES ('Clovelly', 'Y-123', 1000);
INSERT INTO Account VALUES ('Maroubra', 'M-222', 5000);
INSERT INTO Account VALUES ('Maroubra', 'M-225', 12000);



INSERT INTO Owner VALUES ( 'U-245', 12345);
INSERT INTO Owner VALUES ( 'U-291', 12345);
INSERT INTO Owner VALUES ( 'R-245',12666);
INSERT INTO Owner VALUES ( 'C-123',12666);
INSERT INTO Owner VALUES ( 'C-124',32451);
INSERT INTO Owner VALUES ( 'Y-123',22735);
INSERT INTO Owner VALUES ( 'M-222', 92754);
INSERT INTO Owner VALUES ( 'M-225',12345);
