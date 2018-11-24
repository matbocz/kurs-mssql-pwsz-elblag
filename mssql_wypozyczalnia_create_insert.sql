--dr Robert Fidytek, uaktualnienie 19.03.2016 r.
--Baza danych wypożyczalni samochodów
--MS SQL Server wersja >= 2008

--W celach dydaktycznych ze struktury bazy danych usunięto klucze obce,
--ograniczenia na kolumny i tabele.


--Zmiana formatu daty na rok-miesiąc-dzień
SET DATEFORMAT ymd;
GO

--(MSSQL) Sprawdzamy, czy są i usuwamy niepotrzebne tabele
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='wypozyczenie')
DROP TABLE wypozyczenie;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='pracownik')
DROP TABLE pracownik;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='klient')
DROP TABLE klient;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='samochod')
DROP TABLE samochod;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='miejsce')
DROP TABLE miejsce;
GO

--Tworzymy strukturę bazy danych i dodajemy przykładowe rekordy
CREATE TABLE pracownik (
  id_pracownik  INT          PRIMARY KEY,
  imie          VARCHAR(15)  NOT NULL,
  nazwisko      VARCHAR(20)  NOT NULL,
  data_zatr     DATETIME     NOT NULL,
  dzial         VARCHAR(20)  NOT NULL,
  stanowisko    VARCHAR(20)  NOT NULL,
  pensja        DECIMAL(8,2) NOT NULL,
  dodatek       DECIMAL(8,2),
  id_miejsce    INT          NOT NULL,
  telefon       VARCHAR(16)
);
GO

--celowo Jan Kowalski został napisany drukowanymi literami 
INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (1, 'JAN', 'KOWALSKI', '1997-02-01', 'obsługa klienta', 'sprzedawca', 1100, 123, 1, '987-231-123');

INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (2, 'Wanda', 'Kamińska', '1997-01-01', 'obsługa klienta', 'sprzedawca', 1200, 115, 2, '987-231-124');

INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (3, 'Krzysztof', 'Adamski', '1997-05-01', 'obsługa klienta', 'kierownik', 2000, NULL, 3, '987-231-125');

INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (4, 'Piotr', 'Michalski', '1998-06-01', 'techniczny', 'mechanik', 1700, 76, 1, '987-231-131');

INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (5, 'Bożena', 'Domańska', '1997-02-01', 'obsługa klienta', 'sprzedawca', 1300, 134, 3, '987-231-126');

INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (6, 'Wojciech', 'Burzalski', '1998-12-01', 'techniczny', 'mechanik', 1800, 80, 3, '987-231-132');

--celowo zostaje dodany drugi pracownik o tym samym imieniu i nazwisku
INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (7, 'Wojciech', 'Burzalski', '1997-05-01', 'księgowość', 'kasjer', 1400, 105, 1, '987-231-141');

INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (8, 'Marcin', 'Marcinkowski', '1997-05-01', 'techniczny', 'kierownik', 2200, NULL, 1, '987-231-133');

INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (9, 'Alicja', 'Makowska', '1999-07-01', 'obsługa klienta', 'sprzedawca', 1400, 120, 4, '933-241-525');

INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (10, 'Wojciech', 'Bagielski', '1998-04-01', 'obsługa klienta', 'sprzedawca', 1200, 100, 1, '457-531-143');

INSERT INTO pracownik(id_pracownik,imie,nazwisko,data_zatr,dzial,stanowisko,pensja,dodatek,id_miejsce,telefon)
VALUES (11, 'Jan', 'Bagielski', '1999-04-01', 'techniczny', 'sprzedawca', 1200, 100, 1, '457-531-144');
GO


CREATE TABLE klient (
  id_klient       INT         PRIMARY KEY,
  imie            VARCHAR(15) NOT NULL,
  nazwisko        VARCHAR(20) NOT NULL,
  nr_karty_kredyt CHAR(20),
  firma           VARCHAR(40),
  ulica           VARCHAR(24) NOT NULL,
  numer           VARCHAR(8)  NOT NULL,
  miasto          VARCHAR(24) NOT NULL,
  kod             CHAR(6)     NOT NULL,
  nip             CHAR(11),
  telefon         VARCHAR(16)
);
GO

--celowo Jan Nowak został napisany drukowanymi literami
INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (1, 'JAN', 'NOWAK', NULL, NULL, 'Kochanowskiego', '3', 'Wrocław', '37-300', NULL, '167-763-234');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (2, 'Tomasz', 'Adamczak' , 'HH 12345678', 'Kowalski S.C.', 'Kwiatowa', '4/9', 'Warszawa', '01-900', '543-123-456', '46-744-431');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (3, 'Piotr', 'Malczyk' , 'HF 12445661', 'ADA S.C.', 'Różana', '9', 'Warszawa', '01-900', '443-133-251', '16-742-114');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (4, 'Paweł', 'Fiodorowicz' , 'DD 76545321', 'Krawiectwo', 'Armii Krajowej', '22A', 'Warszawa', '01-200', '555-233-256', '44-342-116');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (5, 'Aniela', 'Dalgiewicz' ,NULL , 'Modna Pani', 'Bohaterów GetaA', '24', 'Wrocław', '37-200', '456-134-153', '144-188-415');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (6, 'Joanna', 'Kwiatkowska', NULL, NULL, 'Tuwima', '2/5', 'Świdnica', '58-100', NULL, '963-733-231');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (7, 'Bożena', 'Malinowska', NULL, NULL, 'Lelewela', '34/1', 'Świdnica', '58-100', NULL, '965-553-778');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (8, 'Tomasz', 'Nowak', NULL, NULL, 'Żeromskiego', '5A/8', 'Świdnica', '58-100', NULL, '911-135-536');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (9, 'Krzysztof', 'Domagała', NULL, NULL, 'Leśna', '5', 'Świdnica', '58-100', NULL, '922-233-232');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (10, 'Arkadiusz', 'Doczekalski', NULL, NULL, 'Leśna', '2', 'Świdnica', '58-100', NULL, '922-233-267');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (11, 'Anna', 'Kowalska' ,'KJ 98765412' , 'Moda S.A.', 'Powstańców Śląskich', '4', 'Wrocław', '37-200', '422-132-354', '444-283-901');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (12, 'Krzysztof', 'Dobrowolski' , NULL, 'Kamieniarstwo.pl', 'Strzegomska', '124', 'Wrocław', '37-400', '433-133-332', '443-285-202');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (13, 'Marcin', 'Krzykała' , NULL, NULL, 'Konopnickiej', '1/4', 'Wrocław', '37-400', NULL, '442-211-109');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (14, 'Aneta', 'Paprocka' , NULL, NULL, 'Tuwima', '2', 'Wrocław', '37-400', NULL, '442-671-899');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (15, 'Sebastion', 'Kownacki' , NULL, NULL, 'Głowackiego', '2/9', 'Wrocław', '37-400', NULL, '423-681-129');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (16, 'Michał', 'Michalski' , NULL, NULL, 'Kwiatowa', '9/3', 'Wrocław', '37-500', NULL, '499-621-921');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (17, 'Michał', 'Szykowny' , 'WW 12398765', NULL, 'Leśna', '3', 'Warszawa', '00-100', NULL, '191-221-622');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (18, 'Marcin', 'Marcinkowski' , 'WQ 14368781', NULL, 'Okrężna', '33', 'Warszawa', '00-200', NULL, '122-127-647');

INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (19, 'Robert', 'Nowak' , 'WS 12358672', 'Auto naprawa', 'Przemysłowa', '1', 'Warszawa', '00-200', '999-765-120', '822-324-742');

--celowo dodaję drugiego klienta o tym samym imieniu i nazwisku
INSERT INTO klient(id_klient,imie,nazwisko,nr_karty_kredyt,firma,ulica,numer,miasto,kod,nip,telefon)
VALUES (20, 'Robert', 'Nowak' , 'AS 61333699', 'Tapicerstwo', 'Mostowa', '9B', 'Warszawa', '00-100', '987-765-333', '811-311-147');
GO


CREATE TABLE samochod (
  id_samochod  INT         PRIMARY KEY,
  marka        VARCHAR(20) NOT NULL,
  typ          VARCHAR(16) NOT NULL,
  data_prod    DATETIME    NOT NULL,
  kolor        VARCHAR(16) NOT NULL,
  poj_silnika  SMALLINT    NOT NULL,
  przebieg     INTEGER     NOT NULL
);
GO

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (1, 'Mercedes', '190D', '1995-01-01', 'biały', 1800, 23000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (2, 'Mercedes', '230D', '1999-01-01', 'niebieski', 2000, 35000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (3, 'Fiat', '126p', '2000-01-01', 'czerwony', 1100, 13000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (4, 'Fiat', '125p', '1999-01-01', 'biały', 900, 10000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (5, 'Fiat', 'TIPO', '1998-01-01', 'bordowy', 1400, 43000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (6, 'Polonez', 'CARO', '1997-01-01', 'zielony', 1600, 55000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (7, 'Opel', 'Corsa', '2000-01-01', 'zielony', 1100, 11000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (8, 'Opel', 'Vectra', '1999-01-01', 'szary', 1800, 36000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (9, 'Mercedes', '190D', '1996-01-01', 'brązowy', 1800, 69000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (10, 'Ford', 'Escort', '2000-01-01', 'niebieski', 1600, 8000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (11, 'Ford', 'Escort', '1999-01-01', 'biały', 1600, 23000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (12, 'Ford', 'KA', '1998-01-01', 'bordowy', 1100, 54000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (13, 'Fiat', 'Seicento', '1999-01-01', 'złoty', 1100, 25000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (14, 'Fiat', 'Seicento', '2000-01-01', 'biały', 1100, 18000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (15, 'Seat', 'Ibiza', '1998-01-01', 'żółty', 1800, 63000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (16, 'Ford', 'Sierra', '1995-01-01', 'czerwony', 1600, 87000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (17, 'Opel', 'Corsa', '2000-01-01', 'zielony', 1400, 9000);

INSERT INTO samochod(id_samochod,marka,typ,data_prod,kolor,poj_silnika,przebieg)
VALUES (18, 'Ford', 'KA', '1999-01-01', 'żółty', 1400, 20000);
GO


CREATE TABLE miejsce (
  id_miejsce INT         PRIMARY KEY,
  ulica      VARCHAR(24) NOT NULL,
  numer      VARCHAR(8)  NOT NULL,
  miasto     VARCHAR(24) NOT NULL,
  kod        CHAR(6)     NOT NULL,
  telefon    VARCHAR(16),
  uwagi      VARCHAR(40)
);
GO

INSERT INTO miejsce(id_miejsce,ulica,numer,miasto,kod,telefon,uwagi)
VALUES (1, 'Lewartowskiego', '12', 'Warszawa', '10-100', '228-277-097', NULL);

INSERT INTO miejsce(id_miejsce,ulica,numer,miasto,kod,telefon,uwagi)
VALUES (2, 'Aleje Lipowe', '3', 'Wrocław', '32-134', '388-299-086', NULL);

INSERT INTO miejsce(id_miejsce,ulica,numer,miasto,kod,telefon,uwagi)
VALUES (3, 'Kochanowskiego', '8', 'Kraków', '91-200', '222-312-498', NULL);

INSERT INTO miejsce(id_miejsce,ulica,numer,miasto,kod,telefon,uwagi)
VALUES (4, 'Lotnicza', '9', 'Poznań', '22-200', '778-512-044', NULL);

INSERT INTO miejsce(id_miejsce,ulica,numer,miasto,kod,telefon,uwagi)
VALUES (5, 'Widmo', '11', 'Malbork', '83-200', '111-222-345', NULL);
GO


CREATE TABLE wypozyczenie (
  id_wypozyczenie INT          PRIMARY KEY,
  id_klient       INT          NOT NULL,
  id_samochod     INT          NOT NULL,
  id_pracow_wyp   INT          NOT NULL,
  id_pracow_odd   INT,
  id_miejsca_wyp  INT          NOT NULL,
  id_miejsca_odd  INT,
  data_wyp        DATETIME     NOT NULL,
  data_odd        DATETIME,
  kaucja          DECIMAL(8,2),
  cena_jedn       DECIMAL(8,2) NOT NULL
);
GO

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (1, 1, 3, 2, 2, 1, 1, '1998-09-11', '1998-09-13', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (2, 3, 4, 1, 1, 1, 1, '1998-09-06', '1998-09-07', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (3, 3, 4, 9, 9, 2, 2, '1998-10-04', '1998-10-14', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (4, 4, 3, 10, 10, 3, 3, '1998-10-10', '1998-10-15', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (5, 6, 7, 10, 10, 3, 3, '1998-10-09', '1998-11-12', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (6, 5, 8, 10, 2, 1, 3, '1998-11-07', '1998-11-19', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (7, 8, 11, 9, 2, 1, 1, '1998-11-07', '1998-11-15', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (8, 6, 11, 1, 5, 4, 4, '1998-11-08', '1998-12-02', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (9, 7, 17, 2, 2, 1, 2, '1998-12-01', '1998-12-03', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (10, 9, 17, 2, 10, 1, 2, '1998-12-12', '1998-12-17', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (11, 10, 1, 5, 5, 3, 3, '1998-12-02', '1998-12-03', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (12, 12, 2, 5, 5, 4, 4, '1999-01-04', '1999-01-12', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (13, 11, 5, 1, 5, 3, 1, '1999-01-04', '1999-01-09', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (14, 13, 5, 1, 1, 4, 1, '1999-02-01', '1999-02-05', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (15, 14, 4, 1, 1, 2, 2, '1999-02-04', '1999-02-04', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (16, 15, 18, 9, 9, 2, 2, '1999-03-08', '1999-03-13', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (17, 16, 13, 10, 10, 4, 1, '1999-03-11', '1999-03-12', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (18, 20, 14, 1, 1, 1, 1, '1999-04-01', '1999-04-05',  NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (19, 19, 15, 5, 5, 4, 4, '1999-05-04', '1999-05-09', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (20, 17, 17, 2, 2, 3, 1, '1999-08-10', '1999-08-17', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (21, 1, 3, 2, 2, 1, 1, '2000-01-01', '2000-01-03', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (22, 3, 4, 1, 1, 1, 1, '2000-01-06', '2000-01-07', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (23, 3, 4, 9, 9, 2, 2, '2000-01-04', '2000-10-04', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (24, 4, 3, 10, 9, 3, 3, '2000-02-10', '2000-02-12', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (25, 6, 7, 10, 9, 3, 3, '2000-02-12', '2000-02-13', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (26, 5, 8, 10, 2, 1, 3, '2000-03-07', '2000-03-09', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (27, 8, 11, 9, 2, 1, 1, '2000-04-07', '2000-04-15', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (28, 6, 11, 1, 5, 4, 3, '2000-06-08', '2000-06-11', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (29, 7, 17, 2, 3, 1, 2, '2000-06-09', '2000-06-10', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (30, 9, 17, 2, 10, 1, 2, '2000-06-12', '2000-06-16', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (31, 10, 1, 5, 1, 3, 3, '2000-06-21', '2000-06-23', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (32, 12, 2, 5, 4, 4, 1, '2000-06-23', '2000-06-29', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (33, 11, 5, 1, 2, 3, 1, '2000-06-27', '2000-06-30', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (34, 13, 5, 1, 2, 4, 1, '2000-07-01', '2000-07-05', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (35, 14, 4, 1, 2, 2, 3, '2000-07-04', '2000-07-04', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (36, 15, 18, 9, 7, 2, 2, '2000-07-08', '2000-08-03', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (37, 16, 13, 10, 10, 4, 1, '2000-07-11', '2000-07-12', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (38, 20, 14, 1, 4, 1, 2, '2000-07-13', '2000-07-29',  NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (39, 19, 15, 5, 6, 4, 3, '2000-10-04', '2000-10-09', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (40, 17, 17, 2, 2, 3, 1, '2000-11-10', '2000-12-01', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (41, 1, 3, 2, 2, 1, 1, '2000-12-20', '2001-01-03', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (42, 3, 4, 1, 1, 1, 1, '2001-02-06', '2001-02-07', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (43, 3, 4, 9, 9, 2, 2, '2001-03-04', '2001-03-07', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (44, 4, 3, 10, 10, 3, 3, '2001-04-10', '2001-04-12', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (45, 6, 7, 10, 10, 3, 3, '2002-02-12', '2002-02-13', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (46, 5, 8, 10, 2, 1, 3, '2002-03-07', '2002-03-09', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (47, 8, 11, 9, 2, 1, 1, '2002-04-07', '2002-04-15', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (48, 6, 11, 1, 5, 4, 4, '2003-06-08', '2003-06-11', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (49, 7, 17, 2, 2, 1, 2, '2003-06-09', '2003-06-10', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (50, 9, 17, 2, 10, 1, 2, '2003-06-12', '2003-06-16', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (51, 10, 1, 5, 5, 3, 3, '2004-06-21', '2004-06-23', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (52, 12, 2, 5, 5, 4, 4, '2004-06-23', '2004-06-29', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (53, 11, 5, 1, 5, 3, 1, '2004-06-27', '2004-06-30', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (54, 13, 5, 1, 1, 4, 1, '2004-07-01', '2004-07-05', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (55, 14, 4, 1, 1, 2, 2, '2004-07-04', '2004-07-04', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (56, 15, 18, 9, 9, 2, 2, '2004-07-08', '2004-08-03', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (57, 16, 13, 10, 10, 4, 1, '2004-07-11', '2004-07-12', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (58, 20, 14, 1, 1, 1, 1, '2004-07-13', '2004-07-29',  NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (59, 19, 15, 5, 5, 4, 4, '2005-10-04', '2005-10-09', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (60, 17, 17, 2, 2, 3, 1, '2005-11-10', '2005-12-01', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (61, 1, 3, 2, 2, 1, 1, '2006-01-01', '2006-01-03', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (62, 3, 4, 1, 1, 1, 1, '2006-01-06', '2006-01-07', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (63, 3, 4, 9, 9, 2, 2, '2006-01-04', '2006-10-04', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (64, 4, 3, 10, 10, 3, 3, '2006-02-10', '2006-02-12', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (65, 6, 7, 10, 10, 3, 3, '2006-02-12', '2006-02-13', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (66, 5, 8, 10, 2, 1, 3, '2006-03-07', '2006-03-09', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (67, 8, 11, 9, 2, 1, 1, '2006-04-07', '2006-04-15', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (68, 6, 11, 1, 5, 4, 4, '2006-06-08', '2006-06-11', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (69, 7, 17, 2, 2, 1, 2, '2007-06-09', '2007-06-10', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (70, 9, 17, 2, 10, 1, 2, '2007-06-12', '2007-06-16', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (71, 10, 1, 5, 5, 3, 3, '2007-06-21', '2007-06-23', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (72, 12, 2, 5, 5, 4, 4, '2007-06-23', '2007-06-29', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (73, 11, 5, 1, 5, 3, 1, '2008-06-27', '2008-06-30', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (74, 13, 5, 1, 1, 4, 1, '2008-07-01', '2008-07-05', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (75, 14, 4, 1, 1, 2, 2, '2008-07-04', '2008-07-04', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (76, 15, 18, 9, 9, 2, 2, '2009-07-08', '2009-08-03', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (77, 16, 13, 10, 10, 4, 1, '2009-07-11', '2009-07-12', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (78, 20, 14, 1, 1, 1, 1, '2009-07-13', '2009-07-29',  NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (79, 19, 15, 5, 5, 4, 4, '2009-10-04', '2009-10-09', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (80, 17, 17, 2, 2, 3, 1, '2009-11-10', '2009-12-01', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (81, 1, 3, 2, 2, 1, 1, '2009-12-29', '2010-01-03', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (82, 3, 4, 1, 1, 1, 1, '2011-02-06', '2011-02-07', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (83, 3, 4, 9, 9, 2, 2, '2011-03-04', '2011-03-07', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (84, 4, 3, 10, 10, 3, 3, '2011-04-10', '2011-04-12', NULL, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (85, 6, 7, 10, 10, 3, 3, '2012-02-12', '2012-02-13', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (86, 5, 8, 10, 2, 1, 3, '2012-03-07', '2012-03-09', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (87, 8, 11, 9, 2, 1, 1, '2012-04-07', '2012-04-15', 200, 50);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (88, 6, 11, 1, 5, 4, 4, '2013-06-08', '2013-06-11', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (89, 7, 17, 2, 2, 1, 2, '2013-06-09', '2013-06-10', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (90, 9, 17, 2, 10, 1, 2, '2013-06-12', '2013-06-16', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (91, 10, 1, 5, 5, 3, 3, '2013-06-21', '2013-06-23', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (92, 12, 2, 5, 5, 4, 4, '2013-06-23', '2013-06-29', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (93, 11, 5, 1, 5, 3, 1, '2013-06-27', '2013-06-30', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (94, 13, 5, 1, 1, 4, 1, '2013-07-01', '2013-07-05', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (95, 14, 4, 1, 1, 2, 2, '2013-07-04', '2013-07-04', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (96, 15, 18, 9, 9, 2, 2, '2013-07-08', '2013-08-03', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (97, 16, 13, 10, 10, 4, 1, '2013-07-11', '2013-07-12', 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (98, 20, 14, 1, 1, 1, 1, '2014-01-13', '2014-02-28',  NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (99, 19, 15, 5, 5, 4, 4, '2014-01-14', '2014-01-24', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (100, 17, 17, 2, 2, 3, 1, '2014-01-10', '2014-01-12', NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (101, 18, 9, 2, NULL, 1,  NULL, '2014-03-04',  NULL, NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (102, 17, 1, 1, NULL, 2,  NULL, '2014-03-11',  NULL, NULL, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (103, 9, 3, 10, NULL, 2,  NULL, '2014-03-14',  NULL, 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (104, 14, 4, 5, NULL, 1,  NULL, '2014-03-20',  NULL, 200, 100);

INSERT INTO wypozyczenie(id_wypozyczenie,id_klient,id_samochod,id_pracow_wyp,id_pracow_odd,id_miejsca_wyp,id_miejsca_odd,data_wyp,data_odd,kaucja,cena_jedn)
VALUES (105, 10, 5, 9, NULL, 2,  NULL, '2014-03-26',  NULL, 200, 100);
GO

/*
--klucze obce, celowo zostały zakomentowane
ALTER TABLE wypozyczenie ADD CONSTRAINT fk_wypozyczenie_samochod 
FOREIGN KEY(id_samochod) REFERENCES samochod(id_samochod);

ALTER TABLE wypozyczenie ADD CONSTRAINT fk_wypozyczenie_klient 
FOREIGN KEY(id_klient) REFERENCES klient(id_klient);

ALTER TABLE wypozyczenie ADD CONSTRAINT fk_wypozyczenie_pracownik1 
FOREIGN KEY(id_pracow_wyp) REFERENCES pracownik(id_pracownik);

ALTER TABLE wypozyczenie ADD CONSTRAINT fk_wypozyczenie_pracownik2 
FOREIGN KEY(id_pracow_odd) REFERENCES pracownik(id_pracownik);

ALTER TABLE wypozyczenie ADD CONSTRAINT fk_wypozyczenie_miejsce1 
FOREIGN KEY(id_miejsca_wyp) REFERENCES miejsce(id_miejsce);

ALTER TABLE wypozyczenie ADD CONSTRAINT fk_wypozyczenie_miejsce2 
FOREIGN KEY(id_miejsca_odd) REFERENCES miejsce(id_miejsce);

ALTER TABLE pracownik ADD CONSTRAINT fk_pracownik_miejsce 
FOREIGN KEY(id_miejsce) REFERENCES miejsce(id_miejsce);
*/

--wyświetlenie zawartości tabel
SELECT * FROM pracownik;
SELECT * FROM klient;
SELECT * FROM samochod;
SELECT * FROM miejsce;
SELECT * FROM wypozyczenie;

SELECT 'Ilości rekordów:';

SELECT 
  (SELECT COUNT(*) FROM pracownik) AS pracownik,
  (SELECT COUNT(*) FROM klient) AS klient,
  (SELECT COUNT(*) FROM samochod) AS samochod,
  (SELECT COUNT(*) FROM miejsce) AS miejsce,
  (SELECT COUNT(*) FROM wypozyczenie) AS wypozyczenie
  

