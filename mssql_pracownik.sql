--18560 Mateusz Boczarski

--Ustawienie formatu daty.
SET DATEFORMAT ymd;
GO

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
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES('Jan', 'Kowalski', '90010196632', '1990-01-01', 9000, 300);
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja) VALUES('Marek', 'Nowak', '89021005678', '1989-02-10', 7000);
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, premia) VALUES('Damian', 'Kroll', '85051205472', '1985-05-12', 400);
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur) VALUES('Justyna', 'Noga', '91080403221', '1991-08-04');
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
	DECLARE kursor_poprawny_pesel CURSOR FOR SELECT pesel FROM inserted
	DECLARE @pesel CHAR(11)

	OPEN kursor_poprawny_pesel
	FETCH NEXT FROM kursor_poprawny_pesel INTO @pesel

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF dbo.spr_pesel(@pesel) = 0
		BEGIN
			RAISERROR('Nieprawidlowy numer pesel!', 1, 2)
			ROLLBACK
		END
		FETCH NEXT FROM kursor_poprawny_pesel INTO @pesel
	END

	CLOSE kursor_poprawny_pesel
	DEALLOCATE kursor_poprawny_pesel
END;
GO

--TEST, dwa poprawne pesele.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Jan', 'Kowalski', '90080517455', '1990-08-05', 8000, 300),
('Mariusz', 'Mysz', '81100216357', '1981-10-02', 7000, 500);
GO

--Test, dwa niepoprawne pesele.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Jan', 'Kowalski', '90080519999', '1990-08-05', 8000, 300),
('Mariusz', 'Mysz', '81100219999', '1981-10-02', 7000, 500);
GO

--Test, jeden poprawny i jeden niepoprawny pesel.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Patrycja', 'Pilka', '92071314764', '1992-07-13', 9000, 200),
('Kornelia', 'Kora', '80072909999', '1980-07-29', 8000, 400);
GO

--Test, jeden niepoprawny i jeden poprawny pesel.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES
('Kornelia', 'Kora', '80072909999', '1980-07-29', 8000, 400),
('Patrycja', 'Pilka', '92071314764', '1992-07-13', 9000, 200);
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
