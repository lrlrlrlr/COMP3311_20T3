-- COMP3311 20T3 Assignment 1
-- Calendar schema
-- Written by INSERT YOUR NAME HERE
-- use ass1_test;

-- Types
-- reference https://www.postgresql.org/docs/9.5/sql-createtype.html
create type AccessibilityType as enum ('read-write','read-only','none');
create type InviteStatus as enum ('invited','accepted','declined');
create type Visibility as enum ('public','private');
create type WeekDay as enum ('mon','tue','wed');
-- there should be more(add by yourself)
-- add more types/domains if you want

-- Tables
-- 注意! 这个是未完成版本, 总共有16个tables需要创建, 这里只有13个! 所有的tables都在课堂上用excel画出来了.
-- 请一定了解如何使用 	$ 3311 check_ass1 path/to/schema.sql 命令进行代码调试!!!

create table Users
(
    id       serial,
    email    text    not null unique,
    name     text    not null,
    password text    not null CHECK (password ~ '[^a-zA-Z0-9]'),
    admin    boolean not null,

    primary key (id)

);

create table Groups
(
    id      serial,
    name    text not null,
    user_id int  not null,
    foreign key (user_id) references Users (id),
    primary key (id)
);

create table Members
(
    users_id  int,
    groups_id int,
    primary key (users_id, groups_id),
    foreign key (users_id) REFERENCES users (id),
    foreign key (groups_id) REFERENCES groups (id)

);

create table calendars
(
    id             serial,
    colour         text              not null,
    name           text              not null,
    default_access AccessibilityType not null,
    users_id       int               not null,
    primary key (id),
    foreign key (users_id) references users (id)

);

create table accessibilities
(
    users_id     int,
    calendars_id int,
    access       AccessibilityType not null,
    primary key (users_id, calendars_id),
    foreign key (users_id) references users (id),
    foreign key (calendars_id) references calendars (id)
);


create table subscribed
(
    users_id     int,
    calendars_id int,
    colour       text,
    primary key (users_id, calendars_id),
    foreign key (users_id) references users (id),
    foreign key (calendars_id) references calendars (id)
);



create table events
(
    id           serial,
    title        text       not null,
    visibility   Visibility not null,
    location     text,
    start_time   time,
    end_time     time,
    calendars_id int        not null,
    users_id     int        not null,
    primary key (id),
    foreign key (calendars_id) references calendars (id),
    foreign key (users_id) references users (id)
);


create table alarms
(
    events_id int,
    alarm     timestamp not null,
    primary key (events_id),
    foreign key (events_id) references events (id)
);



create table one_day_events
(
    events_id int,
    date      date not null,
    primary key (events_id),
    foreign key (events_id) references events (id)
);

create table spanning_events
(
    events_id  int,
    start_date date not null,
    end_date   date not null,
    primary key (events_id),
    foreign key (events_id) references events (id)
);

create table recurring_events
(
--     id serial,-- if this needs it's own id?
    events_id  int,
    start_date date,
    end_date   date DEFAULT "ongoing",
    ntimes     int not null,
    primary key (events_id),
    foreign key (events_id) references events (id)
);

create table weekly_events
(
    events_id           int,
    recurring_events_id int,
    dayOfWeek           WeekDay not null,
    frequency           int     not null,
    primary key (events_id, recurring_events_id),
    foreign key (events_id) references recurring_events (events_id),
    foreign key (recurring_events_id) references recurring_events (events_id)
);

create table monthlyByDayEvents
(
    events_id   int,
    dayOfWeek   WeekDay not null,
    weekInMonth int     not null CHECK ( weekInMonth <= 5 and weekInMonth > 0),
    primary key (events_id),
    foreign key (events_id) references recurring_events (events_id)

)