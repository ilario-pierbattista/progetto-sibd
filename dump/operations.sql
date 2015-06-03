/**
 * OP20: Modifica dei dati di un cliente
 */
UPDATE Cliente
SET CF_PIVA      = 'cf_piva',
  Nome           = 'nome',
  Cognome        = 'cognome',
  RagioneSociale = 'ragione sociale',
  Citta          = 'citta',
  Via            = 'via',
  Civico         = 'civico',
  CAP            = 'CAP',
  NDocId         = 'NdocId'
WHERE Cliente.CF_PIVA = 'identifier';

/**
 * OP21: Modifica dei dati di un fornitore
 */
UPDATE Fornitore
SET PIVA         = 'piva',
  RagioneSociale = 'ragione',
  TempiConsegna  = 'tempi',
  ModPagamento   = 'mod',
  IBAN           = 'iban',
  Citta          = 'citta',
  Via            = 'via',
  Civico         = 'civico',
  CAP            = 'cap'
WHERE Fornitore.PIVA = 'piva';

/**
 * OP22: Modifica dei dati di un operatore
 */
UPDATE Operatore
SET CF           = 'cf',
  Nome           = 'nome',
  Cognome        = 'cognome',
  Citta          = 'citta',
  Via            = 'via',
  Civico         = 'civico',
  CAP            = 'cap',
  DataNasc       = 'data',
  ComuneNasc     = 'comune',
  ProvinciaNasc  = 'prov',
  Stipendio      = 'stipendio',
  RetribuzioneH  = 'retrib',
  ModRiscossione = 'mod',
  IBAN           = 'iban'
WHERE Operatore.CF = 'cf';

/**
 * OP23: Modifica del prezzo di vendita di un componente
 */
UPDATE Componente
SET PrezzoVendita = 'prezzo'
WHERE Componente.Codice = 'codice';

/**
 * OP25: Data di ultimo collaudo per un'autovettura
 */
SELECT UltimoCollaudo
FROM Autovettura
WHERE Targa = 'BX692TE';

SELECT
  Autovettura.Targa,
  Autovettura.UltimoCollaudo,
  Cliente.Nome,
  Cliente.Cognome,
  Cliente.CF_PIVA
FROM Autovettura
  JOIN (
         SELECT
           Autovettura.Targa,
           DATEDIFF(
               CURRENT_DATE(),
               DATE_ADD(Autovettura.UltimoCollaudo, INTERVAL 5 YEAR)
           ) AS date_difference
         FROM Autovettura
       ) AS a ON a.Targa = Autovettura.Targa
  JOIN Cliente ON Cliente.CF_PIVA = Autovettura.Cliente
WHERE a.date_difference > -14;

/**
 * OP26: Data di ultima revisione per un'autovettura
 */
SELECT UltimaRevisione
FROM Autovettura
WHERE Targa = 'BX692TE';

SELECT
  Autovettura.Targa,
  Autovettura.UltimaRevisione,
  Cliente.Nome,
  Cliente.Cognome,
  Cliente.CF_PIVA
FROM Autovettura
  JOIN (
         SELECT
           Autovettura.Targa,
           DATEDIFF(
               CURRENT_DATE(),
               DATE_ADD(Autovettura.UltimaRevisione, INTERVAL 5 YEAR)
           ) AS date_difference
         FROM Autovettura
       ) AS a ON a.Targa = Autovettura.Targa
  JOIN Cliente ON Cliente.CF_PIVA = Autovettura.Cliente
WHERE a.date_difference > -14;

/**
 * OP27: Consultazione dei dati per stilare una ricevuta fiscale
 * o una fattura
 */
/** Intestazione della fattura */
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
  IFNULL(p.CostoComponenti, 0)                                                      AS CostoComponenti,
  Prestazione.Manodopera,
  Prestazione.ServAggiuntivi,
  f.ImponibileLordo,
  Fattura.Sconto,
  f.ImportoSconto,
  Fattura.Imponibile                                                                AS ImponibileNetto,
  f.Imposte,
  Fattura.Incentivi,
  Fattura.Imponibile + f.Imposte - Fattura.Incentivi                                AS Totale,
  IFNULL(Transazione.Quota, 0)                                                      AS RitenutaAcconto,
  Fattura.Imponibile + f.Imposte - Fattura.Incentivi - IFNULL(Transazione.Quota, 0) AS TotaleNetto
FROM Fattura
  JOIN Prestazione ON Prestazione.Preventivo = Fattura.Prestazione
  JOIN Preventivo ON Preventivo.Codice = Prestazione.Preventivo
  LEFT JOIN Transazione ON Transazione.Codice = Preventivo.Acconto
  JOIN Autovettura ON Autovettura.Targa = Preventivo.Autovettura
  JOIN Cliente ON Cliente.CF_PIVA = Autovettura.Cliente
  LEFT JOIN (SELECT
               Utilizzo.Prestazione,
               SUM(Utilizzo.PrezzoUnitario * Utilizzo.Quantita) AS CostoComponenti
             FROM Utilizzo
             GROUP BY Utilizzo.Prestazione
            ) AS p ON p.Prestazione = Prestazione.Preventivo
  JOIN (SELECT
          Fattura.Numero,
          Fattura.Anno,
          ROUND(Fattura.Imponibile * (100 / (100 - Fattura.Sconto)), 2)            AS ImponibileLordo,
          ROUND(Fattura.Imponibile * 0.22, 2)                                      AS Imposte,
          ROUND(Fattura.Imponibile * (Fattura.Sconto / (100 - Fattura.Sconto)), 2) AS ImportoSconto
        FROM Fattura) AS f ON Fattura.Numero = f.Numero AND Fattura.Anno = f.Anno;

/**
 * OP43: Scostamento tra i costi preventivati ed i costi effettivi
 */
SELECT sum(Utilizzo.PrezzoUnitario * Utilizzo.Quantita)
FROM Prestazione
  LEFT JOIN Utilizzo ON Prestazione.Preventivo = Utilizzo.Prestazione
GROUP BY Utilizzo.Prestazione;
