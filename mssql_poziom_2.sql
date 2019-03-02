--18560 Mateusz Boczarski

--17   Zlaczenia wewnetrzne dwoch tabel
--17.1 Wyszukaj samochody, ktory nie zostaly zwrocone. (Data oddania samochodu ma miec wartosc NULL.) Wyswietl 
--     identyfikator, marke i typ samochodu oraz jego date wypozyczenia i oddania.
SELECT s.id_samochod, s.marka, s.typ, w.data_wyp, w.data_odd
FROM samochod s INNER JOIN wypozyczenie w ON s.id_samochod=w.id_samochod
WHERE w.data_odd IS NULL;
--17.2 Wyszukaj klientow, ktorzy nie zwrocili jeszcze samochodu. (Data oddania samochodu ma miec wartosc NULL.) 
--     Wyswietl imie i nazwisko klienta oraz identyfikator  samochodu i date wypozyczenia nie zwroconego jeszcze 
--     samochodu. Wynik posortuj rosnaco wzgledem nazwiska i imienia klienta.
SELECT k.imie, k.nazwisko, w.id_samochod, w.data_wyp
FROM klient k INNER JOIN wypozyczenie w ON k.id_klient=w.id_klient
WHERE w.data_odd IS NULL ORDER BY k.nazwisko ASC, k.imie ASC;
--17.3 Wsrod klientow wypozyczalni wyszukaj daty i kwoty wplaconych przez nich kaucji. Wyswietl imie i nazwisko 
--     klienta oraz date wplacenia kaucji (data wypozyczenia samochodu jest rownoczesnie data wplacenia kaucji) i jej 
--     wysokosc (pomin kaucje maj¹ce wartosc NULL).
SELECT k.imie, k.nazwisko, w.kaucja, w.data_wyp AS data_wpl_kaucji
FROM klient k INNER JOIN wypozyczenie w ON k.id_klient=w.id_klient
WHERE w.kaucja IS NOT NULL;

--18   Zlaczenia wewnetrzne wiekszej liczby tabel
--18.1 Dla kazdego klienta, ktory choc raz wypozyczyl samochod, wyszukaj jakie i kiedy wypozyczyl samochody. 
--     Wyswietl imie i nazwisko klienta oraz date wypozyczenia, marke i typ wypozyczonego samochodu. Wynik posortuj 
--     rosnaco po nazwisku i imieniu klienta oraz marce i typie samochodu.
SELECT k.imie, k.nazwisko, w.data_wyp, s.marka, s.typ
FROM klient k INNER JOIN wypozyczenie w ON k.id_klient=w.id_klient
INNER JOIN samochod s ON w.id_samochod=s.id_samochod
ORDER BY k.nazwisko, k.imie, s.marka, s.typ;
--18.2 Dla kazdej filii wypozyczalni samochodow (tabela miejsce) wyszukaj jakie samochody byly wypozyczane. 
--     Wyswietl  adres filii (ulica i numer) oraz marke i typ wypozyczonego samochodu. Wyniki posortuj rosnaco wzgledem 
--     adresu filii, marki i typu samochodu.
SELECT m.ulica, m.numer, s.marka, s.typ
FROM miejsce m INNER JOIN wypozyczenie w ON m.id_miejsce=w.id_miejsca_wyp
INNER JOIN samochod s ON s.id_samochod=w.id_samochod
ORDER BY m.ulica ASC, m.numer ASC, s.marka ASC, s.typ ASC;
--18.3 Dla kazdego wypozyczonego samochodu wyszukaj informacje jacy klienci go wypozyczali. Wyswietl 
--     identyfikator, marke i typ samochodu oraz imie i nazwisko klienta. Wyniki posortuj rosnaco po identyfikatorze 
--     samochodu oraz nazwisku i imieniu klienta.
SELECT s.id_samochod, s.marka, s.typ, k.imie, k.nazwisko
FROM samochod s INNER JOIN wypozyczenie w ON s.id_samochod=w.id_samochod
INNER JOIN klient k ON k.id_klient=w.id_klient
ORDER BY s.id_samochod ASC, k.imie ASC, k.nazwisko ASC;

--19   Funkcje agregujace bez grupowania
--19.1 Znalezc najwieksza pensje pracownika wypozyczalni samochodow.
SELECT MAX(pensja) FROM pracownik;
--19.2 Znalezc srednia pensje  pracownika wypozyczalni samochodow.
SELECT AVG(pensja) FROM pracownik;
--19.3 Znalezc najwczesniejsza date wyprodukowania samochodu.
SELECT MIN(data_prod) FROM samochod;

--20   Funkcje agregujace z grupowaniem (GROUP BY, zlaczenia zewnetrzne)
--20.1 Dla kazdego klienta wypisz imie, nazwisko i laczna ilosc wypozyczen samochodow (nie zapomnij o zerowej liczbie 
--     wypozyczen). Wynik posortuj malejaco wzgledem ilosci wypozyczen.
SELECT k.imie, k.nazwisko, COUNT(w.id_klient) AS ilosc_wypozyczen
FROM klient k LEFT JOIN wypozyczenie w ON k.id_klient=w.id_klient
GROUP BY k.imie, k.nazwisko, k.id_klient
ORDER BY COUNT(w.id_klient) DESC;
--20.2 Dla kazdego samochodu (identyfikator, marka, typ) oblicz ilosc wypozyczen. Wynik posortuj rosnaco wzgledem 
--     ilosci wypozyczen. (Nie zapomnij o samochodach, ktore ani razu nie zostaly wypozyczone.)
SELECT s.id_samochod, s.marka, s.typ, COUNT(w.id_samochod) AS ilosc_wypozyczen
FROM samochod s LEFT JOIN wypozyczenie w  ON s.id_samochod=w.id_samochod
GROUP BY s.id_samochod, s.marka, s.typ
ORDER BY COUNT(w.id_samochod) ASC;
--20.3 Dla kazdego pracownika oblicz ile wypozyczyl samochodow klientom. Wyswietl imie i nazwisko pracownika oraz 
--     ilosc wypozyczen. Wynik posortuj malejaco po ilosci wypozyczen. (Nie zapomnij o pracownikach, ktorzy nie 
--     wypozyczyli zadnego samochodu.)
SELECT p.imie, p.nazwisko, COUNT(w.id_pracow_wyp) AS ilosc_wypozyczen
FROM pracownik p LEFT JOIN wypozyczenie w ON p.id_pracownik=w.id_pracow_wyp
GROUP BY p.imie, p.nazwisko, p.id_pracownik
ORDER BY COUNT(w.id_pracow_wyp) DESC;

--21   Warunki na funkcje agregujace (HAVING)
--21.1 Znajdz klientow, ktorzy co najmniej 2 razy wypozyczyli samochod. Wypisz dla tych klientow imie, nazwisko i ilosc 
--     wypozyczen. Wynik posortuj rosnaco wzgledem nazwiska i imienia.
SELECT k.imie, k.nazwisko, COUNT(w.id_klient) AS ilosc_wypozyczen
FROM klient k INNER JOIN wypozyczenie w ON k.id_klient=w.id_klient
GROUP BY k.imie, k.nazwisko, k.id_klient
HAVING COUNT(w.id_klient)>=2
ORDER BY nazwisko ASC, imie ASC;
--21.2 Znajdz samochody, ktore byly wypozyczone co najmniej 5 razy. Wyswietl identyfikator samochodu, marke, typ i 
--     ilosc wypozyczen. Wynik posortuj rosnaco wzgledem marki i typu samochodu.
SELECT s.id_samochod, s.marka, s.typ, COUNT(w.id_samochod) AS ilosc_wypozyczen
FROM samochod s INNER JOIN wypozyczenie w ON s.id_samochod=w.id_samochod
GROUP BY s.id_samochod, s.marka, s.typ
HAVING COUNT(w.id_samochod)>=5
ORDER BY s.marka ASC, s.typ ASC;
--21.3 Znajdz pracownikow, ktorzy klientom wypozyczyli co najwyzej 20 razy samochod. Wyswietl imiona i nazwiska 
--     pracownikow razem z iloscia wypozyczen. Wynik posortuj rosnaco wzgledem ilosci wypozyczen, nazwiska i imienia 
--     pracownika. (Uwzglednij pracownikow, ktorzy nie wypozyczyli zadnego samochodu.)
SELECT p.imie, p.nazwisko, COUNT(w.id_pracow_wyp) AS ilosc_wypozyczen
FROM pracownik p LEFT JOIN wypozyczenie w ON p.id_pracownik=w.id_pracow_wyp
GROUP BY p.imie, p.nazwisko, p.id_pracownik
HAVING COUNT(w.id_pracow_wyp)<=20
ORDER BY COUNT(w.id_pracow_wyp) ASC, p.nazwisko ASC, p.imie ASC;

--22   Podzapytania nieskorelowane z uzyciem funkcji agregujacych bez grupowania
--22.1 Wyswietl imiona, nazwiska i pensje pracownikow, ktorzy posiadaja najwyzsza pensja.
SELECT imie, nazwisko, pensja FROM pracownik WHERE pensja = (SELECT MAX(pensja) FROM pracownik);
--22.2 Wyswietl pracownikow (imiona, nazwiska, pensje), ktorzy zarabiaja powyzej sredniej pensji.
SELECT imie, nazwisko, pensja FROM pracownik WHERE pensja > (SELECT AVG(pensja) FROM pracownik);
--22.3 Wyszukaj samochod (marka, typ, data produkcji), ktory zostal wyprodukowany najwczesniej. Moze sie tak 
--     zdarzyc, ze kilka samochodow zostalo wyprodukowanych w ten sam "najwczesniejszy" dzien.
SELECT marka, typ, data_prod FROM samochod WHERE data_prod = (SELECT MIN(data_prod) FROM samochod);

--23   Podzapytania nieskorelowane z predykatem IN
--23.1 Wyswietl wszystkie samochody (marka, typ, data produkcji), ktore do tej pory nie zostaly wypozyczone.
SELECT marka, typ, data_prod FROM samochod WHERE id_samochod NOT IN(SELECT DISTINCT id_samochod FROM wypozyczenie);
--23.2 Wyswietl klientow (imie i nazwisko), ktorzy do tej pory nie wypozyczyli zadnego samochodu. Wynik posortuj 
--     rosnaco wzgledem nazwiska i imienia klienta.
SELECT imie, nazwisko FROM klient WHERE id_klient NOT IN(SELECT DISTINCT id_klient FROM wypozyczenie);
--23.3 Znalezc pracownikow (imie i nazwisko), ktorzy do tej pory nie wypozyczyli zadnego samochodu klientowi.
SELECT imie, nazwisko FROM pracownik WHERE id_pracownik NOT IN(SELECT DISTINCT id_pracow_wyp FROM wypozyczenie)

--24   Funkcje agregujace i podzapytania
--24.1 Znajdz samochod/samochody (id_samochod, marka, typ), ktory byl najczesciej wypozyczany. Wynik posortuj 
--     rosnaco (leksykograficznie) wzgledem marki i typu.
SELECT s.id_samochod, s.marka, s.typ
FROM samochod s JOIN wypozyczenie w ON s.id_samochod = w.id_samochod
GROUP BY s.id_samochod, s.marka, s.typ
HAVING COUNT(w.id_samochod) =
(
	SELECT TOP 1 COUNT(w.id_samochod) AS ilosc_wyp
	FROM wypozyczenie w
	GROUP BY w.id_samochod
	ORDER BY ilosc_wyp DESC
)
ORDER BY s.marka ASC, s.typ ASC;
--24.2 Znajdz klienta/klientow (id_klient, imie, nazwisko), ktorzy najrzadziej wypozyczali samochody. Wynik posortuj 
--     rosnaco wzgledem nazwiska i imienia. Nie uwzgledniaj klientow, ktorzy ani razu nie wypozyczyli samochodu.
SELECT k.id_klient, k.imie, k.nazwisko
FROM klient k JOIN wypozyczenie w ON k.id_klient = w.id_klient
GROUP BY k.id_klient, k.imie, k.nazwisko
HAVING COUNT(w.id_klient) =
(
	SELECT TOP 1 COUNT(w.id_klient) AS ilosc_wyp
	FROM wypozyczenie w
	GROUP BY w.id_klient
	ORDER BY ilosc_wyp ASC
)
ORDER BY k.nazwisko, k.imie ASC;
--24.3 Znajdz pracownika/pracownikow (id_pracownik, nazwisko, imie), ktory wypozyczyl najwiecej samochodow 
--     klientom. Wynik posortuj rosnaco (leksykograficznie) wzgledem nazwiska i imienia pracownika.
SELECT p.id_pracownik, p.nazwisko, p.imie
FROM pracownik p JOIN wypozyczenie w ON p.id_pracownik = w.id_pracow_wyp
GROUP BY p.id_pracownik, p.nazwisko, p.imie
HAVING COUNT(w.id_pracow_wyp) = 
(
	SELECT TOP 1 COUNT(w.id_pracow_wyp) AS ilosc_wyp
	FROM wypozyczenie w
	GROUP BY w.id_pracow_wyp
	ORDER BY ilosc_wyp DESC
)
ORDER BY p.nazwisko ASC, p.imie ASC;

--25   Modyfikacja danych w bazie danych (UPDATE i podzapytania)
--25.1 Podwyzszyc o 10% pensje pracownikom, ktorzy zarabiaja ponizej sredniej.
UPDATE pracownik SET pensja = 1.1 * pensja
WHERE pensja < (SELECT AVG(pensja) FROM pracownik);
--25.2 Pracownikom, ktorzy w maju wypozyczyli samochod klientowi  zwieksz dodatek o 10 zl.
UPDATE pracownik SET dodatek = dodatek + 10
WHERE id_pracownik IN
(
	SELECT DISTINCT id_pracow_wyp
	FROM wypozyczenie
	WHERE MONTH(data_wyp) = 5
);
--25.3 Obnizyc pensje o 5% wszystkim pracownikom ktorzy nie wypozyczyli klientowi samochodu w 1999 roku.
UPDATE pracownik SET pensja = 0.95 * pensja
WHERE id_pracownik IN
(
	SELECT DISTINCT id_pracow_wyp
	FROM wypozyczenie
	WHERE YEAR(data_wyp) != 1999
);

--26   Usuwanie danych z bazy danych (DELETE i podzapytania)
--26.1 Usunac klientow, ktorzy nie wypozyczyli zadnego samochodu.
DELETE FROM klient WHERE id_klient NOT IN (SELECT DISTINCT id_klient FROM wypozyczenie);
--26.2 Usunac samochody, ktore nie zostaly ani razu wypozyczone.
DELETE FROM samochod WHERE id_samochod NOT IN (SELECT DISTINCT id_samochod FROM wypozyczenie);
--26.3 Usunac pracownikow, ktorzy klientom nie wypozyczyli zadnego samochodu.
DELETE FROM pracownik WHERE id_pracownik NOT IN (SELECT DISTINCT id_pracow_wyp FROM wypozyczenie);