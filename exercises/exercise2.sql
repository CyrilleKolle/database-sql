/*
Exercises 2
*/

/*
a a) Take out (select) the one-row (unique) periodic table
*/

/*
"Elements" with the following columns: "period", "from" with the
*/

/*
lowest atomic number in the period, "to" with the highest atomic number in
*/

/*
the period, "average isotopes" with the average number of isotopes shown with
*/

/*
2 decimal places, "symbols" with a comma-separated list of all subjects in the period.
*/

select *
from Elements

select period, min(Number) as 'from', max(Number) as 'to', format(avg(Stableisotopes), '##.##') as 'avg'
from Elements
group by period

--b) För varje stad som har 2 eller fler kunder i tabellen Customers, ta ut (select) 
--följande kolumner: ”Region”, ”Country”, ”City”, samt ”Customers” som anger hur många 
--kunder som finns i staden.

select *
from company.customers

select Region, Country, City, count(*) as 'Number of customers'
from company.customers
group by Region, Country, City
having count(CompanyName) >= 2

--c) Skapa en varchar-variabel och skriv en select-sats som sätter värdet:
--”Säsong 1 sändes från april till juni 2011. Totalt sändes 10 avsnitt, 
--som i genomsnitt sågs av 2.5 miljoner människor i USA.”,följtavradbyte/char(13),
--följtav ”Säsong 2 sändes ...” osv.
--När du sedan skriver (print) variabeln till messages ska du alltså få en 
--rad för varje säsong enligt ovan, med data sammanställt från tabellen GameOfThrones.
--Tips: Ange ’sv’ som tredje parameter i format() för svenska månader.


select *
from GameOfThrones

-- declare @season as int
-- declare @episodeFrom as nvarchar(max)
-- declare @episodeTo as nvarchar(max)
-- declare @message as NVARCHAR(max)
-- declare @episodeCount as int

-- select top 1 @season = season, @episodeFrom = min(format([Original air date], 'D', 'sv-SV')), @episodeTo =max(format([Original air date], 'D', 'sv-SV')), @episodeCount = count(Episode)
-- from GameOfThrones
-- group by Season

-- set @message = concat('Säsong ' , @season,' sändes från ', ' from ',@episodeFrom, ' to ', @episodeTo, ' Totalt sändes ',  @episodeCount,' avsnitt,' )
-- print (@message)


DECLARE @Season as varchar(max);

SET @Season = '';

SELECT @Season += CONCAT('Säsong ',Season,' sändes från ',FORMAT(MIN([Original air date]), 'MMMM', 'sv'),' till ',
      FORMAT(Max([Original air date]), 'MMMM yyyy', 'sv'),'. Totalt sändes ', COUNT(*), 
      ' avsnitt som i genomsnitt sågs av ', ROUND(AVG([U.S. viewers(millions)]),1),
      ' miljoner människor i USA',CHAR(13))
FROM 
    GameOfThrones
GROUP BY
    Season
ORDER BY 
    Season

PRINT @Season;

-- DECLARE @season_info NVARCHAR(MAX) = '';

-- SELECT
--     @season_info += CONCAT(
--         'Season ', Season,
--         ' broadcasted from ', DATENAME(MONTH, MIN([Original Air Date])),
--         ' to ', DATENAME(MONTH, MAX([Original Air Date])),
--         ' of ', DATEPART(YEAR, MIN([Original Air Date])), '.',
--         ' Total of ', COUNT(Episode), ' episodes',
--         ' seen by an average of ', FORMAT(AVG([U.S. Viewers(millions)]), '#.##'), ' million people in the US.', CHAR(13))
-- FROM
--     GameOfThrones
-- GROUP BY
--     Season;

-- PRINT @season_info;

--Set language Swedish


--d) Ta ut (select) alla användare i tabellen ”Users” så du får tre 
--kolumner: ”Namn” som har fulla namnet; ”Ålder” som visar hur många år personen 
--är idag (ex. ’45 år’); ”Kön” som visar om det är en man eller kvinna. 
--Sortera raderna efter för- och efternamn.

select * from Users

select ID, substring(reverse(ID), 1,2) from Users
select concat(FirstName , ' ', LastName) as 'Namn', datediff(year, substring(ID, 1, 6), getdate() ) as 'Ålder',iif(substring(reverse(ID), 1,2) % 2 = 0, 'Kvinna', 'Man') as 'Kön' from Users order by FirstName, LastName

-- SELECT
--     FirstName + ' ' + LastName AS 'Name',
--     CAST(DATEDIFF(YEAR, LEFT(ID, 6), GETDATE()) AS NVARCHAR) + ' years old' AS 'Age',
--     CASE
--         WHEN SUBSTRING(ID, 10, 1) % 2 = 0 THEN 'Female'
--         ELSE 'Male'
--     END AS 'Gender'
-- FROM
--     Users
-- ORDER BY
--     FirstName,
--     LastName;
select cast('330720' as datetime2)

--e) Ta ut en lista över regioner i tabellen ”Countries” där det för varje region 
--framgår regionens namn, antal länder i regionen, totalt antal invånare, total area, 
--befolkningstätheten med 2 decimaler, samt spädbarnsdödligheten per 100.000 födslar 
--avrundat till heltal.

select * from Countries

select 
Region, 
count(country) as 'Country count', 
sum(convert(numeric,Population)) as 'Total Pop', 
sum(convert(numeric, [Area (sq# mi#)])) as 'Total area',
 format(avg(convert(float, replace([Pop# Density (per sq# mi#)], ',','.'))), '#####.##') as 'Average pop desity',
convert(int,avg(convert(float, replace([Infant mortality (per 1000 births)], ',','.'))) / 100)  as 'Aveage IMDR (per 100 000 births)' 
from 
Countries 
group by 
Region

-- select 
-- Region, 
-- count(country) as 'Country count', 
-- sum(convert(numeric,Population)) as 'Total Pop', 
-- sum(convert(numeric, [Area (sq# mi#)])) as 'Total area',
--  format(avg(convert(float, replace([Pop# Density (per sq# mi#)], ',','.'))), '#####.##') as 'Average pop desity',
-- convert(int,avg(convert(float, replace([Infant mortality (per 1000 births)], ',','.'))) / 100)  as 'Aveage IMDR (per 100 000 births)' 
-- from 
-- Countries 
-- group by 
-- Region

-- SELECT
--     Region,
--     COUNT(Country) AS 'Countries',
--     SUM(CAST([Population] AS BIGINT)) AS 'Population',
--     SUM([Area (sq# mi#)]) AS 'Area (square miles)',
--     FORMAT(SUM(CAST([Population] AS FLOAT)) / SUM([Area (sq# mi#)]), '#.##') AS 'Population Density (per square mile)',
--     ROUND(AVG(CAST(REPLACE([Infant mortality (per 1000 births)], ',', '.') AS FLOAT)) * 100, 0) AS 'Infant Mortality (per 100.000)'
-- FROM
--     Countries
-- GROUP BY
--     Region;


-- f) Från tabellen ”Airports”, gruppera per land och ta ut kolumner som visar: land, antal flygplatser (IATA-koder), 
-- antal som saknar ICAO-kod, samt hur många procent av flygplatserna i varje land som saknar ICAO-kod.

select * from Airports

select * into Air2 from Airports

select trim('' from ' Canada') -- remove a no breaking space nb&p
select trim(char(160) from ' Canada') --if the trim function cant get the right space then we check the ascii code of the space
select trim(concat(char(160), char(32)) from ' Canada')
select ascii(' ') --get the right ascii code for the space type

ALTER TABLE Air2 ADD Country nvarchar(max);
select * from Air2
--select trim(',' from reverse(substring(reverse([Location served]), 1, PATINDEX('%,%', reverse([Location served]))))) from Air2
UPDATE Air2 SET Country =reverse(substring(reverse([Location served]), 1, PATINDEX('%,%', reverse([Location served]))));


select country, count(IATA) from Air2 group by country