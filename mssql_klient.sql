--18560 Mateusz Boczarski

--Ustawienie formatu daty.
SET DATEFORMAT ymd;
GO

--Zadanie 1
--Dane sa tabele: klient(id, imie, nazwisko), towar(id, nazwa, opis, ilosc_sztuk, cena_netto, podatek),
--zakup(id, klient_id, data_zakupu), koszyk(zakup_id, towar_id, ilosc, cena_netto, podatek).
--Dobierz odpowiednio typy danych, ograniczenia, klucze glowne i obce (pamietaj tez o autoinkrementacji),
--dodaj kilka przykladowych rekordow do kazdej tabeli.

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