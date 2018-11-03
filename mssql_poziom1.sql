--1 Projekcja wynikow zapytan (SELECT ... FROM ...)
--1.1 Wyswietlic zawartosc wszystkich kolumn z tabeli pracownik.
SELECT * FROM pracownik;
--1.2 Z tabeli pracownik wyswietlic same imiona pracownikow.
SELECT imie FROM pracownik;
--1.3 Wyswietlic zawartosc kolumn imie, nazwisko i dzial z tabeli pracownik.
SELECT imie, nazwisko, dzial FROM pracownik;

--2 Sortowanie wynikow zapytan (ORDER BY)
--2.1 Wyswietlic zawartosc kolumn imie, nazwisko i pensja z tabeli pracownik. Wynik posortuj malejaco wzgledem pensji.
SELECT imie, nazwisko, pensja FROM pracownik ORDER BY pensja DESC;
--2.2 Wyswietl zawartosc kolumn nazwisko i imie z tabeli pracownik. Wynik posortuj rosnaco (leksykograficznie) wzgledem nazwiska i imienia.
SELECT nazwisko, imie FROM pracownik ORDER BY nazwisko ASC, imie ASC;
--2.3 Wyswietlic zawartosc kolumn nazwisko, dzial, stanowisko z tabeli pracownik. Wynik posortuj rosnaco wzgledem dzialu, a dla tych samych nazw dzialow malejaco wzgledem stanowiska.
SELECT nazwisko, dzial, stanowisko FROM pracownik ORDER BY dzial ASC, stanowisko DESC;

--3 Eliminowanie duplikatow wynikow zapytan (DISTINCT)
--3.1 Wyswietlic niepowtarzajace sie wartosci kolumny dzial z tabeli pracownik.
SELECT DISTINCT dzial FROM pracownik;
--3.2 Wyswietlic unikatowe wiersze zawierajace wartosci kolumn dzial i stanowisko w tabeli pracownik.
SELECT DISTINCT dzial, stanowisko FROM pracownik;
--3.3 Wyswietlic unikatowe wiersze zawierajace wartosci kolumn dzial i stanowisko w tabeli pracownik. Wynik posortuj malejaco wzgledem dzialu i stanowiska.
SELECT DISTINCT dzial, stanowisko FROM pracownik ORDER BY dzial DESC, stanowisko DESC;

--4 Selekcja wynikow zapytan (WHERE)
--4.1 Znajdz pracownikow o imieniu Jan.  Wyswietl ich imiona i nazwiska.
SELECT imie, nazwisko FROM pracownik WHERE imie='Jan';
--4.2 Wyswietlic imiona i nazwiska pracownikow pracujacych na stanowisku sprzedawca.
SELECT imie, nazwisko FROM pracownik WHERE stanowisko='sprzedawca';
--4.3 Wyswietlic imiona, nazwiska, pensje pracownikow, ktorzy zarabiaja powyzej 1500 zl. Wynik posortuj malejaco wzgledem pensji.
SELECT imie, nazwisko, pensja FROM pracownik WHERE pensja>1500 ORDER BY pensja DESC;

--5 Warunki zlozone (AND, OR, NOT)
--5.1 Z tabeli pracownik wyswietlic imiona, nazwiska, dzialy, stanowiska tych pracownikow, ktorzy pracuja w dziale obslugi klienta na stanowisku sprzedawca.
SELECT imie, nazwisko, dzial, stanowisko FROM pracownik WHERE dzial='obs³uga klienta' AND stanowisko='sprzedawca';
--5.2 Znalezc pracownikow pracujacych w dziale technicznym na stanowisku kierownika lub sprzedawcy. Wyswietl imie, nazwisko, dzial, stanowisko.
SELECT imie, nazwisko, dzial, stanowisko FROM pracownik WHERE dzial='techniczny' AND stanowisko='kierownik' OR dzial='techniczny' AND stanowisko='sprzedawca';
--5.3 Znalezc samochody, ktore nie sa marek fiat i ford.
SELECT * FROM samochod WHERE marka!='Fiat' AND marka!='Ford';

--6 Predykat IN
--6.1 Znalezc samochody marek mercedes, seat i opel.
SELECT * FROM samochod WHERE marka IN ('Mercedes', 'Seat', 'Opel');
--6.2 Znajdz pracownikow o imionach Anna, Marzena i Alicja. Wyswietl ich imiona, nazwiska i daty zatrudnienia.
SELECT imie, nazwisko, data_zatr FROM pracownik WHERE imie IN ('Anna', 'Marzena', 'Alicja');
--6.3 Znajdz klientow, ktorzy nie mieszkaja w Warszawie lub we Wroclawiu. Wyswietl ich imiona, nazwiska i miasta zamieszkania.
SELECT imie, nazwisko, miasto FROM klient WHERE miasto NOT IN ('Warszawa', 'Wroc³aw');

--7 Predykat LIKE
--7.1 Wyswietlic imiona i nazwiska klientow, ktorych nazwisko zawiera litere K.
SELECT imie, nazwisko FROM klient WHERE nazwisko LIKE '%k%';
--7.2 Wyswietlic imiona i nazwiska klientow, dla ktorych nazwisko zaczyna sie na D, a konczy sie na SKI.
SELECT imie, nazwisko FROM klient WHERE nazwisko LIKE 'D%ski';
--7.3 Znalezc imiona i nazwiska klientow, ktorych nazwisko zawiera druga litere O lub A.
SELECT imie, nazwisko FROM klient WHERE nazwisko LIKE '_a%' OR nazwisko LIKE '_o%';

--8 Predykat BETWEEN
--8.1 Z tabeli samochod wyswietlic wiersze, dla ktorych pojemnosc silnika jest z przedzialu [1100,1600].
SELECT * FROM samochod WHERE poj_silnika BETWEEN 1100 AND 1600;
--8.2 Znalezc pracownikow, ktorzy zostali zatrudnieni pomiedzy datami 1997-01-01 a 1997-12-31.
SELECT * FROM pracownik WHERE data_zatr BETWEEN '1997-01-01' AND '1997-12-31';
--8.3 Znalezc samochody, dla ktorych przebieg jest pomiedzy 10000 a 20000 km lub pomiedzy 30000 a 40000 km.
SELECT * FROM samochod WHERE przebieg BETWEEN 10000 AND 20000 OR przebieg BETWEEN 30000 AND 40000;

--9 Wartosc NULL
--9.1 Znalezc pracownikow, ktorzy nie maja okreslonego dodatku do pensji.
SELECT * FROM pracownik WHERE dodatek IS NULL;
--9.2 Wyswietlic klientow, ktorzy posiadaja karte kredytowa.
SELECT * FROM klient WHERE nr_karty_kredyt IS NOT NULL;
--9.3 Dla kazdego pracownika wyswietl imie, nazwisko i wysokosc dodatku. Wartosc NULL z kolumny dodatek powinna byc wyswietlona jako 0.  Wskazowka: Uzyj funkcji COALESCE.
SELECT imie, nazwisko, COALESCE(dodatek, 0) AS dodatek FROM pracownik;

--10 Kolumny wyliczeniowe (COALESCE)
--10.1 Wyswietlic imiona, nazwiska pracownikow ich pensje i dodatki oraz kolumne wyliczeniowa do_zaplaty, zawierajaca sume pensji i dodatku. Wskazowka: Wartosc NULL z kolumny dodatek powinna byc wyswietlona jako zero.
SELECT imie, nazwisko, pensja, COALESCE(dodatek, 0) AS dodatek, pensja+COALESCE(dodatek, 0) AS do_zaplaty FROM pracownik;
--10.2 Dla kazdego pracownika wyswietl imie, nazwisko i wyliczeniowa kolumne nowa_pensja, ktora bedzie miala o 50% wieksza wartosc niz dotychczasowa pensja.
SELECT imie, nazwisko, 1.5*pensja AS nowa_pensja FROM pracownik;
--10.3 Dla kazdego pracownika oblicz ile wynosi 1% zarobkow (pensja + dodatek). Wyswietl imie, nazwisko i obliczony 1%. Wyniki posortuj rosnaco wzgledem obliczonego 1%.
SELECT imie, nazwisko, 0.01*(pensja+COALESCE(dodatek, 0)) AS jeden_procent_pensji FROM pracownik ORDER BY jeden_procent_pensji ASC;

--11 Ograniczanie wynikow wyszukiwania (TOP)
--11.1 Znajdz imie i nazwisko pracownika, ktory jako pierwszy zostal zatrudniony w wypozyczalni samochodow. Jest tylko jeden taki pracownik.
SELECT TOP 1 imie, nazwisko FROM pracownik ORDER BY data_zatr ASC;
--11.2 Wyswietl pierwszych czterech pracownikow z alfabetycznej listy (nazwiska i imiona) wszystkich pracownikow.
SELECT TOP 4 nazwisko, imie FROM pracownik ORDER BY nazwisko ASC, imie ASC;
--11.3 Wyszukaj informacje o ostatnim wypozyczeniu samochodu.
SELECT TOP 1 * FROM wypozyczenie ORDER BY data_wyp DESC;