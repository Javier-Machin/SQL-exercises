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


# Modify it to show the matchid and player name for all goals scored by Germany.

SELECT matchid, player FROM goal 
WHERE teamid = 'GER'


# Show id, stadium, team1, team2 for just game 1012

SELECT id,stadium,team1,team2
FROM game
WHERE id = 1012;


# Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT player,teamid,stadium,mdate
FROM game JOIN goal ON (id = matchid)
WHERE teamid = 'GER';


# Show the team1, team2 and player for every goal scored by a player called Mario 

SELECT team1, team2, player
FROM game JOIN goal ON (id = matchid)
WHERE player LIKE 'Mario%';


# Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT player, teamid, coach, gtime
FROM goal JOIN eteam on teamid=id
WHERE gtime<=10;


# List the the dates of the matches and the name of the team in which 
#'Fernando Santos' was the team1 coach.

SELECT mdate, teamname
FROM game JOIN eteam ON team1=eteam.id
WHERE coach = 'Fernando Santos';


# List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT player
FROM goal JOIN game ON matchid = id
WHERE stadium = 'National Stadium, Warsaw'


# Show the name of all players who scored a goal against Germany.

SELECT DISTINCT player
FROM game JOIN goal ON matchid = id 
WHERE (team1='GER' OR team2='GER') 
AND goal.teamid != 'GER';


# Show teamname and the total number of goals scored.

SELECT teamname, COUNT(player)
FROM eteam JOIN goal ON id=teamid
GROUP BY teamname;


# Show the stadium and the number of goals scored in each stadium.

SELECT stadium, COUNT(player)
FROM game JOIN goal ON matchid = id
GROUP by stadium 


# For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT matchid, mdate, COUNT(teamid)
FROM game JOIN goal ON id = matchid 
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP by matchid, mdate


# For every match where 'GER' scored, show matchid, match date and the 
# number of goals scored by 'GER'

SELECT matchid, mdate, COUNT(matchid)
FROM game JOIN goal ON id = matchid 
WHERE (teamid='GER')
GROUP by matchid, mdate


# List every match with the goals scored by each team as shown.

SELECT mdate,team1, SUM(score1) as score1,team2,SUM(score2) as score2 
FROM (SELECT mdate,team1, matchid, id,
      CASE WHEN teamid=team1 THEN 1 ELSE 0 END score1,
      team2,
      CASE WHEN teamid=team2 THEN 1 ELSE 0 END score2
      FROM game LEFT JOIN goal ON matchid = id) as lul
GROUP BY id
ORDER BY mdate, team1, team2


# List the films where the yr is 1962 [Show id, title]

SELECT id, title
FROM movie
WHERE yr=1962


# Give year of 'Citizen Kane'.

SELECT yr
FROM movie
WHERE title = 'Citizen Kane'


# List all of the Star Trek movies, include the id, title and yr 
# (all of these movies include the words Star Trek in the title). Order results by year.

SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'


# What id number does the actor 'Glenn Close' have?

SELECT id
FROM actor
WHERE name = 'Glenn Close';


# What is the id of the film 'Casablanca'

SELECT id
FROM movie
WHERE title = 'Casablanca';


# Obtain the cast list for 'Casablanca'.
# Use movieid=11768, (or whatever value you got from the previous question)

SELECT name
FROM actor
JOIN casting ON id = actorid
WHERE movieid=11768;


# Obtain the cast list for the film 'Alien'

SELECT name
FROM actor
JOIN casting ON id = actorid
WHERE movieid = 
  (SELECT id 
   FROM movie
   WHERE title = 'Alien');


# List the films in which 'Harrison Ford' has appeared

SELECT title
FROM movie
WHERE id IN 
  (SELECT movieid
   FROM casting
   WHERE actorid = 
     (SELECT id
      FROM actor
      WHERE name = 'Harrison Ford'));


# List the films where 'Harrison Ford' has appeared - but not in the starring role.

SELECT title
FROM movie
WHERE id IN 
  (SELECT movieid
   FROM casting
   WHERE actorid = 
     (SELECT id
      FROM actor
      WHERE name = 'Harrison Ford')
   AND ord != 1);


# List the films together with the leading star for all 1962 films.

SELECT title, name
FROM movie
JOIN
  (SELECT name, movieid
   FROM actor
   JOIN casting ON id = actorid
   WHERE movieid IN 
     (SELECT id
      FROM movie
      WHERE yr = 1962)
      AND ord = 1) as actors ON id = actors.movieid;


# Which were the busiest years for 'John Travolta', show the year and the number 
# of movies he made each year for any year in which he made more than 2 movies.

SELECT yr,COUNT(title) FROM movie 
JOIN casting ON movie.id = movieid
JOIN actor   ON actorid  = actor.id
WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
  (SELECT yr,COUNT(title) AS c FROM movie 
    JOIN casting ON movie.id=movieid
    JOIN actor   ON actorid=actor.id
    WHERE name='John Travolta'
    GROUP BY yr) AS t);


# List the film title and the leading actor for all of the films 'Julie Andrews' played in.

SELECT title, name
FROM movie
JOIN casting ON movie.id = movieid AND ord=1
JOIN actor on actor.id = actorid 
WHERE movie.id IN (SELECT movieid FROM casting
                   WHERE actorid IN (
                   SELECT id FROM actor
                   WHERE name='Julie Andrews')); 


# Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.

SELECT name
FROM actor
JOIN casting ON id = actorid AND ord = 1
GROUP BY name
HAVING COUNT(name) >= 30


# List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

SELECT title, COUNT(actorid)  
FROM movie
JOIN casting on id = movieid
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title;


# List all the people who have worked with 'Art Garfunkel'.

SELECT name
FROM movie
JOIN casting ON movie.id = movieid 
JOIN actor on actor.id = actorid 
WHERE movie.id IN (SELECT movieid FROM casting
                   WHERE actorid IN (
                   SELECT id FROM actor
                   WHERE name='Art Garfunkel')) 
AND name != 'Art Garfunkel'; 


# List the teachers who have NULL for their department.

SELECT name
FROM teacher
WHERE dept IS NULL;


# Note the INNER JOIN misses the teachers with 
# no department and the departments with no teacher.

SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id);


# Use a different JOIN so that all teachers are listed.

SELECT teacher.name, dept.name
 FROM teacher LEFT JOIN dept
           ON (teacher.dept=dept.id);


# Use a different JOIN so that all departments are listed.

SELECT teacher.name, dept.name
 FROM dept LEFT JOIN teacher
           ON (teacher.dept=dept.id);


# Show teacher name and mobile number or '07986 444 2266'

SELECT name, COALESCE(mobile,'07986 444 2266')
FROM teacher;


# Use the COALESCE function and a LEFT JOIN to print the teacher 
# name and department name. Use the string 'None' where there is no department.

SELECT teacher.name, COALESCE(dept.name, 'None') as Department
FROM teacher
LEFT JOIN dept ON dept = dept.id;


# Use COUNT to show the number of teachers and the number of mobile phones.

SELECT COUNT(name), COUNT(mobile)
FROM teacher;


# Use COUNT and GROUP BY dept.name to show each department and the number of staff.
# Use a RIGHT JOIN to ensure that the Engineering department is listed.

SELECT dept.name, COUNT(teacher.id)
FROM teacher
RIGHT JOIN dept ON dept.id = teacher.dept
GROUP BY dept.name;


# Use CASE to show the name of each teacher followed by 'Sci'
# if the teacher is in dept 1 or 2 and 'Art' otherwise.

SELECT name, 
       CASE WHEN dept = 1 OR dept = 2 
            THEN 'Sci' 
            ELSE 'Art' 
       END
FROM teacher;


# Use CASE to show the name of each teacher followed by 'Sci' 
# if the teacher is in dept 1 or 2, show 'Art' if the 
# teacher's dept is 3 and 'None' otherwise.

SELECT name, 
       CASE WHEN dept = 1 OR dept = 2 
            THEN 'Sci'
            WHEN dept = 3
            THEN 'Art' 
            ELSE 'None' 
       END
FROM teacher;


# How many stops are in the database.

SELECT COUNT(id)
FROM stops;


# Find the id value for the stop 'Craiglockhart'

SELECT id
FROM stops
WHERE name = 'Craiglockhart';


# Give the id and the name for the stops on the '4' 'LRT' service.

SELECT id, name
FROM stops
JOIN route ON id = stop
WHERE num = 4 AND company = 'LRT';


# The query shown gives the number of routes that visit either London Road (149) or 
# Craiglockhart (53). Run the query and notice the two services that link these stops 
# have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2;


# Execute the self join shown and observe that b.stop gives all the places you can get
# to from Craiglockhart, without changing routes. Change the query so that it 
# shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149;


# The query shown is similar to the previous one, however by joining two copies of 
# the stops table we can refer to stops by name rather than by number. 
# Change the query so that the services between 'Craiglockhart' and 'London Road' are shown
# If you are tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
AND   stopb.name='London Road';


# Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE (a.stop=115 AND b.stop = 137) 
   OR (a.stop=137 AND b.stop = 115);


# Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE 
      (stopa.name='Craiglockhart' AND
       stopb.name='Tollcross')
OR
      (stopa.name='Tollcross' AND
       stopb.name='Craiglockhart');


# Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking 
# one bus, including 'Craiglockhart' itself, offered by the LRT company. 
# Include the company and bus no. of the relevant services.

SELECT DISTINCT stopb.name, a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE (stopa.name='Craiglockhart')


# Find the routes involving two buses that can go from Craiglockhart to Sighthill.
# Show the bus no. and company for the first bus, the name of the stop for the transfer,
# and the bus no. and company for the second bus.

SELECT DISTINCT to_craig.num, to_craig.company, to_craig.name, 
                to_sight.num, to_sight.company
FROM (SELECT DISTINCT stopa.name as name, a.company, a.num
      FROM route a JOIN route b ON
      (a.company=b.company AND a.num=b.num)
      JOIN stops stopa ON (a.stop=stopa.id)
      JOIN stops stopb ON (b.stop=stopb.id)
      WHERE (stopb.name='Craiglockhart')) as to_craig
JOIN (SELECT DISTINCT stopa.name as name, a.company, a.num
      FROM route a JOIN route b ON
      (a.company=b.company AND a.num=b.num)
      JOIN stops stopa ON (a.stop=stopa.id)
      JOIN stops stopb ON (b.stop=stopb.id)
      WHERE (stopb.name='Sighthill')
      ORDER BY num desc) as to_sight
ON to_sight.name = to_craig.name