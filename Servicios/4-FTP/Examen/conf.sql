create database ftp;


grant select,insert,update,delete on ftp.* to 'proftpd'@'localhost' identified by 'proftpd';

flush privileges;

use ftp;

create table ftpgroup(
    groupname varchar(20) not null default '' primary key,
    gid smallint not null default 5500,
    members varchar(20) not null default ''
);

create table ftpuser(
    id integer not null auto_increment primary key,
    userid varchar(32) not null unique default '',
    passwd varchar(32) not null default '',
    uid smallint not null default 5500,
    gid smallint not null default 5500,
    homedir varchar(255) not null default '',
    shell varchar(16) not null default '/bin/false'
);

insert into ftpgroup values('migrupo',2001,'adrian'); 

insert into ftpuser values(1,'adrian','adrian',2001,2001,'/var/ftp/adrian','/bin/false');