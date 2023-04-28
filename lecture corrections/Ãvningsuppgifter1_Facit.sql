-- Ta ut data (select) från tabellen GameOfThrones på sådant sätt att ni får ut
-- en kolumn ’Title’ med titeln samt en kolumn ’Episode’ som visar episoder
-- och säsonger i formatet ”S01E01”, ”S01E02”, osv.
-- Tips: kolla upp funktionen format() 

select * from GameOfThrones;

select
	Title,
	'S' + format(Season, '00') + 'E' + format(EpisodeInSeason, '00') as 'Episodes',
--	'S' + str(Season, 2) + 'E' + str(EpisodeInSeason, 2) as 'Episodes',
	 concat('S', right('00' + cast(season as varchar), 2), 'E', right('00' + cast(EpisodeInSeason as varchar), 2)) as Episode
--	'5' + Season + '15' + EpisodeInSeason as 'Episodes',
--	concat('5', Season, '15', EpisodeInSeason) as 'Episodes'

from
	GameOfThrones

--select format(123.456, '0000.00'), format(123.456, '000000.##')

-- Uppdatera (kopia på) tabellen user och sätt username för alla användare så
-- den blir de 2 första bokstäverna i förnamnet, och de 2 första i efternamnet
-- (istället för 3+3 som det är i orginalet). Hela användarnamnet ska vara i små
-- bokstäver. 

--select * into users2 from users

select
	firstname,
	lastname,
	translate(lower(concat(left(FirstName, 2), left(LastName, 2))),'åäö', 'aao'),
	LOWER(CONCAT(SUBSTRING(FirstName, 1, 2), SUBSTRING(LastName, 1, 2))),
	lower(left(Firstname,2) + left(LastName,2))
from 
	users2

--UPDATE users2
--SET UserName = translate(lower(concat(left(FirstName, 2), left(LastName, 2))),'åäö', 'aao');

-- Uppdatera (kopia på) tabellen airports så att alla null-värden i kolumnerna
-- Time och DST byts ut mot ’-’ 

select
	*
from 
	Airports

update ny_airports set [Time] = '-' where [Time] is null; 
update ny_airports set dst = '-' where DST is null;

update
    Airports2
set
    Time = isnull(Time,'-' ), -- using is null function
    DST = isnull(DST, '-')
from
    Airports2;


-- Ta bort de rader från (kopia på) tabellen Elements där ”Name” är någon av
-- följande: 'Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium', samt alla
-- rader där ”Name” börjar på någon av bokstäverna d, k, m, o, eller u. 

select 
	Name
from 
	Elements
WHERE 
	[Name] IN ('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium') OR [Name] LIKE '[dkmou]%'
order by
	Name

DELETE FROM Uppgift1_elements WHERE [Name] IN ('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium') OR [Name] LIKE '[dkmou]%';

-- Skapa en ny tabell med alla rader från tabellen Elements. Den nya tabellen
-- ska innehålla ”Symbol” och ”Name” från orginalet, samt en tredje kolumn
-- med värdet ’Yes’ för de rader där ”Name” börjar med bokstäverna i
-- ”Symbol”, och ’No’ för de rader där de inte gör det.
-- Ex: ’He’ -> ’Helium’ -> ’Yes’, ’Mg’ -> ’Magnesium’ -> ’No’. 

select
	Symbol,
	Name,
	case
        when Symbol = left(Name, len(symbol)) then 'Yes'
        else 'No'
    end as 'Yes/No'
into 
	newElements
from 
	Elements

select * from newElements

-- Kopiera tabellen Colors till Colors2, men skippa kolumnen ”Code”. Gör
-- sedan en select från Colors2 som ger samma resultat som du skulle fått från
-- select * from Colors; (Dvs, återskapa den saknade kolumnen från RGBvärdena i resultatet). 

select * from Colors

DECLARE @hex_table varchar(16) = '0123456789abcdef';

SELECT [Name], 
	Code,
	concat('#',format(Red, 'X2'), format(Green, 'X2'), format(Blue, 'X2')) AS 'Code2', 
	format(red * 256 * 256 + blue * 256 + green, 'X6') as 'Code3',
	'#' + UPPER(SUBSTRING(@hex_table, (Red / 16) + 1, 1) + SUBSTRING(@hex_table, (Red % 16) + 1, 1) +
       SUBSTRING(@hex_table, (Green / 16) + 1, 1) + SUBSTRING(@hex_table, (Green % 16) + 1, 1) +
       SUBSTRING(@hex_table, (Blue / 16) + 1, 1) + SUBSTRING(@hex_table, (Blue % 16) + 1, 1)) as 'Calculated code', 
	   Red, Green, Blue 
FROM Colors;

-- Kopiera kolumnerna ”Integer” och ”String” från tabellen ”Types” till en ny
-- tabell. Gör sedan en select från den nya tabellen som ger samma resultat
-- som du skulle fått från select * from types; 
select 
	integer / 100.0 as 'newInteger',
	CAST(DATEADD(DAY, [Integer] - 1, DATEADD(MINUTE, [Integer], '2019-01-01 09:00:00')) AS DATETIME2) AS 'newDateTime',
	integer % 2 as 'newBool',
	*
from Types

select DATEADD(Day, -5, '2019-01-01 09:00:00')
