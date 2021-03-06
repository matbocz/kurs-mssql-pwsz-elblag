--18560 Mateusz Boczarski

--1   Projekcja wynikow zapytan (SELECT ... FROM ...)
--1.1 Wyswietlic zawartosc wszystkich kolumn z tabeli pracownik.
SELECT * FROM pracownik;
--1.2 Z tabeli pracownik wyswietlic same imiona pracownikow.
SELECT imie FROM pracownik;
--1.3 Wyswietlic zawartosc kolumn imie, nazwisko i dzial z tabeli pracownik.
SELECT imie, nazwisko, dzial FROM pracownik;

--2   Sortowanie wynikow zapytan (ORDER BY)
--2.1 Wyswietlic zawartosc kolumn imie, nazwisko i pensja z tabeli pracownik. Wynik posortuj malejaco wzgledem pensji.
SELECT imie, nazwisko, pensja FROM pracownik ORDER BY pensja DESC;
--2.2 Wyswietl zawartosc kolumn nazwisko i imie z tabeli pracownik. Wynik posortuj rosnaco (leksykograficznie) wzgledem nazwiska i imienia.
SELECT nazwisko, imie FROM pracownik ORDER BY nazwisko ASC, imie ASC;
--2.3 Wyswietlic zawartosc kolumn nazwisko, dzial, stanowisko z tabeli pracownik. Wynik posortuj rosnaco wzgledem dzialu, a dla tych samych nazw dzialow malejaco wzgledem stanowiska.
SELECT nazwisko, dzial, stanowisko FROM pracownik ORDER BY dzial ASC, stanowisko DESC;

--3   Eliminowanie duplikatow wynikow zapytan (DISTINCT)
--3.1 Wyswietlic niepowtarzajace sie wartosci kolumny dzial z tabeli pracownik.
SELECT DISTINCT dzial FROM pracownik;
--3.2 Wyswietlic unikatowe wiersze zawierajace wartosci kolumn dzial i stanowisko w tabeli pracownik.
SELECT DISTINCT dzial, stanowisko FROM pracownik;
--3.3 Wyswietlic unikatowe wiersze zawierajace wartosci kolumn dzial i stanowisko w tabeli pracownik. Wynik posortuj malejaco wzgledem dzialu i stanowiska.
SELECT DISTINCT dzial, stanowisko FROM pracownik ORDER BY dzial DESC, stanowisko DESC;

--4   Selekcja wynikow zapytan (WHERE)
--4.1 Znajdz pracownikow o imieniu Jan.  Wyswietl ich imiona i nazwiska.
SELECT imie, nazwisko FROM pracownik WHERE imie='Jan';
--4.2 Wyswietlic imiona i nazwiska pracownikow pracujacych na stanowisku sprzedawca.
SELECT imie, nazwisko FROM pracownik WHERE stanowisko='sprzedawca';
--4.3 Wyswietlic imiona, nazwiska, pensje pracownikow, ktorzy zarabiaja powyzej 1500 zl. Wynik posortuj malejaco wzgledem pensji.
SELECT imie, nazwisko, pensja FROM pracownik WHERE pensja>1500 ORDER BY pensja DESC;

--5   Warunki zlozone (AND, OR, NOT)
--5.1 Z tabeli pracownik wyswietlic imiona, nazwiska, dzialy, stanowiska tych pracownikow, ktorzy pracuja w dziale obslugi klienta na stanowisku sprzedawca.
SELECT imie, nazwisko, dzial, stanowisko FROM pracownik WHERE dzial='obs�uga klienta' AND stanowisko='sprzedawca';
--5.2 Znalezc pracownikow pracujacych w dziale technicznym na stanowisku kierownika lub sprzedawcy. Wyswietl imie, nazwisko, dzial, stanowisko.
SELECT imie, nazwisko, dzial, stanowisko FROM pracownik WHERE dzial='techniczny' AND stanowisko='kierownik' OR dzial='techniczny' AND stanowisko='sprzedawca';
--5.3 Znalezc samochody, ktore nie sa marek fiat i ford.
SELECT * FROM samochod WHERE marka!='Fiat' AND marka!='Ford';

--6   Predykat IN
--6.1 Znalezc samochody marek mercedes, seat i opel.
SELECT * FROM samochod WHERE marka IN ('Mercedes', 'Seat', 'Opel');
--6.2 Znajdz pracownikow o imionach Anna, Marzena i Alicja. Wyswietl ich imiona, nazwiska i daty zatrudnienia.
SELECT imie, nazwisko, data_zatr FROM pracownik WHERE imie IN ('Anna', 'Marzena', 'Alicja');
--6.3 Znajdz klientow, ktorzy nie mieszkaja w Warszawie lub we Wroclawiu. Wyswietl ich imiona, nazwiska i miasta zamieszkania.
SELECT imie, nazwisko, miasto FROM klient WHERE miasto NOT IN ('Warszawa', 'Wroc�aw');

--7   Predykat LIKE
--7.1 Wyswietlic imiona i nazwiska klientow, ktorych nazwisko zawiera litere K.
SELECT imie, nazwisko FROM klient WHERE nazwisko LIKE '%k%';
--7.2 Wyswietlic imiona i nazwiska klientow, dla ktorych nazwisko zaczyna sie na D, a konczy sie na SKI.
SELECT imie, nazwisko FROM klient WHERE nazwisko LIKE 'D%ski';
--7.3 Znalezc imiona i nazwiska klientow, ktorych nazwisko zawiera druga litere O lub A.
SELECT imie, nazwisko FROM klient WHERE nazwisko LIKE '_a%' OR nazwisko LIKE '_o%';

--8   Predykat BETWEEN
--8.1 Z tabeli samochod wyswietlic wiersze, dla ktorych pojemnosc silnika jest z przedzialu [1100,1600].
SELECT * FROM samochod WHERE poj_silnika BETWEEN 1100 AND 1600;
--8.2 Znalezc pracownikow, ktorzy zostali zatrudnieni pomiedzy datami 1997-01-01 a 1997-12-31.
SELECT * FROM pracownik WHERE data_zatr BETWEEN '1997-01-01' AND '1997-12-31';
--8.3 Znalezc samochody, dla ktorych przebieg jest pomiedzy 10000 a 20000 km lub pomiedzy 30000 a 40000 km.
SELECT * FROM samochod WHERE przebieg BETWEEN 10000 AND 20000 OR przebieg BETWEEN 30000 AND 40000;

--9   Wartosc NULL
--9.1 Znalezc pracownikow, ktorzy nie maja okreslonego dodatku do pensji.
SELECT * FROM pracownik WHERE dodatek IS NULL;
--9.2 Wyswietlic klientow, ktorzy posiadaja karte kredytowa.
SELECT * FROM klient WHERE nr_karty_kredyt IS NOT NULL;
--9.3 Dla kazdego pracownika wyswietl imie, nazwisko i wysokosc dodatku. Wartosc NULL z kolumny dodatek powinna byc wyswietlona jako 0.
SELECT imie, nazwisko, COALESCE(dodatek, 0) AS dodatek FROM pracownik;

--10   Kolumny wyliczeniowe (COALESCE)
--10.1 Wyswietlic imiona, nazwiska pracownikow ich pensje i dodatki oraz kolumne wyliczeniowa do_zaplaty, zawierajaca sume pensji i dodatku.
SELECT imie, nazwisko, pensja, COALESCE(dodatek, 0) AS dodatek, pensja+COALESCE(dodatek, 0) AS do_zaplaty FROM pracownik;
--10.2 Dla kazdego pracownika wyswietl imie, nazwisko i wyliczeniowa kolumne nowa_pensja, ktora bedzie miala o 50% wieksza wartosc niz dotychczasowa pensja.
SELECT imie, nazwisko, 1.5*pensja AS nowa_pensja FROM pracownik;
--10.3 Dla kazdego pracownika oblicz ile wynosi 1% zarobkow (pensja + dodatek). Wyswietl imie, nazwisko i obliczony 1%. Wyniki posortuj rosnaco wzgledem obliczonego 1%.
SELECT imie, nazwisko, 0.01*(pensja+COALESCE(dodatek, 0)) AS jeden_procent_pensji FROM pracownik ORDER BY jeden_procent_pensji ASC;

--11   Ograniczanie wynikow wyszukiwania (TOP)
--11.1 Znajdz imie i nazwisko pracownika, ktory jako pierwszy zostal zatrudniony w wypozyczalni samochodow. Jest tylko jeden taki pracownik.
SELECT TOP 1 imie, nazwisko FROM pracownik ORDER BY data_zatr ASC;
--11.2 Wyswietl pierwszych czterech pracownikow z alfabetycznej listy (nazwiska i imiona) wszystkich pracownikow.
SELECT TOP 4 nazwisko, imie FROM pracownik ORDER BY nazwisko ASC, imie ASC;
--11.3 Wyszukaj informacje o ostatnim wypozyczeniu samochodu.
SELECT TOP 1 * FROM wypozyczenie ORDER BY data_wyp DESC;

--12   Wybrane funkcje daty i czasu (DAY, MONTH, YEAR, GETDATE, DATEDIFF)
--12.1 Wyszukaj pracownikow zatrudnionych w maju. Wyswietl ich imiona, nazwiska i date zatrudnienia. Wynik posortuj rosnaco wzgledem nazwiska i imienia.
SELECT imie, nazwisko, data_zatr FROM pracownik WHERE MONTH(data_zatr)=5 ORDER BY nazwisko ASC, imie ASC;
--12.2 Dla kazdego pracownika (imie i nazwisko) oblicz ile juz pracuje dni. Wynik posortuj malejaco wedlug ilosci przepracowanych dni.
SELECT imie, nazwisko, DATEDIFF(DAY, data_zatr, GETDATE()) AS ile_pracuje_dni FROM pracownik ORDER BY ile_pracuje_dni DESC;
--12.3 Dla kazdego samochodu (marka, typ) oblicz ile lat uplynelo od jego produkcji. Wynik posortuj malejaco po ilosci lat.
SELECT marka, typ, DATEDIFF(YEAR, data_prod, GETDATE()) AS ile_lat_od_produkcji FROM samochod ORDER BY ile_lat_od_produkcji DESC;

--13   Wybrane funkcje operujace na napisach (LEFT, RIGHT, LEN, UPPER, LOWER, STUFF)
--13.1 Wyswietl imie, nazwisko i inicjaly kazdego klienta. Wynik posortuj wzgledem inicjalow, nazwiska i imienia klienta.
SELECT imie, nazwisko, LEFT(imie, 1)+'. '+LEFT(nazwisko, 1)+'.' AS inicjaly FROM klient ORDER BY inicjaly, nazwisko, imie;
--13.2 Wyswietl imiona i nazwiska klientow w taki sposob, aby pierwsza litera imienia i nazwiska byla wielka, a pozostale male.
SELECT UPPER(LEFT(imie, 1))+LOWER(STUFF(imie, 1, 1, '')), UPPER(LEFT(nazwisko, 1))+LOWER(STUFF(nazwisko, 1, 1, '')) FROM klient;
--13.3 Wyswietl imiona, nazwiska i numery kart kredytowych klientow. Kazda z ostatnich szesciu cyfr wyswietlanego numeru karty kredytowej klienta powinna byc zastapiona znakiem x.
SELECT imie, nazwisko, STUFF(nr_karty_kredyt, 6, 6, 'xxxxxx') FROM klient;

--14   Modyfikacja danych w bazie danych (UPDATE)
--14.1 Pracownikom, ktorzy nie maja okreslonej wysokosci dodatku nadaj dodatek w wysokosci 50 zl.
UPDATE pracownik SET dodatek=50 WHERE dodatek IS NULL;
--14.2 Klientowi o identyfikatorze rownym 10 zmien imie i nazwisko na Jerzy Nowak.
UPDATE klient SET imie='Jerzy', nazwisko='Nowak' WHERE id_klient=10;
--14.3 Zwieksz o 100 zl dodatek pracownikom, ktorych pensja jest mniejsza niz 1500 zl.
UPDATE pracownik SET dodatek=dodatek+100 WHERE pensja<1500;

--15   Usuwanie danych z bazy danych (DELETE)
--15.1 Usunac klienta o identyfikatorze rownym  17.
DELETE FROM klient WHERE id_klient=17;
--15.2 Usunac wszystkie  informacje o wypozyczeniach dla klienta o identyfikatorze rownym 17.
DELETE FROM wypozyczenie WHERE id_klient=17;
--15.3 Usun wszystkie samochody o przebiegu wiekszym niz 60000.
DELETE FROM samochod WHERE przebieg>60000;

--16   Dodawanie danych do bazy danych (INSERT)
--16.1 Dodaj do bazy danych klienta o identyfikatorze rownym 121: Adam Cichy zamieszkaly ul. Korzenna 12, 00-950 Warszawa, tel. 123-454-321.
INSERT INTO klient(id_klient, imie, nazwisko, ulica, numer, kod, miasto, telefon) VALUES(121, 'Adam', 'Cichy', 'Korzenna', '12', '00-950', 'Warszawa', '123-454-321');
--16.2 Dodaj do bazy danych nowy samochod o identyfikatorze rownym 50: srebrna skoda octavia o pojemnosci silnika 1896 cm3 wyprodukowana 1 wrzesnia 2012 r. i o przebiegu 5 000 km.
INSERT INTO samochod(id_samochod, kolor, marka, typ, poj_silnika, data_prod, przebieg) VALUES(50, 'srebrny', 'Skoda', 'Octavia', 1896, '2012-09-01', 5000);
--16.3 Dodaj do bazy danych pracownika: Alojzy Mikos zatrudniony od 11 sierpnia 2010 r. w dziale zaopatrzenie na stanowisku magazyniera z pensja 3000 zl i dodatkiem 50 zl, telefon do pracownika: 501-501-501, pracownik pracuje w Warszawie na ul. Lewartowskiego 12, kod pocztowy: 00-950.
INSERT INTO pracownik(id_pracownik, imie, nazwisko, data_zatr, dzial, stanowisko, pensja, dodatek, telefon, id_miejsce) VALUES(120, 'Alojzy', 'Mikos', '2010-10-11', 'zaopatrzenie', 'magazynier', 3000, 50, '501-501-501', 1);