#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# echo $($PSQL "TRUNCATE teams, games")
CT=0 #cycle counter
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINGOAL OPPGOAL
do
  let CT+=1
  if [[ $YEAR != "year" ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $WIN_ID ]]
    then
      ITR=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    if [[ -z $OPP_ID ]]
    then
      ITR=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    ITR=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINGOAL, $OPPGOAL)")
  fi
  echo $CT
done
echo -e "COMPLETED Inserts"