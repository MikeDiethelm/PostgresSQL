-- 1) Finden Sie die Teilenummern von allen Teilen, welche von einem Lieferanten aus derselben
-- Stadt geliefert werden, wie das Projekt, für welches das Teil geliefert wird.
--(Praktikum 11 Aufgabe 3 anschauen)
SELECT DISTINCT LTP.TNr FROM LTP, L, P
    WHERE LTP.LNr = L.LNr
      AND LTP.PNr = P.PNr
      AND L.stadt = P.stadt;


-- 2) Finden Sie die Gesamtmenge von Teil ‚T1‘, die Sulzer (für irgendein Projekt) liefert.
SELECT SUM(Menge) FROM LTP JOIN L ON LTP.lnr=L.lnr WHERE L.lname ='Sulzer';
SELECT SUM(Menge) FROM LTP, L WHERE LTP.lnr=L.lnr AND L.lname ='Sulzer';
SELECT SUM(Menge) FROM LTP NATURAL JOIN L WHERE L.lname ='Sulzer';

-- 3) Finden Sie die Teilenummern aller Teile, welche an mindestens ein Projekt mit durchschnittli-
-- cher Menge grösser als 350 geliefert werden.
-- Was macht GROUP BY anders wenn nur TNr übergeben wird???
SELECT DISTINCT TNr FROM LTP GROUP BY TNr,PNr HAVING AVG(Menge) > 350;

-- 4) Finden Sie die Projektnamen aller Projekte, die durch Sulzer beliefert werden.
SELECT DISTINCT y.PName FROM LTP AS x, P AS y, L AS z
    WHERE x.lnr=z.lnr
    AND x.pnr=y.pnr
    AND z.lname = 'Sulzer';

-- 5) Finden Sie die Farben aller Teile, die durch Sulzer geliefert werden.
SELECT DISTINCT x.Farbe FROM T AS x, LTP AS y, L AS z
    WHERE y.tnr = x.tnr
    AND y.lnr = z.lnr
    AND z.lname = 'Sulzer';

-- 6) Finden Sie die Teilenummern aller Teile, welche an irgendein Projekt in Winterthur geliefert
-- werden.
SELECT DISTINCT y.TNr FROM  LTP AS y, P AS z
WHERE y.pnr=z.pnr
AND z.stadt='Winterthur';

-- 7) Finden Sie die Projektnummern aller Projekte, welche mindestens ein Teil geliefert bekom-
-- men, das auch von Sulzer (irgendwohin) geliefert wird.
SELECT DISTINCT PNr FROM LTP
WHERE TNr IN(
    SELECT TNr FROM LTP,L
        WHERE LTP.lnr = L.lnr AND L.lname='Sulzer'
    );

SELECT DISTINCT x.PNr FROM LTP AS x, LTP AS y, L AS z
    WHERE x.tnr = y.tnr
      AND y.lnr=z.lnr
      AND z.lname='Sulzer';

-- 8) Finden Sie alle Lieferanten/Teile-Paare, bei denen der Lieferant das Teil nicht liefert.
(SELECT LNr, TNr FROM L, T)     -- Alle Paare von Teilen die es gibt
EXCEPT                          -- Ohne
(SELECT LNr, TNr FROM LTP);     -- Alle Paare von Teilen, die der Lieferant liefern kann

-- 9) Finden Sie die Lieferantennummern aller Lieferanten, welche das Teil mit der Nummer ‚T1‘ in
-- einer Menge liefern, die grösser ist als die durchschnittliche Menge von Teilen ‚T1‘, welche an
-- dasselbe Projekt geliefert werden.
SELECT x.LNr FROM LTP AS x, P AS y WHERE x.pnr=y.pnr AND x.TNr ='T1' AND x.Menge > (
      SELECT AVG(y.Menge)
      FROM LTP AS y
      WHERE  x.PNr = y.PNr AND y.TNr ='T1');

SELECT DISTINCT x.LNr FROM LTP AS x, P AS y WHERE x.TNr ='T1' AND x.Menge > (
      SELECT AVG(y.Menge)
      FROM LTP AS y
      WHERE  x.PNr = y.PNr AND y.TNr ='T1');


-- 10) Finden Sie alle Städte, in denen sich mindestens ein Lieferant, ein Teil oder ein Projekt befindet
SELECT Stadt FROM L
    UNION
    SELECT Stadt FROM T
    UNION
    SELECT Stadt FROM P;