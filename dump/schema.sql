/**
 * Contenuto
 * 0) Creazione dello schema
 * 1) Tabelle
 * 2) Funzioni
 * 3) Procedure
 * 4) Trigger
 * 5) Viste
 */

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
  CF_PIVA        VARCHAR(16) PRIMARY KEY,
  Nome           VARCHAR(80),
  Cognome        VARCHAR(80),
  RagioneSociale VARCHAR(80),
  Citta          VARCHAR(50) NOT NULL,
  Via            VARCHAR(50) NOT NULL,
  Civico         VARCHAR(10) NOT NULL,
  CAP            VARCHAR(5)  NOT NULL,
  NDocId         VARCHAR(9)
);

CREATE TABLE Fornitore (
  PIVA           VARCHAR(11) PRIMARY KEY,
  RagioneSociale VARCHAR(80)                 NOT NULL,
  TempiConsegna  INTEGER,
  ModPagamento   ENUM('bonifico', 'assegno') NOT NULL,
  IBAN           VARCHAR(27),
  Citta          VARCHAR(50)                 NOT NULL,
  Via            VARCHAR(50)                 NOT NULL,
  Civico         VARCHAR(10)                 NOT NULL,
  CAP            VARCHAR(5)                  NOT NULL
);

CREATE TABLE Operatore (
  CF             VARCHAR(16) PRIMARY KEY,
  Nome           VARCHAR(80)                             NOT NULL,
  Cognome        VARCHAR(80)                             NOT NULL,
  Citta          VARCHAR(50)                             NOT NULL,
  Via            VARCHAR(50)                             NOT NULL,
  Civico         VARCHAR(10)                             NOT NULL,
  CAP            VARCHAR(5)                              NOT NULL,
  DataNasc       DATE                                    NOT NULL,
  ComuneNasc     VARCHAR(50)                             NOT NULL,
  ProvinciaNasc  VARCHAR(2)                              NOT NULL,
  Stipendio      DECIMAL(6, 2),
  RetribuzioneH  DECIMAL(4, 2),
  ModRiscossione ENUM('bonifico', 'assegno', 'contanti') NOT NULL,
  IBAN           VARCHAR(27)
);

CREATE TABLE Transazione (
  Codice INTEGER AUTO_INCREMENT PRIMARY KEY,
  Quota  DECIMAL(10, 2) NOT NULL,
  Data   DATE           NOT NULL
);

CREATE TABLE Autovettura (
  Targa                VARCHAR(8) PRIMARY KEY,
  Telaio               VARCHAR(17),
  Marca                VARCHAR(50)  NOT NULL,
  Modello              VARCHAR(100) NOT NULL,
  Cilindrata           INTEGER,
  AnnoImmatricolazione INTEGER      NOT NULL,
  UltimoCollaudo       DATE,
  UltimaRevisione      DATE,
  Cliente              VARCHAR(16)  NOT NULL,
  FOREIGN KEY (Cliente) REFERENCES Cliente (CF_PIVA)
);

CREATE TABLE Preventivo (
  Codice           INTEGER       AUTO_INCREMENT PRIMARY KEY,
  DataEmissione    DATE       NOT NULL,
  DataInizio       DATE       NOT NULL,
  Categoria        ENUM('riparazione',
                        'installazione_impianto_metano',
                        'installazione_impianto_gpl',
                        'collaudo',
                        'revisione'
  )                           NOT NULL,
  Sintomi          VARCHAR(300),
  SisAlimentazione ENUM('aspirazione', 'iniezione'),
  TempoStimato     INTEGER,
  CostoComponenti  DECIMAL(8, 2) DEFAULT 0,
  Manodopera       DECIMAL(7, 2) DEFAULT 0,
  ServAggiuntivi   DECIMAL(7, 2) DEFAULT 0,
  Autovettura      VARCHAR(8) NOT NULL,
  Acconto          INTEGER,
  FOREIGN KEY (Autovettura) REFERENCES Autovettura (Targa),
  FOREIGN KEY (Acconto) REFERENCES Transazione (Codice)
);

CREATE TABLE Componente (
  Codice        INTEGER AUTO_INCREMENT PRIMARY KEY,
  Nome          VARCHAR(150)  NOT NULL,
  QuantitaMin   INTEGER DEFAULT 0,
  Validita      INTEGER DEFAULT 0,
  PrezzoVendita DECIMAL(6, 2) NOT NULL
);

CREATE TABLE Previsione (
  Componente     INTEGER       NOT NULL,
  Preventivo     INTEGER       NOT NULL,
  Ubicazione     ENUM('motore', 'bagagliaio'),
  Quantita       INTEGER       NOT NULL,
  PrezzoUnitario DECIMAL(6, 2) NOT NULL,
  PRIMARY KEY (Componente, Preventivo),
  FOREIGN KEY (Componente) REFERENCES Componente (Codice),
  FOREIGN KEY (Preventivo) REFERENCES Preventivo (Codice)
);

CREATE TABLE Prestazione (
  Preventivo       INTEGER PRIMARY KEY,
  TempiEsecuzione  INTEGER NOT NULL,
  Procedimento     TEXT,
  DataFine         DATE    NOT NULL,
  Malfunzionamento VARCHAR(300),
  Manodopera       DECIMAL(7, 2) DEFAULT 0,
  ServAggiuntivi   DECIMAL(7, 2) DEFAULT 0,
  FOREIGN KEY (Preventivo) REFERENCES Preventivo (Codice)
);

CREATE TABLE Occupazione (
  Prestazione INTEGER     NOT NULL,
  Operatore   VARCHAR(16) NOT NULL,
  PRIMARY KEY (Prestazione, Operatore),
  FOREIGN KEY (Prestazione) REFERENCES Prestazione (Preventivo),
  FOREIGN KEY (Operatore) REFERENCES Operatore (CF)
);

CREATE TABLE Ordine (
  Codice        INTEGER AUTO_INCREMENT PRIMARY KEY,
  DataEmissione DATE                    NOT NULL,
  DataConsegna  DATE,
  Imponibile    DECIMAL(9, 2) DEFAULT 0,
  Fornitore     VARCHAR(11)             NOT NULL,
  Versamento    INTEGER                 NOT NULL,
  FOREIGN KEY (Fornitore) REFERENCES Fornitore (PIVA),
  FOREIGN KEY (Versamento) REFERENCES Transazione (Codice)
);

CREATE TABLE Fornitura (
  Codice         INTEGER AUTO_INCREMENT PRIMARY KEY,
  Quantita       INTEGER       NOT NULL,
  PrezzoUnitario DECIMAL(8, 2) NOT NULL,
  Componente     INTEGER       NOT NULL,
  Ordine         INTEGER       NOT NULL,
  FOREIGN KEY (Componente) REFERENCES Componente (Codice),
  FOREIGN KEY (Ordine) REFERENCES Ordine (Codice)
);

CREATE TABLE Utilizzo (
  Prestazione    INTEGER       NOT NULL,
  Fornitura      INTEGER       NOT NULL,
  PrezzoUnitario DECIMAL(8, 2) NOT NULL,
  Quantita       INTEGER       NOT NULL,
  PRIMARY KEY (Prestazione, Fornitura),
  FOREIGN KEY (Prestazione) REFERENCES Prestazione (Preventivo),
  FOREIGN KEY (Fornitura) REFERENCES Fornitura (Codice)
);

CREATE TABLE Magazzino (
  Componente INTEGER NOT NULL,
  Fornitura  INTEGER NOT NULL,
  Quantita   INTEGER NOT NULL,
  PRIMARY KEY (Componente, Fornitura),
  FOREIGN KEY (Componente) REFERENCES Componente (Codice),
  FOREIGN KEY (Fornitura) REFERENCES Fornitura (Codice)
);

CREATE TABLE Fattura (
  Numero        INTEGER                                 NOT NULL,
  Anno          INTEGER                                 NOT NULL,
  Imponibile    DECIMAL(10, 2)                          NOT NULL,
  Sconto        DECIMAL(4, 2) DEFAULT 0                 NOT NULL,
  Incentivi     DECIMAL(8, 2) DEFAULT 0                 NOT NULL,
  DataEmissione DATE                                    NOT NULL,
  DataScadenza  DATE                                    NOT NULL,
  TipoPag       ENUM('bonifico', 'assegno', 'contanti') NOT NULL,
  StatoPag      BOOLEAN DEFAULT FALSE                   NOT NULL,
  SisPag        ENUM('rimessa_diretta', 'rimessa_differita')
    DEFAULT 'rimessa_diretta'                           NOT NULL,
  Prestazione   INTEGER                                 NOT NULL,
  Transazione   INTEGER,
  PRIMARY KEY (Numero, Anno),
  FOREIGN KEY (Prestazione) REFERENCES Prestazione (Preventivo),
  FOREIGN KEY (Transazione) REFERENCES Transazione (Codice)
);

CREATE TABLE Turno (
  Operatore VARCHAR(16) NOT NULL,
  Data      DATE        NOT NULL,
  OraInizio TIME        NOT NULL,
  OraFine   TIME        NOT NULL,
  PRIMARY KEY (Operatore, Data, OraInizio),
  FOREIGN KEY (Operatore) REFERENCES Operatore (CF)
);

CREATE TABLE Stipendio (
  Transazione INTEGER PRIMARY KEY,
  Operatore   VARCHAR(16) NOT NULL,
  FOREIGN KEY (Transazione) REFERENCES Transazione (Codice),
  FOREIGN KEY (Operatore) REFERENCES Operatore (CF)
);

CREATE TABLE Recapito (
  Codice   INTEGER AUTO_INCREMENT PRIMARY KEY,
  Recapito VARCHAR(200)  NOT NULL,
  Tipo     ENUM('telefono',
                'fax',
                'tel_fax',
                'sito_web',
                'email') NOT NULL,
  UNIQUE (Recapito)
);

CREATE TABLE RubricaCliente (
  Recapito INTEGER     NOT NULL,
  Cliente  VARCHAR(16) NOT NULL,
  PRIMARY KEY (Recapito, Cliente),
  FOREIGN KEY (Cliente) REFERENCES Cliente (CF_PIVA),
  FOREIGN KEY (Recapito) REFERENCES Recapito (Codice)
);

CREATE TABLE RubricaFornitore (
  Recapito  INTEGER     NOT NULL,
  Fornitore VARCHAR(11) NOT NULL,
  PRIMARY KEY (Recapito, Fornitore),
  FOREIGN KEY (Fornitore) REFERENCES Fornitore (PIVA),
  FOREIGN KEY (Recapito) REFERENCES Recapito (Codice)
);

CREATE TABLE RubricaOperatore (
  Recapito  INTEGER     NOT NULL,
  Operatore VARCHAR(16) NOT NULL,
  PRIMARY KEY (Recapito, Operatore),
  FOREIGN KEY (Operatore) REFERENCES Operatore (CF),
  FOREIGN KEY (Recapito) REFERENCES Recapito (Codice)
);


/**********************************************
 *
 * Funzioni
 *
 **********************************************
 */

DELIMITER ;;
/*
 * Funzione per il controllo del codice fiscale
 * (RV1)
 */
CREATE FUNCTION check_cf(cf VARCHAR(16))
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    SELECT cf REGEXP '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$'
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione per il controllo della partita iva
 * (RV1)
 */
CREATE FUNCTION check_piva(piva VARCHAR(16))
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    SELECT piva REGEXP '^[0-9]{11}$'
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione per il controllo del codice fiscale 
 * o della partita iva
 * (RV1)
 */
CREATE FUNCTION check_cf_piva(stringa VARCHAR(16))
  RETURNS BOOLEAN
  BEGIN
    DECLARE cf, piva BOOLEAN;
    SELECT check_cf(stringa)
    INTO cf;
    SELECT check_piva(stringa)
    INTO piva;
    RETURN cf XOR piva;
  END;;

/*
 * Funzione per il controllo del CAP
 * (RV2)
 */
CREATE FUNCTION check_cap(cap VARCHAR(5))
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    SELECT cap REGEXP '^[0-9]{5}$'
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione per il controllo per il
 * numero del documento d'identità
 * (RV4)
 */
CREATE FUNCTION check_ndocid(ndocid VARCHAR(9))
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    SELECT ndocid REGEXP '^[A-Z]{2}[0-9]{7}$'
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione di controllo per la sigla della
 * provincia
 * (RV5)
 */
CREATE FUNCTION check_provincia(provincia VARCHAR(2))
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    SELECT provincia REGEXP '^[A-Z]{2}$'
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione di controllo per gli IBAN
 * (RV10)
 */
CREATE FUNCTION check_iban(iban VARCHAR(27))
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    SELECT iban REGEXP '^[A-Z]{2}[0-9]{2}[A-Z]{1}[0-9]{10}[0-9A-Z]{12}$'
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione di controllo per i turni
 * (RV11)
 */
CREATE FUNCTION check_turno(inizio TIME, fine TIME)
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    DECLARE difference INTEGER;
    SELECT time_to_sec(timediff(fine, inizio))
    INTO difference;
    SET result = difference > 0;
    RETURN result;
  END;;

/*
 * Funziona per il controllo della targa
 * (RV14)
 */
CREATE FUNCTION check_targa(targa VARCHAR(8), annoImm INTEGER)
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    IF annoImm >= 1927 AND annoImm < 1994
    THEN
      SELECT targa REGEXP '^[A-Z0-9]{8}$'
      INTO result;
    ELSEIF annoImm = 1994
      THEN
        SELECT targa REGEXP '^[A-Z0-9]{7,8}$'
        INTO result;
    ELSEIF annoImm > 1994
      THEN
        SELECT targa REGEXP '^[A-Z0-9]{7}$'
        INTO result;
    ELSE
      SET result = FALSE;
    END IF;
    RETURN result;
  END;;

/*
 * Funzione per il controllo del codice di telaio
 * (RV15)
 */
CREATE FUNCTION check_telaio(telaio VARCHAR(17))
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    SELECT telaio REGEXP '^[A-Z0-9]{17}$'
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione per il controllo delle date (la prima
 * data deve essere antecedente alla seconda)
 * (RV22, RV29)
 */
CREATE FUNCTION check_date_chronical_order(inizio DATE, fine DATE)
  RETURNS BOOLEAN
  BEGIN
    DECLARE result BOOLEAN;
    DECLARE difference INTEGER;
    SELECT DATEDIFF(fine, inizio)
    INTO difference;
    SET result = difference >= 0;
    RETURN result;
  END;;

/*
 * Funzione per calcolare l'imponibile di un ordine
 */
CREATE FUNCTION calc_imponibile_ordine(ordine INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SELECT SUM(Fornitura.PrezzoUnitario * Fornitura.Quantita)
    FROM Ordine
      JOIN Fornitura ON Ordine.Codice = Fornitura.Ordine
    WHERE Ordine.Codice = ordine
    INTO result;
    RETURN result;
  END;;

/*
 * Calcolo della quota di una transazione per saldare la fattura
 * di un ordine
 * @TODO Pensare se aggiungere un parametro opzionale per specificare un'aggiunta
 */
CREATE FUNCTION calc_transazione_ordine(ordine INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SELECT Imponibile * (- 1.22)
    FROM Ordine
    WHERE Codice = ordine
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione per il calcolo del costo dei componenti
 */
CREATE FUNCTION calc_costo_componenti(prestazione INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SELECT SUM(Fornitura.PrezzoUnitario * Utilizzo.Quantita)
    FROM Prestazione
      LEFT JOIN Preventivo ON Preventivo.Codice = Prestazione.Preventivo
      LEFT JOIN Utilizzo ON Prestazione.Preventivo = Utilizzo.Prestazione
      LEFT JOIN Fornitura ON Fornitura.Codice = Utilizzo.Fornitura
    WHERE Prestazione.Preventivo = prestazione
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione per il calcolo del costo totale
 */
CREATE FUNCTION calc_costo_totale(prestazione INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SELECT Prestazione.ServAggiuntivi + Prestazione.Manodopera
      AS CostiAggiuntivi
    FROM Prestazione
    WHERE Prestazione.Preventivo = prestazione
    INTO result;
    SET result = result + calc_costo_componenti(prestazione);
    RETURN result;
  END;;

/*
 * Funzione per il calcolo dell'imponibile per una prestazione
 */
CREATE FUNCTION calc_imponibile(prestazione INTEGER, sconto DECIMAL(4, 2))
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SET result = calc_costo_totale(prestazione) * (1 - sconto / 100);
    IF result < 0
    THEN
      CALL throw_error('Sembra che lo sconto applicato sia un po\' troppo alto');
    END IF;
    RETURN result;
  END;;

/*
 * Funzione per il calcolo delle imposte
 */
CREATE FUNCTION calc_imposte(imponibile DECIMAL(10, 2))
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE imposte DECIMAL(10, 2);
    SET imposte = imponibile * 22 / 100;
    RETURN imposte;
  END;;



/*****************************************
 *
 * Procedure
 *
 *****************************************
 */
DELIMITER ;;

/*
 * Procedura per la generazione di errori
 */
CREATE PROCEDURE throw_error(IN msg VARCHAR(300))
  BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = msg;
  END;;

/*
 * Procedura di aggiornamento di imponibile in Ordine
 */
CREATE PROCEDURE ordine_update_imponibile(IN ordine INTEGER)
  BEGIN
    UPDATE Ordine
    SET Imponibile = calc_imponibile_ordine(ordine)
    WHERE Codice = ordine;
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
    IF check_cf_piva(NEW.CF_PIVA) = FALSE
    THEN
      CALL throw_error('Codice fiscale o Partita IVA non valido');
    ELSEIF check_cap(NEW.CAP) = FALSE
      THEN
        CALL throw_error('CAP non valido');
    ELSEIF check_ndocid(NEW.NDocId) = FALSE
      THEN
        CALL throw_error('Numero del documento d\'identità non valido');
    ELSEIF check_cf(NEW.CF_PIVA) AND
           (NEW.Nome IS NULL OR
            NEW.Cognome IS NULL OR
            NEW.RagioneSociale IS NOT NULL)
      THEN
        CALL throw_error('Codice Fiscale rilevato: inserire solamente Nome e Cognome');
    ELSEIF check_piva(NEW.CF_PIVA) AND (NEW.RagioneSociale IS NULL)
      THEN
        CALL throw_error('Partita IVA rilevata: inserire RagioneSociale');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Fornitore
 */
CREATE TRIGGER Fornitore_before_insert
BEFORE INSERT ON Fornitore FOR EACH ROW
  BEGIN
    IF NOT check_piva(NEW.PIVA)
    THEN
      CALL throw_error('Partita IVA non valida');
    ELSEIF NOT check_cap(NEW.CAP)
      THEN
        CALL throw_error('CAP non valido');
    ELSEIF NOT check_iban(NEW.IBAN)
      THEN
        CALL throw_error('IBAN non valido');
    ELSEIF NEW.ModPagamento = 'bonifico' AND NEW.IBAN IS NULL
      THEN
        CALL throw_error('Il pagamento tramite bonifico richiede l\'IBAN');
    END IF;
  END;;

/*
 * Implementazione vincoli su Operatore
 */
CREATE TRIGGER Operatore_before_insert
BEFORE INSERT ON Operatore FOR EACH ROW
  BEGIN
    IF check_cf_piva(NEW.CF) = FALSE
    THEN
      CALL throw_error('Codice fiscale non valido');
    ELSEIF check_cap(NEW.CAP) = FALSE
      THEN
        CALL throw_error('CAP non valido');
    ELSEIF check_provincia(NEW.ProvinciaNasc) = FALSE
      THEN
        CALL throw_error('ProvinciaNasc non valida');
    ELSEIF NOT (NEW.Stipendio IS NULL XOR NEW.RetribuzioneH IS NULL)
      THEN
        CALL throw_error('Specificare uno solo tra Stipendio e RetribuzioneH');
    ELSEIF NEW.ModRiscossione = 'bonifico' AND NEW.IBAN IS NULL
      THEN
        CALL throw_error('La riscossione tramite bonifico richiede l\'IBAN');
    ELSEIF check_iban(NEW.IBAN) = FALSE
      THEN
        CALL throw_error('IBAN non valido');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Autovettura
 */
CREATE TRIGGER Autovettura_before_insert
BEFORE INSERT ON Autovettura FOR EACH ROW
  BEGIN
    IF check_targa(NEW.Targa, NEW.AnnoImmatricolazione) = FALSE
    THEN
      CALL throw_error('Targa non valida');
    ELSEIF (New.Telaio IS NOT NULL AND NOT check_telaio(New.Telaio))
      THEN
        CALL throw_error('Telaio non valido');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Turno
 */
CREATE TRIGGER Turno_before_insert
BEFORE INSERT ON Turno FOR EACH ROW
  BEGIN
    IF NOT check_turno(NEW.OraInizio, NEW.OraFine)
    THEN
      CALL throw_error('L\'ora di fine del turno non può essere antecedente a quella d\'inizio');
    END IF;
  END;;

/*
 * Trigger su Fornitura
 */
CREATE TRIGGER Fornitura_after_insert
AFTER INSERT ON Fornitura FOR EACH ROW
  BEGIN
    CALL ordine_update_imponibile(NEW.Ordine);
  END;;

CREATE TRIGGER Fornitura_after_update
AFTER UPDATE ON Fornitura FOR EACH ROW
  BEGIN
    CALL ordine_update_imponibile(New.Ordine);
  END;;

/* Delimiter di default */
DELIMITER ;


/************************************
 *
 * Viste
 *
 ************************************
 */

/*
 * Fatture
 */
CREATE VIEW FatturaView
AS
  SELECT
    Fattura.*,
    calc_imposte(Fattura.Imponibile)                                          AS Imposte,
    Fattura.Imponibile + calc_imposte(Fattura.Imponibile) - Fattura.Incentivi AS Totale
  FROM Fattura;