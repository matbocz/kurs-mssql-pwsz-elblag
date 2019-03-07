--18560 Mateusz Boczarski

--Ustawienie formatu daty.
SET DATEFORMAT ymd;
GO

--**************************************************************************************************************************
--W pewnej bazie danych, w pewnym systemie zarzadzania baza danych SQL Server istnieje tabela pracownik(id, imie, nazwisko, pesel, data_ur, pensja, premia).
--dobierz typy atrybutow,
--dobierz ograniczenia dla atrybutow (postaraj sie!),
--nie zapomnij o autoinkrementacji :),
--napisz instrukcje SQL, ktora utworzy powyzszą tabele z dobranymi wczesniej ograniczeniami.
--**************************************************************************************************************************

--Usuniecie tabeli pracownik, jesli istnieje.
DROP TABLE IF EXISTS pracownik;
GO

--Utworzenie tabeli pracownik.
CREATE TABLE pracownik (
	id INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	imie VARCHAR(20) NOT NULL CHECK(LEN(imie) > 2),
	nazwisko VARCHAR(40) NOT NULL CHECK(LEN(nazwisko) > 2),
	pesel CHAR(11) NOT NULL UNIQUE CHECK(LEN(pesel) = 11),
	data_ur DATE NOT NULL,
	pensja DECIMAL(10, 2) DEFAULT 5500,
	premia DECIMAL(10, 2) DEFAULT 0
);
GO

--Wstawienie rekordow do tabeli pracownik.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES('Jan', 'Kowalski', '87111978112', '1987-11-19', 9000, 300);
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja) VALUES('Marek', 'Nowak', '78070881731', '1978-07-08', 7000);
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, premia) VALUES('Damian', 'Kroll', '55112484114', '1955-11-24', 400);
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur) VALUES('Justyna', 'Noga', '96122837664', '1996-12-28');
GO

--Wyswietlenie calej zawartosci tabeli pracownik.
SELECT * FROM pracownik;
GO

--**************************************************************************************************************************
--Dodawanie rekordow.
--**************************************************************************************************************************

--**************************************************************************************************************************
--Zadanie 1
--Nalezy uniemozliwic dodanie rekordu z niepoprawnym numerem pesel,
--napisz funkcje pomocnicza, wyswietl odpowiedni komunikat bledu.
--**************************************************************************************************************************

--Usuniecie funkcji pomocniczej, jesli istnieje.
DROP FUNCTION IF EXISTS spr_pesel;
GO

--Utworzenie funkcji pomocniczej.
CREATE FUNCTION spr_pesel(@pesel CHAR(11))
RETURNS BIT AS
BEGIN
	IF(LEN(@pesel) != 11) OR (ISNUMERIC(@pesel) = 0)
		RETURN 0
	DECLARE @wagi AS TABLE (pozycja TINYINT IDENTITY(1, 1), waga TINYINT)
	INSERT INTO @wagi VALUES (1), (3), (7), (9), (1), (3), (7), (9), (1), (3), (1)
	IF(SELECT SUM(CONVERT(TINYINT, SUBSTRING(@pesel, pozycja, 1)) * waga) % 10 FROM @wagi) = 0
		RETURN 1
	RETURN 0
END
GO

--Usuniecie wyzwalacza, jesli istnieje.
DROP TRIGGER IF EXISTS poprawny_pesel;
GO

--Utworzenie wyzwalacza.
CREATE TRIGGER poprawny_pesel ON pracownik
AFTER INSERT AS
BEGIN
	DECLARE poprawny_pesel_kursor CURSOR FOR SELECT pesel FROM inserted
	DECLARE @pesel CHAR(11)

	OPEN poprawny_pesel_kursor
	FETCH NEXT FROM poprawny_pesel_kursor INTO @pesel

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF dbo.spr_pesel(@pesel) = 0
		BEGIN
			RAISERROR('Nieprawidlowy numer pesel!', 1, 2)
			ROLLBACK
		END
		FETCH NEXT FROM poprawny_pesel_kursor INTO @pesel
	END

	CLOSE poprawny_pesel_kursor
	DEALLOCATE poprawny_pesel_kursor
END;
GO

--TEST, dwa poprawne pesele.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Jan', 'Kowalski', '90080517455', '1990-08-05', 8000, 300),
('Mariusz', 'Mysz', '81100216357', '1981-10-02', 7000, 500);
GO

--Test, dwa niepoprawne pesele.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Jacek', 'Strus', '99080749999', '1999-08-07', 5300, 200),
('Mateusz', 'Mrok', '83011539999', '1983-01-15', 8600, 100);
GO

--Test, jeden poprawny i jeden niepoprawny pesel.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Patrycja', 'Pilka', '92071314764', '1992-07-13', 9500, 200),
('Kornelia', 'Kora', '80072909999', '1980-07-29', 6200, 400);
GO

--Test, jeden niepoprawny i jeden poprawny pesel.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Magda', 'Mruczek', '46110219999', '1946-11-02', 5200, 200),
('Paulina', 'Kruczek', '64120988286', '1964-12-09', 9100, 40000);
GO

--Wyswietlenie calej zawartosci tabeli pracownik.
SELECT * FROM pracownik;
GO

--**************************************************************************************************************************
--Zadanie 2
--W dodawanym rekordzie nalezy poprawic imie tak, aby zawsze sie zaczynało z wielkiej litery,
--a pozostale litery byly male.
--**************************************************************************************************************************

--Usuniecie wyzwalacza, jesli istnieje.
DROP TRIGGER IF EXISTS imie_wielka;
GO

--Utworzenie wyzwalacza.
CREATE TRIGGER imie_wielka ON pracownik
AFTER INSERT AS
BEGIN
	DECLARE imie_wielka_kursor CURSOR FOR SELECT id FROM inserted
	DECLARE @id INTEGER

	OPEN imie_wielka_kursor
	FETCH NEXT FROM imie_wielka_kursor INTO @id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE pracownik SET imie = UPPER(LEFT(imie, 1)) + LOWER(SUBSTRING(imie, 2, LEN(imie))) WHERE id = @id
		FETCH NEXT FROM imie_wielka_kursor INTO @id
	END

	CLOSE imie_wielka_kursor
	DEALLOCATE imie_wielka_kursor
END;
GO

--Test, dwa niepoprawne imiona.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('paWel', 'Kowal', '85010174413', '1985-01-01', 8200, 100),
('kAROL', 'Plotek', '85010186715', '1985-01-01', 6500, 250);
GO

--Wyswietlenie calej zawartosci tabeli pracownik.
SELECT * FROM pracownik;
GO

--**************************************************************************************************************************
--Zadanie 3
--Dodawany pracownik powinien byc pelnoletni, w przeciwnym przypadku wyswietl odpowiedni komunikat bledu.
--**************************************************************************************************************************

--Usuniecie wyzwalacza, jesli istnieje.
DROP TRIGGER IF EXISTS pelnoletni;
GO

--Utworzenie wyzwalacza.
CREATE TRIGGER pelnoletni ON pracownik
AFTER INSERT AS
BEGIN
	DECLARE pelnoletni_kursor CURSOR FOR SELECT data_ur FROM inserted
	DECLARE @data_ur DATE

	OPEN pelnoletni_kursor
	FETCH NEXT FROM pelnoletni_kursor INTO @data_ur

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF DATEDIFF(year, @data_ur, GETDATE()) < 18
		BEGIN
			RAISERROR('Pracownik jest niepelnoletni!', 1, 2)
			ROLLBACK
		END
		FETCH NEXT FROM pelnoletni_kursor INTO @data_ur
	END

	CLOSE pelnoletni_kursor
	DEALLOCATE pelnoletni_kursor
END;
GO

--Test, dwie osoby pelnoletnie.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Krzysztof', 'Mrowka', '90090277613', '1990-09-02', 6000, 200),
('Andrzej', 'Baran', '90022022818', '1990-02-20', 7000, 400);
GO

--Test, dwie osoby niepelnoletnie.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Rafal', 'Banka', '05231003518', '2005-03-10', 1400, 200),
('Wojciech', 'Malpa', '10250507316', '2010-05-05', 3000, 350);
GO

--Wyswietlenie calej zawartosci tabeli pracownik.
SELECT * FROM pracownik;
GO

--**************************************************************************************************************************
--Zadanie 4
--Dodawana pensja nie moze byc mniejsza niz 5000 zl, w przeciwnym wypadku wyswietl odpowiedni komunikat bledu.
--**************************************************************************************************************************

--Usuniecie wyzwalacza, jesli istnieje.
DROP TRIGGER IF EXISTS minimalna_pensja;
GO

--Utworzenie wyzwalacza.
CREATE TRIGGER minimalna_pensja ON pracownik
AFTER INSERT AS
BEGIN
	DECLARE minimalna_pensja_kursor CURSOR FOR SELECT pensja FROM inserted
	DECLARE @pensja DECIMAL(10, 2)

	OPEN minimalna_pensja_kursor
	FETCH NEXT FROM minimalna_pensja_kursor INTO @pensja

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @pensja < 5000
		BEGIN
			RAISERROR('Pensja jest nizsza niz 5000zl!', 1, 2)
			ROLLBACK
		END
		FETCH NEXT FROM minimalna_pensja_kursor INTO @pensja
	END

	CLOSE minimalna_pensja_kursor
	DEALLOCATE minimalna_pensja_kursor
END;
GO

--Test, dwie pensje powyzej 5000zl.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Mikolaj', 'Stol', '70011079515', '1970-01-10', 5400, 400),
('Franciszek', 'Kropka', '77010762910', '1977-01-07', 6500, 100);
GO

--Test, dwie pensje ponizej 5000zl.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Bogdan', 'Zalewski', '88040407410', '1988-04-04', 2000, 300),
('Marek', 'Krowa', '87050503516', '1987-05-05', 1500, 400);
GO

--Wyswietlenie calej zawartosci tabeli pracownik.
SELECT * FROM pracownik;
GO
