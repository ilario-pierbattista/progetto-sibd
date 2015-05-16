/**
 * OP25: Data di ultimo collaudo per un'autovettura
 */
SELECT UltimoCollaudo FROM Autovettura WHERE Targa = 'BX692TE';

/**
 * OP26: Data di ultima revisione per un'autovettura
 */
SELECT UltimaRevisione FROM Autovettura WHERE Targa = 'BX692TE';

/**
 * OP27: Consultazione dei dati per stilare una ricevuta fiscale
 * o una fattura
 */
SELECT * FROM FatturaView
WHERE Prestazione = 1;