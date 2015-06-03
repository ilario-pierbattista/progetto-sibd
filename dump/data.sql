/**********************************
 * Inserimento di nuovi clienti
 **********************************
 */
/* Cliente non dotato di partita iva */
INSERT INTO Cliente (CF_PIVA, Nome, Cognome, Citta, Via, Civico, CAP, NDocId)
VALUES
  ('PRBLRI93R05I324O', 'Ilario', 'Pierbattista', 'Monte Urano', 'Via Picena', '14', '63813', 'AO5254936'),
  ('STFLSN93A08E783E', 'Alessandro', 'Staffolani', 'Pollenza', 'Via Cardarelli', '31', '62010', 'MC5160237'),
  ('RSSMRA78L13L366E', 'Mario', 'Rossi', 'Treia', 'Via Roma', '56', '62010', 'LM3698120');

/* Cliente dotato di partita iva */
INSERT INTO Cliente (CF_PIVA, RagioneSociale, Citta, Via, Civico, CAP)
VALUES
  ('00138790431', 'Comune di Treia', 'Treia', 'Piazza della Repubblica', '2', '62010');

/** Inserimento Autovettura */
INSERT INTO Autovettura (Targa, Telaio, Marca, Modello, Cilindrata, AnnoImmatricolazione, UltimoCollaudo, UltimaRevisione, Cliente)
VALUES ('BX692TE', 'ZFA17600002123456', 'Fiat', 'Punto', 1200, 2001, '2014-05-15', '2012-08-02', 'STFLSN93A08E783E'),
  ('BN548BL', 'WVW18500002123874', 'Volkswagen', 'Golf', 1600, 2013, '2013-08-23', '2013-04-14', 'RSSMRA78L13L366E'),
  ('EZ874LO', 'VF7SA5FR8AW654321', 'Citroen', 'C3', 1400, 2010, '2010-06-10', '2010-01-31', 'PRBLRI93R05I324O'),
  ('RT435CM', 'ZAF47800002743656', 'Alfa Romeo', '147', 1800, 2008, '2014-06-15', '2010-11-15', 'STFLSN93A08E783E'),
  ('AB123OR', 'BAF47800002243656', 'Fiat', 'Panda', 1200, 2009, '2014-06-10', '2014-06-10', 'PRBLRI93R05I324O');

/* Inserimento ed associazione dei recapiti */
CALL add_recapito_cliente('STFLSN93A08E783E', '3382704282', 'telefono');
CALL add_recapito_cliente('STFLSN93A08E783E', 'alestam93@gmail.com', 'email');
CALL add_recapito_cliente('PRBLRI93R05I324O', '3312704268', 'telefono');
CALL add_recapito_cliente('PRBLRI93R05I324O', 'pierbattista.ilario@gmail.com', 'email');
CALL add_recapito_cliente('RSSMRA78L13L366E', '3300011222', 'telefono');
CALL add_recapito_cliente('00138790431', '0733218705', 'telefono');
CALL add_recapito_cliente('00138790431', '0733218709', 'fax');


/***********************************
 * Inserimento di nuovi fornitori
 ***********************************
 */
INSERT INTO Fornitore (PIVA, RagioneSociale, TempiConsegna, ModPagamento, IBAN, Citta, Via, Civico, CAP)
VALUES
  ('00523300358', 'Landi Renzo', 2, 'bonifico', 'IT02L1234512345123456781234',
   'Cavriago', 'Via Nobel', '2', '42025'),
  ('02365478952', 'Metano Ancona', 2, 'bonifico', 'IT02L1234512345123456789012',
   'Ancona', 'Viale Raffaello', '145B', '60100'),
  ('05987418630', 'MC Ricambi', 1, 'assegno', 'IT02L1234512345473450089087',
   'Macerata', 'Via Podesti', '98', '62100'),
  ('00236587149', 'Cerchioni srl', 2, 'bonifico', 'IT02L1254312534123451000012',
   'Recanati', 'Corso Leopardi', '45', '64521'),
  ('02555531207', 'Autozona srl', 5, 'bonifico', 'IT02L1254312534123451000013',
   'Casalecchio di Reno', 'Via dei Caduti di Reggio Emilia', '33bis', '40033');

/** Inserimento ed associazione recapiti dei nuovi fornitori */
CALL add_recapito_fornitore('00523300358', '05229433', 'telefono');
CALL add_recapito_fornitore('00523300358', '0522944044', 'fax');
CALL add_recapito_fornitore('00523300358', '800213883', 'telefono');
CALL add_recapito_fornitore('00523300358', 'http://preventivo.landi.it/preventivi.php', 'sito_web');
CALL add_recapito_fornitore('02365478952', '0718452370', 'tel_fax');
CALL add_recapito_fornitore('02365478952', '0718452369', 'fax');
CALL add_recapito_fornitore('05987418630', '07331234567', 'telefono');
CALL add_recapito_fornitore('05987418630', 'mc.ricambi@gmail.com', 'email');
CALL add_recapito_fornitore('00236587149', '07331234568', 'telefono');
CALL add_recapito_fornitore('02555531207', 'http://www.autozona.it/', 'sito_web');
CALL add_recapito_fornitore('02555531207', '051753303', 'telefono');


/*******************************************
 * Inserimento di nuovi operatori
 *******************************************
 */
/** Inserimento Operatore con stipendio fisso */
INSERT INTO Operatore (CF, Nome, Cognome, Citta, Via, Civico, CAP, DataNasc, ComuneNasc, ProvinciaNasc, Stipendio, ModRiscossione, IBAN)
VALUES
  ('STFDRN60A02E783V', 'Adriano', 'Staffolani', 'Pollenza', 'Via Cardarelli', '31', '62010',
   '1960-01-02', 'Macerata', 'MC', 1800, 'bonifico', 'IT02L1254312534123651074012'),
  ('VNCNDR84T24I156L', 'Andrea', 'Vincenzetti', 'San Severino', 'Via della Repubblica', '12', '62300',
   '1984-12-24', 'San Severino', 'MC', 1200, 'assegno', 'IT02L1254312004743501000012');
/* Operatore con retribuzione oraria */
INSERT INTO Operatore (CF, Nome, Cognome, Citta, Via, Civico, CAP, DataNasc, ComuneNasc, ProvinciaNasc, RetribuzioneH, ModRiscossione, IBAN)
VALUES
  ('VRDLCU90D15E783S', 'Luca', 'Verdi', 'Tolentino', 'Viale Isonzo', '87', '62150',
   '1990-04-15', 'Macerata', 'MC', 8, 'contanti', 'IT02L1254312000023451000012');

/** Inserimento recapiti */
CALL add_recapito_operatore('STFDRN60A02E783V', '0733843482', 'tel_fax');
CALL add_recapito_operatore('VNCNDR84T24I156L', '0733853583', 'telefono');
CALL add_recapito_operatore('VRDLCU90D15E783S', '0733854593', 'telefono');
CALL add_recapito_operatore('VRDLCU90D15E783S', 'luca.verdi@gmail.com', 'email');

/** Inserimento di turni */
INSERT INTO Turno (Operatore, Data, OraInizio, OraFine)
VALUES
  ('STFDRN60A02E783V', '2015-04-08', '08:00:00', '18:30:00'),
  ('STFDRN60A02E783V', '2015-04-09', '08:00:00', '18:30:00'),
  ('STFDRN60A02E783V', '2015-04-10', '08:00:00', '18:30:00'),
  ('STFDRN60A02E783V', '2015-04-11', '08:00:00', '18:30:00'),
  ('STFDRN60A02E783V', '2015-04-12', '08:00:00', '18:30:00'),
  ('STFDRN60A02E783V', '2015-04-13', '08:00:00', '18:30:00'),
  ('STFDRN60A02E783V', '2015-04-14', '08:00:00', '18:30:00'),
  ('STFDRN60A02E783V', '2015-04-15', '08:00:00', '18:30:00'),
  ('VNCNDR84T24I156L', '2015-04-09', '08:30:00', '16:30:00'),
  ('VNCNDR84T24I156L', '2015-04-10', '08:30:00', '16:30:00'),
  ('VNCNDR84T24I156L', '2015-04-11', '08:30:00', '16:30:00'),
  ('VNCNDR84T24I156L', '2015-04-12', '08:30:00', '16:30:00'),
  ('VNCNDR84T24I156L', '2015-04-13', '08:30:00', '16:30:00'),
  ('VNCNDR84T24I156L', '2015-04-14', '08:30:00', '16:30:00'),
  ('VNCNDR84T24I156L', '2015-04-15', '08:30:00', '16:30:00'),
  ('VNCNDR84T24I156L', '2015-04-16', '08:30:00', '16:30:00'),
  ('VRDLCU90D15E783S', '2015-04-09', '08:30:00', '12:30:00'),
  ('VRDLCU90D15E783S', '2015-04-09', '14:30:00', '18:30:00'),
  ('VRDLCU90D15E783S', '2015-04-10', '14:30:00', '18:30:00'),
  ('VRDLCU90D15E783S', '2015-04-11', '14:30:00', '18:30:00'),
  ('VRDLCU90D15E783S', '2015-04-12', '14:30:00', '18:30:00'),
  ('VRDLCU90D15E783S', '2015-04-14', '14:30:00', '18:30:00'),
  ('VRDLCU90D15E783S', '2015-04-15', '14:30:00', '18:30:00'),
  ('VRDLCU90D15E783S', '2015-04-16', '14:30:00', '18:30:00');


/***************************************
 * Inserimento di nuovi componenti
 ***************************************
 */
INSERT INTO Componente (Nome, QuantitaMin, Validita, PrezzoVendita)
VALUES
  ('Bombola Metano 100l', 4, 365 * 5, 400), /* 1 */
  ('Bombola Metano 80l', 3, 365 * 5, 350), /* 2 */
  ('Serbatoio GPL', 3, 365 * 5, 380), /* 3 */
  ('Kit Evo Metano', 2, 365, 250), /* 4 */
  ('Kit Evo GPL', 2, 365, 240), /* 5 */
  ('Iniettore', 4, 100, 100), /* 6 */
  ('Pneumatico 15 pollici', 4, 365 * 2, 80), /* 7 */
  ('Olio Motore', 10, 365, 40), /* 8 */
  ('Kit frizione Golf', 0, NULL, 130), /* 9 */
  ('Aspiratore', 3, 100, 100), /* 10 */
  ('Olio del Cambio', 8, 365, 25), /* 11 */
  ('Olio dei Freni', 9, 365 * 2, 10), /* 12 */
  ('Pastiglie dei freni FIAT', 4, 365, 30), /* 13 */
  ('Tubi freni anteriori FIAT', NULL, 365, 20);


/***************************************
 * Inserimento di un nuovo ordine
 ***************************************
 */
INSERT INTO Ordine (DataEmissione, Fornitore) VALUES ('2015-04-08', '00523300358');
SELECT LAST_INSERT_ID()
INTO @last_ord;
INSERT INTO Fornitura (Quantita, Componente, Ordine, PrezzoUnitario)
VALUES
  (2, 1, @last_ord, 350),
  (2, 2, @last_ord, 300),
  (2, 3, @last_ord, 320),
  (3, 4, @last_ord, 210),
  (3, 5, @last_ord, 200),
  (4, 6, @last_ord, 80),
  (4, 10, @last_ord, 80);
UPDATE Ordine
SET Imponibile = calc_imponibile_ordine(@last_ord)
WHERE Ordine.Codice = @last_ord;
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_ordine(@last_ord, 0), '2015-04-10');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Ordine
SET Ordine.Versamento = @last_trans,
  Ordine.DataConsegna = '2015-04-10'
WHERE Ordine.Codice = @last_ord;
CALL registra_ordine_magazzino(@last_ord);

INSERT INTO Ordine (DataEmissione, Fornitore) VALUES ('2015-04-07', '05987418630');
SELECT LAST_INSERT_ID()
INTO @last_ord;
INSERT INTO Fornitura (Quantita, Componente, Ordine, PrezzoUnitario)
VALUES
  (1, 9, @last_ord, 100),
  (7, 12, @last_ord, 6);
UPDATE Ordine
SET Imponibile = calc_imponibile_ordine(@last_ord)
WHERE Ordine.Codice = @last_ord;
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_ordine(@last_ord, 0), '2015-04-10');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Ordine
SET Ordine.Versamento = @last_trans,
  Ordine.DataConsegna = '2015-04-09'
WHERE Ordine.Codice = @last_ord;
CALL registra_ordine_magazzino(@last_ord);

INSERT INTO Ordine (DataEmissione, Fornitore) VALUES ('2015-04-09', '00236587149');
SELECT LAST_INSERT_ID()
INTO @last_ord;
INSERT INTO Fornitura (Quantita, Componente, Ordine, PrezzoUnitario)
VALUES
  (10, 8, @last_ord, 100),
  (8, 11, @last_ord, 20);
UPDATE Ordine
SET Imponibile = calc_imponibile_ordine(@last_ord)
WHERE Ordine.Codice = @last_ord;
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_ordine(@last_ord, 5), '2015-04-10');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Ordine
SET Ordine.Versamento = @last_trans,
  Ordine.DataConsegna = '2015-04-10'
WHERE Ordine.Codice = @last_ord;
CALL registra_ordine_magazzino(@last_ord);
/* Autozona */
INSERT INTO Ordine (DataEmissione, Fornitore) VALUES ('2015-04-10', '02555531207');
SELECT LAST_INSERT_ID()
INTO @last_ord;
INSERT INTO Fornitura (Quantita, Componente, Ordine, PrezzoUnitario)
VALUES
  (4, 13, @last_ord, 100),
  (1, 14, @last_ord, 20);
UPDATE Ordine
SET Imponibile = calc_imponibile_ordine(@last_ord)
WHERE Ordine.Codice = @last_ord;
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_ordine(@last_ord, 5), '2015-04-10');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Ordine
SET Ordine.Versamento = @last_trans,
  Ordine.DataConsegna = '2015-04-15'
WHERE Ordine.Codice = @last_ord;
CALL registra_ordine_magazzino(@last_ord);


/****************************************
 * Inserimento di nuovi preventivi
 ****************************************
 */
/* Primo preventivo */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria,
                        TempoStimato, Sintomi,
                        Manodopera, ServAggiuntivi, Autovettura)
VALUES ('2015-04-08', '2015-04-18', 'riparazione',
        2, 'Il pedale del freno è pericolosamente duro',
        100, 0, 'BN548BL');
SELECT LAST_INSERT_ID()
INTO @last_prev;
INSERT INTO Previsione (Componente, Preventivo, Quantita)
VALUES
  (12, @last_prev, 1),
  (13, @last_prev, 4),
  (14, @last_prev, 1);
UPDATE Preventivo
SET
  CostoComponenti = calc_costo_componenti_preventivo(@last_prev)
WHERE Preventivo.Codice = @last_prev;


/* Secondo preventivo */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria, Sintomi,
                        SisAlimentazione, TempoStimato,
                        Manodopera, ServAggiuntivi, Autovettura)
VALUES ('2015-04-09', '2015-04-22', 'installazione_impianto_metano',
        NULL, 'iniezione', 2, 400, 100, 'BX692TE');
SELECT LAST_INSERT_ID()
INTO @last_prev;
INSERT INTO Previsione (Componente, Preventivo, Ubicazione, Quantita)
VALUES
  (1, @last_prev, 'bagagliaio', 1),
  (4, @last_prev, 'motore', 1),
  (6, @last_prev, 'motore', 1),
  (8, @last_prev, 'motore', 1);
INSERT INTO Transazione (Quota, Data)
VALUES (400, '2015-04-09');
SELECT LAST_INSERT_ID()
INTO @last_transazione;
UPDATE Preventivo
SET Acconto       = @last_transazione,
  CostoComponenti = calc_costo_componenti_preventivo(@last_prev)
WHERE Preventivo.Codice = @last_prev;

/* Terzo preventivo */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria,
                        SisAlimentazione, TempoStimato,
                        Manodopera, ServAggiuntivi, Autovettura)
VALUES ('2015-05-03', '2015-05-15', 'installazione_impianto_gpl',
        'aspirazione', 2, 400, 150, 'EZ874LO');
SELECT LAST_INSERT_ID()
INTO @last_prev;
INSERT INTO Previsione (Componente, Preventivo, Quantita, Ubicazione)
VALUES
  (3, @last_prev, 1, 'bagagliaio'),
  (5, @last_prev, 1, 'motore'),
  (10, @last_prev, 1, 'motore'),
  (8, @last_prev, 1, 'motore');
INSERT INTO Transazione (Quota, Data)
VALUES (500, '2015-05-03');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Preventivo
SET Acconto       = @last_tras,
  CostoComponenti = calc_costo_componenti_preventivo(@last_prev)
WHERE Preventivo.Codice = @last_prev;


/* Quarto preventivo */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria,
                        TempoStimato,
                        Manodopera, ServAggiuntivi, Autovettura)
VALUES ('2015-05-01', '2015-05-10', 'revisione', 1,
        19.80, 45, 'AB123OR');
UPDATE Preventivo
SET
  CostoComponenti = calc_costo_componenti_preventivo(@last_prev)
WHERE Preventivo.Codice = @last_prev;


/* Quinto preventivo */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria, Sintomi,
                        SisAlimentazione, TempoStimato,
                        Manodopera, ServAggiuntivi, Autovettura)
VALUES ('2015-04-15', '2015-04-17', 'riparazione',
        'Difficoltà nell''inserire le marce, disco della frizione incollato al volano.',
        NULL, 1, 70, 0, 'BN548BL');
SELECT LAST_INSERT_ID()
INTO @last_prev;
INSERT INTO Previsione (Componente, Preventivo, Quantita)
VALUES
  (9, @last_prev, 1);
UPDATE Preventivo
SET CostoComponenti = calc_costo_componenti_preventivo(@last_prev)
WHERE Preventivo.Codice = @last_prev;

/************************************
 * Inserimento delle prestazioni
 ************************************
 */
/** Inserimento prestazione per preventivo 5 */
SET @last_prest = 5;
INSERT INTO Prestazione (Preventivo, TempiEsecuzione, Malfunzionamento, Procedimento,
                         DataFine, Manodopera, ServAggiuntivi)
VALUES (@last_prest, 2,
        'Guasto alla frizione',
        'Smontare le ruote anteriori, le sospensioni, staccare il motorino d''avviamento, '
        'svuotare l''olio del cambio, estrarre il cambio e sostituire la frizione',
        '2015-04-18', 80, 0);
INSERT INTO Utilizzo (Prestazione, Fornitura, Quantita)
VALUES
  (@last_prest, 10, 1),
  (@last_prest, 8, 1);
CALL update_quantita_magazzino(@last_prest);
INSERT INTO Occupazione (Prestazione, Operatore)
VALUES
  (@last_prest, 'VRDLCU90D15E783S');
SET @num_fattura = next_fattura_num(2015);
INSERT INTO Fattura (Numero, Anno, Imponibile, Sconto, Incentivi,
                     DataEmissione, DataScadenza, TipoPag,
                     StatoPag, SisPag, Prestazione)
VALUES (@num_fattura, 2015, calc_imponibile_fattura(@last_prest, 0), 0, 0,
        '2015-04-18', '2015-04-18', 'contanti',
        FALSE, 'rimessa_diretta', @last_prest);
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_fattura(@num_fattura, 2015), '2015-04-18');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Fattura
SET
  StatoPag    = TRUE,
  Transazione = @last_trans
WHERE Fattura.Numero = @num_fattura AND Fattura.Anno = 2015;

/** Inserimento prestazione per preventivo 1 */
SET @last_prest = 1;
INSERT INTO Prestazione (Preventivo, TempiEsecuzione, Malfunzionamento, Procedimento,
                         DataFine, Manodopera, ServAggiuntivi)
VALUES (@last_prest, 2,
        'Guasto al sistema frenante. Rottura dei tubi del freno. Pastiglie frenanti degradate.',
        'Smontare i tubi del freno, sostituirli, cambiare l''olio del freno. Sostituire le pastiglie',
        '2015-04-20', 100, 0);
INSERT INTO Utilizzo (Prestazione, Fornitura, Quantita)
VALUES
  (@last_prest, 9, 1),
  (@last_prest, 12, 4),
  (@last_prest, 13, 1);
CALL update_quantita_magazzino(@last_prest);
INSERT INTO Occupazione (Prestazione, Operatore)
VALUES
  (@last_prest, 'VRDLCU90D15E783S');
SET @num_fattura = next_fattura_num(2015);
INSERT INTO Fattura (Numero, Anno, Imponibile, Sconto, Incentivi,
                     DataEmissione, DataScadenza, TipoPag,
                     StatoPag, SisPag, Prestazione)
VALUES (@num_fattura, 2015, calc_imponibile_fattura(@last_prest, 0), 0, 0,
        '2015-04-20', '2015-04-20', 'contanti',
        FALSE, 'rimessa_diretta', @last_prest);
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_fattura(@num_fattura, 2015), '2015-04-20');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Fattura
SET
  StatoPag    = TRUE,
  Transazione = @last_trans
WHERE Fattura.Numero = @num_fattura AND Fattura.Anno = 2015;

/** Inserimento Prestazione per preventivo 2 */
SET @last_prest = 2;
INSERT INTO Prestazione (Preventivo, TempiEsecuzione, Procedimento,
                         DataFine, Manodopera, ServAggiuntivi)
VALUES (@last_prest, 2, 'Installazione tradizionale impianto metano', '2015-04-24', 420, 115);
INSERT INTO Utilizzo (Prestazione, Fornitura, Quantita)
VALUES
  (@last_prest, 1, 1),
  (@last_prest, 4, 1),
  (@last_prest, 6, 1);
CALL update_quantita_magazzino(@last_prest);
INSERT INTO Occupazione (Prestazione, Operatore)
VALUES
  (@last_prest, 'STFDRN60A02E783V'),
  (@last_prest, 'VNCNDR84T24I156L');
SET @num_fattura = next_fattura_num(2015);
INSERT INTO Fattura (Numero, Anno, Imponibile, Sconto, Incentivi,
                     DataEmissione, DataScadenza, TipoPag,
                     StatoPag, SisPag, Prestazione)
VALUES (@num_fattura, 2015, calc_imponibile_fattura(@last_prest, 5), 5, 0,
        '2015-04-24', '2015-05-01', 'assegno',
        FALSE, 'rimessa_differita', @last_prest);
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_fattura(@num_fattura, 2015), '2015-05-01');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Fattura
SET
  StatoPag    = TRUE,
  Transazione = @last_trans
WHERE Fattura.Numero = @num_fattura AND Fattura.Anno = 2015;

/** Inserimento prestazione per preventivo 4 */
SET @last_prest = 4;
INSERT INTO Prestazione (Preventivo, TempiEsecuzione,
                         DataFine, Manodopera, ServAggiuntivi)
VALUES (@last_prest, 2,
        '2015-05-11', 19.80, 45);
CALL update_quantita_magazzino(@last_prest);
UPDATE Autovettura
SET Autovettura.UltimaRevisione = '2015-05-11'
WHERE Autovettura.Targa = 'AB123OR';
INSERT INTO Occupazione (Prestazione, Operatore)
VALUES
  (@last_prest, 'STFDRN60A02E783V');
SET @num_fattura = next_fattura_num(2015);
INSERT INTO Fattura (Numero, Anno, Imponibile, Sconto, Incentivi,
                     DataEmissione, DataScadenza, TipoPag,
                     StatoPag, SisPag, Prestazione)
VALUES (@num_fattura, 2015, calc_imponibile_fattura(@last_prest, 0), 0, 0,
        '2015-04-11', '2015-04-11', 'contanti',
        FALSE, 'rimessa_diretta', @last_prest);
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_fattura(@num_fattura, 2015), '2015-04-11');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Fattura
SET
  StatoPag    = TRUE,
  Transazione = @last_trans
WHERE Fattura.Numero = @num_fattura AND Fattura.Anno = 2015;

/** Inserimento prestazione per preventivo 3 */
SET @last_prest = 3;
INSERT INTO Prestazione (Preventivo, TempiEsecuzione, Procedimento,
                         DataFine, Manodopera, ServAggiuntivi)
VALUES (@last_prest, 2,
        'Installazione di un impianto a gpl',
        '2015-05-18', 400, 140);
INSERT INTO Utilizzo (Prestazione, Fornitura, Quantita)
VALUES
  (@last_prest, 3, 1),
  (@last_prest, 5, 1),
  (@last_prest, 10, 1),
  (@last_prest, 7, 1);
CALL update_quantita_magazzino(@last_prest);
INSERT INTO Occupazione (Prestazione, Operatore)
VALUES
  (@last_prest, 'STFDRN60A02E783V'),
  (@last_prest, 'VRDLCU90D15E783S');
SET @num_fattura = next_fattura_num(2015);
INSERT INTO Fattura (Numero, Anno, Imponibile, Sconto, Incentivi,
                     DataEmissione, DataScadenza, TipoPag,
                     StatoPag, SisPag, Prestazione)
VALUES (@num_fattura, 2015, calc_imponibile_fattura(@last_prest, 0), 0, 200,
        '2015-04-18', '2015-04-24', 'bonifico',
        FALSE, 'rimessa_differita', @last_prest);
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_fattura(@num_fattura, 2015), '2015-04-23');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Fattura
SET
  StatoPag    = TRUE,
  Transazione = @last_trans
WHERE Fattura.Numero = @num_fattura AND Fattura.Anno = 2015;