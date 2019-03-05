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
	pensja DECIMAL(10, 2) DEFAULT 2500,
	premia DECIMAL(10, 2) DEFAULT 0
);
GO

--Usuniecie calej zawartosci z tabeli pracownik.
DELETE FROM pracownik;
GO

--Wstawienie rekordow do tabeli pracownik.
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja, premia) VALUES('Jan', 'Kowalski', '90010196632', '1990-01-01', 3000, 300);
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, pensja) VALUES('Marek', 'Nowak', '89021005678', '1989-02-10', 4000);
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur, premia) VALUES('Damian', 'Kroll', '85051205472', '1985-05-12', 400);
INSERT INTO pracownik(imie, nazwisko, pesel, data_ur) VALUES('Justyna', 'Noga', '91080403221', '1991-08-04');
GO

--Wyswietlenie calej zawartosci tabeli pracownik.
SELECT * FROM pracownik;
GO
