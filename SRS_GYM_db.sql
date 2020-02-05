
alter table GYM_account_history drop constraint account_history_id_account_FK;
alter table GYM_account_history drop constraint account_history_action_type_ck;

alter table GYM_person drop constraint person_account_id_account_FK;
alter table GYM_person drop constraint person_status_ck;
alter table GYM_person drop constraint person_category_ck;
alter table GYM_person drop primary key;

--alter table trainer drop constraint trainer_person_id_account_FK;
--alter table trainer drop constraint trainer_program_trainerId_FK;

--alter table GYM_review drop constraint rev_person_id_acc_cus_FK;
--alter table GYM_review drop constraint rev_person_id_acc_tra_FK;
alter table GYM_review drop constraint rev_reciver_id_rec_cus_FK;
alter table GYM_review drop primary key;

alter table GYM_report_ui drop constraint report_person_id_acc_man_FK;
alter table GYM_report_ui drop constraint report_person_id_acc_tra_FK;
alter table GYM_report_ui drop primary key;


alter table GYM_manager_fb_to_trainer drop constraint feedback_person_id_acc_man_FK;
alter table GYM_manager_fb_to_trainer drop constraint feedback_person_id_acc_tra_FK;
alter table GYM_manager_fb_to_trainer drop constraint feedback_person_category_FK;


alter table GYM_program drop constraint program_customer_id_account_FK;
alter table GYM_program drop constraint program_trainer_id_account_FK;
alter table GYM_program drop constraint program_status_CK;
--alter table GYM_program drop constraint program_trainer_id_teacher_FK;


alter table GYM_schedule drop constraint schedule_program_id_FK;
alter table GYM_schedule drop constraint schedule_cus_id_customer_FK;
--alter table GYM_schedule drop constraint schedule_cus_category_CK;

alter table GYM_trainer_program_list drop constraint trainer_program_trainerId_FK;
alter table GYM_trainer_program_list drop constraint trainer_pro_programlist_br_FK;

alter table GYM_account drop primary key;
alter table GYM_account_history drop primary key;
alter table GYM_review drop primary key;
alter table GYM_report_ui drop primary key;
alter table GYM_manager_fb_to_trainer drop primary key;
alter table GYM_program drop primary key;
alter table GYM_schedule drop primary key;
alter table GYM_trainer_program_list drop primary key;

drop table GYM_account;
drop table GYM_account_history;
drop table GYM_review;
drop table GYM_report_ui;
drop table GYM_manager_fb_to_trainer;
drop table GYM_program;
drop table GYM_schedule;
--drop table GYM_trainer;
drop table GYM_person;
drop table GYM_trainer_program_list;
drop sequence GYM_account_id_account_seq;

Create table GYM_account
(
    id_account number(10) primary key, --Ying change from varchar(2) to number as it should use sequence
    password varchar2(15),
    status varchar2(15)
);
--create table GYM_account_history
--(
--    id_history varchar2(10) primary key,
--    id_account varchar2(10),
--    datetime date default SYSDATE not null,
--    login_address varchar2(20),
--    action_type varchar2(10) ,
--    constraint account_history_id_account_FK foreign key (id_account) references GYM_account(id_account),
--    constraint account_history_action_type_ck check (action_type in ('active','lock','inactive','archive'))
--);
create table GYM_person
(
    id_account number(10) unique,
    name_person varchar2(10),
    --photo bfile, Ying's comments: delete the photo field as we cannot input photo values
    person_category varchar2(10),
    telenum number(15),
    email varchar2(20),
    status varchar2(10),
    id_person varchar2(10) primary key,
    salary number(15,2),
    rank number(5),
    constraint person_account_id_account_FK foreign key (id_account) references GYM_account(id_account),
    constraint person_status_ck check (status in ('normal','sick_leave','quit')),
    constraint person_category_ck check (person_category in ('manager','trainer','customer'))--Ying's comment: change status to person_category
);
/*create table GYM_trainer
(
    id_account varchar2(10) unique,
    id_program_in_list varchar2(10),
    constraint trainer_person_id_account_FK foreign key(id_account) references person(id_account)
);
*/
create table GYM_review
(
    --id_account_cus varchar2(10),
    --id_account_tra varchar2(10),
    --person_category_review varchar2(10),
    id_review varchar2(10) primary key,
    date_review date default sysdate not null,
    content_review varchar2(50),
    id_reciver number(10),
    --constraint rev_person_id_acc_cus_FK foreign key (id_account_cus) references GYM_person(id_account),
    constraint rev_reciver_id_rec_cus_FK foreign key (id_reciver) references GYM_account(id_account)
    --constraint rev_person_id_acc_tra_FK foreign key (id_account_tra) references GYM_person(id_account)
    --constraint review_person_category_FK foreign key (person_category) references person(person_category),
    --constraint review_person_category_ck check (person_category_review in ('customer'))
);

create table GYM_report_ui
(
    id_account_manager number(10),
    id_account_trainer number(10),
    --person_category varchar2(10) check (person_category in ("manager")),
    id_report varchar2(10) primary key,
    date_report date default sysdate not null,
    constraint report_person_id_acc_man_FK foreign key (id_account_manager) references GYM_account(id_account),
    constraint report_person_id_acc_tra_FK foreign key (id_account_trainer) references GYM_account(id_account)
    --constraint report_person_category_ck check (person_category in ('customer'))
);
create table GYM_manager_fb_to_trainer
(
    creator_fb number(10),
    id_reciver number(10),
    person_category_feedback varchar2(10),
    date_feedback date default sysdate not null,
    id_feedback varchar2(10) primary key,
    content_feedback varchar2(50),
    constraint feedback_person_id_acc_man_FK foreign key (creator_fb) references GYM_account(id_account),
    constraint feedback_person_id_acc_tra_FK foreign key (id_reciver) references GYM_account(id_account),
    constraint feedback_person_category_FK check (person_category_feedback in ('manager','trainer'))
);
create table GYM_program
(
    id_program varchar2(10) primary key,
    category_program varchar2(15),
    hours_programs number(3),
    date_available_program date,
    id_trainer_creator number(10),
    status_program varchar2(10),
    --number_customer number(10),
    --id_customer varchar2(10), --YING'S COMMENTS: delete this field as we have senario that two customers take the same program 
                                --and SCHEDULE table can display the info about customers' program taken.
    --id_teacher varchar2(10),
    --constraint program_customer_id_account_FK foreign key(id_customer) references GYM_account(id_account), --YING CHANGED
    constraint program_trainer_id_account_FK foreign key(id_trainer_creator) references GYM_account(id_account),
    --constraint program_trainer_id_teacher_FK foreign key(id_teacher) references GYM_trainer_program_list(id_account_trainer),
    constraint program_status_CK check (status_program in('on-going','closed'))
);

create table GYM_schedule
(
    id_account_customer number(10) unique,
    --person_category_schedule varchar2(10) ,
    id_schedule varchar2(10) primary key,
    id_program varchar2(10),
    constraint schedule_program_id_FK foreign key(id_program) references GYM_program(id_program),
    constraint schedule_cus_id_customer_FK foreign key(id_account_customer) references GYM_account(id_account)
    --constraint schedule_cus_category_CK check (person_category_schedule in ('customer'))
);

create table GYM_trainer_program_list
(
    id_account_trainer number(10) ,
    id_program_in_list varchar2(10),
    primary key(id_account_trainer,id_program_in_list),
    constraint trainer_program_trainerId_FK foreign key(id_account_trainer) references GYM_account(id_account),
    constraint trainer_pro_programlist_br_FK foreign key(id_program_in_list) references GYM_program(id_program)
);

--Ying's Part
--Insert Values to Table GYM_account and create SEQUENCE to id_account
CREATE SEQUENCE GYM_account_id_account_seq 
    START WITH 1
    INCREMENT BY 1   
    NOCACHE
    NOCYCLE;
    
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, 'abc123', 'active');
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, 'aej3ko', 'active');
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, 'joikel', 'active');
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, '7dh3rh', 'active');
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, 'ih3kde', 'active');
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, '9fkehr', 'active');
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, 'opolki', 'active');
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, '7u3jik', 'active');
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, '89ekif', 'active');
INSERT INTO GYM_account (id_account, password, status )
VALUES (GYM_account_id_account_seq.NEXTVAL, '8ej3gd', 'active');

--Insert Values to Table GYM_person
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (1, 'Hellen', 'manager', 6472325263, 'hellen@gmail.com', 'normal', 'P001', 5000, NULL );
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (2, 'Jason', 'trainer', 6478884562, 'jason@gmail.com', 'normal', 'P002', 3000, 1 );
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (3, 'Tom', 'trainer', 6472325263, 'Tom@gmail.com', 'normal', 'P003', 3000, 2 );
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (4, 'Ann', 'trainer', 6472325278, 'Ann@gmail.com', 'normal', 'P004', 3000, 3 );
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (5, 'Jim', 'customer', 647233456, 'Jim@gmail.com', 'normal', 'P005', NULL, NULL );
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (6, 'Callen', 'customer', 6472325999, 'Callen@gmail.com', 'normal', 'P006', NULL, NULL );
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (7, 'Sue', 'customer', 6472321254, 'Sue@gmail.com', 'normal', 'P007', NULL, NULL );
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (8, 'Kim', 'customer', 6472325865, 'Kim@gmail.com', 'normal', 'P008', NULL, NULL );
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (9, 'Helin', 'customer', 6472325233, 'Helin@gmail.com', 'normal', 'P009', NULL, NULL );
INSERT INTO GYM_person (id_account, name_person, person_category, telenum, email, status, id_person, salary, rank )
VALUES (10, 'Wing', 'customer', 6472325474, 'Wing@gmail.com', 'normal', 'P010', NULL, NULL );

--Insert Values to Table GYM_program
INSERT INTO GYM_program (id_program, category_program, hours_programs, date_available_program, id_trainer_creator, status_program)
VALUES ('PR001', 'YOGA', 1.5, '23-NOV-2019', 2, 'on-going');
INSERT INTO GYM_program (id_program, category_program, hours_programs, date_available_program, id_trainer_creator, status_program)
VALUES ('PR002', 'CARDIO', 2, '13-NOV-2019', 2, 'on-going');
INSERT INTO GYM_program (id_program, category_program, hours_programs, date_available_program, id_trainer_creator, status_program)
VALUES ('PR003', 'STRENTH', 1, '10-NOV-2019', 3, 'on-going');
INSERT INTO GYM_program (id_program, category_program, hours_programs, date_available_program, id_trainer_creator, status_program)
VALUES ('PR004', 'AEROBIC', 2, '12-NOV-2019', 3, 'on-going');

--Li's part
--Insert value into table GYM_REVIEW
INSERT INTO GYM_REVIEW (ID_REVIEW, DATE_REVIEW, CONTENT_REVIEW, ID_RECIVER)
VALUES ('R001', '10-NOV-2019', 'nice teacher, recommend',2);
INSERT INTO GYM_REVIEW (ID_REVIEW, DATE_REVIEW, CONTENT_REVIEW, ID_RECIVER)
VALUES ('R002', '11-NOV-2019', 'good teacher recommend',2);
INSERT INTO GYM_REVIEW (ID_REVIEW, DATE_REVIEW, CONTENT_REVIEW, ID_RECIVER)
VALUES ('R003', '20-NOV-2019', 'not recommend',3);
INSERT INTO GYM_REVIEW (ID_REVIEW, DATE_REVIEW, CONTENT_REVIEW, ID_RECIVER)
VALUES ('R004', '21-NOV-2019', 'not recommend',3);
INSERT INTO GYM_REVIEW (ID_REVIEW, DATE_REVIEW, CONTENT_REVIEW, ID_RECIVER)
VALUES ('R005', '17-NOV-2019', 'recommend',4);
INSERT INTO GYM_REVIEW (ID_REVIEW, DATE_REVIEW, CONTENT_REVIEW, ID_RECIVER)
VALUES ('R006', '18-NOV-2019', 'recommend',4);

--Insert value into table GYM_REPORT_UI
INSERT INTO GYM_REPORT_UI (ID_ACCOUNT_MANAGER, ID_ACCOUNT_TRAINER, ID_REPORT, DATE_REPORT)
VALUES (1, 2, 'RE001','30-NOV-2019');
INSERT INTO GYM_REPORT_UI (ID_ACCOUNT_MANAGER, ID_ACCOUNT_TRAINER, ID_REPORT, DATE_REPORT)
VALUES (1, 3, 'RE002','1-DEC-2019');
INSERT INTO GYM_REPORT_UI (ID_ACCOUNT_MANAGER, ID_ACCOUNT_TRAINER, ID_REPORT, DATE_REPORT)
VALUES (1, 4, 'RE003','2-DEC-2019');

--Steve's part
INSERT INTO GYM_TRAINER_PROGRAM_LIST (ID_ACCOUNT_TRAINER,ID_PROGRAM_IN_LIST)
VALUES(2,'PR001');
INSERT INTO GYM_TRAINER_PROGRAM_LIST (ID_ACCOUNT_TRAINER,ID_PROGRAM_IN_LIST)
VALUES(3,'PR002');
INSERT INTO GYM_TRAINER_PROGRAM_LIST (ID_ACCOUNT_TRAINER,ID_PROGRAM_IN_LIST)
VALUES(4,'PR003');

INSERT INTO GYM_SCHEDULE (ID_ACCOUNT_CUSTOMER, ID_SCHEDULE,ID_PROGRAM)
VALUES(5,'S001','PR001');
INSERT INTO GYM_SCHEDULE (ID_ACCOUNT_CUSTOMER, ID_SCHEDULE,ID_PROGRAM)
VALUES(6,'S002','PR002');
INSERT INTO GYM_SCHEDULE (ID_ACCOUNT_CUSTOMER, ID_SCHEDULE,ID_PROGRAM)
VALUES(7,'S003','PR003');
INSERT INTO GYM_SCHEDULE (ID_ACCOUNT_CUSTOMER, ID_SCHEDULE,ID_PROGRAM)
VALUES(8,'S004','PR001');
INSERT INTO GYM_SCHEDULE (ID_ACCOUNT_CUSTOMER, ID_SCHEDULE,ID_PROGRAM)
VALUES(9,'S005','PR002');
INSERT INTO GYM_SCHEDULE (ID_ACCOUNT_CUSTOMER, ID_SCHEDULE,ID_PROGRAM)
VALUES(10,'S006','PR003');

INSERT INTO GYM_MANAGER_FB_TO_TRAINER (CREATOR_FB,ID_RECIVER,PERSON_CATEGORY_FEEDBACK,DATE_FEEDBACK,ID_FEEDBACK,CONTENT_FEEDBACK)
VALUES(1,2,'manager','1-DEC-2019','F001','Highly responsible, be on time.');
INSERT INTO GYM_MANAGER_FB_TO_TRAINER (CREATOR_FB,ID_RECIVER,PERSON_CATEGORY_FEEDBACK,DATE_FEEDBACK,ID_FEEDBACK,CONTENT_FEEDBACK)
VALUES(1,3,'manager','1-DEC-2019','F001','The trainer has good skills, and the cutomer give good review.');
INSERT INTO GYM_MANAGER_FB_TO_TRAINER (CREATOR_FB,ID_RECIVER,PERSON_CATEGORY_FEEDBACK,DATE_FEEDBACK,ID_FEEDBACK,CONTENT_FEEDBACK)
VALUES(1,4,'manager','1-DEC-2019','F001','Highly-Motivated, good skiiled trainer.Thank you for hardworking.');
