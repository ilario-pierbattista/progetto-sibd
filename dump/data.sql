/** Inserimento Cliente */
INSERT INTO Cliente (CF_PIVA, Nome, Cognome, Citta, Via, Civico, CAP, NDocId)
VALUES
  ('PRBLRI93R05I324O', 'Ilario', 'Pierbattista', 'Monte Urano', 'Via Picena', '14', '63813', 'AO5254936'),
  ('STFLSN93A08E783E', 'Alessandro', 'Staffolani', 'Pollenza', 'Via Cardarelli', '31', '62010', 'MC5160237'),
  ('RSSMRA78L13L366E', 'Mario', 'Rossi', 'Treia', 'Via Roma', '56', '62010', 'LM3698120');

/** Inserimento Fornitore */
INSERT INTO Fornitore (PIVA, RagioneSociale, TempiConsegna, ModPagamento, IBAN, Citta, Via, Civico, CAP)
VALUES
  ('02365478952', 'Metano Ancona', 2, 'bonifico', 'IT02L1234512345123456789012', 'Ancona', 'Viale Raffaello', '145B',
   '60100'),
  ('05987418630', 'MC Ricambi', 1, 'assegno', 'IT02L1234512345473450089087', 'Macerata', 'Via Podesti', '98', '62100'),
  ('00236587149', 'Cerchioni srl', 2, 'bonifico', 'IT02L1254312534123451000012', 'Recanati', 'Corso Leopardi', '45',
   '64521');

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

/** Inserimento Autovettura */
INSERT INTO Autovettura (Targa, Telaio, Marca, Modello, Cilindrata, AnnoImmatricolazione, UltimoCollaudo, UltimaRevisione, Cliente)
VALUES ('BX692TE', 'ZFA17600002123456', 'Fiat', 'Punto', 1200, 2001, '2014-05-15', '2012-08-02', 'STFLSN93A08E783E'),
  ('BN548BL', 'WVW18500002123874', 'Volkswagen', 'Golf', 1600, 2013, '2013-08-23', '2013-04-14', 'RSSMRA78L13L366E'),
  ('EZ874LO', 'VF7SA5FR8AW654321', 'Citroen', 'C3', 1400, 2010, '2011-10-10', '2010-01-31', 'PRBLRI93R05I324O'),
  ('RT435CM', 'ZAF47800002743656', 'Alfa Romeo', '147', 1800, 2008, '2014-06-15', '2013-11-15', 'STFLSN93A08E783E');

/** Inserimento Componente */
INSERT INTO Componente (Nome, QuantitaMin, Validita, PrezzoVendita)
VALUES ('Bombola Metano 100l', 4, 365 * 5, 400),
  ('Bombola Metano 80l', 3, 365 * 5, 350),
  ('Serbatoio GPL', 3, 365 * 5, 380),
  ('Kit Evo Metano', 2, 365 * 2, 250),
  ('Kit Evo GPL', 2, 365 * 2, 240),
  ('Iniettore', 4, 365, 100),
  ('Preomatico 15 pollici', 4, 365 * 10, 220);

/** Insemento Transazione */
INSERT INTO Transazione (Quota, Data) VALUES (800, '2015-04-09');
INSERT INTO Transazione (Quota, Data) VALUES (1000, '2015-02-08');
INSERT INTO Transazione (Quota, Data) VALUES (650, '2015-04-15');
INSERT INTO Transazione (Quota, Data) VALUES (200, '2015-05-05');
INSERT INTO Transazione (Quota, Data) VALUES (200, '2015-02-15');
INSERT INTO Transazione (Quota, Data) VALUES (1800, '2015-04-06');
INSERT INTO Transazione (Quota, Data) VALUES (1200, '2015-04-06');
INSERT INTO Transazione (Quota, Data) VALUES (1000, '2015-04-06');

/** Inserimento Preventivo */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria, Sintomi, SisAlimentazione, TempoStimato, CostoComponenti, Manodopera, ServAggiuntivi, Autovettura)
VALUES
  ('2015-04-09', '2015-04-22', 'installazione_impianto_metano', 'Installazione classica impianto metano',
   'iniezione', 48, 1100, 400, 100, 'BX692TE'),
  ('2015-02-15', '2015-02-15', 'riparazione', 'Routa bucata', NULL, 2, 220, 50, 0, 'BN548BL');

INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria, Sintomi, SisAlimentazione, TempoStimato, CostoComponenti, Manodopera, ServAggiuntivi, Autovettura, Acconto)
VALUES ('2015-05-03', '2015-05-15', 'installazione_impianto_gpl', 'Installazione classica impianto GPL',
        'aspirazione', 48, 1000, 400, 150, 'EZ874LO', 1);

/** Inserimento Previsione */
INSERT INTO Previsione (Componente, Preventivo, Ubicazione, Quantita, PrezzoUnitario)
VALUES (1, 1, 'bagagliaio', 1, 400),
  (2, 1, 'bagagliaio', 1, 350),
  (4, 1, 'motore', 1, 250),
  (6, 1, 'motore', 1, 100);

/** preventivo 2 */
INSERT INTO Previsione (Componente, Preventivo, Quantita, PrezzoUnitario)
VALUES (7, 2, 1, 220);

/** preventivo 3 */
INSERT INTO Previsione (Componente, Preventivo, Ubicazione, Quantita, PrezzoUnitario)
VALUES (3, 3, 'bagagliaio', 2, 380),
  (5, 3, 'motore', 1, 240);

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

/** Inserimento Ordine */

INSERT INTO Ordine (DataEmissione, DataConsegna, Fornitore, Versamento)
VALUES ('2015-02-08', '2015-02-10', '02365478952', 2);
INSERT INTO Fornitura (Quantita, PrezzoUnitario, Componente, Ordine)
VALUES (2, 300, 1, 1),
  (2, 200, 2, 1);

INSERT INTO Ordine (DataEmissione, DataConsegna, Fornitore, Versamento)
VALUES ('2015-04-15', '2015-04-16', '05987418630', 3);
INSERT INTO Fornitura (Quantita, PrezzoUnitario, Componente, Ordine)
VALUES (2, 200, 4, 2),
  (1, 100, 5, 2);

INSERT INTO Ordine (DataEmissione, DataConsegna, Fornitore, Versamento)
VALUES ('2015-05-05', '2015-05-07', '00236587149', 4);
INSERT INTO Fornitura (Quantita, PrezzoUnitario, Componente, Ordine)
VALUES (3, 50, 6, 2),
  (2, 100, 7, 3);

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

/** Inserimento Magazzino */
INSERT INTO Magazzino (Componente, Fornitura, Quantita)
VALUES
  (1, 1, 1),
  (2, 2, 1),
  (4, 3, 1),
  (6, 5, 2),
  (7, 6, 1);

/** Inserimento Fattura */
INSERT INTO Fattura (Numero, Anno, Imponibile, Sconto, Incentivi,
                     DataEmissione, DataScadenza, TipoPag, StatoPag,
                     SisPag, Prestazione, Transazione)
VALUES
  (1, 2015, 1100, 5, 0, '2015-04-24', '2015-05-24', 'assegno', 0,
   'rimessa_differita', 1, NULL),
  (2, 2015, 200, 0, 0, '2015-02-15', '2015-02-15', 'contanti', 1,
   'rimessa_diretta', 2, 5);

/** Inserimento Turno */

INSERT INTO Turno (Operatore, Data, OraInizio, OraFine)
VALUES ('STFDRN60A02E783V', '2015-04-09', '08:00:00', '18:30:00'),
  ('STFDRN60A02E783V', '2015-04-08', '08:00:00', '18:30:00'),
  ('VNCNDR84T24I156L', '2015-04-09', '08:30:00', '16:30:00'),
  ('VRDLCU90D15E783S', '2015-04-09', '08:30:00', '12:30:00'),
  ('VRDLCU90D15E783S', '2015-04-09', '14:30:00', '18:30:00');

/** Inserimento Stipendio */

INSERT INTO Stipendio (Transazione, Operatore)
VALUES (6, 'STFDRN60A02E783V');

INSERT INTO Stipendio (Transazione, Operatore)
VALUES (7, 'VNCNDR84T24I156L');

INSERT INTO Stipendio (Transazione, Operatore)
VALUES (8, 'VRDLCU90D15E783S');

/** Inserimento Recapito */
/* Operatori */
INSERT INTO Recapito (Recapito, Tipo)
VALUES ('0733843482', 'tel_fax');
INSERT INTO RubricaOperatore (Recapito, Operatore)
VALUES (1, 'STFDRN60A02E783V');

/* Fornitori */
INSERT INTO Recapito (Recapito, Tipo)
VALUES ('0718452369', 'fax');
INSERT INTO RubricaFornitore (Recapito, Fornitore)
VALUES (2, '02365478952');

/* Clienti */

INSERT INTO Recapito (Recapito, Tipo)
VALUES ('3382704282', 'telefono');
INSERT INTO RubricaCliente (Recapito, Cliente)
VALUES (3, 'STFLSN93A08E783E');

INSERT INTO Recapito (Recapito, Tipo)
VALUES ('alestam93@gmail.com', 'email');
INSERT INTO RubricaCliente (Recapito, Cliente)
VALUES (4, 'STFLSN93A08E783E');