-- Praktikum 10
-- 1) Wie hoch ist der durchschnittliche Lagerbestand aller Biere (der Wert soll den Namen Durchschnittslagerbestand erhalten)?
SELECT AVG(AnLager) AS Durchschnittslagerbestand FROM Sortiment;


-- 2) Welche Besucher (Name,Vorname, Strasse) wohnen an einer Strasse, deren Bezeichnung das Wort ‚bach‘ enthält?
-- Untersuchen Sie auch die Resultate, die Sie mit ,Bach‘, ‚BACH‘ etc. erhalten. Sehen Sie hier allenfalls ein Problem?
SELECT name,vorname,strasse FROM besucher WHERE LOWER(Strasse) LIKE '%bach%' OR Strasse LIKE '%Bach%';

-- 3) An welchen Strassen gibt es mindestens drei Restaurants (GROUP BY verwenden)?
SELECT Strasse FROM restaurant
GROUP BY Strasse  having count(Strasse)>=3;

-- 4) Bilden Sie das Kreuzprodukt der Tabellen Restaurant und Besucher (mit und ohne CROSS JOIN).
-- Wieviele Tupel enthält das Resultat? Warum? Wozu könnte eine solche Abfrage nützlich sein?
SELECT * FROM restaurant CROSS JOIN besucher;
SELECT * FROM restaurant, besucher; -- Automatischer cross Join

-- 5) Gesucht ist eine Liste von Besuchern mit Name, Vorname und der Anzahl Restaurantbesuche pro Woche (= Frequenz).
-- Falls ein Besucher nie Gast ist, soll er auf der Liste mit einer Anzahl Besuche von 0 erscheinen.
-- Verwenden Sie dazu einen OUTER JOIN. Optional: Lösung ohne JOIN.
SELECT Name,Vorname,SUM(COALESCE(Frequenz,0)) AS AnzahlBesuche FROM Besucher AS b
LEFT OUTER JOIN Gast AS g
ON b.Name = g.Bname AND b.Vorname = g.Bvorname
    GROUP BY b.Name,b.Vorname
    ORDER BY AnzahlBesuche DESC;


-- 6) Gesucht ist eine Liste der Hersteller von Biersorten zusammen mit der Anzahl Biersorten, die
-- sie produzieren und der Anzahl verschiedener dabei verwendeter Grundstoffe.
SELECT hersteller,count(*) AS AnzahlBiere,count(distinct grundstoff) AS AnzahlGrundstoffe from biersorte
group by  hersteller;

-- 7) Welche Biersorten sind von allen mit derselben Note bewertet worden (Hinweis: das bedeutet,
-- dass kleinste Note = grösste Note)?
SELECT Bsorte
FROM Lieblingsbier
GROUP BY Bsorte
HAVING MIN(Bewertung) = MAX(Bewertung);

-- 8) Gesucht ist eine Liste von Restaurants mit ihrem Namen, ihrem Suppenpreis, sowie dem durch-
-- schnittlichen Suppenpreis aller Restaurants derselben Strasse.
SELECT Name,Suppenpreis, AVG(Suppenpreis) AS DurchschnittSuppenpreis FROM restaurant
WHERE

-- 9) Gesucht ist eine Liste von Restaurants und Biersorten, von denen sie am meisten an Lager
-- haben.


-- 10) Gesucht sind die Strassen, an denen es mehr Restaurants gibt als Besucher.


-- 11) Gesucht ist eine Liste der Strassen von Besuchern, deren Vornamen den Buchstaben “p“ ent-
-- hält und die in Restaurants verkehren mit einem Suppenpreis zwischen 3 und 5


-- 12) Gesucht ist die Anzahl verschiedener Besucher des Restaurant Löwen.