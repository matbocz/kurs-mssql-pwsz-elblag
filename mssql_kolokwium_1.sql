--1 Dla kazdej miejscowosci (tabela adres) oblicz ilu klientow z niej pochodzi. Uwzglednij wszystkie miejscowosci.
--  Wynik posortuj malejaco po obliczonej ilosci, a w przypadku takiej samej ilosci rosnaco po nazwie miejscowosci.
SELECT a.miejscowosc, COUNT(k.id_adres) AS ilosc_klientow
FROM adres a LEFT JOIN klient k ON a.id_adres = k.id_adres
GROUP BY a.miejscowosc
ORDER BY COUNT(k.id_adres) DESC, a.miejscowosc ASC;

--2 Znajdz nazwy producentow (tabela producent), za ktorych towary klienci zaplacili ponad 50 tys. zl. brutto.
--  Wyswietl tylko posortowane alfabetycznie nazwy producentow.

--3 Usun producentow, ktorzy nie maja zadnego produktu.

--4 Dla kazdego roku (tabela zamowienie, kolumna data_zamowienia), oblicz ile bylo zlozonych zamowien.
--  Wynik posortuj rosnaco wzgledem roku. Uzyj funkcji YEAR.

--5 Stworz widok zawierajacy zestawienie nazw kategorii i nazw kupionych produktow z tych kategorii.
--  Wykorzystaj powyzszy widok, aby obliczyc ile razy sie powtarza kazda krotka w widoku.
