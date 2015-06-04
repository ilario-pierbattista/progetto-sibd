/**
 * Tabella dei contenuti
 * 0) Creazione dello schema......12
 * 1) Tabelle.....................16
 * 2) Funzioni...................262
 * 3) Procedure..................677
 * 4) Trigger....................910
 * 5) Viste.....................1371
 * 6) Inserimento dati..........1432
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
    ON UPDATE CASCADE
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
  FOREIGN KEY (Autovettura) REFERENCES Autovettura (Targa)
    ON UPDATE CASCADE,
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
  Componente     INTEGER NOT NULL,
  Preventivo     INTEGER NOT NULL,
  Ubicazione     ENUM('motore', 'bagagliaio'),
  Quantita       INTEGER NOT NULL,
  PrezzoUnitario DECIMAL(6, 2),
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
    ON UPDATE CASCADE
);

CREATE TABLE Ordine (
  Codice        INTEGER       AUTO_INCREMENT PRIMARY KEY,
  DataEmissione DATE        NOT NULL,
  DataConsegna  DATE,
  Imponibile    DECIMAL(9, 2) DEFAULT 0,
  Fornitore     VARCHAR(11) NOT NULL,
  Versamento    INTEGER,
  FOREIGN KEY (Fornitore) REFERENCES Fornitore (PIVA)
    ON UPDATE CASCADE,
  FOREIGN KEY (Versamento) REFERENCES Transazione (Codice)
);

CREATE TABLE Fornitura (
  Codice         INTEGER AUTO_INCREMENT PRIMARY KEY,
  Quantita       INTEGER NOT NULL,
  PrezzoUnitario DECIMAL(8, 2),
  Componente     INTEGER NOT NULL,
  Ordine         INTEGER NOT NULL,
  FOREIGN KEY (Componente) REFERENCES Componente (Codice),
  FOREIGN KEY (Ordine) REFERENCES Ordine (Codice)
);

CREATE TABLE Utilizzo (
  Prestazione    INTEGER NOT NULL,
  Fornitura      INTEGER NOT NULL,
  PrezzoUnitario DECIMAL(8, 2),
  Quantita       INTEGER NOT NULL,
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
    ON UPDATE CASCADE
);

CREATE TABLE Stipendio (
  Transazione INTEGER PRIMARY KEY,
  Operatore   VARCHAR(16) NOT NULL,
  FOREIGN KEY (Transazione) REFERENCES Transazione (Codice),
  FOREIGN KEY (Operatore) REFERENCES Operatore (CF)
    ON UPDATE CASCADE
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

/**
 * Costanti:
 * Non essendovi, in mysql, il supporto alle costanti
 * definite dall'utente, la definizione di funzioni che
 * restituiscono letterali simulano tale comportamento.
 */
/* Valore percentuale dell'iva */
CREATE FUNCTION PERCENTAGE_IVA()
  RETURNS INTEGER
  BEGIN
    RETURN 22;
  END;;
/* Valore reale dell'iva */
CREATE FUNCTION IVA()
  RETURNS REAL
  BEGIN
    RETURN 0.22;
  END;;
/* Ammontare massimo delle transazioni monetarie in contanti */
CREATE FUNCTION MAX_CONTANTI()
  RETURNS REAL
  BEGIN
    RETURN 1000.00;
  END;;

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
 * di un ordine.
 * Il primo parametro è il codice dell'ordine, il secondo è una
 * quantità reale che si può aggiungere per esprimere costi aggiuntivi.
 */
CREATE FUNCTION calc_transazione_ordine(ordine INTEGER, plus REAL)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SELECT Imponibile * (-(1 + IVA()))
    FROM Ordine
    WHERE Codice = ordine
    INTO result;
    RETURN result + plus;
  END;;

/*
 * Funzione per il calcolo del costo dei componenti utilizzati in una
 * prestazione
 */
CREATE FUNCTION calc_costo_componenti_prestazione(prestazione INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SELECT SUM(Utilizzo.PrezzoUnitario * Utilizzo.Quantita)
    INTO result
    FROM Utilizzo
    WHERE Utilizzo.Prestazione = prestazione
    GROUP BY Utilizzo.Prestazione;
    IF result IS NULL
    THEN
      SET result = 0;
    END IF;
    RETURN result;
  END;;

/*
 * Funzione per il calcolo del costo dei componenti previsti in un
 * preventivo
 */
CREATE FUNCTION calc_costo_componenti_preventivo(preventivo INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SELECT SUM(Previsione.PrezzoUnitario * Previsione.Quantita)
    FROM Preventivo
      LEFT JOIN Previsione ON Preventivo.Codice = Previsione.Preventivo
    WHERE Preventivo.Codice = preventivo
    INTO result;
    RETURN result;
  END;;

/*
 * Funzione per il calcolo del costo totale
 */
CREATE FUNCTION calc_costo_totale(prestazione INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result REAL DEFAULT 0;
    SELECT Prestazione.ServAggiuntivi + Prestazione.Manodopera
    INTO result
    FROM Prestazione
    WHERE Prestazione.Preventivo = prestazione;
    IF result IS NOT NULL
    THEN
      SET result = result + calc_costo_componenti_prestazione(prestazione);
    ELSE
      SET result = calc_costo_componenti_prestazione(prestazione);
    END IF;
    RETURN result;
  END;;

/*
 * Funzione per il calcolo dell'imponibile per una prestazione
 */
CREATE FUNCTION calc_imponibile_fattura(prestazione INTEGER, sconto DECIMAL(4, 2))
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

/**
 * Funzione per il calcolo dell'imponibile lordo
 */
CREATE FUNCTION calc_imponibile_lordo(numero INTEGER, anno INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    DECLARE imponibile_netto DECIMAL(10, 2);
    DECLARE sconto INTEGER;
    SELECT
      Fattura.Imponibile,
      Fattura.Sconto
    INTO imponibile_netto, sconto
    FROM Fattura
    WHERE Fattura.Numero = numero AND Fattura.Anno = anno;
    SET result = imponibile_netto * (100 / (100 - sconto));
    RETURN result;
  END;;

/*
 * Funzione per il calcolo delle imposte
 */
CREATE FUNCTION calc_imposte_fattura(imponibile DECIMAL(10, 2))
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE imposte DECIMAL(10, 2);
    SET imposte = imponibile * IVA();
    RETURN imposte;
  END;;

/*
 * Funzione per il calcolo dell'ammontare dello sconto
 */
CREATE FUNCTION calc_ammontare_sconto(imponibile_netto REAL, sconto INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SET result = imponibile_netto * (sconto / (100 - sconto));
    RETURN result;
  END;;

/*
 * Funzione per il calcolo del totale lordo
 */
CREATE FUNCTION calc_totale_lordo(imponibile REAL, incentivi REAL)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SET result = imponibile + calc_imposte_fattura(imponibile) - incentivi;
    RETURN result;
  END;;

/*
 * Funzione per il calcolo del totale netto
 */
CREATE FUNCTION calc_totale_netto(imponibile REAL, incentivi REAL, acconto REAL)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE result DECIMAL(10, 2);
    SET result = imponibile + calc_imposte_fattura(imponibile) - incentivi - acconto;
    RETURN result;
  END ;;

/*
 * Funzione per calcolare la somma per saldare la fattura
 * (Tiene conto di un eventuale acconto)
 */
CREATE FUNCTION calc_transazione_fattura(numero_fattura INTEGER, anno INTEGER)
  RETURNS DECIMAL(10, 2)
  BEGIN
    DECLARE acconto REAL DEFAULT 0;
    DECLARE totale REAL;
    SELECT
      Fattura.Imponibile,
      Transazione.Quota
    INTO totale, acconto
    FROM Fattura
      JOIN Prestazione ON Prestazione.Preventivo = Fattura.Prestazione
      JOIN Preventivo ON Preventivo.Codice = Prestazione.Preventivo
      LEFT JOIN Transazione ON Transazione.Codice = Fattura.Transazione
    WHERE Fattura.Numero = numero_fattura AND
          Fattura.Anno = anno;
    SET totale = totale + calc_imposte_fattura(totale);
    IF acconto IS NOT NULL
    THEN
      SET totale = totale + acconto;
    END IF;
    RETURN totale;
  END;;

/*
 * Funzione per trovare il numero della prossima fattura da inserire
 */
CREATE FUNCTION next_fattura_num(anno INTEGER)
  RETURNS INTEGER
  BEGIN
    DECLARE num INTEGER DEFAULT NULL;
    SELECT Fattura.Numero
    INTO num
    FROM Fattura
    WHERE Fattura.Anno = anno
    ORDER BY Fattura.Numero DESC
    LIMIT 1;
    IF num IS NULL
    THEN
      SET num = 1;
    ELSE
      SET num = num + 1;
    END IF;
    RETURN num;
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
CREATE PROCEDURE throw_error(IN msg VARCHAR(128))
  BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = msg;
  END;;

/*
 * Procedura di aggunta automatica di un recapito ad un cliente
 */
CREATE PROCEDURE add_recapito_cliente(
  IN cf_piva  VARCHAR(16),
     recapito VARCHAR(200),
     tipo     ENUM('telefono',
                   'fax',
                   'tel_fax',
                   'sito_web',
                   'email')
)
  BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK;
      CALL throw_error('Recapito già registrato');
    END;
    START TRANSACTION;
    INSERT INTO Recapito (Recapito, Tipo) VALUES (recapito, tipo);
    SELECT LAST_INSERT_ID()
    INTO @last_id;
    INSERT INTO RubricaCliente (Recapito, Cliente) VALUES (@last_id, cf_piva);
    COMMIT;
  END;;

/**
 * Procedura di aggiunta di un recapito ad un fornitore
 */
CREATE PROCEDURE add_recapito_fornitore(
  IN piva     VARCHAR(16),
     recapito VARCHAR(200),
     tipo     ENUM('telefono',
                   'fax',
                   'tel_fax',
                   'sito_web',
                   'email')
)
  BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK;
      CALL throw_error('Recapito già registrato');
    END;
    START TRANSACTION;
    INSERT INTO Recapito (Recapito, Tipo) VALUES (recapito, tipo);
    SELECT LAST_INSERT_ID()
    INTO @last_id;
    INSERT INTO RubricaFornitore (Recapito, Fornitore) VALUES (@last_id, piva);
    COMMIT;
  END;;

/**
 * Procedura di aggiunta di un recapito ad un operatore
 */
CREATE PROCEDURE add_recapito_operatore(
  IN cf       VARCHAR(16),
     recapito VARCHAR(200),
     tipo     ENUM('telefono',
                   'fax',
                   'tel_fax',
                   'sito_web',
                   'email')
)
  BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK;
      CALL throw_error('Recapito già registrato');
    END;
    START TRANSACTION;
    INSERT INTO Recapito (Recapito, Tipo) VALUES (recapito, tipo);
    SELECT LAST_INSERT_ID()
    INTO @last_id;
    INSERT INTO RubricaOperatore (Recapito, Operatore) VALUES (@last_id, cf);
    COMMIT;
  END;;

/**
 * Procedura per la registrazione di un nuovo ordine in magazzino
 */
CREATE PROCEDURE registra_ordine_magazzino(IN ordine INTEGER)
  BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE componente_id INT;
    DECLARE fornitura_id INT;
    DECLARE quantita INT;
    DECLARE cur CURSOR FOR
      SELECT
        Fornitura.Codice,
        Fornitura.Componente,
        Fornitura.Quantita
      FROM Fornitura
      WHERE Fornitura.Ordine = ordine;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK;
      CALL throw_error('Errore nell''inserimento dell''ordine in magazzino');
    END;
    START TRANSACTION;
    OPEN cur;
    REPEAT
      FETCH cur
      INTO fornitura_id, componente_id, quantita;
      IF NOT done
      THEN
        INSERT INTO Magazzino (Componente, Fornitura, Quantita)
        VALUES (componente_id, fornitura_id, quantita);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
    COMMIT;
  END;;

/*
 * Procedura di aggiornamento delle quantità rimanenti in magazzino
 */
CREATE PROCEDURE update_quantita_magazzino(IN prestazione INTEGER)
  BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE fornitura_id INT;
    DECLARE quantita INT;
    DECLARE quantita_presente INT;
    DECLARE error_message VARCHAR(128) DEFAULT 'Errore nell''aggiornamento del magazzino';
    DECLARE cur CURSOR FOR
      SELECT
        Utilizzo.Fornitura,
        Utilizzo.Quantita
      FROM Utilizzo
      WHERE Utilizzo.Prestazione = prestazione;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK;
      CALL throw_error(error_message);
    END;
    START TRANSACTION;
    OPEN cur;
    REPEAT
      FETCH cur
      INTO fornitura_id, quantita;
      IF NOT done
      THEN
        SELECT Magazzino.Quantita
        INTO quantita_presente
        FROM Magazzino
        WHERE Magazzino.Fornitura = fornitura_id;
        IF quantita_presente - quantita >= 0
        THEN
          UPDATE Magazzino
          SET Magazzino.Quantita = Magazzino.Quantita - quantita
          WHERE Magazzino.Fornitura = fornitura_id;
        ELSE
          SET error_message = 'La quantità di componenti disponibili non è sufficiente';
          CALL throw_error(error_message);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
    COMMIT;
  END;;

/*
 * Procedura d'inserimento degli stipendi
 */
CREATE PROCEDURE insert_stipendi(IN data_inizio DATE, data_fine DATE, data_inserimento DATE)
  BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE operatore VARCHAR(16);
    DECLARE stipendio REAL;
    DECLARE transazione INTEGER;
    DECLARE error_message VARCHAR(128) DEFAULT 'Errore nell''inserimento degli stipendi';
    DECLARE cur CURSOR FOR
      SELECT Operatore.CF
      FROM Operatore;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK;
      CALL throw_error(error_message);
    END;
    START TRANSACTION;
    OPEN cur;
    REPEAT
      FETCH cur
      INTO operatore;
      IF NOT done
      THEN
        SELECT CASE
               WHEN Operatore.Stipendio IS NULL THEN Ore * RetribuzioneH
               ELSE Operatore.Stipendio
               END
        INTO stipendio
        FROM Operatore
          JOIN (
                 SELECT
                   Turno.Operatore,
                   SUM(ROUND(TIME_TO_SEC(TIMEDIFF(OraFine, OraInizio)) / 3600, 1)) AS Ore
                 FROM Turno
                 WHERE (Turno.Data BETWEEN data_inizio AND data_fine)
                 GROUP BY Turno.Operatore
               ) AS t ON t.Operatore = Operatore.CF
        WHERE Operatore.CF = operatore;
        INSERT INTO Transazione (Quota, Data)
        VALUES (-stipendio, data_inserimento);
        SELECT LAST_INSERT_ID()
        INTO transazione;
        INSERT INTO Stipendio (Operatore, Transazione)
        VALUES (operatore, transazione);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
    COMMIT;
  END;;

/*****************************************
 *
 * Aggiunta dei trigger che implementano i
 * vincoli d'integrità
 *
 * Purtroppo i trigger vanno duplicati, uno per
 * l'inserimento ed uno per l'aggiornamento
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
CREATE TRIGGER Cliente_before_update
BEFORE UPDATE ON Cliente FOR EACH ROW
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
CREATE TRIGGER Fornitore_before_update
BEFORE UPDATE ON Fornitore FOR EACH ROW
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
    ELSEIF NEW.ModRiscossione = 'contanti' AND NEW.Stipendio > MAX_CONTANTI()
      THEN
        CALL throw_error('La modalità di riscossione non può essere ''contanti'' per questo importo');
    ELSEIF check_iban(NEW.IBAN) = FALSE
      THEN
        CALL throw_error('IBAN non valido');
    END IF;
  END;;
CREATE TRIGGER Operatore_before_update
BEFORE UPDATE ON Operatore FOR EACH ROW
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
    ELSEIF NEW.ModRiscossione = 'contanti' AND NEW.Stipendio > MAX_CONTANTI()
      THEN
        CALL throw_error('La modalità di riscossione non può essere ''contanti'' per questo importo');
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
CREATE TRIGGER Autovettura_before_update
BEFORE UPDATE ON Autovettura FOR EACH ROW
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
CREATE TRIGGER Turno_before_update
BEFORE UPDATE ON Turno FOR EACH ROW
  BEGIN
    IF NOT check_turno(NEW.OraInizio, NEW.OraFine)
    THEN
      CALL throw_error('L\'ora di fine del turno non può essere antecedente a quella d\'inizio');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Preventivo
 */
CREATE TRIGGER Preventivo_before_insert
BEFORE INSERT ON Preventivo FOR EACH ROW
  BEGIN
    IF NEW.SisAlimentazione IS NULL AND NEW.Categoria IN (
      'installazione_impianto_gpl', 'installazione_impianto_metano')
    THEN
      CALL throw_error('SisAlimentazione è un attributo necessario per un preventivo d''installazione');
    ELSEIF NEW.SisAlimentazione IS NOT NULL AND NEW.Categoria NOT IN (
      'installazione_impianto_gpl', 'installazione_impianto_metano')
      THEN
        CALL throw_error('SisAlimentazione deve essere null per i preventivi che non siano d''installazione');
    END IF;
  END;;
CREATE TRIGGER Preventivo_before_update
BEFORE UPDATE ON Preventivo FOR EACH ROW
  BEGIN
    IF NEW.SisAlimentazione IS NULL AND NEW.Categoria IN (
      'installazione_impianto_gpl', 'installazione_impianto_metano')
    THEN
      CALL throw_error('SisAlimentazione è un attributo necessario per un preventivo d''installazione');
    ELSEIF NEW.SisAlimentazione IS NOT NULL AND NEW.Categoria NOT IN (
      'installazione_impianto_gpl', 'installazione_impianto_metano')
      THEN
        CALL throw_error('SisAlimentazione deve essere null per i preventivi che non siano d''installazione');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Prestazione
 */
CREATE TRIGGER Prestazione_before_insert
BEFORE INSERT ON Prestazione FOR EACH ROW
  BEGIN
    DECLARE data_emissione DATE;
    SELECT Preventivo.DataEmissione
    INTO data_emissione
    FROM Preventivo
    WHERE Preventivo.Codice = NEW.Preventivo;
    IF NOT check_date_chronical_order(data_emissione, NEW.DataFine)
    THEN
      CALL throw_error('La data di fine non può essere antecedente a quella di emissione del preventivo');
    END IF;
  END;;
CREATE TRIGGER Prestazione_before_update
BEFORE UPDATE ON Prestazione FOR EACH ROW
  BEGIN
    DECLARE data_emissione DATE;
    SELECT Preventivo.DataEmissione
    INTO data_emissione
    FROM Preventivo
    WHERE Preventivo.Codice = NEW.Preventivo;
    IF NOT check_date_chronical_order(data_emissione, NEW.DataFine)
    THEN
      CALL throw_error('La data di fine non può essere antecedente a quella di emissione del preventivo');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Componente
 */
CREATE TRIGGER Componente_before_insert
BEFORE INSERT ON Componente FOR EACH ROW
  BEGIN
    IF NEW.Validita < 0
    THEN
      CALL throw_error('Validità di Componente non può essere un numero minore di zero');
    ELSEIF NEW.QuantitaMin < 0
      THEN
        CALL throw_error('QuantitàMin di Componente non può essere un numero minore di zero');
    END IF;
  END;;
CREATE TRIGGER Componente_before_update
BEFORE UPDATE ON Componente FOR EACH ROW
  BEGIN
    IF NEW.Validita < 0
    THEN
      CALL throw_error('Validità di Componente non può essere un numero minore di zero');
    ELSEIF NEW.QuantitaMin < 0
      THEN
        CALL throw_error('QuantitàMin di Componente non può essere un numero minore di zero');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Fornitura
 */
CREATE TRIGGER Fornitura_before_insert
BEFORE INSERT ON Fornitura FOR EACH ROW
  BEGIN
    IF NOT (NEW.Quantita > 0 AND NEW.PrezzoUnitario > 0)
    THEN
      CALL throw_error('Quantità e PrezzoUnitario di Fornitura devono essere maggiori di zero');
    END IF;
  END;;
CREATE TRIGGER Fornitura_before_update
BEFORE UPDATE ON Fornitura FOR EACH ROW
  BEGIN
    IF NOT (NEW.Quantita > 0 AND NEW.PrezzoUnitario > 0)
    THEN
      CALL throw_error('Quantità e PrezzoUnitario di Fornitura devono essere maggiori di zero');
    END IF;
  END;;


/*
 * Implementazione dei vincoli su Ordine
 */
CREATE TRIGGER Ordine_before_insert
BEFORE INSERT ON Ordine FOR EACH ROW
  BEGIN
    IF NOT check_date_chronical_order(NEW.DataEmissione, NEW.DataConsegna)
    THEN
      CALL throw_error('La data di consegna dell''ordine non può antecedere quella di emissione');
    END IF;
  END;;
CREATE TRIGGER Ordine_before_update
BEFORE UPDATE ON Ordine FOR EACH ROW
  BEGIN
    IF NOT check_date_chronical_order(NEW.DataEmissione, NEW.DataConsegna)
    THEN
      CALL throw_error('La data di consegna dell''ordine non può antecedere quella di emissione');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Fattura
 */
CREATE TRIGGER Fattura_before_insert
BEFORE INSERT ON Fattura FOR EACH ROW
  BEGIN
    IF NOT check_date_chronical_order(NEW.DataEmissione, NEW.DataScadenza)
    THEN
      CALL throw_error('La data di scadenza di una fattura non può essere antecedente a quella di emissione');
    ELSEIF NEW.SisPag = 'rimessa_diretta' AND
           NEW.DataEmissione != NEW.DataScadenza
      THEN
        IF NEW.DataScadenza IS NULL
        THEN
          SET NEW.DataScadenza = NEW.DataEmissione;
        ELSE
          CALL throw_error('Nel pagamento a rimessa diretta la data di scadenza non può '
                           'essere diversa da quella di emissione');
        END IF;
    ELSEIF NEW.Sconto < 0 OR NEW.Sconto >= 100
      THEN
        CALL throw_error('Sconto di Fattura non può assumere questo valore');
    END IF;
  END;;
CREATE TRIGGER Fattura_before_update
BEFORE UPDATE ON Fattura FOR EACH ROW
  BEGIN
    IF NOT check_date_chronical_order(NEW.DataEmissione, NEW.DataScadenza)
    THEN
      CALL throw_error('La data di scadenza di una fattura non può essere antecedente a quella di emissione');
    ELSEIF NEW.SisPag = 'rimessa_diretta' AND
           NEW.DataEmissione != NEW.DataScadenza
      THEN
        IF NEW.DataScadenza IS NULL
        THEN
          SET NEW.DataScadenza = NEW.DataEmissione;
        ELSE
          CALL throw_error('Nel pagamento a rimessa diretta la data di scadenza non può '
                           'essere diversa da quella di emissione');
        END IF;
    ELSEIF NEW.Sconto < 0 OR NEW.Sconto >= 100
      THEN
        CALL throw_error('Sconto di Fattura non può assumere questo valore');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Utilizzo
 */
CREATE TRIGGER Utilizzo_before_insert
BEFORE INSERT ON Utilizzo FOR EACH ROW
  BEGIN
    DECLARE prezzo REAL;
    IF NEW.PrezzoUnitario IS NULL
    THEN
      SELECT Componente.PrezzoVendita
      INTO prezzo
      FROM Fornitura
        JOIN Componente ON Componente.Codice = Fornitura.Componente
      WHERE Fornitura.Codice = NEW.Fornitura;
      SET NEW.PrezzoUnitario = prezzo;
    END IF;
    IF NEW.Quantita < 0
    THEN
      CALL throw_error('La Quantità di Utilizzo non può essere minore di zero');
    END IF;
  END;;
CREATE TRIGGER Utilizzo_before_update
BEFORE UPDATE ON Utilizzo FOR EACH ROW
  BEGIN
    IF NEW.Quantita < 0
    THEN
      CALL throw_error('La Quantità di Utilizzo non può essere minore di zero');
    END IF;
  END;;

/*
 * Implementazione dei vincoli su Previsione
 */
CREATE TRIGGER Previsione_before_insert
BEFORE INSERT ON Previsione FOR EACH ROW
  BEGIN
    DECLARE categoria VARCHAR(30);
    DECLARE ubicazione_required BOOLEAN;
    DECLARE prezzo REAL;
    SELECT Preventivo.Categoria /* Estrazione della categoria del preventivo */
    INTO categoria
    FROM Preventivo
    WHERE Preventivo.Codice = NEW.Preventivo;
    SET ubicazione_required = (categoria = 'installazione_impianto_metano' OR
                               categoria = 'installazione_impianto_gpl');
    IF NEW.Quantita < 0
    THEN
      CALL throw_error('La Quantità di Previsione non può essere minore di zero');
    ELSEIF NEW.Ubicazione IS NOT NULL XOR ubicazione_required
      THEN
        CALL throw_error('Ubicazione deve essere NULL solo se non si tratta '
                         'della previsione di un''installazione');
    END IF;
    IF NEw.PrezzoUnitario IS NULL
    THEN
      SELECT Componente.PrezzoVendita /* Estrazione del prezzo del componente */
      INTO prezzo
      FROM Componente
      WHERE Componente.Codice = NEW.Componente;
      SET NEW.PrezzoUnitario = prezzo;
    END IF;
  END;;
CREATE TRIGGER Previsione_before_update
BEFORE UPDATE ON Previsione FOR EACH ROW
  BEGIN
    DECLARE categoria VARCHAR(30);
    DECLARE ubicazione_required BOOLEAN;
    SELECT Preventivo.Categoria
    INTO categoria
    FROM Preventivo
    WHERE Preventivo.Codice = NEW.Preventivo;
    SET ubicazione_required = (categoria = 'installazione_impianto_metano' OR
                               categoria = 'installazione_impianto_gpl');
    IF NEW.Quantita < 0
    THEN
      CALL throw_error('La Quantità di Previsione non può essere minore di zero');
    ELSEIF NEW.Ubicazione IS NOT NULL XOR ubicazione_required
      THEN
        CALL throw_error('Ubicazione deve essere NULL solo se non si tratta '
                         'della previsione di un''installazione');
    END IF;
  END;;

DELIMITER ;


/************************************
 *
 * Viste
 *
 ************************************
 */

/*
 * Fatture
 * Riepilogo di una fattura
 */
CREATE VIEW FatturaView
AS
  SELECT
    Fattura.Numero,
    Fattura.Anno,
    Fattura.DataEmissione,
    Fattura.SisPag,
    Cliente.Nome,
    Cliente.Cognome,
    Cliente.Citta,
    Cliente.Via,
    Cliente.Civico,
    Cliente.CAP,
    Autovettura.Targa,
    calc_costo_componenti_prestazione(Prestazione.Preventivo)                              AS CostoComponenti,
    Prestazione.Manodopera,
    Prestazione.ServAggiuntivi,
    calc_imponibile_lordo(Fattura.Numero, Fattura.Anno)                                    AS ImponibileLordo,
    Fattura.Sconto,
    calc_ammontare_sconto(Fattura.Imponibile, Fattura.Sconto)                              AS ImportoSconto,
    Fattura.Imponibile                                                                     AS ImponibileNetto,
    calc_imposte_fattura(Fattura.Imponibile)                                               AS Imposte,
    Fattura.Incentivi,
    calc_totale_lordo(Fattura.Imponibile, Fattura.Incentivi)                               AS Totale,
    IFNULL(Transazione.Quota, 0)                                                           AS RitenutaAcconto,
    calc_totale_netto(Fattura.Imponibile, Fattura.Incentivi, IFNULL(Transazione.Quota, 0)) AS TotaleNetto
  FROM Fattura
    JOIN Prestazione ON Prestazione.Preventivo = Fattura.Prestazione
    JOIN Preventivo ON Preventivo.Codice = Prestazione.Preventivo
    LEFT JOIN Transazione ON Transazione.Codice = Preventivo.Acconto
    JOIN Autovettura ON Autovettura.Targa = Preventivo.Autovettura
    JOIN Cliente ON Cliente.CF_PIVA = Autovettura.Cliente;

/**
 * Magazzino
 * Componenti presenti in magazzino
 */
CREATE VIEW MagazzinoView
AS
  SELECT
    Componente.Codice,
    Componente.Nome,
    SUM(IFNULL(Magazzino.Quantita, 0)) AS QuantitaPresente
  FROM Componente
    LEFT JOIN Magazzino ON Componente.Codice = Magazzino.Componente
  GROUP BY Componente.Codice
  HAVING QuantitaPresente > 0
  ORDER BY Componente.Nome ASC;


/***************************************************************
 ***************************************************************
 ****
 ****     INSERIMENTO DATI
 ****
 ****
 ***************************************************************
 ***************************************************************
 */

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
   '1990-04-15', 'Macerata', 'MC', 10, 'contanti', 'IT02L1254312000023451000012');

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

INSERT INTO Ordine (DataEmissione, Fornitore) VALUES ('2015-04-09', '02365478952');
SELECT LAST_INSERT_ID()
INTO @last_ord;
INSERT INTO Fornitura (Quantita, Componente, Ordine, PrezzoUnitario)
VALUES
  (1, 2, @last_ord, 305);
UPDATE Ordine
SET Imponibile = calc_imponibile_ordine(@last_ord)
WHERE Ordine.Codice = @last_ord;
INSERT INTO Transazione (Quota, Data)
VALUES (calc_transazione_ordine(@last_ord, 0), '2015-04-11');
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
SET Acconto       = @last_trans,
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
  (@last_prest, 10, 2),
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


/**********************************
 * Stipendi
 **********************************
 */
CALL insert_stipendi('2015-04-01', '2015-05-01', '2015-05-01');


/*********************************
 * INSERIMENTI EXTRA
 *********************************
 */

/************************************
 * Preventivo che non verrà eseguito
 */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria, Sintomi,
                        SisAlimentazione, TempoStimato,
                        Manodopera, ServAggiuntivi, Autovettura)
VALUES ('2015-04-20', '2015-04-30', 'installazione_impianto_metano',
        NULL, 'iniezione', 3, 400, 100, 'RT435CM');
SELECT LAST_INSERT_ID()
INTO @last_prev;
INSERT INTO Previsione (Componente, Preventivo, Ubicazione, Quantita)
VALUES
  (1, @last_prev, 'bagagliaio', 1),
  (4, @last_prev, 'motore', 1),
  (6, @last_prev, 'motore', 1),
  (8, @last_prev, 'motore', 1);
INSERT INTO Transazione (Quota, Data)
VALUES (300, '2015-04-09');
SELECT LAST_INSERT_ID()
INTO @last_transazione;
UPDATE Preventivo
SET Acconto       = @last_transazione,
  CostoComponenti = calc_costo_componenti_preventivo(@last_prev)
WHERE Preventivo.Codice = @last_prev;


/*************************************
 * Fattura che non verrà saldata
 */
INSERT INTO Preventivo (DataEmissione, DataInizio, Categoria,
                        SisAlimentazione, TempoStimato,
                        Manodopera, ServAggiuntivi, Autovettura)
VALUES ('2015-05-03', '2015-05-20', 'installazione_impianto_gpl',
        'aspirazione', 2, 400, 150, 'BX692TE');
SELECT LAST_INSERT_ID()
INTO @last_prev;
INSERT INTO Previsione (Componente, Preventivo, Quantita, Ubicazione)
VALUES
  (3, @last_prev, 1, 'bagagliaio'),
  (5, @last_prev, 1, 'motore'),
  (10, @last_prev, 1, 'motore'),
  (8, @last_prev, 1, 'motore');
INSERT INTO Transazione (Quota, Data)
VALUES (350, '2015-05-03');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Preventivo
SET Acconto       = @last_trans,
  CostoComponenti = calc_costo_componenti_preventivo(@last_prev)
WHERE Preventivo.Codice = @last_prev;
INSERT INTO Prestazione (Preventivo, TempiEsecuzione, Procedimento,
                         DataFine, Manodopera, ServAggiuntivi)
VALUES (@last_prev, 2,
        'Installazione di un impianto a gpl',
        '2015-05-22', 400, 140);
INSERT INTO Utilizzo (Prestazione, Fornitura, Quantita)
VALUES
  (@last_prev, 3, 1),
  (@last_prev, 5, 1),
  (@last_prev, 10, 1),
  (@last_prev, 7, 1);
CALL update_quantita_magazzino(@last_prev);
INSERT INTO Occupazione (Prestazione, Operatore)
VALUES
  (@last_prev, 'STFDRN60A02E783V');
SET @num_fattura = next_fattura_num(2015);
INSERT INTO Fattura (Numero, Anno, Imponibile, Sconto, Incentivi,
                     DataEmissione, DataScadenza, TipoPag,
                     StatoPag, SisPag, Prestazione)
VALUES (@num_fattura, 2015, calc_imponibile_fattura(@last_prev, 0), 0, 200,
        '2015-05-22', '2015-05-30', 'bonifico',
        FALSE, 'rimessa_differita', @last_prev);


/***********************************************
 * Ordine che non verrà consegnato
 */
INSERT INTO Ordine (DataEmissione, Fornitore) VALUES ('2015-05-30', '05987418630');
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
VALUES (calc_transazione_ordine(@last_ord, 0), '2015-05-30');
SELECT LAST_INSERT_ID()
INTO @last_trans;
UPDATE Ordine
SET Ordine.Versamento = @last_trans
WHERE Ordine.Codice = @last_ord;
