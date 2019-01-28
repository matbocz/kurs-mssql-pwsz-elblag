--32   Tworzenie procedur skladowych (CREATE PROCEDURE)
--32.1 Napisac procedure o nazwie wypisz_samochody, ktora posiada tylko jeden parametr - marka samochodu. 
--     Procedura powinna wyswietlac wszystkie informacje z tabeli samochod o samochodach zadanej marki.
DROP PROCEDURE wypisz_samochody;
GO

CREATE PROCEDURE wypisz_samochody @marka VARCHAR(20)
AS
SELECT * FROM samochod WHERE marka = @marka;
GO

EXECUTE wypisz_samochody 'opel';
GO
--32.2 Napisac procedure o nazwie zwieksz_pensje posiadajaca dwa parametry: identyfikator pracownika i kwote. 
--     Procedura powinna zwiekszyc pensje pracownikowi, na ktorego wskazuje zadany identyfikator o zadana kwote. 
--     Przetestuj utworzona procedure - zwieksz pracownikowi o identyfikatorze rownym 1 pensje o 1000 zl.
DROP PROCEDURE zwieksz_pensje;
GO

CREATE PROCEDURE zwieksz_pensje @id INT, @kwota INT
AS
UPDATE pracownik SET pensja = pensja + @kwota WHERE id_pracownik = @id;
GO

EXECUTE zwieksz_pensje 1, 1000;
GO
--32.3 Napisz procedure o nazwie dodaj_klienta umozliwiajaca dodanie nowego klienta. Dane klienta powinny byc 
--     odczytane z parametrow procedury. Dobierz  odpowiednio parametry dla tworzonej procedury na podstawie kolumn 
--     tabeli klient. Przetestuj utworzona procedure - dodaj nowego klienta.
DROP PROCEDURE dodaj_klienta
GO

CREATE PROCEDURE dodaj_klienta
	@id_klient INT, @imie VARCHAR(15), @nazwisko VARCHAR(20),
	@nr_karty_kredyt CHAR(20), @firma VARCHAR(40), @ulica vARCHAR(24),
	@numer VARCHAR(8), @miasto VARCHAR(24), @kod CHAR(6), @nip CHAR(11), @telefon VARCHAR(16)
AS
INSERT INTO klient VALUES
(@id_klient, @imie, @nazwisko, @nr_karty_kredyt, @firma, @ulica, @numer, @miasto, @kod, @nip, @telefon);
GO

EXECUTE dodaj_klienta 543, 'Andrzej', 'Mleczko', '543256853', 'Samsung', 'Kwiatowa', '22A', 'Elbl¹g', '43-202', '44256754322', '543876320';
GO

--33   Tworzenie funkcji skladowych (CREATE FUNCTION)
--33.1 Napisac  funkcje o nazwie aktywnosc_klienta, ktora bedzie zwracac ilosc wypozyczen samochodow dla klienta o 
--     identyfikatorze zadanym jako parametr funkcji. Przetestuj utworzona funkcje - sprawdz ile samochodow wypozyczyl 
--     klient o identyfikatorze rownym 3.
DROP FUNCTION dbo.aktywnosc_klienta;  
GO 

CREATE FUNCTION dbo.aktywnosc_klienta(@id_klient INT) RETURNS INT 
BEGIN 
	RETURN(SELECT COUNT(*) FROM wypozyczenie WHERE id_klient = @id_klient) 
END; 
GO

SELECT dbo.aktywnosc_klienta(3) AS ile_wyp;
GO
--33.2 Napisac funkcje o nazwie ile_wypozyczen posiadajaca dwa parametry data_od i data_do. Funkcja powinna 
--     zwrocic ilosc wypozyczen samochodow w zadanym przedziale czasowym. Przetestuj utworzona funkcje - sprawdz ile 
--     zostalo wypozyczonych samochodow od 01.01.2000r. do 31.12.2000r.
DROP FUNCTION dbo.ile_wypozyczen
GO

CREATE FUNCTION dbo.ile_wypozyczen(@data_od DATETIME, @data_do DATETIME) RETURNS INT
BEGIN
	RETURN(SELECT COUNT(*) FROM wypozyczenie WHERE @data_od <= data_wyp AND @data_do >= data_wyp)
END;
GO

SELECT dbo.ile_wypozyczen('2000-01-01', '2000-12-31') AS ile_wyp;
GO
--33.3 Napisac funkcje o nazwie roznica_pensji nie posiadajaca parametrow i zwracajaca roznice pomiedzy najwieksza i 
--     najmniejsza pensja wsrod pracownikow wypozyczalni. Przetestuj utworzona funkcje.
DROP FUNCTION dbo.roznica_pensji
GO

CREATE FUNCTION dbo.roznica_pensji() RETURNS DECIMAL(8, 2)
BEGIN
	RETURN(SELECT MAX(pensja) - MIN(pensja) FROM pracownik)
END;
GO

SELECT dbo.roznica_pensji() AS roznica_pensji;
GO

--34   Tworzenie widokow (zlaczenia zewnetrzne, CREATE VIEW)
--34.1 Utworz widok o nazwie klient_raport zawierajacy informacje o ilosci wypozyczen kazdego z klientow (id_klient, 
--     imie, nazwisko). Uwzglednij klientow, ktorzy ani razu nie wypozyczyli samochodu. Za pomoca utworzonego widoku 
--     znajdz klientow, ktorzy wypozyczyli samochod wiecej niz raz.
DROP VIEW klient_raport; 
GO
 
CREATE VIEW klient_raport  
AS 
SELECT k.id_klient, k.imie, k.nazwisko, COUNT(w.id_klient) AS ilosc_wyp
FROM klient k LEFT JOIN wypozyczenie w ON k.id_klient = w.id_klient 
GROUP BY k.id_klient, k.imie, k.nazwisko; 
GO

SELECT * FROM klient_raport WHERE ilosc_wyp > 1;
GO
--34.2 Utworz widok o nazwie samochod_raport zawierajacy informacje o ilosci wypozyczen kazdego z samochodow 
--     (id_samochod, marka, typ). Uwzglednij samochody, ktore ani razu nie zostaly wypozyczone. Za pomoca utworzonego 
--     widoku znajdz samochod/samochody, ktore byly najczesciej wypozyczane.
DROP VIEW samochod_raport;
GO

CREATE VIEW samochod_raport
AS
SELECT s.id_samochod, s.marka, s.typ, COUNT(w.id_samochod) AS ilosc_wyp
FROM samochod s LEFT JOIN wypozyczenie w ON s.id_samochod = w.id_samochod
GROUP BY s.id_samochod, s.marka, s.typ;
GO

SELECT TOP 1 WITH TIES * FROM samochod_raport ORDER BY ilosc_wyp DESC;
GO
--34.3 Utworz widok o nazwie pracownik_raport zawierajacy informacje o ilosci wypozyczen samochodow przez 
--     pracownikow. Nie zapomnij uwzglednic pracownikow, ktorzy nie wypozyczyli zadnego samochodu. Za pomoca 
--     utworzonego widoku znajdz pracownikow, dla ktorych ilosc wypozyczen jest wieksza od sredniej ilosci wypozyczen 
--     samochodow przez pracownikow.
DROP VIEW pracownik_raport;
GO

CREATE VIEW pracownik_raport
AS
SELECT p.id_pracownik, p.imie, p.nazwisko, COUNT(w.id_pracow_wyp) AS ilosc_wyp
FROM pracownik p LEFT JOIN wypozyczenie w ON p.id_pracownik = w.id_pracow_wyp
GROUP BY p.id_pracownik, p.imie, p.nazwisko;
GO

SELECT imie, nazwisko, ilosc_wyp FROM pracownik_raport WHERE ilosc_wyp > (SELECT AVG(ilosc_wyp) FROM pracownik_raport)
GO
















--36
--36.1
DROP TRIGGER klient_anuluj_usuwanie;
GO

CREATE TRIGGER klient_anuluj_usuwanie ON klient
FOR DELETE AS
RAISERROR('Zabronione jest usuwanie klientów!',1,2)
ROLLBACK
GO

sp_helptrigger klient
sp_depends klient
sp_helptext klient_anuluj_usuwanie

DELETE FROM klient;
--36.2
CREATE TRIGGER pracownik_insert ON pracownik
AFTER INSERT AS 
BEGIN 
	DECLARE @pensja DECIMAL(8, 2), @dodatek DECIMAL(8, 2)
	SELECT @pensja = pensja, @dodatek = dodatek FROM inserted
	IF @pensja = 0
	BEGIN
		RAISERROR('Nie mozna dodac pracownika', 1, 2) 
		ROLLBACK
	END
	ELSE IF @dodatek = 0
	BEGIN
		RAISERROR('Nie mozna dodac pracownika', 1, 2) 
		ROLLBACK
	END
END
GO

INSERT INTO pracownik(id_pracownik, imie, nazwisko, data_zatr, dzial, stanowisko, pensja, dodatek, id_miejsce, telefon)
VALUES(112, 'Jan', 'Kowalski', '2012-02-14', 'spedycja', 'dyrektor', 0, 0, 3, '223344665');

--36.3
CREATE TRIGGER duplikat_miejsca ON miejsce
FOR INSERT AS
BEGIN
	DECLARE @id INT, @ulica VARCHAR(20), @numer VARCHAR(8), @miasto VARCHAR(24), @kod CHAR(8)
	SELECT @id = id_miejsce, @ulica = ulica, @numer = numer, @miasto = miasto, @kod = kod FROM inserted
	IF @@ROWCOUNT > 1 
	BEGIN
		RAISERROR('Nie mozna dodac wielu jednoczesnie', 1, 2)
		ROLLBACK
	END
	ELSE IF EXISTS
	(SELECT * FROM miejsce WHERE(@ulica IN(SELECT ulica FROM miejsce) AND @miasto IN(SELECT miasto FROM miejsce) AND @kod IN(SELECT kod FROM miejsce)))
	BEGIN
		RAISERROR('Istnieje juz takie miejsce', 1, 2)
		ROLLBACK
	END
END
GO

INSERT INTO miejsce(id_miejsce, ulica, numer, miasto, kod)
VALUES(6, 'Widmo', 11, 'Malbork', '82-200'), (7, 'Test', 23, 'Torun', '43-209')

--37
--37.1
ALTER TABLE samochod ADD usuniety BIT DEFAULT 0;
UPDATE samochod SET usuniety=0;
GO

CREATE TRIGGER usuniety_samochod ON samochod
INSTEAD OF DELETE AS
BEGIN
	UPDATE samochod
	SET usuniety=1
	WHERE id_samochod IN (SELECT id_samochod FROM deleted)
END
GO

DELETE FROM samochod WHERE id_samochod=3;
SELECT * FROM samochod;
--37.2
CREATE TRIGGER usun_miejsce_i_wypozyczenia