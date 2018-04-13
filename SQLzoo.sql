# Show the name for the countries that have a population of at least 200 million.

SELECT name FROM world
WHERE population >= 200000000


# Give the name and the per capita GDP for those countries with 
# a population of at least 200 million.

SELECT name, gdp / population as GDP_per_capita
FROM world
WHERE population >= 200000000;


# Show the name and population in millions for the countries 
# of the continent 'South America'.

SELECT name, population / 1000000 as Population_millions
FROM world
WHERE continent = 'South America';


# Show the name and population for France, Germany, Italy

SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');


# Show the countries which have a name that includes the word 'United'

SELECT name
FROM world
WHERE name LIKE ('%United%');


# Show the countries that are big by area or big by population. 
# Show name, population and area.

SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 250000000


# Show the countries that are big by area or big by population but not both. 
# Show name, population and area.

SELECT name, population, area
FROM world
WHERE area > 3000000 XOR population > 250000000


# For South America show population in millions and GDP in billions 
# both to 2 decimal places.

SELECT name, ROUND(population / 1000000, 2), ROUND(gdp / 1000000000, 2)
FROM world
WHERE continent = 'South America';


# Show per-capita GDP for the trillion dollar countries to the nearest $1000.

SELECT name, ROUND(gdp / population, -3)
FROM world
WHERE gdp >= '1000000000000'; 


# Show the name and capital where the name and the capital have 
# the same number of characters.

SELECT name,capital
FROM world
WHERE LENGTH(name) = LENGTH(capital);


# Show the name and the capital where the first letters of each match. 
# Don't include countries where the name and the capital are the same word.

SELECT name , capital
FROM world
WHERE LEFT(name,1) = LEFT(capital,1) AND name != capital


# Find the country that has all the vowels and no spaces in its name.

SELECT name
FROM world
WHERE 
  name LIKE '%a%' AND
  name LIKE '%e%' AND
  name LIKE '%i%' AND
  name LIKE '%o%' AND
  name LIKE '%u%' AND
  name NOT LIKE '% %';
# The answer is Mozambique if you are curious.


# List each country name where the population is larger than that of 'Russia'.

SELECT name 
FROM world
WHERE population > (SELECT population 
                    FROM world
                    WHERE name='Russia');


# Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

SELECT name 
FROM world
WHERE continent = 'Europe' AND gdp / population > 
                  (SELECT gdp / population FROM world 
                   WHERE name = 'United Kingdom');


# List the name and continent of countries in the continents 
# containing either Argentina or Australia.
# Order by name of the country.

SELECT name, continent
FROM world
WHERE continent IN (SELECT continent FROM world 
                    WHERE name = 'Argentina' OR name = 'Australia') 
ORDER BY name


# Which country has a population that is more than Canada but less than Poland? 
# Show the name and the population.

SELECT name, population
FROM world
WHERE population > (SELECT population FROM world 
                    WHERE name = 'Canada') 
AND   population < (SELECT population FROM world 
                    WHERE name = 'Poland');


# Show the name and the population of each country in Europe. 
# Show the population as a percentage of the population of Germany.

SELECT name, CONCAT(ROUND(population * 100 / (SELECT population FROM world 
                                              WHERE name = 'Germany')), '%')
FROM world
WHERE continent = 'Europe';


# Which countries have a GDP greater than every country in Europe? 
# [Give the name only.] (Some countries may have NULL gdp values)

SELECT name
FROM world
WHERE gdp > (SELECT MAX(gdp) FROM world WHERE continent = 'Europe');


# Find the largest country (by area) in each continent, show the continent, 
# the name and the area:

SELECT continent, name, area FROM world x
WHERE area >= ALL (SELECT area FROM world y
                   WHERE y.continent=x.continent)


# List each continent and the name of the country that comes first alphabetically.

SELECT continent, name
FROM world as X
WHERE name = (SELECT name 
              FROM world as Y 
              WHERE Y.continent = X.continent 
              ORDER BY name ASC LIMIT 1);


# Find the continents where all countries have a population <= 25000000. 
# Then find the names of the countries associated with these continents.
# Show name, continent and population.

SELECT name,continent,population
FROM world as Y
WHERE (SELECT COUNT(name) 
       FROM world as X
       WHERE population <= 25000000 AND
       X.continent = Y.continent) = (SELECT COUNT(name) 
       FROM world as Z
       WHERE Z.continent = Y.continent)


# Some countries have populations more than three times that of any 
# of their neighbours (in the same continent). 
# Give the countries and continents.

SELECT name, continent
FROM world as Y
WHERE Y.population >= ALL (SELECT population * 3 FROM world as X 
                           WHERE X.continent = Y.continent AND X.name != Y.name)


# Show the total population of the world.

SELECT SUM(population)
FROM world


# List all the continents - just once each.

SELECT DISTINCT continent
FROM world;


# Give the total GDP of Africa

SELECT SUM(gdp)
FROM world
WHERE continent = 'Africa';


# How many countries have an area of at least 1000000

SELECT COUNT(name)
FROM world
WHERE area >= 1000000;


# What is the total population of ('Estonia', 'Latvia', 'Lithuania')

SELECT SUM(population)
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania');


# For each continent show the continent and number of countries.

SELECT continent, COUNT(name)
FROM world
GROUP BY continent


# For each continent show the continent and number of countries 
# with populations of at least 10 million.

SELECT continent, COUNT(name)
FROM world
WHERE population >= 10000000
GROUP BY continent


# List the continents that have a total population of at least 100 million.

SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population)>100000000


# Change the query shown so that it displays Nobel prizes for 1950.

SELECT yr, subject, winner
FROM nobel
WHERE yr = 1950


# Show who won the 1962 prize for Literature.

SELECT winner
FROM nobel
WHERE yr = 1962
AND   subject = 'Literature'


# Show the year and subject that won 'Albert Einstein' his prize.

SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein';


# Give the name of the 'Peace' winners since the year 2000, including 2000.

SELECT winner
FROM nobel
WHERE subject = 'Peace' AND
      yr >= 2000;


# Show all details (yr, subject, winner) of the Literature prize winners 
# for 1980 to 1989 inclusive.

SELECT *
FROM nobel
WHERE yr BETWEEN 1980 AND 1989 AND
      subject = 'Literature';


# Show all details of the presidential winners:
# Theodore Roosevelt
# Woodrow Wilson
# Jimmy Carter
# Barack Obama

SELECT * FROM nobel
WHERE winner IN ('Theodore Roosevelt',
                  'Woodrow Wilson',
                  'Jimmy Carter',
                  'Barack Obama')


# Show the winners with first name John

SELECT winner
FROM nobel
WHERE winner LIKE 'John%';


# Show the year, subject, and name of Physics winners for 1980 together 
# with the Chemistry winners for 1984.

SELECT *
FROM nobel
WHERE (subject = 'Physics' AND yr = 1980) OR
      (subject = 'Chemistry' AND yr = 1984);


# Show the year, subject, and name of winners for 1980 excluding Chemistry and Medicine

SELECT *
FROM nobel
WHERE yr = 1980 AND 
      (subject != 'Chemistry' AND subject != 'Medicine');


# Show year, subject, and name of people who won a 'Medicine' prize in an early year 
# (before 1910, not including 1910) together with winners of a 'Literature' prize 
# in a later year (after 2004, including 2004)

SELECT *
FROM nobel
WHERE (subject = 'Medicine' AND yr < 1910) OR
      (subject = 'Literature' AND yr >= 2004);


# Find all details of the prize won by PETER GRÜNBERG

SELECT *
FROM nobel
WHERE winner = 'PETER GRÜNBERG'


# Find all details of the prize won by EUGENE O'NEILL

SELECT *
FROM nobel
WHERE winner = 'EUGENE O\'NEILL'


# List the winners, year and subject where the winner starts with Sir. 
# Show the the most recent first, then by name order.

SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner;


# Show the 1984 winners and subject ordered by subject and winner name; 
# but list Chemistry and Physics last.

SELECT winner, subject
FROM nobel
WHERE yr = 1984
ORDER BY subject IN('Chemistry', 'Physics'), subject, winner;