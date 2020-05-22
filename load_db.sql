create database if not exists universita;
use universita;
drop table if exists corso_laurea;
create table corso_laurea
(
  codice varchar(6) PRIMARY KEY,
  nome varchar(20) NOT NULL,
  descrizione varchar(50)
);
insert into corso_laurea
    values('INF', 'Informatica', 'test');
insert into corso_laurea
    values('MED', 'Medicina', 'test');
drop table if exists dipartimento;
create table dipartimento
(
  codice varchar(6) PRIMARY KEY,
  nome varchar(20) NOT NULL
);
insert into dipartimento
    values('1A', 'Informatica');
insert into dipartimento
    values('1B', 'Ingegneria');
drop table if exists sede;
create table sede
(
  codice varchar(6) PRIMARY KEY,
  indirizzo varchar(20) NOT NULL,
  citta varchar(15) NOT NULL
);
insert into sede
    values('001', 'Via Dante 21', 'Bari');
insert into sede
    values('002', 'Via primo maggio 67', 'Taranto');
drop table if exists sede_dipartimento;
create table sede_dipartimento
(
  codice_sede varchar(6) references sede(codice),
  codice_dipartimento varchar(6) references dipartimento(codice),
  note varchar(50)
);
insert into sede_dipartimento
    values('001', '1A', 'prova');
insert into sede_dipartimento
    values('002', '1B', 'prova');
drop table if exists studente;
create table studente
(
  matricola varchar(6) PRIMARY KEY check(matricola > 0),
  corso varchar(30) references corso_laurea(codice),
  nome varchar(30) NOT NULL,
  cognome varchar(30) NOT NULL,
  data_nascita date NOT NULL,
  codice_fiscale char(16) UNIQUE,
  foto BLOB
);
insert into studente
    values('1', 'INF', 'Alessandro', 'Carelli', '1999-02-24', 'test', NULL);
insert into studente
    values('2', 'MED', 'Mario', 'Rossi', '1999-06-14', 'test2', NULL);
drop table if exists docente;
create table docente
(
  matricola varchar(6) PRIMARY KEY check(matricola > 0),
  dipartimento_codice varchar(30) references dipartimento(codice),
  nome varchar(30) NOT NULL,
  cognome varchar(30) NOT NULL,
  data_nascita date NOT NULL,
  codice_fiscale char(16) UNIQUE,
  foto BLOB
);
insert into docente
    values('3', '1A', 'Gianni', 'Piccinni', '1998-05-23', 'ciao', NULL);
insert into docente
    values('4', '1B', 'Franco', 'Tomai', '1999-11-29', 'ciao1', NULL);
insert into docente
    values('10', '1C', 'Armando', 'Tenna', '1997-11-29', 'ciao2', NULL);
drop table if exists modulo;
create table modulo
(
  codice varchar(6) PRIMARY KEY check(codice > 0),
  nome varchar(30) NOT NULL,
  descrizione varchar(50),
  cfu smallint NOT NULL check(cfu > 0)
);
insert into modulo
    values('5', 'Test', 'prova', '10');
insert into modulo
    values('6', 'Test2', 'prova2', '12');
drop table if exists esame;
create table esame
(
  matricola_studente varchar(6) references studente(matricola),
  codice_modulo varchar(6) references modulo(codice),
  matricola_docente varchar(6) references docente(matricola),
  data date NOT NULL,
  voto smallint NOT NULL,
  note varchar(50)
);
insert into esame
    values('1', '5', '4', '1999-03-26', '27', 'Nota');
insert into esame
    values('1', '5', '4', '1999-03-26', '20', 'Nota');
insert into esame
    values('2', '5', '4', '1999-03-26', '20', 'Nota');
insert into esame
    values('2', '6', '4', '1998-11-18', '28', 'Test2');
insert into esame
    values('2', '6', '3', '1999-01-23', '28', 'Bella');
insert into esame
    values('2', '6', '3', '1999-01-23', '28', 'Bella');
