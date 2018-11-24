--28   Tworzenie tabel (CREATE TABLE)
--28.1 Utworz tabele pracownik2(id_pracownik, imie, nazwisko, pesel, data_zatr, pensja), gdzie
--     * id_pracownik - jest numerem pracownika nadawanym automatycznie, jest to klucz glowny 
--     * imie i nazwisko - to niepuste lancuchy znakow zmiennej dlugosci, 
--     * pesel - unikatowy lancuch jedenastu znakow stalej dlugosci, 
--     * data_zatr - domyslna wartosc daty zatrudnienia to biezaca data systemowa, 
--     * pensja - nie moze byc nizsza niz 1000zl.
CREATE TABLE pracownik2(
id_pracownik INT IDENTITY(1, 1) PRIMARY KEY,
imie VARCHAR(15) NOT NULL,
nazwisko VARCHAR(20) NOT NULL,
pesel CHAR(11) UNIQUE,
data_zatr DATETIME DEFAULT GETDATE(),
pensja MONEY CHECK(pensja >= 1000)
);
--28.2 Utworz tabele naprawa2(id_naprawa, data_przyjecia, opis_usterki, zaliczka), gdzie
--     * id_naprawa - jest unikatowym, nadawanym automatycznie numerem naprawy, jest to klucz glowny, 
--     * data_przyjecia - nie moze byc pozniejsza niz biezaca data systemowa, 
--     * opis usterki - nie moze byc pusty, musi miec dlugosc powyzej 10 znakow, 
--     * zaliczka - nie moze byc mniejsza niz 100zl ani wieksza niz 1000zl.
CREATE TABLE naprawa2(
id_naprawa INT IDENTITY(1, 1) PRIMARY KEY,
data_przyjecia DATETIME CHECK(data_przyjecia <= GETDATE()),
opis_usterki VARCHAR(MAX) CHECK(LEN(opis_usterki) > 2),
zaliczka MONEY CHECK(zaliczka >= 100 AND zaliczka <= 1000)
);
--29.3 Utworz tabele wykonane_naprawy2(id_pracownik, id_naprawa, data_naprawy, opis_naprawy, cena), gdzie
--     * id_pracownik - identyfikator pracownika wykonujacego naprawe, klucz obcy powiazany z tabela pracownik2, 
--     * id_naprawa - identyfikator zgloszonej naprawy, klucz obcy powiazany z tabela naprawa2, 
--     * data_naprawy - domyslna wartosc daty naprawy to biezaca data systemowa, 
--     * opis_naprawy - niepusty opis informujacy o sposobie naprawy, 
--     * cena - cena naprawy.
CREATE TABLE wykonane_naprawy2(
id_pracownik INT REFERENCES pracownik2(id_pracownik),
id_naprawa INT REFERENCES naprawa2(id_naprawa),
data_naprawy DATETIME DEFAULT GETDATE(),
opis_naprawy VARCHAR(MAX) NOT NULL,
cena MONEY
);

--29   Modyfikacja struktury tabeli (ALTER TABLE)
--29.1 Dana jest tabela CREATE TABLE student2(id_student INT IDENTITY(1,1) PRIMARY KEY, nazwisko VARCHAR(20), 
--     nr_indeksu INT, stypendium MONEY);  Wprowadz ograniczenia na tabele student2: 
--     * nazwisko - niepusta kolumna, 
--     * nr_indeksu - unikatowa kolumna, 
--     * stypendium -nie moze byc nizsze niz 1000zl, 
--     * dodatkowo dodaj niepusta kolumne imie.
CREATE TABLE student2(id_student INT IDENTITY(1, 1) PRIMARY KEY, nazwisko VARCHAR(20), nr_indeksu INT, stypendium MONEY);
ALTER TABLE student2 ALTER COLUMN nazwisko VARCHAR(20) NOT NULL;
ALTER TABLE student2 ADD CONSTRAINT unikatowy_nr_indeksu UNIQUE(nr_indeksu);
ALTER TABLE student2 ADD CONSTRAINT sprawdz_stypendium CHECK (stypendium >= 1000);
ALTER TABLE student2 ADD imie VARCHAR(15) NOT NULL;
--29.2 Dane sa tabele: CREATE TABLE dostawca2(id_dostawca INT IDENTITY(1,1) PRIMARY KEY, nazwa VARCHAR(30)); 
--     CREATE TABLE towar2(id_towar INT IDENTITY(1,1) PRIMARY KEY, kod_kreskowy INT, id_dostawca INT); 
--     Zmodyfikuj powyzsze tabele: 
--     * kolumna nazwa z tabeli dostawca2 powinna byc unikatowa, 
--     * do tabeli towar2 dodaj niepusta kolumne nazwa, 
--     * kolumna kod_kreskowy w tabeli towar2 powinna byc unikatowa, 
--     * kolumna id_dostawca z tabeli towar2 jest kluczem obcym z tabeli dostawca2.
CREATE TABLE dostawca2(id_dostawca INT IDENTITY(1, 1) PRIMARY KEY, nazwa VARCHAR(30));
CREATE TABLE towar2(id_towar INT IDENTITY(1, 1) PRIMARY KEY, kod_kreskowy INT, id_dostawca INT);
ALTER TABLE dostawca2 ADD CONSTRAINT unikatowa_nazwa UNIQUE(nazwa);
ALTER TABLE towar2 ADD nazwa VARCHAR(MAX) NOT NULL;
ALTER TABLE towar2 ADD CONSTRAINT unikatowy_kod_kreskowy UNIQUE(kod_kreskowy);
ALTER TABLE towar2 ADD FOREIGN KEY(id_dostawca) REFERENCES dostawca2(id_dostawca);
--29.3 Dane sa tabele:  CREATE TABLE kraj2(id_kraj INT IDENTITY(1,1) PRIMARY KEY, nazwa VARCHAR(30)); 
--     CREATE TABLE gatunek2(id_gatunek INT IDENTITY(1,1) PRIMARY KEY, nazwa VARCHAR(30)); 
--     CREATE TABLE zwierze2(id_zwierze INT IDENTITY(1,1) PRIMARY KEY, id_gatunek INT, id_kraj INT, cena MONEY); 
--     Zmodyfikuj powyzsze tabele: 
--     * kolumny nazwa z tabel kraj2 i gatunek2 maja byc niepuste, 
--     * kolumna id_gatunek z tabeli zwierze2 jest kluczem obcym z tabeli gatunek2, 
--     * kolumna id_kraj z tabeli zwierze2 jest kluczem obcym z tabeli kraj2.
CREATE TABLE kraj2(id_kraj INT IDENTITY(1, 1) PRIMARY KEY, nazwa VARCHAR(30));
CREATE TABLE gatunek2(id_gatunek INT IDENTITY(1, 1) PRIMARY KEY, nazwa VARCHAR(30));
CREATE TABLE zwierze2(id_zwierze INT IDENTITY(1, 1) PRIMARY KEY, id_gatunek INT, id_kraj INT, cena MONEY);
ALTER TABLE kraj2 ALTER COLUMN nazwa VARCHAR(30) NOT NULL;
ALTER TABLE gatunek2 ALTER COLUMN nazwa VARCHAR(30) NOT NULL;
ALTER TABLE zwierze2 ADD FOREIGN KEY(id_gatunek) REFERENCES gatunek2(id_gatunek);
ALTER TABLE zwierze2 ADD FOREIGN KEY(id_kraj) REFERENCES kraj2(id_kraj);

--30   Usuwanie tabel, kolumn w tabeli i ograniczen (DROP i ALTER)
--30.1 Dane sa tabele: CREATE TABLE kategoria2(id_kategoria INT PRIMARY KEY, nazwa VARCHAR(30) );  
--     CREATE TABLE przedmiot2(id_przedmiot INT PRIMARY KEY, id_kategoria INT REFERENCES kategoria2(id_kategoria), 
--     nazwa VARCHAR(30)); 
--     Napisac instrukcje SQL, ktora usuna tabele kategoria2 i przedmiot2. 
--     Wsk: Zwroc uwage na kolejnosc usuwania tabel. 
--     Wersja trudniejsza: Czy potrafisz najpierw sprawdzic, czy tabele istnieja i jesli istnieja to dopiero wtedy  je usunac?
DROP TABLE przedmiot2;
DROP table kategoria2;
--30.2 Dana jest tabela: CREATE TABLE osoba2(id_osoba INT, imie VARCHAR(15), imie2 VARCHAR(15) ); 
--     Napisac instrukcje SQL, ktora z tabeli osoba2 usunie kolumne imie2.

--20.3 Dana jest tabela: CREATE TABLE uczen2(id_uczen INT PRIMARY KEY, imie VARCHAR(15), nazwisko VARCHAR(20) 
--     CONSTRAINT uczen_nazwisko_unique UNIQUE); 
--     Napisac instrukcje SQL, ktora usunie narzucony warunek unikatowosci na kolumne nazwisko. 
--     Wersja trudniejsza: Czy potrafilbys zrobic powyzsze zadanie dla definicji tabeli: CREATE TABLE uczen2(id_uczen INT 
--     PRIMARY KEY, imie VARCHAR(15), nazwisko VARCHAR(20) CONSTRAINT UNIQUE); ?


--31   Usuwanie i modyfikacja kaskadowa (CREATE i ALTER)
--31.1 Utworz tabele wlasciciel2(id_wlasciciel, imie,nazwisko,data_ur,ulica,numer,kod,miejscowosc) i 
--     zwierze2(id_zwierze,id_wlasciciel,rasa,data_ur,imie) w taki sposob, aby po usunieciu informacji o wlascicielu 
--     zwierzecia z tabeli wlasciciel2, SZBD automatycznie identyfikator wlasciciela w tabeli zwierze2 ustawial na wartosc 
--     NULL. Nie zapomnij o doborze pozostalych ograniczen na kolumny (mozna to zrobic wg uznania).
CREATE TABLE wlasciciel2(
id_wlasciciel INT IDENTITY(1, 1)PRIMARY KEY,
imie VARCHAR(15) NOT NULL CHECK(LEN(imie) > 2),
nazwisko VARCHAR(15) NOT NULL CHECK(LEN(nazwisko) > 2),
data_ur DATE NOT NULL DEFAULT GETDATE(),
ulica VARCHAR(50),
numer VARCHAR(8),
kod CHAR(6) NOT NULL CHECK(LEN(kod) = 6),
miejscowosc VARCHAR(30) NOT NULL CHECK(LEN(miejscowosc) > 1)
);
CREATE TABLE zwierze2(
id_zwierze INT IDENTITY(1, 1) PRIMARY KEY,
id_wlasciciel INT REFERENCES wlasciciel2(id_wlasciciel) ON DELETE SET NULL,
rasa VARCHAR(30) NOT NULL CHECK(LEN(rasa) > 2),
data_ur DATE NOT NULL DEFAULT GETDATE(),
imie VARCHAR(15) NOT NULL CHECK(LEN(imie) > 2)
);
--31.2 Dane sa tabele: CREATE TABLE film2(id_film INT PRIMARY KEY,tytul VARCHAR(50) NOT NULL); 
--     CREATE TABLE gatunek2(id_gatunek INT PRIMARY KEY,nazwa VARCHAR(50) NOT NULL); 
--     CREATE TABLE film2_gatunek2(id_film INT,id_gatunek INT,PRIMARY KEY(id_film,id_gatunek)); 
--     Zmodyfikuj strukture powyzszych tabel (polecenie ALTER) taka aby: 
--     a) w przypadku usuniecia filmu z tabeli film2 zostaly automatycznie usuwane informacje jakich gatunkow byl 
--     usuniety film (nie usuwamy gatunkow z tabeli gatunek2), 
--     b) w przypadku usuniecia gatunku z tabeli gatunek2 zostaly automatycznie usuwane informacje jakie filmy byly tego 
--     gatunku (nie usuwamy filmow z tabeli film2).

--31.3 Dane sa tabele: CREATE TABLE stanowisko2 (id_stanowisko INT PRIMARY KEY, nazwa VARCHAR(30)); 
--     CREATE TABLE pracownik2(id_pracownik INT PRIMARY KEY, id_stanowisko INT, nazwisko VARCHAR(20)); 
--     Zmodyfikuj struktury powyzszych tabel tak, aby po usunieciu stanowiska z tabeli stanowisko2 identyfikator 
--     stanowiska w tabeli pracownik2 byl automatycznie ustawiany na wartosc NULL oraz podczas modyfikowania 
--     identyfikatora stanowiska w tabeli stanowisko2 wszystkie identyfikatory stanowiska w tabeli pracownik2 powinny 
--     zostac automatycznie zaktualizowane.

