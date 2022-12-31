-- Praktikum 9
-- 1) Geben Sie die Namen und Vornamen aller Besucher an, die an der Dorfstrasse wohnen.
SELECT Name, Vorname
FROM Besucher
WHERE Strasse = 'Dorfstrasse';

-- 2) Geben Sie die Namen aller Personen an, deren Lieblingsbier ‚Malzdrink‘ ist und die dieses bes-
-- ser als mit 3 bewerten.
SELECT BName
FROM Lieblingsbier
WHERE Bewertung > 3
  AND Bsorte = 'Malzdrink';

-- 3) Sortieren Sie das Ergebnis aus Aufgabe 1) absteigend nach Name und Vorname.
SELECT Name, Vorname
FROM Besucher
WHERE Strasse = 'Dorfstrasse'
ORDER BY Name, Vorname DESC;

-- 4) Geben Sie den Suppenpreis und den Restaurantnamen aller Restaurants an, die Biere mit dem
-- Grundstoff ‚Hopfen‘ anbieten.
SELECT Distinct r.name, r.suppenpreis
FROM Restaurant r
         Join sortiment s ON r.name = s.Rname
         Join biersorte b ON s.bsorte = b.name
WHERE b.grundstoff = 'Hopfen';

-- 5) Geben Sie Namen und Geburtstag aller Gäste an, die ein Restaurant mit Eröffnungsdatum vor
-- dem Jahr 2010 besuchen.
SELECT Distinct b.Name, b.Gebtag FROM Besucher b
JOIN Gast g ON  b.Name = g.Bname AND b.Vorname = g.Bvorname
JOIN Restaurant r ON g.Rname = r.Name
WHERE r.Eroeffnungsdatum < '2010-01-01';



-- 6) Formulieren Sie den Ausdruck:
-- 𝜋𝑁𝑎𝑚𝑒,𝑉𝑜𝑟𝑛𝑎𝑚𝑒(𝐵𝑒𝑠𝑢𝑐h𝑒𝑟) \ (𝜋𝐵𝑛𝑎𝑚𝑒,𝐵𝑣𝑜𝑟𝑛𝑎𝑚𝑒(𝐺𝑎𝑠𝑡) ⊔ 𝜋𝐵𝑛𝑎𝑚𝑒,𝐵𝑣𝑜𝑟𝑛𝑎𝑚𝑒(𝐿𝑖𝑒𝑏𝑙𝑖𝑛𝑔𝑠𝑏𝑖𝑒𝑟))
-- in SQL. Hier identifizieren wir Name mit Bname, etc.; es soll angenommen werden, dass das
-- Datenbanksystem EXCEPT nicht kennt. Formulieren Sie den Ausdruck auch in Prosa.
SELECT DISTINCT b.Name, b.Vorname
FROM Besucher b
WHERE NOT EXISTS(SELECT * FROM Gast g WHERE b.Name = g.Bname AND b.Vorname = g.Bvorname)
  AND NOT EXISTS(SELECT * FROM Lieblingsbier l WHERE b.Name = l.Bname AND b.Vorname = l.Bvorname);


-- 7) Gesucht sind Name, Vorname und Strasse der Besucher, die kein Restaurant an ihrer
--  Wohnstrasse besuchen.
SELECT Distinct b.Name, b.Vorname, b.Strasse FROM Besucher b
WHERE NOT EXISTS(
    SELECT 1 FROM Gast g, Restaurant r WHERE b.name=g.bname AND b.vorname=g.bvorname
                                         AND g.rname=r.name AND b.strasse=r.strasse);

-- 8) Gesucht sind Namen und Vornamen von Besuchern, die das Glück haben, dass es ein Restau-
-- rant gibt, welches eines ihrer Lieblingsbiere im Sortiment hat.
-- ToDo

-- 9) Gesucht sind die Lieblingsbiersorten derjenigen Gäste des Restaurant ‚Löwen‘, deren Vorname
-- mit ‚P‘ beginnt. (Algebraischer Ausdruck und SQL)
-- ToDo

-- 10) An welchen Strassen gibt es mindestens drei Restaurants? (ohne Gruppierung zu lösen)
-- ToDo




