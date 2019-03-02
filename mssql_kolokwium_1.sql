--18560 Mateusz Boczarski

--1 Dla kazdej miejscowosci (tabela adres) oblicz ilu klientow z niej pochodzi. Uwzglednij wszystkie miejscowosci.
--  Wynik posortuj malejaco po obliczonej ilosci, a w przypadku takiej samej ilosci rosnaco po nazwie miejscowosci.
SELECT a.miejscowosc, COUNT(k.id_adres) AS ilosc_klientow
FROM adres a LEFT JOIN klient k ON a.id_adres = k.id_adres
GROUP BY a.miejscowosc
ORDER BY COUNT(k.id_adres) DESC, a.miejscowosc ASC;

--2 Znajdz nazwy producentow (tabela producent), za ktorych towary klienci zaplacili ponad 50 tys. zl. brutto.
--  Wyswietl tylko posortowane alfabetycznie nazwy producentow.
SELECT p.nazwa
FROM producent p JOIN produkt pr ON p.id_producent = pr.id_producent
JOIN koszyk k ON pr.id_produkt = k.id_produkt
GROUP BY p.nazwa, k.cena_netto, k.podatek, k.ilosc_sztuk
HAVING (k.cena_netto + ((k.podatek / 100) * k.cena_netto)) * k.ilosc_sztuk > 50000;

--3 Usun producentow, ktorzy nie maja zadnego produktu.
DELETE FROM producent WHERE id_producent NOT IN(SELECT DISTINCT id_producent FROM produkt);

--4 Dla kazdego roku (tabela zamowienie, kolumna data_zamowienia), oblicz ile bylo zlozonych zamowien.
--  Wynik posortuj rosnaco wzgledem roku. Uzyj funkcji YEAR.
SELECT YEAR(data_zamowienia), COUNT(id_zamowienie) AS ilosc_zamowien
FROM zamowienie
GROUP BY YEAR(data_zamowienia)
ORDER BY YEAR(data_zamowienia) ASC;

--5 Stworz widok zawierajacy zestawienie nazw kategorii i nazw kupionych produktow z tych kategorii.
--  Wykorzystaj powyzszy widok, aby obliczyc ile razy sie powtarza kazda krotka w widoku.
CREATE VIEW kat_prod AS
SELECT k.nazwa AS kategoria, p.nazwa AS produkt
FROM kategoria k JOIN podkategoria pdk ON k.id_kategoria = pdk.id_kategoria
JOIN produkt p ON pdk.id_podkategoria = p.id_podkategoria

SELECT kategoria, COUNT(kategoria) AS ilosc
FROM kat_prod
GROUP BY kategoria
ORDER BY COUNT(kategoria) DESC;