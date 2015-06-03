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
        FROM Fattura) AS f ON Fattura.Numero = f.Numero AND Fattura.Anno = f.Anno
WHERE Fattura.Numero = 3 AND Fattura.Anno = 2015;
/** Costi dei componenti */
SELECT
  Componente.Codice                           AS CodiceComponente,
  Componente.Nome,
  Utilizzo.Quantita,
  Utilizzo.PrezzoUnitario,
  Utilizzo.Quantita * Utilizzo.PrezzoUnitario AS PrezzoTotale
FROM Fattura
  JOIN Utilizzo ON Utilizzo.Prestazione = Fattura.Prestazione
  JOIN Fornitura ON Fornitura.Codice = Utilizzo.Fornitura
  JOIN Componente ON Componente.Codice = Fornitura.Componente
WHERE Anno = 2015 AND Numero = 3;


/**
 * OF28: Transazioni avvenute in un certo periodo
 */
SELECT
  Transazione.*,
  Preventivo.Codice as Preventivo,
  CONCAT(Fattura.Numero, '/', Fattura.Anno) as Fattura,
  Ordine.Codice as Ordine,
  Stipendio.Operatore as Operatore,
  CASE
    WHEN Preventivo.Acconto is not NULL THEN 'acconto'
    WHEN Fattura.Transazione is NOT null THEN 'pagamento prestazione'
    WHEN Ordine.Versamento is NOT null THEN 'versamento fornitore'
    WHEN Stipendio.Transazione is not null THEN 'stipendio'
    ELSE 'categoria non riconosciuta'
  END AS Categoria
FROM Transazione
  LEFT JOIN Preventivo ON Transazione.Codice = Preventivo.Acconto
  LEFT JOIN Fattura ON Transazione.Codice = Fattura.Transazione
  LEFT JOIN Ordine ON Transazione.Codice = Ordine.Versamento
  LEFT JOIN Stipendio ON Transazione.Codice = Stipendio.Transazione
WHERE (Transazione.Data BETWEEN '2015-04-10' AND '2015-05-03')
ORDER BY Data DESC;


/**
 * OP29: Storico riparazioni
 */
/* Lista */
SELECT Prestazione.*
FROM Prestazione
  JOIN Preventivo ON Preventivo.Codice = Prestazione.Preventivo
WHERE Categoria = 'riparazione';
/* Ricerca */
SELECT Prestazione.*
FROM Prestazione
  JOIN Preventivo ON Preventivo.Codice = Prestazione.Preventivo
WHERE Categoria = 'riparazione'
      AND LOWER(Prestazione.Malfunzionamento) LIKE LOWER('%frizione%');

/**
 * OP30: Storico preventivi
 */
/* Lista dei preventivi */
SELECT *
FROM Preventivo
WHERE Categoria = 'installazione_impianto_gpl';
/* Ricerca per categoria e sintomi */
SELECT *
FROM Preventivo
WHERE Categoria = 'riparazione' AND
      LOWER(Sintomi) LIKE LOWER('%freno%');
/* Ricerca per modello d'auto e sintomi */
SELECT *
FROM Preventivo
  JOIN Autovettura ON Autovettura.Targa = Preventivo.Autovettura
WHERE Autovettura.Marca = 'Volkswagen'
      AND Autovettura.Modello = 'Golf'
      AND LOWER(Preventivo.Sintomi) LIKE '%freno%';

/**
 * OP31: Disponibilità di un componente
 */
SELECT
  Componente.Codice,
  Componente.Nome,
  SUM(IFNULL(Magazzino.Quantita, 0)) AS QuantitaPresente
FROM Componente
  LEFT JOIN Magazzino ON Componente.Codice = Magazzino.Componente
WHERE Componente.Codice = 9
GROUP BY Componente.Codice;

/**
 * OP32: Lista delle presenze di un operatore
 */
SELECT *
FROM Turno
WHERE Turno.Operatore = 'VRDLCU90D15E783S'
      AND (Turno.Data BETWEEN '2015-04-10' AND '2015-04-14');

/**
 * OP33: Lista componenti presenti
 */
SELECT
  Componente.Codice,
  Componente.Nome,
  SUM(IFNULL(Magazzino.Quantita, 0)) AS QuantitaPresente
FROM Componente
  LEFT JOIN Magazzino ON Componente.Codice = Magazzino.Componente
GROUP BY Componente.Codice
ORDER BY Componente.Nome ASC;

/**
 * OP34: Lista dei componenti più usati
 */
SELECT
  Componente.Codice,
  Componente.Nome,
  SUM(Utilizzo.Quantita)                      AS QuantitaUsata,
  COUNT(Prestazione)                          AS Prestazioni,
  SUM(Utilizzo.Quantita) / COUNT(Prestazione) AS QuantitaPrestazione
FROM Utilizzo
  JOIN Prestazione ON Prestazione.Preventivo = Utilizzo.Prestazione
  JOIN Fornitura ON Fornitura.Codice = Utilizzo.Fornitura
  JOIN Componente ON Componente.Codice = Fornitura.Componente
GROUP BY Componente
ORDER BY QuantitaUsata DESC;

/**
 * OP35: Lista dei componenti che si dovrebbero acquistare nuovamente
 */
SELECT
  Componente.Codice,
  Componente.Nome,
  Componente.QuantitaMin,
  m.QuantitaPresente,
  Componente.QuantitaMin - m.QuantitaPresente AS DaAcquistare
FROM Componente
  LEFT JOIN (SELECT
               Magazzino.Componente,
               SUM(IFNULL(Magazzino.Quantita, 0)) AS QuantitaPresente
             FROM Magazzino
             GROUP BY Magazzino.Componente
            ) AS m ON m.Componente = Componente.Codice
WHERE m.QuantitaPresente < Componente.QuantitaMin
ORDER BY Componente.Nome;

/**
 * OP36: Lista dei recapiti di un cliente
 */
SELECT
  Recapito.Recapito,
  Recapito.Tipo
FROM RubricaCliente
  JOIN Recapito ON Recapito.Codice = RubricaCliente.Recapito
WHERE RubricaCliente.Cliente = 'PRBLRI93R05I324O';

/**
 * OP37: Lista dei recapiti di un fornitore
 */
SELECT
  Recapito.Recapito,
  Recapito.Tipo
FROM RubricaFornitore
  JOIN Recapito ON Recapito.Codice = RubricaFornitore.Recapito
WHERE RubricaFornitore.Fornitore = '00523300358';

/**
 * OP38: Lista dei recapiti di un operatore
 */
SELECT
  Recapito.Recapito,
  Recapito.Tipo
FROM RubricaOperatore
  JOIN Recapito ON Recapito.Codice = RubricaOperatore.Recapito
WHERE RubricaOperatore.Operatore = 'VRDLCU90D15E783S';

/**
 * OP39: Fatture che devono essere ancora saldate
 */
SELECT
  Fattura.*,
  CASE
  WHEN DATEDIFF(DataScadenza, CURRENT_DATE()) < 0 THEN 0
  ELSE DATEDIFF(DataScadenza, CURRENT_DATE())
  END AS GiorniRimanenti,
  CASE
  WHEN DATEDIFF(CURRENT_DATE(), DataScadenza) < 0 THEN 0
  ELSE DATEDIFF(CURRENT_DATE(), DataScadenza)
  END AS GiorniRitardo
FROM Fattura
WHERE Fattura.StatoPag IS FALSE;

/**
 * OP40: Ordini che devono ancora essere consegnati
 */
SELECT
  Ordine.*,
  CASE
  WHEN DATEDIFF(CURRENT_DATE(), DATE_ADD(DataEmissione, INTERVAL TempiConsegna DAY)) < 0 THEN 0
  ELSE DATEDIFF(CURRENT_DATE(), DATE_ADD(DataEmissione, INTERVAL TempiConsegna DAY))
  END AS GiorniRitardo
FROM Ordine
  JOIN Fornitore ON Fornitore.PIVA = Ordine.Fornitore
WHERE DataConsegna IS NULL;

/**
 * OP41: Lista delle prestazioni dei lavori da eseguire
 */
SELECT
  Preventivo.*,
  DATEDIFF(CURRENT_DATE(), Preventivo.DataInizio) AS GiorniRitardo
FROM Preventivo
  LEFT JOIN Fattura ON Fattura.Prestazione = Preventivo.Codice
WHERE DATEDIFF(CURRENT_DATE(), DataInizio) >= 0
      AND Fattura.Prestazione IS NULL;

/**
 * OP42: Calcolo dello stipendio
 */
SELECT
  Operatore.CF,
  Operatore.Nome,
  Operatore.Cognome,
  CASE
  WHEN Operatore.Stipendio IS NULL THEN Ore * RetribuzioneH
  ELSE Operatore.Stipendio
  END AS StipendioMensile
FROM Operatore
  JOIN (
         SELECT
           Turno.Operatore,
           SUM(ROUND(TIME_TO_SEC(TIMEDIFF(OraFine, OraInizio)) / 3600, 1)) AS Ore
         FROM Turno
         WHERE (Turno.Data BETWEEN '2015-04-01' AND '2015-05-01')
         GROUP BY Operatore
       ) AS t ON t.Operatore = Operatore.CF;

/**
 * OP43: Scostamento tra i costi preventivati ed i costi effettivi
 */
SELECT
  Preventivo.Codice,
  Preventivo.CostoComponenti                       AS ComponentiPrevisti,
  SUM(Utilizzo.PrezzoUnitario * Utilizzo.Quantita) AS ComponentiEffettivi,
  Preventivo.Manodopera                            AS ManodoperaPrevista,
  Prestazione.Manodopera                           AS ManodoperaEffettiva,
  Preventivo.ServAggiuntivi                        AS CostiAggiuntiviPrevisti,
  Prestazione.ServAggiuntivi                       AS CostiAggiuntiviEffettivi,
  Preventivo.CostoComponenti + Preventivo.Manodopera + Preventivo.ServAggiuntivi
                                                   AS TotalePrevisto,
  SUM(Utilizzo.PrezzoUnitario * Utilizzo.Quantita) + Prestazione.Manodopera + Prestazione.ServAggiuntivi
                                                   AS TotaleEffettivo
FROM Preventivo
  JOIN Prestazione ON Preventivo.Codice = Prestazione.Preventivo
  JOIN Utilizzo ON Prestazione.Preventivo = Utilizzo.Prestazione
GROUP BY Prestazione;

/**
 * OP44: Variazioni di prezzo di un componente
 */
SELECT
  Fornitura.Componente,
  Fornitura.PrezzoUnitario AS PrezzoAcquisto,
  Ordine.DataEmissione
FROM Fornitura
  JOIN Ordine ON Ordine.Codice = Fornitura.Ordine
WHERE Componente = 2
ORDER BY DataEmissione DESC;