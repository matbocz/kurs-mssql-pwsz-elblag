--17
--17.1
SELECT s.id_samochod, s.marka, s.typ, w.data_wyp, w.data_odd
FROM samochod s INNER JOIN wypozyczenie w ON s.id_samochod=w.id_samochod
WHERE w.data_odd IS NULL;
--17.2
SELECT k.imie, k.nazwisko, w.id_samochod, w.data_wyp
FROM klient k INNER JOIN wypozyczenie w ON k.id_klient=w.id_klient
WHERE w.data_odd IS NULL ORDER BY k.nazwisko ASC, k.imie ASC;
--17.3
SELECT k.imie, k.nazwisko, w.kaucja, w.data_wyp AS data_wpl_kaucji
FROM klient k INNER JOIN wypozyczenie w ON k.id_klient=w.id_klient
WHERE w.kaucja IS NOT NULL;

--18
--18.1
SELECT k.imie, k.nazwisko, w.data_wyp, s.marka, s.typ
FROM klient k INNER JOIN wypozyczenie w ON k.id_klient=w.id_klient
INNER JOIN samochod s ON w.id_samochod=s.id_samochod
ORDER BY k.nazwisko, k.imie, s.marka, s.typ;
--18.2
SELECT m.ulica, m.numer, s.marka, s.typ
FROM miejsce m INNER JOIN wypozyczenie w ON m.id_miejsce=w.id_miejsca_wyp
INNER JOIN samochod s ON s.id_samochod=w.id_samochod
ORDER BY m.ulica ASC, m.numer ASC, s.marka ASC, s.typ ASC;
--18.3
SELECT s.id_samochod, s.marka, s.typ, k.imie, k.nazwisko
FROM samochod s INNER JOIN wypozyczenie w ON s.id_samochod=w.id_samochod
INNER JOIN klient k ON k.id_klient=w.id_klient
ORDER BY s.id_samochod ASC, k.imie ASC, k.nazwisko ASC;

--19
--19.1
SELECT MAX(pensja) FROM pracownik;
--19.2
SELECT AVG(pensja) FROM pracownik;
--19.3
SELECT MIN(data_prod) FROM samochod;

--20
--20.1
SELECT k.imie, k.nazwisko, COUNT(w.id_klient) AS ilosc_wypozyczen
FROM klient k LEFT JOIN wypozyczenie w ON k.id_klient=w.id_klient
GROUP BY k.imie, k.nazwisko, k.id_klient
ORDER BY COUNT(w.id_klient) DESC;
--20.2
SELECT s.id_samochod, s.marka, s.typ, COUNT(w.id_samochod) AS ilosc_wypozyczen
FROM samochod s LEFT JOIN wypozyczenie w  ON s.id_samochod=w.id_samochod
GROUP BY s.id_samochod, s.marka, s.typ
ORDER BY COUNT(w.id_samochod) ASC;
--20.3
SELECT p.imie, p.nazwisko, COUNT(w.id_pracow_wyp) AS ilosc_wypozyczen
FROM pracownik p LEFT JOIN wypozyczenie w ON p.id_pracownik=w.id_pracow_wyp
GROUP BY p.imie, p.nazwisko, p.id_pracownik
ORDER BY COUNT(w.id_pracow_wyp) DESC;

--21
--21.1
SELECT k.imie, k.nazwisko, COUNT(w.id_klient) AS ilosc_wypozyczen
FROM klient k INNER JOIN wypozyczenie w ON k.id_klient=w.id_klient
GROUP BY k.imie, k.nazwisko, k.id_klient
HAVING COUNT(w.id_klient)>=2
ORDER BY nazwisko ASC, imie ASC;
--21.2
SELECT s.id_samochod, s.marka, s.typ, COUNT(w.id_samochod) AS ilosc_wypozyczen
FROM samochod s INNER JOIN wypozyczenie w ON s.id_samochod=w.id_samochod
GROUP BY s.id_samochod, s.marka, s.typ
HAVING COUNT(w.id_samochod)>=5
ORDER BY s.marka ASC, s.typ ASC;
--21.3
SELECT p.imie, p.nazwisko, COUNT(w.id_pracow_wyp) AS ilosc_wypozyczen
FROM pracownik p LEFT JOIN wypozyczenie w ON p.id_pracownik=w.id_pracow_wyp
GROUP BY p.imie, p.nazwisko, p.id_pracownik
HAVING COUNT(w.id_pracow_wyp)<=20
ORDER BY COUNT(w.id_pracow_wyp) ASC, p.nazwisko ASC, p.imie ASC;

--22
--22.1
SELECT imie, nazwisko, pensja FROM pracownik WHERE pensja = (SELECT MAX(pensja) FROM pracownik);
--22.2
SELECT imie, nazwisko, pensja FROM pracownik WHERE pensja > (SELECT AVG(pensja) FROM pracownik);
--22.3
SELECT marka, typ, data_prod FROM samochod WHERE data_prod = (SELECT MIN(data_prod) FROM samochod);

--23
--23.1
SELECT marka, typ, data_prod FROM samochod WHERE id_samochod NOT IN(SELECT DISTINCT id_samochod FROM wypozyczenie);
--23.2
SELECT imie, nazwisko FROM klient WHERE id_klient NOT IN(SELECT DISTINCT id_klient FROM wypozyczenie);
--23.3
SELECT imie, nazwisko FROM pracownik WHERE id_pracownik NOT IN(SELECT DISTINCT id_pracow_wyp FROM wypozyczenie)

--24
--24.1
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
--24.2
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
--24.3
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

--25
--25.1
UPDATE pracownik SET pensja = 1.1 * pensja
WHERE pensja < (SELECT AVG(pensja) FROM pracownik);
--25.2
UPDATE pracownik SET dodatek = dodatek + 10
WHERE id_pracownik IN
(
	SELECT DISTINCT id_pracow_wyp
	FROM wypozyczenie
	WHERE MONTH(data_wyp) = 5
);
--25.3
UPDATE pracownik SET pensja = 0.95 * pensja
WHERE id_pracownik IN
(
	SELECT DISTINCT id_pracow_wyp
	FROM wypozyczenie
	WHERE YEAR(data_wyp) != 1999
);

--26
--26.1
DELETE FROM klient WHERE id_klient NOT IN (SELECT DISTINCT id_klient FROM wypozyczenie);
--26.2
DELETE FROM samochod WHERE id_samochod NOT IN (SELECT DISTINCT id_samochod FROM wypozyczenie);
--26.3
DELETE FROM pracownik WHERE id_pracownik NOT IN (SELECT DISTINCT id_pracow_wyp FROM wypozyczenie);