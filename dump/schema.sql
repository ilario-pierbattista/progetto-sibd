DROP SCHEMA IF EXISTS Officina;
CREATE SCHEMA Officina;
USE Officina;

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
	Acconto Integer,
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
	DataConsegna Date,
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
	Transazione Integer,
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
	Codice Integer AUTO_INCREMENT PRIMARY KEY,
	Recapito Varchar(200) NOT NULL,
	Tipo ENUM('telefono',
		'fax', 
		'tel_fax',
		'sito_web',
		'email') NOT NULL,
	UNIQUE(Recapito)
);

CREATE TABLE RubricaCliente (
	Recapito Integer NOT NULL,
	Cliente Varchar(16) NOT NULL,
	PRIMARY KEY(Recapito, Cliente),
	FOREIGN KEY (Cliente) REFERENCES Cliente(CF_PIVA),
	FOREIGN KEY (Recapito) REFERENCES Recapito(Codice)
);

CREATE TABLE RubricaFornitore (
	Recapito Integer NOT NULL,
	Fornitore Varchar(11) NOT NULL,
	PRIMARY KEY(Recapito, Fornitore),
	FOREIGN KEY (Fornitore) REFERENCES Fornitore(PIVA),
	FOREIGN KEY (Recapito) REFERENCES Recapito(Codice)
);

CREATE TABLE RubricaOperatore (
	Recapito Integer NOT NULL,
	Operatore Varchar(16) NOT NULL,
	PRIMARY KEY(Recapito, Operatore),
	FOREIGN KEY (Operatore) REFERENCES Operatore(CF),
	FOREIGN KEY (Recapito) REFERENCES Recapito(Codice)
);


/**********************************************
 *
 * Funzioni custom
 *
 **********************************************
 */

DELIMITER ;;
/*
 * Funzione per il controllo del codice fiscale
 * (RV1)
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
 * (RV1)
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
 * (RV1)
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
 * (RV2)
 */
CREATE FUNCTION check_cap(cap Varchar(5))
	RETURNS BOOLEAN
BEGIN
	DECLARE result BOOLEAN;
	SELECT cap REGEXP '^[0-9]{5}$' INTO result;
	RETURN result;
END;;

/*
 * Funzione per il controllo per il
 * numero del documento d'identità
 * (RV4)
 */
CREATE FUNCTION check_ndocid(ndocid Varchar(9))
	RETURNS BOOLEAN
BEGIN
	DECLARE result BOOLEAN;
	SELECT ndocid REGEXP '^[A-Z]{2}[0-9]{7}$' INTO result;
	RETURN result;
END;;

/*
 * Funzione di controllo per la sigla della
 * provincia
 * (RV5)
 */
CREATE FUNCTION check_provincia(provincia Varchar(2)) 
	RETURNS BOOLEAN
BEGIN
	DECLARE result BOOLEAN;
	SELECT provincia REGEXP '^[A-Z]{2}$' INTO result;
	RETURN result;
END;;

/*
 * Funzione di controllo per gli IBAN
 * (RV10)
 */
CREATE FUNCTION check_iban(iban Varchar(27))
	RETURNS BOOLEAN
BEGIN
	DECLARE result BOOLEAN;
	SELECT iban REGEXP '^[A-Z]{2}[0-9]{2}[A-Z]{1}[0-9]{10}[0-9A-Z]{12}$' INTO result;
	RETURN result;
END;;


/*****************************************
 *
 * Aggiunta dei trigger che implementano i
 * vincoli d'integrità
 *
 *****************************************
 */
DELIMITER ;;

/*
 * Implmentazione dei vincoli su Cliente
 */
CREATE TRIGGER Cliente_before_insert
	BEFORE INSERT ON Cliente FOR EACH ROW
BEGIN
	IF check_cf_piva(NEW.CF_PIVA) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Codice fiscale o Partita IVA non valido';
	ELSEIF check_cap(NEW.CAP) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'CAP non valido';
	ELSEIF check_ndocid(NEW.NDocId) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Numero del documento d\'identità non valido';
	ELSEIF check_cf(NEW.CF_PIVA) AND 
		(NEW.Nome IS NULL OR 
			NEW.Cognome IS NULL OR 
			NEW.RagioneSociale IS NOT NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Codice Fiscale rilevato: inserire solamente Nome e Cognome';
	ELSEIF check_piva(NEW.CF_PIVA) AND (NEW.RagioneSociale IS NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Partita IVA rilevata: inserire RagioneSociale';
	END IF;
END;;

/*
 * Implementazione dei vincoli su Fornitore
 */
CREATE TRIGGER Fornitore_before_insert
	BEFORE INSERT ON Fornitore FOR EACH ROW
BEGIN
	IF check_piva(NEW.PIVA) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Partita IVA non valida';
	ELSEIF check_cap(NEW.CAP) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'CAP non valido';
	ELSEIF check_iban(NEW.IBAN) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'IBAN non valido';
	ELSEIF NEW.ModPagamento = 'bonifico' AND NEW.IBAN IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Il pagamento tramite bonifico richiede l\'IBAN';
	END IF;
END;;

/*
 * Implementazione vincoli su Operatore
 */
CREATE TRIGGER Operatore_before_insert
	BEFORE INSERT ON Operatore FOR EACH ROW
BEGIN
	IF check_cf_piva(NEW.CF) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Codice fiscale non valido';
	ELSEIF check_cap(NEW.CAP) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'CAP non valido';
	ELSEIF check_provincia(NEW.ProvinciaNasc) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ProvinciaNasc non valida';
	ELSEIF NOT (NEW.Stipendio IS NULL XOR NEW.RetribuzioneH IS NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Specificare uno solo tra Stipendio e RetribuzioneH';
	ELSEIF NEW.ModRiscossione = 'bonifico' AND NEW.IBAN IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'La riscossione tramite bonifico richiede l\'IBAN';
	ELSEIF check_iban(NEW.IBAN) = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'IBAN non valido';
	END IF;
END;;

/* Delimiter di default */
DELIMITER ;