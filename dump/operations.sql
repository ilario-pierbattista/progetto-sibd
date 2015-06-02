/**
 * OP25: Data di ultimo collaudo per un'autovettura
 */
SELECT UltimoCollaudo
FROM Autovettura
WHERE Targa = 'BX692TE';

/**
 * OP26: Data di ultima revisione per un'autovettura
 */
SELECT UltimaRevisione
FROM Autovettura
WHERE Targa = 'BX692TE';

/**
 * OP27: Consultazione dei dati per stilare una ricevuta fiscale
 * o una fattura
 */
SELECT *
FROM FatturaView
WHERE Prestazione = 1;

/**
 * OP43: Scostamento tra i costi preventivati ed i costi effettivi
 */
SELECT sum(Utilizzo.PrezzoUnitario * Utilizzo.Quantita)
FROM Prestazione
LEFT JOIN Utilizzo ON Prestazione.Preventivo = Utilizzo.Prestazione
GROUP BY Utilizzo.Prestazione;

SELECT *
FROM Prestazione;