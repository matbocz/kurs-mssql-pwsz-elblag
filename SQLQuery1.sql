--1.1 Wyswietlic zawartosc wszystkich kolumn z tabeli pracownik.
SELECT * FROM pracownik;
--1.2 Z tabeli pracownik wyswietlic same imiona pracownikow.
SELECT imie FROM pracownik;
--1.3 Wyswietlic zawartosc kolumn imie, nazwisko i dzial z tabeli pracownik.
SELECT imie, nazwisko, dzial FROM pracownik;

--2.1 Wyswietlic zawartosc kolumn imie, nazwisko i pensja z tabeli pracownik. Wynik posortuj malejaco wzgledem pensji.
SELECT imie, nazwisko, pensja FROM pracownik ORDER BY pensja DESC;
--2.2 Wyswietl zawartosc kolumn nazwisko i imie z tabeli pracownik. Wynik posortuj rosnaco (leksykograficznie) wzgledem nazwiska i imienia.
SELECT nazwisko, imie FROM pracownik ORDER BY nazwisko ASC, imie ASC;
--2.3 Wyswietlic zawartosc kolumn nazwisko, dzial, stanowisko z tabeli pracownik. Wynik posortuj rosnaco wzgledem dzialu, a dla tych samych nazw dzialow malejaco wzgledem stanowiska.
SELECT nazwisko, dzial, stanowisko FROM pracownik ORDER BY dzial ASC, stanowisko DESC;

