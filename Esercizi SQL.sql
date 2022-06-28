ESERCIZIO 1:

Si consideri il seguente schema relazionale. Molte interrogazioni fanno riferimento al “numero di studenti”: si tratta dell’attributo NumStudenti della tabella Corsi. 

  
Aule(IdA, Nome, Edificio, Capienza) 
AuleCorsi(IdA*, IdC*, Ora, Giorno) 
Corsi(IdC, NomeC, AnnoAccademico, NumStudenti, IdD*) 
Docenti(IdD, Nome, Cognome, Dipartimento) 

  

Scrivere le interrogazioni SQL che restituiscono, senza ripetizioni, le seguenti informazioni: 

  
1) Per ogni Dipartimento con più di 30 docenti, riportare il nome del Dipartimento e il numero di docenti che vi appartengono 

2) Per ogni Dipartimento, riportare il nome del Dipartimento il numero di docenti che vi appartengono, il numero di Corsi che vengono insegnati dai docenti di quel dipartimento, e il numero totali di studenti di tali corsi 
 
3) Per ogni aula in cui si svolge un qualche corso con un numero di studenti maggiore della capienza dell’aula, riportare IdA, Nome, Capienza, Giorno del corso, e numero di studenti 

4) Per ogni aula riportare il nome, la capienza, l’IdA, e il numero di corsi diversi che si tengono in quell’aula 

5) Per ogni coppia di docenti con lo stesso cognome, riportare il nome e il cognome e il dipartimento del primo e il nome e il cognome e il dipartimento del secondo 

6) Per ogni corso in cui il docente appartiene al Dipartimento di ‘Informatica’ riportare IdC, Nome C, NumStudenti. 

7) Per ogni docente che tiene almeno un corso con più di 100 studenti riportare il nome del docente, il suo IdD, e il numero di studenti 

8) Per ogni docente che non tiene nessun corso con più di 100 studenti riportare il nome del docente e il suo IdD 

9) Per ogni docente che tiene solo corsi con più di 100 studenti riportare il nome del docente e il suo IdD 


TABELLE:

CREATE TABLE Aule (

	IdA int(10) NOT NULL,
	Nome char(20),
	Edificio char(20),
	Capienza int(255),
	PRIMARY KEY pk_aula (IdA)

);


CREATE TABLE AuleCorsi (

	IdA int(10) NOT NULL,
	IdC int(10) NOT NULL,
	Ora int(24),
	Giorno char(20),
	FOREIGN KEY fk_AuleCorsi (IdA) REFERENCES Aule,
	FOREIGN KEY fk_IdeCorsi (IdC) REFERENCES Corsi

);


CREATE TABLE Corsi (

	IdC int(10) NOT NULL,
	NomeC char(20),
	AnnoAccademico int(10),
	NumStudenti int (100),
	IdD int(10),
	PRIMARY KEY pk_IdC (IdC),
	FOREIGN KEY fk_Docente (IdD) REFERENCES Docenti

);


CREATE TABLE Docenti(

	IdD int(10) NOT NULL,
	Nome char(20),
	Cognome char(20),
	Dipartimento char(20),
	PRIMARY KEY pk_IdD (IdD)

);


DATI:


INSERT INTO Docenti  VALUES (58, 'Matteo', 'Ceccherini', 'Informatica');
INSERT INTO Docenti  VALUES (63, 'Giorgio', 'Mazzei', 'Informatica');
INSERT INTO Docenti  VALUES (15, 'Fabio', 'Marchetti', 'Informatica');
INSERT INTO Docenti  VALUES (48, 'Mattia', 'Pavone', 'Matematica');
INSERT INTO Docenti  VALUES (12, 'Luca', 'Matto', 'Ingegneria');
INSERT INTO Docenti  VALUES (20, 'Paolo', 'Gori', 'Scienze');
INSERT INTO Docenti  VALUES (03, 'Giovanni', 'Ceccherini', 'Politica');
INSERT INTO Aule  VALUES (150, 'Magna', 'Fibonacci', 300);
INSERT INTO Aule  VALUES (132, 'Sesta', 'Bocconi', 250);
INSERT INTO Aule  VALUES (110, 'Piccola', 'Fibonacci', 100);
INSERT INTO Corsi  VALUES (3, 'Matematica', 2020, 95, 63);
INSERT INTO Corsi  VALUES (4, 'Fisica', 2010, 55, 48);
INSERT INTO Corsi  VALUES (5, 'Informatica', 2020, 35, 58);
INSERT INTO Corsi  VALUES (1, 'Storia', 2020, 500, 12);
INSERT INTO Corsi  VALUES (2, 'Logica', 2020, 700, 20);
INSERT INTO AuleCorsi  VALUES (150, 3, 09, 'Giovedi');
INSERT INTO AuleCorsi  VALUES (132, 4, 16, 'Giovedi');
INSERT INTO AuleCorsi  VALUES (110, 4, 18, 'Lunedi');
INSERT INTO AuleCorsi  VALUES (150, 4, 13, 'Martedi');
INSERT INTO AuleCorsi  VALUES (132, 1, 10, 'Martedi');
INSERT INTO AuleCorsi  VALUES (110, 2, 14, 'Sabato');


DROP TABLE Aule;
DROP TABLE Corsi;
DROP TABLE AuleCorsi;
DROP TABLE Docenti;


SOLUZIONI:

1) Per ogni Dipartimento con più di 30 docenti, riportare il nome del Dipartimento e il numero di docenti che vi appartengono

SELECT d.Dipartimento, COUNT(*)
FROM Docenti d
GROUP BY d.Dipartimento
HAVING COUNT(*) > 30


2) Per ogni Dipartimento, riportare il nome del Dipartimento il numero di docenti che vi appartengono, il numero di Corsi che vengono insegnati dai docenti di quel dipartimento, e il numero totali di studenti di tali corsi 

SELECT d.Dipartimento, COUNT(DISTINCT d.IdD), COUNT(*), SUM(c.NumStudenti)
FROM Docenti d JOIN Corsi c ON (c.IdD=d.IdD)
GROUP BY d.Dipartimento
HAVING COUNT(*) >= 30


3) Per ogni aula in cui si svolge un qualche corso con un numero di studenti maggiore della capienza dell’aula, riportare IdA, Nome, Capienza, Giorno del corso, e numero di studenti 

SELECT a.IdA, a.Nome, a.Capienza, ac.Giorno, c.NumStudenti
FROM Aule a 
JOIN AuleCorsi ac ON (a.IdA=ac.IdA)
JOIN Corsi c ON (ac.IdC=c.IdC)
GROUP BY a.Capienza
HAVING c.NumStudenti > a.Capienza


4) Per ogni aula riportare il nome, la capienza, l’IdA, e il numero di corsi diversi che si tengono in quell’aula 

SELECT a.Nome, a.Capienza, a.IdA, COUNT(DISTINCT ac.IdC)
FROM Aule a 
JOIN AuleCorsi ac ON (a.IdA=ac.IdA)
GROUP BY a.Nome, a.Capienza, a.IdA


5) Per ogni coppia di docenti con lo stesso cognome, riportare il nome e il cognome e il dipartimento del primo e il nome e il cognome e il dipartimento del secondo 

SELECT d1.Nome, d1.Cognome, d1.Dipartimento, 
	   d2.Nome, d2.Cognome, d2.Dipartimento
FROM Docenti d1, Docenti d2
WHERE d2.Cognome = d1.Cognome AND d1.IdD < d2.IdD


6) Per ogni corso in cui il docente appartiene al Dipartimento di ‘Informatica’ riportare IdC, Nome C, NumStudenti.

SELECT c.IdC, c.NomeC, c.NumStudenti
FROM Corsi c 
JOIN Docenti d ON (c.IdD=d.IdD)
WHERE d.Dipartimento = 'Informatica'


7) Per ogni docente che tiene almeno un corso con più di 100 studenti riportare il nome del docente, il suo IdD, e il numero di studenti

SELECT d.Nome, d.IdD, c.NumStudenti
FROM Docenti d
JOIN Corsi c ON (c.IdD=d.IdD)
WHERE c.NumStudenti >= 100


8) Per ogni docente che non tiene nessun corso con più di 100 studenti riportare il nome del docente e il suo IdD 

SELECT d.Nome, d.IdD
FROM Docenti d 
WHERE NOT EXISTS (	SELECT *
					FROM Corsi c
					WHERE c.IdD=d.IdD AND c.NumStudenti >= 100 )



9) Per ogni docente che tiene solo corsi con più di 100 studenti riportare il nome del docente e il suo IdD

SELECT d.Nome, d.IdD
FROM Docenti d
WHERE NOT EXISTS (	SELECT *
					FROM Corsi c
					WHERE (c.IdD=d.IdD) AND NOT (c.NumStudenti >= 100 ))



Esercizio 2 :


Dato il seguente schema relazionale che descrive pratiche associate ciascuna a più clienti e seguita ciascuna da più dipendenti, rispondete alle seguenti interrogazioni.

Clienti(IdC, Nome, Cognome, Nazione)
PraticheClienti(IdP*, IdC*)
Pratiche(IdP, Data, NomeBreve, Descrizione, Budget)
PraticheDipendenti(IdP*, IdD*)
Dipendenti(IdD, NomeD, CognomeD, AnnoAssunzione)


a)  Per tutti le pratiche che sono associate anche a clienti italiani, riportare IdP e nome breve

	SELECT p.IdP, p.NomeBreve
	FROM Pratiche p
	WHERE EXISTS (	SELECT *
					FROM ClientiPreatiche cp
					JOIN Clienti c ON (c.IdC=cp.IcC)
					WHERE p.IdP=cp.IdP AND c.Nazione = 'Italia' )



	Oppure 


	SELECT DISTINCT p.IdP, p.NomeBreve
	FROM Pratiche p
	JOIN ClientiPreatiche cp ON (p.IdP=cp.IdP)
	JOIN Clienti c ON (c.IdC=cp.IcD)
	WHERE c.Nazione = 'Italia'


b)	Per tutti le pratiche che sono associate solo a clienti italiani, riportare IdP e nome breve

	SELECT p.IdP, p.NomeBreve
	FROM Pratiche p
	WHERE NOT EXISTS (	SELECT *
					FROM ClientiPreatiche cp
					JOIN Clienti c ON (c.IdC=cp.IcD)
					WHERE p.IdP=cp.IdP AND NOT (c.Nazione = 'Italia') )


c)	Per tutti le pratiche in cui tutti i clienti associati appartengono alla nazione N, riportare IdP, nome breve, e la nazione N

	SELECT p.IdP, p.NomeBreve, c1.Nazione
	FROM Pratiche p
	JOIN ClientiPreatiche cp1 ON (p.IdP=cp1.IdP)
	JOIN Clienti c1 ON (c1.IdC=cp1.IcD)
	WHERE NOT EXISTS (	SELECT *
						FROM ClientiPratiche cp2
						JOIN Clienti c2 ON (cp2.IdC=c2.IdC)
						WHERE p.IdP=cp2.IdP AND c1.Nazione <> c2.Nazione)

d)	Per ogni Nazione, il budget massimo tra i progetti che hanno almeno un cliente per quella nazione.

	SELECT c.Nazione, MAX(p.budget)
	FROM Clienti c
	JOIN ClientiPreatiche cp ON (p.IdP=cp.IdP)
	JOIN Pratiche p ON (p.IdP=cp.IcP)
	GROUP BY c.Nazione
	
e)	Per ogni cliente, IdC, Nome, Cognome, e numero di pratiche in cui è coinvolto quel cliente che abbiano il budget > 1000.

	SELECT c.IdC, c.Nome, c.Cognome, COUNT(c.IdC)
	FROM Clienti c
	JOIN ClientiPreatiche cp ON (p.IdP=cp.IdP)
	JOIN Pratiche p ON (p.IdP=cp.IcP)
	WHERE p.budget > 1000
	GROUP BY c.IdC, c.Nome, c.Cognome

f)	Per ogni dipendente che segue solo pratiche in cui almeno un cliente ha nazione = ‘Italia’, restituire IdD, Nome e Cognome

	SELECT d.IdD, d.Nome, d.Cognome
	FROM Dipendenti d
	WHERE NOT EXISTS (	SELECT *
						FROM DipendentiPratiche dp 
						JOIN Pratiche p ON (dp.IdP=p.IdP)
						WHERE dp.IdD=d.IdD AND NOT EXISTS (	SELECT *
															FROM PraticheClienti pc
															JOIN Clienti c ON (pc.IdC=C.IdC)
															WHERE pc.IdP=p.IdP AND c.Nazione='Italia') )


g)	Indicare in italiano, senza usare termini informatici ma solo facendo riferimento a dipendenti e pratiche, cosa ritorna la seguente interrogazione, assumendo che su ciascuna chiave primaria o esterna sia definito un vincolo NOT NULL

     SELECT d.IdD, d.Nome, d.Cognome
FROM  Dipendenti d LEFT JOIN PraticheDipendenti pd USING (d.IdD=pd.IdD)
WHERE pd.IdP IS NULL and d.AnnoAssunzione < 2018

     dire se la prossima interrogazione ritorna lo stesso risultato della precedente o ritorna un risultato diverso

     SELECT d.IdD, d.Nome, d.Cognome
FROM  Dipendenti d JOIN PraticheDipendenti pd USING (d.IdD=pd.IdD)
WHERE pd.IdP IS NULL and d.AnnoAssunzione < 2018




/* Numero dei proprietari di auto che vivono in Via Nova */

SELECT COUNT(a.targa)
FROM proprietari p
JOIN Auto a ON (p.targa=a.targa)
GROUP BY p.Indirizzo, a.targa
HAVING p.Indirizzo = 'Via Nova'

SELECT count(distinct CodiceFiscale)
FROM Proprietari JOIN Auto ON (Auto.targa = Proprietari.targa)
group by indirizzo
having indirizzo = "Via Nova";






SELECT s.CognomeStudente
FROM Studenti s1 
JOIN Esami e1 ON (s1.Matricola=e1.Matricola)
WHERE e.Voto='27' AND NOT EXISTS (SELECT *
						FROM Studenti s2
						JOIN Esami e2 ON (s2.Matricola=e2.Matricola)
						WHERE (e1.Matricola = e2.Matricola) AND (e1.CodiceMateria <> e2.CodiceMateria))


SELECT d.CodiceDocente, d.CognomeDocente, SUM(m.Crediti)
FROM Docenti d
JOIN Attivazioni a ON (d.CodiceDocente=a.CodiceDocente)
JOIN Materie m ON (a.CodiceMateria=m.CodiceMateria)
WHERE Anno='2020' 
GROUP BY d.CodiceDocente, d.CognomeDocente


SELECT d.CodiceDocente, d.CognomeDocente, m.CodiceMateria, m.NomeMateria
FROM Docenti d1
JOIN Attivazioni a1 ON (d1.CodiceDocente=a1.CodiceDocente)
JOIN Materie m1 ON (a1.CodiceMateria=m1.CodiceMateria)
WHERE NOT EXIST (	SELECT *
					FROM Docenti d2
					JOIN Attivazioni a2 ON (d2.CodiceDocente=a2.CodiceDocente)
					JOIN Materie m2 ON (a2.CodiceMateria=m2.CodiceMateria) 
					WHERE d1.CodiceDocente=d2.CodiceDocente AND m1.CodiceMateria <> m2.CodiceMateria)
GROUP BY d.CodiceDocente, d.CognomeDocente, m.CodiceMateria, m.NomeMateria


SELECT 	s1.Matricola, s1.CognomeStudente
		s2.Matricola, s2.CognomeStudente
FROM Studenti s1, Studenti s2
JOIN Iscrizioni i1, Iscrizioni i2 ON (s1.Matricola=i1.Matricola, s2.Matricola=i2.Matricola)
WHERE (SELECT MAX

SELECT DISTINCT e.Anno, m.NomeMateria, MAX(e.Voto)
FROM Esami e 
JOIN  Materie m ON (e.CodiceMateria=m.CodiceMateria)
GROUP BY e.Anno, m.NomeMateria






Ingredienti(IdIn,NomeIn,Famiglia)
IngredientiRicette(IdIn,IdR,percentuale)
Ricette(IdR,Nome,IdBirraioAutore)
RicetteCondiviseBirrai(IdR,IdB*)
Birrai(IdB, Nome, Soprannome, Nazione)


1) Per ogni ingrediente che appare con una percentuale superiore a 0,1 solo in ricette in cui l’IdBirraioAutore è 100, stampare IdIn e NomeIn


SELECT i.IdIn, i.NomeIn
FROM Ingredienti i 
JOIN IngredientiRicette ir ON (i.IdIn = ir.IdIn)
JOIN Ricette r ON (r.IdR = ir.IdR)
WHERE ir.percentuale > 0.1 AND r.IdBirraioAutore = 100


2) Per ogni Nazione, dare la Nazione e il numero totale di ricette il cui BirraioAutore è di quella nazione

SELECT b.Nazione ,  COUNT (*) AS NumeroTotaleRicette
FROM Birrai b 
JOIN Ricette r ON (r.IdBirraioAutore = b.IdB)
GROUP BY b.Nazione 


1 franco brogi Italia 
2 giovanni ghelli Italia 
3 matteo ceccherini Venezuela

1 Bamba 3
2 Rosa 2
2 Ciao 3


4) Per ogni birraio che è autore solo di ricette in cui appare almeno un ingrediente della famiglia ‘zuccheri’ con percentuale superiore allo 0,05, riportare Nome e Soprannome

SELECT b.Birrai , b.Soprannome 
FROM Birrai b 
WHERE EXISTS ( SELECT *
			FROM Ingredienti i 
			JOIN IngredientiRicette ir ON (i.IdIn = ir.IdIn)
			WHERE i.Famiglia <> 'zuccheri' <> ir.percentuale = 0.05)



5) Per ogni ricetta che è condivisa da birrai che appartengono tutti alla stessa nazione, riportare il Nome della ricetta e la Nazione a cui appartengono tutti i birrai che la condividono

SELECT r.Nome , b.Nazione
FROM Ricette r 
JOIN Birrai b1 ON (r.IdBirraioAutore = b1.IdB)
JOIN Birrai b2 ON (r.IdBirraioAutore = b2.IdB)
WHERE b1.Nazione = b2.Nazione AND b1.IdIn <> b2.IdIn 



Registi(IdRegista, Nome, NazioneRegista)
Film(IdFilm, Titolo, IdRegista*, Anno, CasaProduzione, Incasso)
FilmAttori(IdFilm*, IdAttore*)
Attori(IdAttore, IdAgente*, Nome, Cognome, DataNascita)
Parentele(IdAttore1*, IdAttore2*, gradoParentela)



1) Per ogni attore che, dopo il 2000, ha fatto almeno un film con incasso maggiore di 1000, restituire IdAttore e Cognome

SELECT a.IdAttore a.Cognome 
FROM Attori a 
WHERE F.Anno < 2000 AND EXISTS ( SELECT *
			FROM Film f, FilmAttori fa
			WHERE f.IdFilm=fa.IdFilm AND a.IdAttore=fa.IdAttore AND F.Incasso < 1000)



1)



R (AB -> D, AD -> B, A -> C, C -> A, BEC -> D, ABCDE)

AB -> D 
- B->D => B+=B NO
- A->D => A+=AC NO

AD -> B 
- D->B => D+=D NO
- A->B => A+=AC NO 

BEC -> D 
- EC->D => EC+=ECA NO
- BC->D => BC+=BCAD SI - E ESTRANEO -


Abbonamenti(IdA, Data, Riduzioni, CostoA)
AbbonamentiSale(IdA*, IdS*)
Sale(IdS, NomeS, IdM*, Dimensioni, TipoSala)
Connessioni(IdS1*,IdS2*)
Musei(IdM, NomeM, Nazione, CostoB)

scrivere le interrogazioni SQL che restituiscono le seguenti informazioni, senza ripetizioni

a) Per tutte le sale che sono connesse almeno a una sala dello stesso tipo, riportare IdS e NomeS

SELECT s.IdS , s.NomeS
FROM Sale s1 
JOIN Connesioni c1 ON (s1.IdS=c1.IdS1)
WHERE EXISTS ( SELECT *
			FROM Sale s2
			JOIN Connessioni c2 ON (s2.IdS=c2.IdS2)
			WHERE s1.IdA <> s2.IdA AND s1.TipoSala=s2.TipoSala)

b) Per tutte le sale che sono connesse solo a sale dello stesso tipo, riportare IdS e NomeS

SELECT s.IdS , s.NomeS
FROM Sale s1 
JOIN Connesioni c1 ON (s1.IdS=c1.IdS1)
WHERE NOT EXISTS ( SELECT *
			FROM Sale s2
			JOIN Connessioni c2 ON (s2.IdS=c2.IdS2)
			WHERE s1.IdA = s2.IdA AND s1.TipoSala<>s2.TipoSala)


c) Per ogni museo, riportre il NomeMuseo e la dimensione e il nome della sala di dimensione massima in quel museo

SELECT m.NomeMuseo, s.NomeS , MAX(s.Dimensione)
FROM Museo m
JOIN Sale s ON (m.IdM = s.IdM)
GROUP BY m.IdM, m.NomeMuseo


e) Per ogni Nazione, riportare la Nazione e la dimensione totale delle Sale dei Musei di quella nazione

SELECT m.Nazione, SUM (s.dimensione)
FROM Musei m
JOIN Sale s ON (m.IdM=s.IdM)
GROUP BY m.Nazione 

f) Per ogni abbonamento in cui ogni sala ha Tipo = ‘speciale’ o dimensione > 100, riportare IdA e Data.


Si consideri lo schema:

Studenti(Matricola, CognomeStudente)
Esami(Matricola*, CodiceMateria*, Voto, Anno, Semestre, CodiceDocente)
Docenti(CodiceDocente, CognomeDocente)
Attivazioni(CodiceMateria, Anno, CodiceDocente, LetteraCorso)
Materie(CodiceMateria, NomeMateria, Crediti)
Iscrizioni(Matricola*, CodiceMateria*, Anno)


Si scrivano le seguenti query:

a) Si trovi il nome di tutti gli studenti che hanno 27 come unico voto

SELECT s.CognomeStudente
FROM Studenti s1
JOIN Esami e1 ON (s1.Matricola=e1.Matricola)
WHERE e.Voto = '27' AND NOT EXIST ( 	SELECT *
								FROM Studenti s2
								FROM Esami e2 ON (s2.Matricola=e2.Matricola) 
								WHERE (e1.Matricola = e2.Matricola) AND (e1.CodiceMateria <> e2.CodiceMateria))

b)Per ogni docente, si restituisca il Codice, il Cognome, e il numero totale di crediti di
tutte le materie per cui è presente un attivazione per quel docente nel 2020

SELECT d.CodiceDocente, d.CognomeDocente, SUM(m.Crediti)
FROM Docenti d
JOIN Attivazioni a USING (CodiceDocente)
JOIN Materie m USING (CodiceMateria)
WHERE Anno = '2020'
GROUP BY d.CodiceDocente, d.CognomeDocente

c) Per ogni docente per cui tutte le attivazioni riguardano la stessa materia, si riporti
codice e cognome del docente, e codice e nome della materia in questione

SELECT d.CodiceDocente, d.CognomeDocente, m.CodiceMateria, m.NomeMateria
FROM Docenti d
JOIN Attivazioni a USING (CodiceDocente)
JOIN Materie m USING (CodiceMateria)


d) Per ogni coppia di studenti per cui il primo ha almeno 5 iscrizioni con la stessa
materia e anno del secondo, si riporti matricola e cognome di entrambi

e) Per ogni anno, riportare l’anno e la materia che ha ricevuto il voto più alto in
quell’anno, assieme a tale voto



Si consideri il seguente schema relazionale. Molte interrogazioni fanno riferimento al
“numero di studenti”: si tratta dell’attributo NumStudenti della tabella Corsi.


Aule(IdA, Nome, Edificio, Capienza)
AuleCorsi(IdA*, IdC*, Ora, Giorno)
Corsi(IdC, NomeC, AnnoAccademico, NumStudenti, IdD*)
Docenti(IdD, Nome, Cognome, Dipartimento)


Scrivere le interrogazioni SQL che restituiscono, senza ripetizioni, le seguenti informazioni
1) Per ogni Dipartimento con più di 30 docenti, riportare il nome del Dipartimento e il numero
di docenti che vi appartengono

2) Per ogni Dipartimento, riportare il nome del Dipartimento il numero di docenti che vi
appartengono, il numero di Corsi che vengono insegnati dai docenti di quel dipartimento, e il
numero totali di studenti di tali corsi

3) Per ogni aula in cui si svolge un qualche corso con un numero di studenti maggiore della
capienza dell’aula, riportare IdA, Nome, Capienza, Giorno del corso, e numero di studenti

3) Per ogni aula riportare il nome, la capienza, l’IdA, e il numero di corsi diversi che si
tengono in quell’aula

5) Per ogni coppia di docenti con lo stesso cognome, riportare il nome e il cognome e il
dipartimento del primo e il nome e il cognome e il dipartimento del secondo

6) Per ogni corso in cui il docente appartiene al Dipartimento di ‘Informatica’ riportare IdC,
Nome C, NumStudenti.

7) Per ogni docente che tiene almeno un corso con più di 100 studenti riportare il nome del
docente, il suo IdD, e il numero di studenti

8) Per ogni docente che non tiene nessun corso con più di 100 studenti riportare il nome del
docente e il suo IdD

9) Per ogni docente che tiene solo corsi con più di 100 studenti riportare il nome del docente e il
suo IdD


/*
Persone(IdP, Nome, Cognome, NazioneP, AnnoNascita, Citta')
Amicizie(IdP1*, IdP2*)
PersoneLibri(IdP, IdL)
Libri(IdL, Titolo, Autore, Anno, Lingua, IdE*)
Editori(IdE, Nome, Fatturato, NazioneE)
*/

-- a) Per tutte le persone che hanno letto solo libri in lingua inglese, riportare il nome e il cognome
SELECT p.nome, p.cognome
FROM Persone p
WHERE NOT EXISTS (
  SELECT *
  FROM PersoneLibri pl
  JOIN Libri l ON (pl.IdL = l.IdL)
  WHERE p.IdP = pl.IdP AND l.Lingua <> "Inglese"
)

-- b) Per tutte le persone che hanno letto almeno un libro in lingua inglese, riportare nome, cognome e numero di libri in lingua inglese letti
SELECT p.nome, p.cognome, COUNT(*) as LibriIngleseLetti
FROM Persone p
JOIN PersoneLibri pl ON (pl.IdP = p.IdP)
JOIN Libri l ON (pl.IdL = l.IdL)
WHERE l.Lingua = "Inglese"
GROUP BY IdP

-- c) Per tutte le persone che hanno letto almeno un libro in lingua inglese, riportare nome, cognome e numero TOTALE di libri letti (in qualunque lingua)
SELECT p.nome, p.cognome, COUNT(*) as LibriLetti
FROM Persone p
JOIN PersoneLibri pl ON (pl.IdP = p.IdP)
WHERE EXISTS(
  SELECT *
  FROM Libri l
  JOIN PersoneLibri pl2 ON (pl2.IdL = l.IdL)
  WHERE pl2.IdP = p.IdP AND p.Lingua = "Inglese"
)
GROUP BY IdP

-- e) Per ogni NazioneE riportare il numero totale di libri il cui editore appartiene a tale NazioneE
SELECT e.NazioneE, COUNT(*) as NLibriNazione
FROM Editore e
JOIN Libri l ON (l.IdE = e.IdE)
GROUP BY e.NazioneE

-- f) Per ogni coppia IdPUno, IdPDue di identificatori di persone diverse che hanno almeno 3 amici in comune, riportare la coppia e il numero
-- di amici in comune tra i due
SELECT a1.IdP1 as Persona1, a2.IdP1 as Persona2, COUNT(*) as AmiciInComune
FROM Amicizie a1
JOIN Amicizie a2 ON a1.IdP2 = a2.IdP2 AND a1.IdP1 < a2.IdP1
GROUP BY a1.IdP1, a2.IdP1;
-- Ho ipotizzato che P1 amica di P2 non implichi che P2 amica di P1

-- g) Per ogni coppia di persone per cui la prima ha letto tutti i libri letti dalla seconda, riportare il nome e il cognome di entrambi
SELECT p.nome, p.cognome, p2.nome, p2.cognome
FROM Persone p, Persone p2
WHERE NOT EXISTS (
  SELECT *
  FROM PersoneLibri pl2
  WHERE p2.IdP = pl2.IdP AND pl2.IdL NOT IN (
    SELECT pl.IdL
    FROM PersoleLibri pl
    WHERE p.IdP = pl.IdP
  )
)

/*
Si consideri lo schema:
Studenti(Matricola, CognomeStudente)
Esami(Matricola, CodiceMateria, Voto, Anno, Semestre, CodiceDocente)
Docenti(CodiceDocente, CognomeDocente)
Attivazioni(CodiceMateria, Anno, CodiceDocente, LetteraCorso)
Materie(CodiceMateria, NomeMateria, Crediti)
Iscrizioni(Matricola, CodiceMateria, Anno)

Si scrivano le seguenti query:
a) Si trovi il nome di tutti gli studenti che hanno 27 come unico voto
b)Per ogni docente, si restituisca il Codice, il Cognome, e il numero totale di crediti di
tutte le materie per cui è presente un attivazione per quel docente nel 2020
c) Per ogni docente per cui tutte le attivazioni riguardano la stessa materia, si riporti
codice e cognome del docente, e codice e nome della materia in questione
d) Per ogni coppia di studenti per cui il primo ha almeno 5 iscrizioni con la stessa
materia e anno del secondo, si riporti matricola e cognome di entrambi
e) Per ogni anno, riportare l’anno e la materia che ha ricevuto il voto più alto in
quell’anno, assieme a tale voto
2) Si consideri lo schema:
  R<ABCDE, {BC→A, BD→C, C→ E, C→ D}>
  a) Trovare una chiave
  b) Eseguire l’algoritmo di sintesi
*/

-- a)
SELECT s.CognomeStudente
FROM Studenti s1
JOIN Esami e1 ON (s1.Matricola=e1.Matricola)
WHERE e.Voto='27' AND NOT EXISTS (SELECT *
                        FROM Studenti s2
                        JOIN Esami e2 ON (s2.Matricola=e2.Matricola)
                        WHERE (e1.Matricola = e2.Matricola) AND (e1.CodiceMateria <> e2.CodiceMateria))


-- b)
SELECT d.CodiceDocente, d.CognomeDocente, SUM(m.Crediti)
FROM Docenti d
JOIN Attivazioni a ON (d.CodiceDocente=a.CodiceDocente)
JOIN Materie m ON (a.CodiceMateria=m.CodiceMateria)
WHERE Anno='2020'
GROUP BY d.CodiceDocente, d.CognomeDocente

-- c)
SELECT d.CodiceDocente, d.CognomeDocente, m.CodiceMateria, m.NomeMateria
FROM Docenti d
JOIN Attivazioni a ON (d.CodiceDocente=a.CodiceDocente)
JOIN Materie m ON (a.CodiceMateria=m.CodiceMateria)
WHERE NOT EXISTS (
  SELECT *
  FROM Docenti d1
  JOIN Attivazioni a1 ON (d1.CodiceDocente=a1.CodiceDocente)
  JOIN Materie m1 ON (a1.CodiceMateria=m1.CodiceMateria)
  WHERE d.CodiceDocente = d1.CodiceDocente
  AND m.CodiceMateria <> m1.CodiceMateria
)
GROUP BY d.CodiceDocente, d.CognomeDocente, m.CodiceMateria, m.NomeMateria

-- d)
SELECT s1.CognomeStudente
FROM
Studenti s1 JOIN Iscrizioni i1 ON (s1.Matricola = i1.Matricola),
Studenti s2 JOIN Iscrizioni i2 ON (s2.Matricola = i2.Matricola)
WHERE (
  SELECT MAX(cnt)
  FROM (
    SELECT count(*) as cnt
    FROM
    Studenti s11 JOIN Iscrizioni i1 ON (s11.Matricola = i11.Matricola),
    Studenti s21 JOIN Iscrizioni i2 ON (s21.Matricola = i21.Matricola)
    WHERE s1.Matricola = s11.Matricola
    AND s2.Matricola = s21.Matricola
    AND i11.CodiceMateria = i21.CodiceMateria
    AND i11.anno = i21.anno
    GROUP BY i11.CodiceMateria, i11.Anno
  ) as ContaIscrizioniComuni
)  >= 5;

-- e) Per ogni anno, riportare l’anno e la materia che ha ricevuto il voto più alto in quell’anno, assieme a tale voto

SELECT e.Anno, m.NomeMateria, e.Voto
FROM Esami e JOIN Materie m ON (e.CodiceMateria = m.CodiceMateria)
WHERE e.Voto = (
  SELECT MAX(e2.voto)
  FROM Esami e2
  WHERE e2.Anno = e.Anno
)
GROUP BY e.Anno





 Rastrelliere(IdR,Capacità,Città,Indirizzo)
 BicicletteRastrelliere(IdB*,IdR*, OraDataIn, OraDataOut)
 Biciclette(IdB,Modello,AnnoPresaServizio, Colore)
 Prenotazione(IdP, IdB*,IdRastrInizio*,IdRastrFine*, OraInizio, DataInizio, IdUt*)
 Utrenti(IdUt, Nome, Cognome, Genere, DataDiNascita, CittàUtente)

 Si risponda, senza ripetizioni, alle interrogazioni seguenti.

a) Per ogni bicicletta che si sia trovata solo su rastrelliere della Città di Pisa, restituire Id e Modello. [GIUSTA]

SELECT B.idB B.Modello
FROM Biciclette B
WHERE NOT EXISTS (SELECT*
 FROM BicicletteRastrelliere BR, Rastrelliere R
 WHERE B.idB=BC.idB AND R.idR=BR.idR AND NOT(R.Città=’Pisa’))

b) Per ogni bicicletta che risulti uscita da due rastrelliere diverse alla stessa data e ore (OraDataOut), riportare IdB, Modello, IdR e città della prima rastrelliera, e IdR e città dell’altra rastrelliera [GIUSTA]

SELECT DISTINCT B1.idB, B1.Modello, R1.idR, R1.città, R2.idR, R2.città,
FROM Rastrelliere R1, BicicletteRastrelliere BR1, Biciclette B1,Rastrelliere R2, BicicletteRastrelliere BR2, Biciclette B2
WHERE R1.idR=BR1.idR and B1.idB=BR1.idB AND R2.idR=BR2.idR and B2.idB=BR2.idB and B2.idB!=B1.idB and R1.idR!=R2.idR AND BR1.OraDataIn=BR2.OraDataIn AND BR1.OraDataOut=BR2.OraDataOut

c) Per ogni Modello di bicicletta, riportare il numero totale di utenti che hanno prenotato almeno una volta una bicicletta con tale modello [GIUSTA]

SELECT Count(*)
FROM Biciclette B, Prenotazione P, Utenti U
WHERE B.idB=P.IdB and P.idU=U.idU
GROUP BY B.Modello

d) Per ogni rastrelliera tale che TUTTE le bici che sono passate da tale rastrelliera sono state prenotate SOLO da utenti della stessa città della rastrelliera, riportare IdR e città [GIUSTA]
SELECT
FROM Rastrelliere R
WHERE NOT EXISTS(SELECT*
 FROM Prenotazione P
 WHERE R.idR=P.idR AND EXISTS(SELECT *
 FROM Utenti U
 WHERE P.idU=U.idU AND NOT (U.CittàUtente=R.Città)))

e) Opzionale: restituire Id, Nome e Cognome di ogni utente che non ha mai fatto alcuna prenotazione usando l’operatore LEFT OUTER JOIN

f)  Dire se le due query seguenti riportano lo stesso risultato, e in cosa consiste tale risultato, usando solo termini della lingua comune ma senza termini informatici, o dire se riportano due risultati diversi, e allora dite che cosa ritorna ciascuna

SELECT b.IdB, b.Modello
FROM Biciclette b, BicicletteRastrelliere br
WHERE b.IdB=br.IdB
 AND NOT EXISTS (SELECT *
 FROM Rastrelliere r
 WHERE br.IdR=r.IdR
 AND r.Città != Pisa

SELECT b.IdB, b.Modello
FROM Biciclette b
WHERE NOT EXISTS (SELECT *
 FROM BicicletteRastrelliere br, Rastrelliere r
 WHERE b.IdB=br.IdB AND  br.IdR=r.IdR
 AND r.Città != Pisa)

La prima e’ esistenziale la seconda e’ universale

0.	Si consideri il seguente schema
 R(ABCDE, { CB->A, CE->D, CB-> E, AB->E, D->E }
a.	Ci sono dipendenze ridondanti? Se sì, cancellarle [GIUSTA]
R(ABCDE, { CB->A, CE->D, AB->E, D->E }
⦁	Calcolare una chiave [GIUSTA]
CB
⦁	Applicare l’algoritmo di sintesi[GIUSTA]

CBA CED  ABE DE(lo elimino perché contenuto in CED)
controllo che almeno una di queste decomposizioni abbia gli attributi che siano superchiave per R 
CBA e’ superchiave per R
quindi la decomposizione e’

R1(CBA{CB->A}) R2(CED{CE->D,D->E }) R1(ABE{AB->E})

⦁	Applicare l’algoritmo di analisi[GIUSTA]
la dipendenza CE->D non e’ in FNBC poiche’ CE non e’ superchiave
Ottengo R1(CED{CE->D,D->E}) e R4(ABCE{AB->E,CB->A}) ma D-> non rispetta fnbc
quindi decompongo ancora R2(DE,D->E) e R3(CD)
anche AB->E non e in FNBC
R5(ABE,AB->E) R6(ABC,CB->A)
decomposizione finale
R2(DE,D->E) R3(CD) R5(ABE,AB->E) R6(ABC,CB->A)

3) Si consideri la seguente tabella che descive stazionamenti di biciclette:[GIUSTA]
BicicletteRastrelliere(IdB, ModelloB, IdR, IndirizzoR, CittàR, OraDataIn, OraDataOut)
E si formalizzino le seguenti dipendenze funzionali - una di loro non è una dipendenza, indicarlo.
a.	Non è possibile che la stessa bicicletta entri (OraDataIn) allo stesso momento in due rastrelliere diverse
 
 oradatain=, idB= -> idR=

⦁	Due biciclette con modello diverso non possono passare dalla stessa rastrelliera
 
 idR= -> modello=

⦁	Due biciclette con modello uguale possono uscire dalla stessa rastrelliera contemporaneamente (OraDataOut)

 Non è una dipendenza funzionale perché c’è la parola possono 



