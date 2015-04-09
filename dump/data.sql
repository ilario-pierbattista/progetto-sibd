/** Inserimento Cliente */

Insert Into Cliente (CF_PIVA, Nome, Cognome, Citta, Via, Civico, CAP, NDocId)
	Values ('PRBLRI93R05I324O', 'Ilario', 'Pierbattista', 'Monte Urano',
		'Via Picena', '14', '63813', 'AO5254936');

Insert Into Cliente (CF_PIVA, Nome, Cognome, Citta, Via, Civico, CAP, NDocId)
	Values ('STFLSN93A08E783E', 'Alessandro', 'Staffolani', 'Pollenza', 'Via Cardarelli', '31', '62010', 'MC5160237');

Insert Into Cliente (CF_PIVA, Nome, Cognome, Citta, Via, Civico, CAP, NDocId)
	Values ('RSSMRA78L13L366E', 'Mario', 'Rossi', 'Treia', 'Via Roma', '56', '62010', 'LM3698120');

/** Inserimento Fornitore */

Insert Into Fornitore (PIVA, RagioneSociale, TempiConsegna, ModPagamento, IBAN, Citta, Via, Civico, CAP)
	Values ('02365478952', 'Metano Ancona', 2, 'bonifico', 'IT02L1234512345123456789012', 'Ancona', 'Viale Raffaello', '145B', '60100');

Insert Into Fornitore (PIVA, RagioneSociale, TempiConsegna, ModPagamento, IBAN, Citta, Via, Civico, CAP)
	Values ('05987418630', 'MC Ricambi', 1, 'assegno', 'IT02L1234512345473450089087', 'Macerata', 'Via Podesti', '98', '62100');

Insert Into Fornitore (PIVA, RagioneSociale, TempiConsegna, ModPagamento, IBAN, Citta, Via, Civico, CAP)
	Values ('00236587149', 'Cerchioni srl', 2, 'bonifico', 'IT02L1254312534123451000012', 'Recanati', 'Corso Leopardi', '45', '64521');

/** Inserimento Operatore */

Insert Into Operatore (CF, Nome, Cognome, Citta, Via, Civico, CAP, DataNasc, ComuneNasc, ProvinciaNasc, Stipendio, RetribuzioneH, ModRiscossione, IBAN)
	Values ('STFDRN60A02E783V', 'Adriano', 'Staffolani', 'Pollenza', 'Via Cardarelli', '31', '62010', 
		'1960-01-02', 'Macerata', 'MC', 1800, 12, 'bonifico', 'IT02L1254312534123651074012');

Insert Into Operatore (CF, Nome, Cognome, Citta, Via, Civico, CAP, DataNasc, ComuneNasc, ProvinciaNasc, Stipendio, RetribuzioneH, ModRiscossione, IBAN)
	Values ('VNCNDR84T24I156L', 'Andrea', 'Vincenzetti', 'San Severino', 'Via della Repubblica', '12', '62300', 
		'1984-12-24', 'San Severino', 'MC', 1200, 8, 'assegno', 'IT02L1254312004743501000012');

Insert Into Operatore (CF, Nome, Cognome, Citta, Via, Civico, CAP, DataNasc, ComuneNasc, ProvinciaNasc, Stipendio, RetribuzioneH, ModRiscossione, IBAN)
	Values ('VRDLCU90D15E783S', 'Luca', 'Verdi', 'Tolentino', 'Viale Isonzo', '87', '62150', 
		'1990-04-15', 'Macerata', 'MC', 1000, 8, 'contanti', 'IT02L1254312000023451000012');

/** Inserimento Autovettura */

Insert Into Autovettura (Targa, Telaio, Marca, Modello, Cilindrata, AnnoImmatricolazione, UltimoCollaudo, UltimaRevisione, Cliente)
	Values ('BX692TE', 'ZFA17600002123456', 'Fiat', 'Punto', 1200, 2001, '2014-05-15', '2012-08-02', 'STFLSN93A08E783E');

Insert Into Autovettura (Targa, Telaio, Marca, Modello, Cilindrata, AnnoImmatricolazione, UltimoCollaudo, UltimaRevisione, Cliente)
	Values ('BN548BL', 'WVW18500002123874', 'Volkswagen', 'Golf', 1600, 2013, '2013-08-23', '2013-04-14', 'RSSMRA78L13L366E');

Insert Into Autovettura (Targa, Telaio, Marca, Modello, Cilindrata, AnnoImmatricolazione, UltimoCollaudo, UltimaRevisione, Cliente)
	Values ('EZ874LO', 'VF7SA5FR8AW654321', 'Citroen', 'C3', 1400, 2010, '2011-10-10', '2010-01-31', 'PRBLRI93R05I324O');

Insert Into Autovettura (Targa, Telaio, Marca, Modello, Cilindrata, AnnoImmatricolazione, UltimoCollaudo, UltimaRevisione, Cliente)
	Values ('RT435CM', 'ZAF47800002743656', 'Alfa Romeo', '147', 1800, 2008, '2014-06-15', '2013-11-15', 'STFLSN93A08E783E');

/** Inserimento Componente */

Insert Into Componente (Nome, QuantitaMin, Validita, PrezzoVendita) 
	Values ('Bombola Metano 100l', 4, 365*5, 400); 

Insert Into Componente (Nome, QuantitaMin, Validita, PrezzoVendita) 
	Values ('Bombola Metano 80l', 3, 365*5, 350); 

Insert Into Componente (Nome, QuantitaMin, Validita, PrezzoVendita) 
	Values ('Serbatoio GPL', 3, 365*5, 380); 

Insert Into Componente (Nome, QuantitaMin, Validita, PrezzoVendita) 
	Values ('Kit Evo Metano', 2, 365*2, 250); 

Insert Into Componente (Nome, QuantitaMin, Validita, PrezzoVendita) 
	Values ('Kit Evo GPL', 2, 365*2, 240); 

Insert Into Componente (Nome, QuantitaMin, Validita, PrezzoVendita) 
	Values ('Inettore', 4, 365, 100); 

Insert Into Componente (Nome, QuantitaMin, Validita, PrezzoVendita) 
	Values ('Preomatico 15 pollici', 4, 365*10, 220); 

/** Insemento Transazione */

Insert Into Transazione (Quota, Data) Values (800, '2015-04-09');
Insert Into Transazione (Quota, Data) Values (1000, '2015-02-08');
Insert Into Transazione (Quota, Data) Values (650, '2015-04-15');
Insert Into Transazione (Quota, Data) Values (200, '2015-05-05');
Insert Into Transazione (Quota, Data) Values (200, '2015-02-15');
Insert Into Transazione (Quota, Data) Values (1800, '2015-04-06');
Insert Into Transazione (Quota, Data) Values (1200, '2015-04-06');
Insert Into Transazione (Quota, Data) Values (1000, '2015-04-06');

/** Inserimento Preventivo */

Insert Into Preventivo (DataEmissione, DataInizio, Categoria, Sintomi, SisAlimentazione, TempoStimato, CostoComponenti, Manodopera, ServAggiuntivi, Autovettura, Acconto) 
	Values ('2015-04-09', '2015-04-22', 'installazione_impianto_metano', 'Installazione classica impianto metano', 
		'iniezione', 48, 1100, 400, 100, 'BX692TE', null);

Insert Into Preventivo (DataEmissione, DataInizio, Categoria, Sintomi, SisAlimentazione, TempoStimato, CostoComponenti, Manodopera, ServAggiuntivi, Autovettura, Acconto) 
	Values ('2015-02-15', '2015-02-15', 'riparazione', 'Routa bucata', null, 2, 220, 50, 0, 'BN548BL', null);

Insert Into Preventivo (DataEmissione, DataInizio, Categoria, Sintomi, SisAlimentazione, TempoStimato, CostoComponenti, Manodopera, ServAggiuntivi, Autovettura, Acconto) 
	Values ('2015-05-03', '2015-05-15', 'installazione_impianto_gpl', 'Installazione classica impianto GPL', 
		'aspirazione', 48, 1000, 400, 150, 'EZ874LO', 1);

/** Inserimento Previsione */

/** preventivo 1 */
Insert Into Previsione (Componente, Preventivo, Ubicazione, Quantita, PrezzoUnitario) 
	Values (1, 1, 'bagagliaio', 1, 400);
Insert Into Previsione (Componente, Preventivo, Ubicazione, Quantita, PrezzoUnitario) 
	Values (2, 1, 'bagagliaio', 1, 350);
Insert Into Previsione (Componente, Preventivo, Ubicazione, Quantita, PrezzoUnitario) 
	Values (4, 1, 'motore', 1, 250);
Insert Into Previsione (Componente, Preventivo, Ubicazione, Quantita, PrezzoUnitario) 
	Values (6, 1, 'motore', 1, 100);

/** preventivo 2 */
Insert Into Previsione (Componente, Preventivo, Ubicazione, Quantita, PrezzoUnitario) 
	Values (7, 2, null, 1, 220);

/** preventivo 3 */
Insert Into Previsione (Componente, Preventivo, Ubicazione, Quantita, PrezzoUnitario) 
	Values (3, 3, 'bagagliaio', 2, 380);
Insert Into Previsione (Componente, Preventivo, Ubicazione, Quantita, PrezzoUnitario) 
	Values (5, 3, 'motore', 1, 240);

/** Inserimento Prestazione */

Insert Into Prestazione (Preventivo, TempiEsecuzione, Procedimento, DataFine, Malfunzionamento, Manodopera, ServAggiuntivi)
	Values (1, 48, 'Installazione tradizionale impianto metano', '2015-04-24', 'Impianto Metano', 420, 115);

Insert Into Prestazione (Preventivo, TempiEsecuzione, Procedimento, DataFine, Malfunzionamento, Manodopera, ServAggiuntivi)
	Values (2, 1, 'Sostituzione pneomatico anteriore destro', '2015-02-15', 'Ruota Bucata', 30, 15);

/** Inserimento Occupazione */

Insert Into Occupazione (Prestazione, Operatore) 
	Values (1, 'STFDRN60A02E783V');

Insert Into Occupazione (Prestazione, Operatore) 
	Values (2, 'VRDLCU90D15E783S');

/** Inserimento Ordine */

Insert Into Ordine (DataEmissione, DataConsegna, Imponibile, Fornitore, Versamento)
	Values ('2015-02-08', '2015-02-10', 1000, '02365478952', 2);

Insert Into Ordine (DataEmissione, DataConsegna, Imponibile, Fornitore, Versamento)
	Values ('2015-04-15', '2015-04-16', 650, '05987418630', 3);

Insert Into Ordine (DataEmissione, DataConsegna, Imponibile, Fornitore, Versamento)
	Values ('2015-05-05', '2015-05-07', 200, '00236587149', 4);

/** Inserimento Fornitura */

/** ordine 1 */
Insert Into Fornitura (Quantita, PrezzoUnitario, Componente, Ordine)
	Values (2, 300, 1, 1);

Insert Into Fornitura (Quantita, PrezzoUnitario, Componente, Ordine)
	Values (2, 200, 2, 1);

/** ordine 2 */
Insert Into Fornitura (Quantita, PrezzoUnitario, Componente, Ordine)
	Values (2, 200, 4, 2);

Insert Into Fornitura (Quantita, PrezzoUnitario, Componente, Ordine)
	Values (1, 100, 5, 2);

Insert Into Fornitura (Quantita, PrezzoUnitario, Componente, Ordine)
	Values (3, 50, 6, 2);

/** ordine 3 */

Insert Into Fornitura (Quantita, PrezzoUnitario, Componente, Ordine)
	Values (2, 100, 7, 3);

/** Inserimento Utilizzo */

/** prestazione 1 */
Insert Into Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
	Values (1, 1, 400, 1);
Insert Into Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
	Values (1, 2, 350, 1);
Insert Into Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
	Values (1, 3, 250, 1);
Insert Into Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
	Values (1, 5, 100, 1);

/** prestazione 2 */
Insert Into Utilizzo (Prestazione, Fornitura, PrezzoUnitario, Quantita)
	Values (2, 6, 200, 1);

/** Inserimento Magazzino */

Insert Into Magazzino (Componente, Fornitura, Quantita) 
	Values (1, 1, 1);

Insert Into Magazzino (Componente, Fornitura, Quantita) 
	Values (2, 2, 1);

Insert Into Magazzino (Componente, Fornitura, Quantita) 
	Values (4, 3, 1);

Insert Into Magazzino (Componente, Fornitura, Quantita) 
	Values (6, 5, 2);

Insert Into Magazzino (Componente, Fornitura, Quantita) 
	Values (7, 6, 1);

/** Inserimento Fattura */

Insert Into Fattura (Numero, Anno, Imponibile, Sconto, Incentivi, DataEmissione, DataScadenza, TipoPag, StatoPag, SisPag, Prestazione, Transazione)
	Values (1, 2015, 1100, 5, 0, '2015-04-24', '2015-05-24', 'assegno', 0, 'rimessa_differita', 1, null);

Insert Into Fattura (Numero, Anno, Imponibile, Sconto, Incentivi, DataEmissione, DataScadenza, TipoPag, StatoPag, SisPag, Prestazione, Transazione)
	Values (2, 2015, 200, 0, 0, '2015-02-15', '2015-02-15', 'contanti', 1, 'rimessa_diretta', 2, 5);

/** Inserimento Turno */

Insert Into Turno (Operatore, Data, OraInizio, OraFine)
	Values ('STFDRN60A02E783V', '2015-04-09', '08:00:00', '18:30:00');

Insert Into Turno (Operatore, Data, OraInizio, OraFine)
	Values ('STFDRN60A02E783V', '2015-04-08', '08:00:00', '18:30:00');

Insert Into Turno (Operatore, Data, OraInizio, OraFine)
	Values ('VNCNDR84T24I156L', '2015-04-09', '08:30:00', '16:30:00');

Insert Into Turno (Operatore, Data, OraInizio, OraFine)
	Values ('VRDLCU90D15E783S', '2015-04-09', '08:30:00', '12:30:00');

Insert Into Turno (Operatore, Data, OraInizio, OraFine)
	Values ('VRDLCU90D15E783S', '2015-04-09', '14:30:00', '18:30:00');

/** Inserimento Stipendio */

Insert Into Stipendio (Transazione, Operatore)
	Values (6, 'STFDRN60A02E783V');

Insert Into Stipendio (Transazione, Operatore)
	Values (7, 'VNCNDR84T24I156L');

Insert Into Stipendio (Transazione, Operatore)
	Values (8, 'VRDLCU90D15E783S');

/** Inserimento Recapito */

Insert Into Recapito (Recapito, Tipo)
	Values ('0733843482', 'tel_fax');

Insert Into Recapito (Recapito, Tipo)
	Values ('3382704282', 'telefono');

Insert Into Recapito (Recapito, Tipo)
	Values ('alestam93@gmail.com', 'email');

Insert Into Recapito (Recapito, Tipo)
	Values ('0718452369', 'fax');

/** Inserimento RubricaCliente */

Insert Into RubricaCliente (Recapito, Cliente)
	Values ('3382704282', 'STFLSN93A08E783E');

Insert Into RubricaCliente (Recapito, Cliente)
	Values ('alestam93@gmail.com', 'STFLSN93A08E783E');

/** Inserimento RubricaFornitore */

Insert Into RubricaFornitore (Recapito, Fornitore)
	Values ('0718452369', '02365478952');

/** Inserimento RubricaOperatore */

Insert Into RubricaOperatore (Recapito, Operatore)
	Values ('0733843482', 'STFDRN60A02E783V');
