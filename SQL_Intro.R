
#copy_paste_pre
install.packages('dbplyr')
install.packages('dplyr')
install.packages('tidyverse')
install.packages('Lahman')
install.packages('RSQLite')
library(tidyverse)
library(dplyr)
library(dbplyr)
library(Lahman)
lahman = lahman_sqlite()


# syntax in R
# put your SQL query in the colon
master = lahman %>% 
  tbl(sql('
          SELECT * FROM master')) %>% collect()

#to show you table in R, you can use the collect
master %>% collect()

# boolean ---------------------------------------------------------------------
#use boolean after WHERE to select with conditons
#example...


# 1. Get the name/or * of the players from the master table that are born on March 7th
birth37 = lahman %>% 
  tbl(sql('
          SELECT ...
          FROM   ...
          WHERE  ...')) %>% collect()

# in --------------------------------------------------------------------------
#To select on a column by testing against a set of fixed values use IN
#example...

# 2. get the name/or * of the players from the master table that are not born in USA and Mexico
birthLoc = lahman %>% 
  tbl(sql('
          SELECT ...
          FROM   ... 
          WHERE  ...'
          )) %>% collect()


# like ------------------------------------------------------------------------
#Use a LIKE statement with a WHERE clause to get partial string matching. You can use % to match any sub-string.
#example..


# 3. select all Richard in any position of names from master
Richards = lahman %>% 
  tbl(sql('
          SELECT ...
          FROM   ...
          WHERE  ...'
          )) %>% collect()

# Order by --------------------------------------------------------------------
#example..

# 4/5. select name/or * from master who are born in ohio(OH) ordered by their 
# birthMonth and birthDay in increasing order
ordeyby = lahman %>% 
  tbl(sql('
          SELECT ...
          FROM   ... 
          WHERE  ...
          ORDER BY ...'
          )) %>% collect()

ordeybynotnull = lahman %>% 
  tbl(sql('
          SELECT ...
          FROM  ...
          WHERE ...
          AND ...
          AND ...
          ORDER BY ...'
          )) %>% collect()

# Group by --------------------------------------------------------------------
# 6. get the count of people in each birth state
stateCount = lahman %>% 
  tbl(sql('
          SELECT DISTINCT ...
          FROM  ...
          WHERE ...
          GROUP ...
          ORDER BY ...'
          )) %>% collect()

# Having ----------------------------------------------------------------------
# 7. states that are more than 500
stateCountGreater = lahman %>% 
  tbl(sql('
          SELECT ...
          FROM  ... 
          WHERE ...
          GROUP ...
          HAVING ...
          ORDER BY ...')) %>% collect()

#inner join -------------------------------------------------------------------
batting = lahman %>% 
  tbl(sql('
          SELECT * FROM batting')) %>% collect()

pitching = lahman %>% 
  tbl(sql('
          SELECT * FROM pitching')) %>% collect()

#8. find both batting and pitching playerID 
both = lahman %>% 
  tbl(sql('
          SELECT DISTINCT ... 
          FROM ...
          INNER JOIN ...')) %>% collect()

#BONUS: try to find the name of the player both batting and pitching?
bothName = lahman %>% 
  tbl(sql('
          SELECT ...
          FROM ...
          WHERE m.playerID IN
          .
          .
          .
          INNER JOIN ...)')) %>% collect()

# left/right join -------------------------------------------------------------
# 9. find the player name that pitcher that has more than 10 wins
pitchWin = lahman %>% 
  tbl(sql('
          SELECT ...
          FROM ...
          LEFT JOIN ...
          WHERE ...')) %>% collect()