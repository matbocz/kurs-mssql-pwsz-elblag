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

--3.1 Wyswietlic niepowtarzajace sie wartosci kolumny dzial z tabeli pracownik.
SELECT DISTINCT dzial FROM pracownik;
--3.2 Wyswietlic unikatowe wiersze zawierajace wartosci kolumn dzial i stanowisko w tabeli pracownik.
SELECT DISTINCT dzial, stanowisko FROM pracownik;
--3.3 Wyswietlic unikatowe wiersze zawierajace wartosci kolumn dzial i stanowisko w tabeli pracownik. Wynik posortuj malejaco wzgledem dzialu i stanowiska.
SELECT DISTINCT dzial, stanowisko FROM pracownik ORDER BY dzial DESC, stanowisko DESC;

--4.1 Znajdz pracownikow o imieniu Jan.  Wyswietl ich imiona i nazwiska.
SELECT imie, nazwisko FROM pracownik WHERE imie='Jan';
--4.2 Wyswietlic imiona i nazwiska pracownikow pracujacych na stanowisku sprzedawca.
SELECT imie, nazwisko FROM pracownik WHERE stanowisko='sprzedawca';
--4.3 Wyswietlic imiona, nazwiska, pensje pracownikow, ktorzy zarabiaja powyzej 1500 zl. Wynik posortuj malejaco wzgledem pensji.
SELECT imie, nazwisko, pensja FROM pracownik WHERE pensja>1500 ORDER BY pensja DESC;

--5.1 Z tabeli pracownik wyswietlic imiona, nazwiska, dzialy, stanowiska tych pracownikow, ktorzy pracuja w dziale obslugi klienta na stanowisku sprzedawca.
SELECT imie, nazwisko, dzial, stanowisko FROM pracownik WHERE dzial='obs³uga klienta' AND stanowisko='sprzedawca';
--5.2 Znalezc pracownikow pracujacych w dziale technicznym na stanowisku kierownika lub sprzedawcy. Wyswietl imie, nazwisko, dzial, stanowisko.
SELECT imie, nazwisko, dzial, stanowisko FROM pracownik WHERE dzial='techniczny' AND stanowisko='kierownik' OR dzial='techniczny' AND stanowisko='sprzedawca';
--5.3 Znalezc samochody, ktore nie sa marek fiat i ford.
SELECT * FROM samochod WHERE marka!='Fiat' AND marka!='Ford';

--6.1 Znalezc samochody marek mercedes, seat i opel.
SELECT * FROM samochod WHERE marka IN ('Mercedes', 'Seat', 'Opel');
--6.2 Znajdz pracownikow o imionach Anna, Marzena i Alicja. Wyswietl ich imiona, nazwiska i daty zatrudnienia.
SELECT imie, nazwisko, data_zatr FROM pracownik WHERE imie IN ('Anna', 'Marzena', 'Alicja');
--6.3 Znajdz klientow, ktorzy nie mieszkaja w Warszawie lub we Wroclawiu. Wyswietl ich imiona, nazwiska i miasta zamieszkania.
SELECT imie, nazwisko, miasto FROM klient WHERE miasto NOT IN ('Warszawa', 'Wroc³aw');