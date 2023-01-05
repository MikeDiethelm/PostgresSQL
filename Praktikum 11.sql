
-- 1. Finden Sie alle verschiedenen Teilefarben/Teilestädte-Kombinationen.
-- (Mit “alle“ ist gemeint “alle, die zur Zeit in der DB gespeichert sind“, und nicht alle überhaupt möglichen.)
SELECT DISTINCT Farbe, Stadt FROM T;

-- 2. Finden Sie alle Lieferantennummern/Teilenummern/Projektnummern-Kombinationen, bei denen Lieferant,
-- Teil und Projekt alle aus derselben Stadt kommen.
SELECT LNr, TNr, PNr FROM (L JOIN T ON L.Stadt = T.Stadt) JOIN P ON T.Stadt = P.Stadt;


-- 3. Finden Sie die Teilenummern von allen Teilen, welche von einem Lieferanten aus Winterthur für
-- ein Projekt in Winterthur geliefert werden.
SELECT DISTINCT TNr FROM LTP, L, P
WHERE LTP.LNr = L.LNr AND LTP.PNr = P.PNr AND P.Stadt = 'Winterthur' AND L.Stadt = 'Winterthur';

-- 4. Definieren Sie eine Sicht mit Namen BStadtTeile, die alle Angaben über alle Teile liefert die aus einer Stadt
-- stammen deren Namen mit ‚B‘ beginnt. Fragen Sie die Sicht ab nach blauen Teilen (nur die Attribute TName und Gewicht).
DROP VIEW IF EXISTS BStadtTeile;
CREATE VIEW BStadtTeile AS
SELECT * FROM T
WHERE Stadt LIKE 'B%';
SELECT TName,Gewicht FROM BStadtTeile WHERE Farbe = 'Blau';

-- 5. Finden Sie die Lieferantennummern aller Lieferanten, die ein Teil liefern das aus einer Stadt stammt,
-- deren Namen mit ‚B‘ beginnt (verwenden Sie obige Sicht).
SELECT DISTINCT LNr
FROM LTP JOIN BStadtTeile
ON LTP.TNr = BStadtTeile.TNr;

-- 6. Finden Sie die Projektnummern aller Projekte, die mit dem Teil mit der Nummer T1 beliefert werden in
-- einer durchschnittlichen Menge, welche grösser ist als die grösste Menge eines Teiles, das an das Projekt
-- mit der Nummer P1 geliefert wird.
SELECT PNr FROM Ltp WHERE TNr = 'T1'
GROUP BY PNr
HAVING AVG(Menge) > (SELECT MAX(Menge) FROM Ltp WHERE PNr = 'P1');

-- 7. Finden Sie die Teilenummern aller Teile, welche an alle Projekte in Winterthur geliefert werden.
SELECT Distinct TNr FROM LTP,P WHERE LTP.pnr = P.pnr AND stadt='Winterthur';
SELECT Distinct TNr FROM LTP JOIN P ON LTP.pnr = P.pnr AND stadt='Winterthur';

-- 8. Finden Sie die Lieferantennummern aller Lieferanten mit Status kleiner als der Status von Sulzer.
SELECT DISTINCT LNr FROM L WHERE L.status < (SELECT status FROM L WHERE lname='Sulzer');

-- 9. Finden Sie alle Paare von verschiedenen Teilenummern, bei denen es einen Lieferanten gibt,
-- welcher beide Teile liefert.


-- 10. Finden Sie die Anzahl Projekte, zu denen der Lieferant mit dem Namen “Sulzer“ beiträgt.