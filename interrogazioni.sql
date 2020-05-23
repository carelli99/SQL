use universita;
/*
1. Mostrare nome e descrizione di tutti i moduli da 10 CFU.
*/

SELECT nome, descrizione
FROM modulo
WHERE CFU = 10

/*
2. Mostrare matricola, nome e cognome dei docenti che hanno piu di 20 anni
*/

SELECT matricola, nome, cognome
FROM docente
WHERE TIMESTAMPDIFF(YEAR, data_nascita, CURDATE()) > 20

/*
3. Mostrare nome, cognome e nome del dipartimento di ogni docente, ordinati dal piu giovane al piu anziano
*/

SELECT docente.nome, docente.cognome, dipartimento.nome, TIMESTAMPDIFF(YEAR, docente.data_nascita, CURDATE()) as anni
FROM docente, dipartimento
WHERE docente.dipartimento_codice = dipartimento.codice
ORDER BY anni ASC

SELECT docente.nome, docente.cognome, dipartimento.nome, TIMESTAMPDIFF(YEAR, docente.data_nascita, CURDATE()) as anni
FROM docente JOIN dipartimento ON docente.dipartimento_codice = dipartimento.codice
ORDER BY anni ASC

/*
4. Mostrare città e indirizzo di ogni sede del dipartimento di codice "1A"
*/

SELECT citta, indirizzo
FROM sede, dipartimento, sede_dipartimento
WHERE sede_dipartimento.codice_sede = sede.codice AND sede_dipartimento.codice_dipartimento = dipartimento.codice AND dipartimento.codice = "1B"

SELECT citta, indirizzo
FROM sede_dipartimento JOIN dipartimento ON sede_dipartimento.codice_dipartimento = dipartimento.codice JOIN sede ON sede_dipartimento.codice_sede = sede.codice
WHERE dipartimento.codice = "1B"

/*
5. Mostrare nome del dipartimento, città e indirizzo di ogni sede di ogni dipartimento, ordinate alfabeticamente prima per nome dipartimento,
poi per nome città e infine per indirizzo
*/

SELECT dipartimento.nome, citta, indirizzo
FROM sede_dipartimento JOIN sede ON sede_dipartimento.codice_sede = sede.codice JOIN dipartimento on sede_dipartimento.codice_dipartimento = dipartimento.codice
ORDER BY dipartimento.nome ASC, citta ASC, indirizzo ASC

/*
6. Mostrare il nome di ogni dipartimento che ha una sede a Taranto
*/

SELECT dipartimento.nome
FROM sede_dipartimento JOIN sede ON sede_dipartimento.codice_sede = sede.codice JOIN dipartimento on sede_dipartimento.codice_dipartimento = dipartimento.codice
WHERE sede.citta = "Taranto"

/*
7. Mostrare il nome di ogni dipartimento che non ha sede a Brindisi.
*/

SELECT dipartimento.nome
FROM sede_dipartimento JOIN sede ON sede_dipartimento.codice_sede = sede.codice JOIN dipartimento on sede_dipartimento.codice_dipartimento = dipartimento.codice
WHERE sede.citta <> "Brindisi"

/*
8. Mostrare media, numero esami sostenuti e totale CFU acquisiti dello studente con matricola 1
*/

SELECT AVG(esame.voto) as media, COUNT(esame.voto) as esami, SUM(cfu) as somma
FROM esame JOIN studente ON esame.matricola_studente = studente.matricola JOIN modulo ON esame.codice_modulo = modulo.codice
WHERE studente.matricola = "1"

/*
9. Mostrare nome, cognome, nome del corso di laurea, media e numero esami sostenuti dello studente con matricola 1
*/

SELECT studente.nome, studente.cognome, corso_laurea.nome, AVG(esame.voto) as media, COUNT(esame.voto) as esami
FROM studente JOIN esame ON studente.matricola = esame.matricola_studente JOIN corso_laurea ON studente.corso = corso_laurea.codice
WHERE studente.matricola = "1"

/*
10. Mostrare codice, nome e voto medio di ogni modulo, ordinati dalla media più alta alla più bassa
*/

SELECT modulo.codice, modulo.nome, AVG(esame.voto) as media
FROM modulo JOIN esame ON esame.codice_modulo = modulo.codice
GROUP BY modulo.codice
ORDER BY media DESC

/*
11. Mostrare nome e cognome del docente, nome e descrizione del modulo per ogni docente ed ogni modulo di cui quel docente abbia tenuto almeno un esame;
il risultato deve includere anche i docenti che non abbiano tenuto alcun esame, in quel caso rappresentati con un'unica tupla in cui
nome e descrizione del modulo avranno valore NULL.
*/

SELECT docente.nome, docente.cognome, modulo.nome, modulo.descrizione
FROM esame JOIN modulo ON esame.codice_modulo = modulo.codice RIGHT OUTER JOIN docente ON esame.matricola_docente = docente.matricola
GROUP BY docente.nome, modulo.nome

/*
12. Mostrare matricola, nome, cognome, data di nascita, media e numero esami sostenuti da ogni studente
*/

SELECT studente.matricola, studente.nome, studente.cognome, studente.data_nascita, AVG(esame.voto) as media, count(esame.voto) as esami
FROM esame JOIN studente ON esame.matricola_studente = studente.matricola
GROUP BY studente.matricola

/*
13. Mostrare matricola, nome, cognome, data di nascita, media e numero esami sostenuti di ogni studente del corso di laurea di codice "INF"
che abbia media maggiore di 27
*/

SELECT studente.matricola, studente.nome, studente.cognome, studente.data_nascita, AVG(esame.voto) as media, count(esame.voto) as esami
FROM esame JOIN studente ON esame.matricola_studente = studente.matricola JOIN corso_laurea ON studente.corso = corso_laurea.codice
WHERE studente.corso = "INF"
GROUP BY studente.matricola
HAVING media > 27

/*
14. Mostrare nome, cognome e data di nascita di tutti gli studenti che ancora non hanno superato nessun esame
*/

SELECT studente.nome, studente.cognome, studente.data_nascita
FROM studente
WHERE NOT EXISTS (SELECT esame.voto
                  FROM esame
                  WHERE esame.voto >= 18 AND esame.matricola_studente = studente.matricola)
GROUP BY studente.nome

SELECT studente.nome, studente.cognome, studente.data_nascita, COUNT(CASE WHEN esame.voto >= 18 THEN 1 END)
FROM studente
GROUP BY studente.nome
HAVING COUNT(CASE WHEN esame.voto <= 18 THEN 1 END) = 0

/*
15. Mostrare la matricola di tutti gli studenti che hanno superato almeno un esame e che hanno preso sempre voti maggiori di 26
*/

SELECT studente.matricola
FROM studente
WHERE NOT EXISTS (SELECT esame.voto
                  FROM esame
                  WHERE esame.voto <= 26 AND esame.matricola_studente = studente.matricola)
GROUP BY studente.nome

SELECT studente.matricola, COUNT(CASE WHEN esame.voto >= 26 THEN 1 END)
FROM studente
GROUP BY studente.nome
HAVING COUNT(CASE WHEN esame.voto >= 26 THEN 1 END) >= 1

/*
16. Mostrare, per ogni modulo, il numero degli studenti che hanno preso tra 18 e 21, quelli che hanno preso tra 22 e 26 e quelli che hannno preso tra 27 e 30
(con un' unica interrogazione)
*/

SELECT modulo.nome, COUNT(CASE WHEN esame.voto BETWEEN 18 AND 21 THEN 1 END) AS tra_18_e_21, COUNT(CASE WHEN esame.voto BETWEEN 22 AND 26 THEN 1 END) AS tra_22_e_26, COUNT(CASE WHEN esame.voto BETWEEN 27 AND 30 THEN 1 END) AS tra_27_e_30
FROM esame JOIN modulo ON esame.codice_modulo = modulo.codice
GROUP BY modulo.nome

/*
17. Mostrare matricola, nome, cognome e voto di ogni studente che ha preso un voto maggiore della media nel modulo "Test"
*/

SELECT studente.matricola, studente.nome, studente.cognome, esame.voto
FROM esame JOIN studente ON esame.matricola_studente = studente.matricola
WHERE esame.voto >= ANY(SELECT AVG(esame.voto)
                        FROM esame
                        WHERE esame.codice_modulo = "5")

/*
18. Mostrare matricola, nome, cognome di ogni studente che ha preso ad almeno 3 esami un voto maggiore della media per quel modulo
*/

SELECT studente.matricola, COUNT(esame.voto) AS maggiore_media
FROM esame JOIN studente ON esame.matricola_studente = studente.matricola JOIN modulo ON esame.codice_modulo = modulo.codice
WHERE esame.voto > ANY(SELECT AVG(esame.voto)
                        FROM esame JOIN studente ON esame.matricola_studente = studente.matricola JOIN modulo ON esame.codice_modulo = modulo.codice
                        GROUP BY modulo.codice) AND esame.codice_modulo = modulo.codice
GROUP BY studente.matricola
HAVING COUNT(esame.voto) >= 3
