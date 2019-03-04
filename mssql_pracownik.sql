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
