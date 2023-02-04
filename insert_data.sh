#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != "year" ]]
  then
    WTEAM_ID=$($PSQL "Select team_id from teams where name='$WINNER';")
    if [[ -z $WTEAM_ID ]]
    then
      WTEAM_ADD=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      WTEAM_ID=$($PSQL "Select team_id from teams where name='$WINNER';")
    fi
    
    OTEAM_ID=$($PSQL "Select team_id from teams where name='$OPPONENT';")
    if [[ -z $OTEAM_ID ]]
    then
      OTEAM_ADD=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      OTEAM_ID=$($PSQL "Select team_id from teams where name='$OPPONENT';")
    fi 
    GAME_INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WTEAM_ID, $OTEAM_ID, $WGOALS, $OGOALS);")
  
  fi 
done  
