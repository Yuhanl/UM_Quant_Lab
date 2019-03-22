
#copy_paste_pre
install.packages('Lahman')
install.packages('RSQLite')
library(tidyverse)
library(dbplyr)
library(Lahman)
lahman = lahman_sqlite()


#syntax in R
#put your SQL quesry in the colon
master = lahman %>% 
  tbl(sql('
          SELECT * FROM master')) %>% collect()

#to show you table in R, you can use the collect
master %>% collect()

#boolean
#use boolean after WHERE to select with conditons
#example...


#get the name/or * of the players from the master table that are born on March 7th
birth37 = lahman %>% 
  tbl(sql('
          SELECT nameGiven, birthMonth, birthDay
          FROM  master 
          WHERE birthMonth == 3 AND birthDay == 7')) %>% collect()

#in
#To select on a column by testing against a set of fixed values use IN
#example...

#get the name/or * of the players from the master table that are not born in USA and Mexico
birthLoc = lahman %>% 
  tbl(sql('
          SELECT nameGiven, birthCountry
          FROM  master 
          WHERE birthCountry NOT IN  
          ("USA", "Mexico")')) %>% collect()


#like
#Use a LIKE statement with a WHERE clause to get partial string matching. You can use % to match any sub-string.
#example..


#select all Richard in any position of names from master
Richards = lahman %>% 
  tbl(sql('
          SELECT nameFirst, nameLast, nameGiven
          FROM  master 
          WHERE nameFirst LIKE "%Richard%" 
          OR nameLast LIKE "%Richard%"
          OR nameGiven LIKE "%Richard%"')) %>% collect()

#Order by
#example..

#select name/or * from master who are born in ohio(OH) ordered by their birthMonth and birthDay in increasing order
ordeyby = lahman %>% 
  tbl(sql('
          SELECT nameGiven, birthMonth, birthDay, birthState
          FROM  master 
          WHERE birthState == "OH"
          ORDER BY birthMonth, birthDay')) %>% collect()

ordeybynotnull = lahman %>% 
  tbl(sql('
          SELECT nameGiven, birthMonth, birthDay, birthState
          FROM  master 
          WHERE birthState == "OH"
          AND birthDay IS NOT NULL
          AND birthMonth IS NOT NULL
          ORDER BY birthMonth, birthDay')) %>% collect()

#Group by
#get the count of people in each birth state
stateCount = lahman %>% 
  tbl(sql('
          SELECT DISTINCT birthState, COUNT(birthState) AS stateCount
          FROM  master 
          WHERE birthState IS NOT NULL
          GROUP BY birthState
          ORDER BY stateCount DESC')) %>% collect()

#having
#states that are more than 500
stateCountGreater = lahman %>% 
  tbl(sql('
          SELECT birthState, COUNT(birthState) AS stateCount
          FROM  master 
          WHERE birthState IS NOT NULL
          GROUP BY birthState
          HAVING stateCount >= 500
          ORDER BY stateCount DESC, birthState')) %>% collect()

#inner join
batting = lahman %>% 
  tbl(sql('
          SELECT * FROM batting')) %>% collect()

pitching = lahman %>% 
  tbl(sql('
          SELECT * FROM pitching')) %>% collect()

#find both batting and pitching playerID 
both = lahman %>% 
  tbl(sql('
          SELECT DISTINCT p.playerID 
          FROM pitching p
          INNER JOIN batting b ON p.playerID = b.playerID')) %>% collect()

#BONUS: try to find the name of the player both batting and pitching?
bothName = lahman %>% 
  tbl(sql('
          SELECT m.nameGiven, m.playerID
          FROM master m
          WHERE m.playerID IN
          (SELECT DISTINCT p.playerID 
            FROM pitching p
            INNER JOIN batting b ON p.playerID = b.playerID)')) %>% collect()

#left/right join
#find the player name that pitcher that has more than 10 wins
pitchWin = lahman %>% 
  tbl(sql('
          SELECT m.nameGiven, p.W
          FROM pitching p
          LEFT JOIN master m ON p.playerID = m.playerID
          WHERE p.W >=10')) %>% collect()
