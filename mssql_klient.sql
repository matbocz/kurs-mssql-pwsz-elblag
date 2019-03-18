--18560 Mateusz Boczarski

--Ustawienie formatu daty.
SET DATEFORMAT ymd;
GO

--=================================================================================================================================================
--Zadanie 1
--Dane sa tabele: klient(id, imie, nazwisko), towar(id, nazwa, opis, ilosc_sztuk, cena_netto, podatek),
--zakup(id, klient_id, data_zakupu), koszyk(zakup_id, towar_id, ilosc, cena_netto, podatek).
--Dobierz odpowiednio typy danych, ograniczenia, klucze glowne i obce (pamietaj tez o autoinkrementacji),
--dodaj kilka przykladowych rekordow do kazdej tabeli.
--=================================================================================================================================================

--Usuniecie tabeli klient, jesli istnieje.
DROP TABLE IF EXISTS klient;
GO

--Utworzenie tabeli klient.
CREATE TABLE klient (
	id INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	imie VARCHAR(20) NOT NULL CHECK(LEN(imie) > 2),
	nazwisko VARCHAR(40) NOT NULL CHECK(LEN(nazwisko) > 2)
);
GO

--Wstawienie rekordow do tabeli klient.
INSERT INTO klient(imie, nazwisko) VALUES
	('Maciej', 'Mrowka'), ('Rafal', 'Biurko'), 
	('Magda', 'Stol'), ('Paulina', 'Wieczorek');
GO

--Wyswietlenie zawartosci tabeli klient.
SELECT * FROM klient;
GO

--*************************************************************************************

--Usuniecie tabeli towar, jesli istnieje.
DROP TABLE IF EXISTS towar;
GO

--Utworzenie tabeli towar.
CREATE TABLE towar (
	id INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	nazwa VARCHAR(40) NOT NULL CHECK(LEN(nazwa) > 2),
	opis VARCHAR(200) NOT NULL CHECK(LEN(opis) > 10),
	ilosc_sztuk INTEGER DEFAULT 0 CHECK(ilosc_sztuk >= 0),
	cena_netto DECIMAL(10, 2) NOT NULL CHECK(cena_netto >= 0),
	podatek DECIMAL(10, 2) NOT NULL CHECK(podatek >= 0)
);
GO

--Wstawienie rekordow do tabeli towar.
INSERT INTO towar(nazwa, opis, ilosc_sztuk, cena_netto, podatek) VALUES
	('Logitech M185', 'Logitech M185 to mysz, ktora oferuje niezawodna lacznosc bezprzewodowa 2.4 GHz.', 10, 59.99, 0.22),
	('HP K2500', 'Klawiatura HP K2500 zawiera pelna klawiature numeryczna oraz dedykowane klawisze skrotow.', 21, 99.00, 0.22),
	('Kingston 16GB DataTraveler', 'Pamiec Flash USB Kingston DataTraveler czwartej generacji.', 44, 23.00, 0.22),
	('Creative 2.0 A60', 'Zestaw glosnikowy 2.0 do uniwersalnych zastosowan audio zwiazanych z rozrywka.', 8, 59.00, 0.22);
GO

--Wyswietlenie zawartosci tabeli towar.
SELECT * FROM towar;
GO

--*************************************************************************************

--Usuniecie tabeli zakup, jesli istnieje.
DROP TABLE IF EXISTS zakup;
GO

--Utworzenie tabeli zakup.
CREATE TABLE zakup (
	id INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	klient_id INTEGER NOT NULL FOREIGN KEY REFERENCES klient(id) ON DELETE CASCADE,
	data_zakupu DATE NOT NULL
);
GO

--Wstawienie rekordow do tabeli zakup.
INSERT INTO zakup(klient_id, data_zakupu) VALUES
	(1, '2010-03-03'), (1, '2011-04-20'), (2, '2012-01-10'), (2, '2018-08-01'),
	(3, '2014-05-22'), (3, '2016-09-10'), (3, '2019-01-28'), (4, '2015-12-17');
GO

--Wyswietlenie zawartosci tabeli zakup.
SELECT * FROM zakup;
GO

--*************************************************************************************

--Usuniecie tabeli koszyk, jesli istnieje.
DROP TABLE IF EXISTS koszyk;
GO

--Utworzenie tabeli koszyk.
CREATE TABLE koszyk (
	zakup_id INTEGER NOT NULL FOREIGN KEY REFERENCES zakup(id) ON DELETE CASCADE,
	towar_id INTEGER NOT NULL FOREIGN KEY REFERENCES towar(id) ON DELETE CASCADE,
	ilosc INTEGER NOT NULL CHECK(ilosc > 0),
	cena_netto DECIMAL(10, 2) NOT NULL CHECK(cena_netto >= 0),
	podatek DECIMAL(10, 2) NOT NULL CHECK(podatek >= 0),
	PRIMARY KEY(zakup_id, towar_id)
);
GO

--Wstawienie rekordow do tabeli koszyk.
INSERT INTO koszyk(zakup_id, towar_id, ilosc, cena_netto, podatek) VALUES
	(1, 3, 1, 23.00, 0.22), (2, 3, 3, 23.00, 0.22), (3, 1, 1, 59.99, 0.22), (4, 2, 1, 99.00, 0.22),
	(5, 3, 2, 23.00, 0.22), (6, 2, 5, 99.00, 0.22), (7, 3, 1, 23.00, 0.22), (8, 4, 2, 59.00, 0.22);
GO

--Wyswietlenie zawartosci tabeli zakup.
SELECT * FROM koszyk;
GO

--=================================================================================================================================================
--Zadanie 2
--Oprogramuj powyzsza baze danych tak, aby podczas sprzedazy towaru ilosc dostepnych sztuk sprzedawanego towaru byla uaktualniana automatycznie
--(czyli zmniejszana o ilosc zakupionych sztuk danego towaru przez klienta),
--uwzglednij przypadek, gdy chcemy sprzedac wieksza ilosc sztuk niz mamy rzeczywiscie dostepnych - wymysl jak mozna zareagowac na taka sytuacje
--(prosze sie postawic w sytuacji sprzedawcy - odmowa sprzedazy jest niekorzystna dla sprzedawcy,
--wiec prosze wymyslic inne rozwiazanie - dopuszczalna jest mozliwosc modyfikacji struktury bazy danych).

--Zadanie 3
--Utworz widok klient_statystyki(id,imie,nazwisko,ilosc_zakupow,suma_wydanej_kasy_brutto), gdzie id, imie, nazwisko to dane z tabeli klient,
--a ilosc_zakupow, suma_wydanej_kasy_brutto to wyniki dzialania funkcji agregujacych zliczajacych odpowiednio ilosc dokonanych zakupow przez danego klienta
--i laczna kwote brutto [czyli (1+podatek)*cena_netto] wydanych pieniedzy podczas tych zakupow.

--Zadanie 4
--Utworz wyzwalacze dzialajace na widoku klient_statystyki i reagujace na:
--dodanie klienta - dane klienta maja byc dodane do tabeli klienci,
--usuwanie klienta - klient ma byc usuwany z tabeli klient,
--modyfikacje danych klienta - dane klienta maja byc zmodyfikowane w tabeli klient,
--nalezy przewidziec przypadek, ze jest jednoczesnie wiele dodawanych, usuwanych i modyfikowanych danych.