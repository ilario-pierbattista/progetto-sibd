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
  ('EZ874LO', 'VF7SA5FR8AW654321', 'Citroen', 'C3', 1400, 2010, '2011-10-10', '2010-01-31', 'PRBLRI93R05I324O'),
  ('RT435CM', 'ZAF47800002743656', 'Alfa Romeo', '147', 1800, 2008, '2014-06-15', '2013-11-15', 'STFLSN93A08E783E');

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
  ('00523300358', 'Landi Renzo', 2, 'bonifico', 'IT02L1234512345123456781234', 'Cavriago', 'Via Nobel', '2',
   '42025'),
  ('02365478952', 'Metano Ancona', 2, 'bonifico', 'IT02L1234512345123456789012', 'Ancona', 'Viale Raffaello', '145B',
   '60100'),
  ('05987418630', 'MC Ricambi', 1, 'assegno', 'IT02L1234512345473450089087', 'Macerata', 'Via Podesti', '98', '62100'),
  ('00236587149', 'Cerchioni srl', 2, 'bonifico', 'IT02L1254312534123451000012', 'Recanati', 'Corso Leopardi', '45',
   '64521');

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
  ('Kit Evo Metano', 2, 365 * 2, 250), /* 4 */
  ('Kit Evo GPL', 2, 365 * 2, 240), /* 5 */
  ('Iniettore', 4, 365, 100), /* 6 */
  ('Pneumatico 15 pollici', 4, 365 * 2, 80), /* 7 */
  ('Olio Motore', 10, 365, 40), /* 8 */
  ('Kit frizione Golf', 0, NULL, 130), /* 9 */
  ('Aspiratore', 3, 365, 100);


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
INSERT INTO Transazione (Quota)
VALUES (calc_transazione_ordine(@last_ord, 0));
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Ordine
SET Ordine.Versamento = @last_trans,
  Ordine.DataConsegna = '2015-04-10'
WHERE Ordine.Codice = @last_ord;
CALL registra_ordine_magazzino(@last_ord);


/****************************************
 * Inserimento di nuovi preventivi
 ****************************************
 */
/* Primo preventivo */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria, Sintomi,
                        SisAlimentazione, TempoStimato,
                        Manodopera, ServAggiuntivi, Autovettura)
VALUES ('2015-04-09', '2015-04-22', 'installazione_impianto_metano',
        NULL, 'iniezione', 2, 400, 100, 'BX692TE');
SELECT LAST_INSERT_ID()
INTO @last_preventivo;
INSERT INTO Previsione (Componente, Preventivo, Ubicazione, Quantita)
VALUES
  (1, @last_preventivo, 'bagagliaio', 1),
  (4, @last_preventivo, 'motore', 1),
  (6, @last_preventivo, 'motore', 1),
  (8, @last_preventivo, 'motore', 1);
INSERT INTO Transazione (Quota) VALUES (400);
SELECT LAST_INSERT_ID()
INTO @last_transazione;
UPDATE Preventivo
SET Acconto       = @last_transazione,
  CostoComponenti = calc_costo_componenti_preventivo(@last_preventivo)
WHERE Preventivo.Codice = @last_preventivo;

/* Secondo preventivo */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria, Sintomi,
                        SisAlimentazione, TempoStimato,
                        Manodopera, ServAggiuntivi, Autovettura)
VALUES ('2015-02-15', '2015-02-15', 'riparazione',
        'Difficoltà nell''inserire le marce, disco della frizione incollato al volano.',
        NULL, 2, 50, 0, 'BN548BL');
SELECT LAST_INSERT_ID()
INTO @last_prev;
INSERT INTO Previsione (Componente, Preventivo, Quantita)
VALUES
  (9, @last_prev, 9);
UPDATE Preventivo
SET CostoComponenti = calc_costo_componenti_preventivo(@last_prev)
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
INSERT INTO Transazione (Quota) VALUES (500);
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Preventivo
SET Acconto       = @last_tras,
  CostoComponenti = calc_costo_componenti_preventivo(@last_prev)
WHERE Preventivo.Codice = @last_prev;


/** Inserimento Prestazione */
INSERT INTO Prestazione (Preventivo, TempiEsecuzione, Procedimento, DataFine, Malfunzionamento, Manodopera, ServAggiuntivi)
VALUES (1, 48, 'Installazione tradizionale impianto metano', '2015-04-24', 'Impianto Metano', 420, 115);

INSERT INTO Prestazione (Preventivo, TempiEsecuzione, Procedimento, DataFine, Malfunzionamento, Manodopera, ServAggiuntivi)
VALUES (2, 1, 'Sostituzione pneomatico anteriore destro', '2015-02-15', 'Ruota Bucata', 30, 15);

/** Inserimento Occupazione */

INSERT INTO Occupazione (Prestazione, Operatore)
VALUES (1, 'STFDRN60A02E783V');

INSERT INTO Occupazione (Prestazione, Operatore)
VALUES (2, 'VRDLCU90D15E783S');

/** Inserimento Utilizzo */

/** prestazione 1 */
INSERT INTO Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
VALUES (1, 1, 400, 1);
INSERT INTO Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
VALUES (1, 2, 350, 1);
INSERT INTO Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
VALUES (1, 3, 250, 1);
INSERT INTO Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
VALUES (1, 5, 100, 1);

/** prestazione 2 */
INSERT INTO Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
VALUES (2, 6, 200, 1);

/** Inserimento Fattura */
INSERT INTO Fattura (Numero, Anno, Imponibile, Sconto, Incentivi,
                     DataEmissione, DataScadenza, TipoPag, StatoPag,
                     SisPag, Prestazione, Transazione)
VALUES
  (1, 2015, 1100, 5, 0, '2015-04-24', '2015-05-24', 'assegno', 0,
   'rimessa_differita', 1, NULL),
  (2, 2015, 200, 0, 0, '2015-02-15', '2015-02-15', 'contanti', 1,
   'rimessa_diretta', 2, 5);