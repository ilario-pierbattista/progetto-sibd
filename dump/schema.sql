DROP SCHEMA IF EXISTS Officina;
CREATE SCHEMA Officina;
USE Officina;

/**********************************************
 *
 * Funzioni custom
 *
 **********************************************
 */

DELIMITER ;;
/*
 * Funzione per il controllo del codice fiscale
 * CF usati per il test:
 * - PRBLRI93R05I324O
 * - STFLSN93A08E783E
 */
CREATE FUNCTION check_cf(cf Varchar(16)) 
	RETURNS BOOLEAN
BEGIN
	DECLARE result BOOLEAN;
	SELECT cf REGEXP '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$' INTO result;
	RETURN result;
END;;

/*
 * Funzione per il controllo della partita iva
 */
CREATE FUNCTION check_piva(piva Varchar(11))
	RETURNS BOOLEAN
BEGIN
	DECLARE result BOOLEAN;
	SELECT piva REGEXP '^[0-9]{11}$' INTO result;
	RETURN result;
END;;

/*
 * Funzione per il controllo del codice fiscale 
 * o della partita iva
 */
CREATE FUNCTION check_cf_piva(stringa Varchar(16)) 
	RETURNS BOOLEAN
BEGIN
	DECLARE cf, piva BOOLEAN;
	SELECT check_cf(stringa) INTO cf;
	SELECT check_piva(stringa) INTO piva;
	RETURN cf XOR piva;
END;;

/*
 * Funzione per il controllo del CAP
 */
CREATE FUNCTION check_cap(cap Varchar(5))
	RETURNS BOOLEAN
BEGIN
	DECLARE result BOOLEAN;
	SELECT cap REGEXP '^[0-9]{5}$' INTO result;
	RETURN result;
END;; 

/**********************************************
 * 
 * Definizione delle tabelle
 *
 **********************************************
 */

DELIMITER ;

CREATE TABLE Cliente (
	CF_PIVA Varchar(16) PRIMARY KEY,
	Nome Varchar(80),
	Cognome Varchar(80),
	RagioneSociale Varchar(80),
	Citta Varchar(50) NOT NULL,
	Via Varchar(50) NOT NULL,
	Civico Varchar(10) NOT NULL,
	CAP Varchar(5) NOT NULL,
	NDocId Varchar(9)
);

CREATE TABLE Fornitore (
	PIVA Varchar(11) PRIMARY KEY,
	RagioneSociale Varchar(80) NOT NULL,
	TempiConsegna Integer,
	ModPagamento ENUM('bonifico', 'assegno') NOT NULL,
	IBAN Varchar(27),
	Citta Varchar(50) NOT NULL,
	Via Varchar(50) NOT NULL,
	Civico Varchar(10) NOT NULL,
	CAP Varchar(5) NOT NULL
);

CREATE TABLE Operatore (
	CF Varchar(16) PRIMARY KEY,
	Nome Varchar(80) NOT NULL,
	Cognome Varchar(80) NOT NULL,
	Citta Varchar(50) NOT NULL,
	Via Varchar(50) NOT NULL,
	Civico Varchar(10) NOT NULL,
	CAP Varchar(5) NOT NULL,
	DataNasc Date NOT NULL,
	ComuneNasc Varchar(50) NOT NULL,
	ProvinciaNasc Varchar(2) NOT NULL,
	Stipendio Decimal(6,2),
	RetribuzioneH Decimal(4,2),
	ModRiscossione ENUM('bonifico', 'assegno', 'contanti') NOT NULL,
	IBAN Varchar(27)
);

CREATE TABLE Transazione (
	Codice Integer AUTO_INCREMENT PRIMARY KEY,
	Quota Decimal(10,2) NOT NULL,
	Data Date NOT NULL
);

CREATE TABLE Autovettura (
	Targa Varchar(8) PRIMARY KEY,
	Telaio Varchar(17),
	Marca Varchar(50) NOT NULL,
	Modello Varchar(100) NOT NULL,
	Cilindrata Integer,
	AnnoImmatricolazione Integer NOT NULL,
	UltimoCollaudo Date,
	UltimaRevisione Date,
	Cliente Varchar(16) NOT NULL,
	FOREIGN KEY (Cliente) REFERENCES Cliente(CF_PIVA)
);

CREATE TABLE Preventivo (
	Codice Integer AUTO_INCREMENT PRIMARY KEY,
	DataEmissione Date NOT NULL,
	DataInizio Date NOT NULL,
	Categoria ENUM('riparazione',
		'installazione_impianto_metano',
		'installazione_impianto_gpl',
		'collaudo',
		'revisione'
		) NOT NULL,
	Sintomi Varchar(300),
	SisAlimentazione ENUM('aspirazione', 'iniezione'),	
	TempoStimato Integer,
	CostoComponenti Decimal(8,2) DEFAULT 0,
	Manodopera Decimal(7,2) DEFAULT 0,
	ServAggiuntivi Decimal(7,2) DEFAULT 0,
	Autovettura Varchar(8) NOT NULL,
	Acconto Integer NOT NULL,
	FOREIGN KEY (Autovettura) REFERENCES Autovettura(Targa),
	FOREIGN KEY (Acconto) REFERENCES Transazione(Codice)
);

CREATE TABLE Componente (
	Codice Integer AUTO_INCREMENT PRIMARY KEY,
	Nome Varchar(150) NOT NULL,
	QuantitaMin Integer DEFAULT 0,
	Validita Integer DEFAULT 0,
	PrezzoVendita Decimal(6,2) NOT NULL
);

CREATE TABLE Previsione (
	Componente Integer NOT NULL,
	Preventivo Integer NOT NULL,
	Ubicazione ENUM('motore', 'bagagliaio'),
	Quantita Integer NOT NULL,
	PrezzoUnitario Decimal(6,2) NOT NULL,
	PRIMARY KEY (Componente, Preventivo),
	FOREIGN KEY (Componente) REFERENCES Componente(Codice),
	FOREIGN KEY (Preventivo) REFERENCES Preventivo(Codice)
);

CREATE TABLE Prestazione (
	Preventivo Integer PRIMARY KEY,
	TempiEsecuzione Integer NOT NULL,
	Procedimento Text,
	DataFine Date NOT NULL,
	Malfunzionamento Varchar(300),
	Manodopera Decimal(7,2) DEFAULT 0,
	ServAggiuntivi Decimal(7,2) DEFAULT 0,
	FOREIGN KEY (Preventivo) REFERENCES Preventivo(Codice)
);

CREATE TABLE Occupazione (
	Prestazione Integer NOT NULL,
	Operatore Varchar(16) NOT NULL,
	PRIMARY KEY(Prestazione, Operatore),
	FOREIGN KEY (Prestazione) REFERENCES Prestazione(Preventivo),
	FOREIGN KEY (Operatore) REFERENCES Operatore(CF)
);

CREATE TABLE Ordine (
	Codice Integer AUTO_INCREMENT PRIMARY KEY,
	DataEmissione Date NOT NULL,
	DataConsegna Date NOT NULL,
	Imponibile Decimal(9,2) NOT NULL,
	Fornitore Varchar(11) NOT NULL,
	Versamento Integer NOT NULL,
	FOREIGN KEY (Fornitore) REFERENCES Fornitore(PIVA),
	FOREIGN KEY (Versamento) REFERENCES Transazione(Codice)
);

CREATE TABLE Fornitura (
	Codice Integer AUTO_INCREMENT PRIMARY KEY,
	Quantita Integer NOT NULL,
	PrezzoUnitario Decimal(8,2) NOT NULL,
	Componente Integer NOT NULL,
	Ordine Integer NOT NULL,
	FOREIGN KEY (Componente) REFERENCES Componente(Codice),
	FOREIGN KEY (Ordine) REFERENCES Ordine(Codice)
);

CREATE TABLE Utilizzo (
	Prestazione Integer NOT NULL,
	Fornitura Integer NOT NULL,
	PrezzoUnitario Decimal(8,2) NOT NULL,
	Quantita Integer NOT NULL,
	PRIMARY KEY(Prestazione, Fornitura),
	FOREIGN KEY (Prestazione) REFERENCES Prestazione(Preventivo),
	FOREIGN KEY (Fornitura) REFERENCES Fornitura(Codice)
);

CREATE TABLE Magazzino (
	Componente Integer NOT NULL,
	Fornitura Integer NOT NULL,
	Quantita Integer NOT NULL,
	PRIMARY KEY(Componente, Fornitura),
	FOREIGN KEY (Componente) REFERENCES Componente(Codice),
	FOREIGN KEY (Fornitura) REFERENCES Fornitura(Codice)
);

CREATE TABLE Fattura (
	Numero Integer NOT NULL,
	Anno Integer NOT NULL,
	Imponibile Decimal(10,2) NOT NULL,
	Sconto Decimal(4,2) DEFAULT 0 NOT NULL,
	Incentivi Decimal(8,2) DEFAULT 0 NOT NULL,
	DataEmissione Date NOT NULL,
	DataScadenza Date NOT NULL,
	TipoPag ENUM('bonifico', 'assegno', 'contanti') NOT NULL,
	StatoPag BOOLEAN DEFAULT False NOT NULL,
	SisPag ENUM('rimessa_diretta', 'rimessa_differita')
		DEFAULT 'rimessa_diretta' NOT NULL,
	Prestazione Integer NOT NULL,
	Transazione Integer NOT NULL,
	PRIMARY KEY(Numero, Anno),
	FOREIGN KEY (Prestazione) REFERENCES Prestazione(Preventivo),
	FOREIGN KEY (Transazione) REFERENCES Transazione(Codice)
);

CREATE TABLE Turno (
	Operatore Varchar(16) NOT NULL,
	Data Date NOT NULL,
	OraInizio Time NOT NULL,
	OraFine Time NOT NULL,
	PRIMARY KEY(Operatore, Data, OraInizio),
	FOREIGN KEY (Operatore) REFERENCES Operatore(CF)
);

CREATE TABLE Stipendio (
	Transazione Integer PRIMARY KEY,
	Operatore Varchar(16) NOT NULL,
	FOREIGN KEY (Transazione) REFERENCES Transazione(Codice),
	FOREIGN KEY (Operatore) REFERENCES Operatore(CF)
);

CREATE TABLE Recapito (
	Recapito Varchar(200) PRIMARY KEY,
	Tipo ENUM('telefono',
		'fax', 
		'tel_fax',
		'sito_web',
		'email') NOT NULL
);

CREATE TABLE RubricaCliente (
	Recapito Varchar(200) NOT NULL,
	Cliente Varchar(16) NOT NULL,
	PRIMARY KEY(Recapito, Cliente),
	FOREIGN KEY (Cliente) REFERENCES Cliente(CF_PIVA)
);

CREATE TABLE RubricaFornitore (
	Recapito Varchar(200) NOT NULL,
	Fornitore Varchar(11) NOT NULL,
	PRIMARY KEY(Recapito, Fornitore),
	FOREIGN KEY (Fornitore) REFERENCES Fornitore(PIVA)
);

CREATE TABLE RubricaOperatore (
	Recapito Varchar(200) NOT NULL,
	Operatore Varchar(16) NOT NULL,
	PRIMARY KEY(Recapito, Operatore),
	FOREIGN KEY (Operatore) REFERENCES Operatore(CF)
);