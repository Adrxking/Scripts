CREATE DATABASE correo;

USE correo;

CREATE TABLE virtual_domains (
    id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE virtual_users (
 id int(11) PRIMARY KEY auto_increment,
 domain_id int(11) NOT NULL,
 password varchar(32) NOT NULL,
 email varchar(100) NOT NULL,
 UNIQUE KEY email (email),
 FOREIGN KEY (domain_id) REFERENCES virtual_domains(id)
 ON DELETE CASCADE 
);

CREATE TABLE virtual_aliases (
 id int(11) PRIMARY KEY auto_increment,
 domain_id int(11) NOT NULL,
 source varchar(100) NOT NULL,
 destination varchar(100) NOT NULL,
 FOREIGN KEY (domain_id) REFERENCES virtual_domains(id)
 ON DELETE CASCADE
);

INSERT INTO correo.virtual_domains (id, name)
    VALUES (1, "aldeagala.icv");

INSERT INTO correo.virtual_domains (id, name)
    VALUES (2, "simpsons.icv");

INSERT INTO correo.virtual_users (id, domain_id, password, email) VALUES 
    (1, 1, MD5("asterix"), "asterix@aldeagala.icv"), (2, 2, MD5("homer"), "homer@simpsons.icv");

INSERT INTO correo.virtual_aliases (id, domain_id, source, destination) VALUES
    (1, 1, "bajito@aldeagala.icv", "asterix@aldeagala.icv"),
    (2, 2, "papa@simpsons.icv", "homer@simpsons.icv");

CREATE USER usuariocorreo@localhost identified by "usuariocorreo";

GRANT ALL PRIVILEGES ON correo.* to usuariocorreo@localhost;

FLUSH PRIVILEGES;