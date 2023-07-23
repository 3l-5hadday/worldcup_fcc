#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# First script to insert each team from games.csv into teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #1 get team id winner side
    WINNER_TEAM_ID=$($PSQL "SELECT team_id, name FROM teams WHERE name = '$WINNER'")
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert winners teams first
      INSERT_WINNER_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo Inserted Winner Team From $YEAR $ROUND : $WINNER
      # get new team_id
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi

    #2 get team_id opponent side
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id, name FROM teams WHERE name = '$OPPONENT'")
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert opponents teams if not winner team
      INSERT_OPPONENT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo Inserted Opponent Team From $YEAR $ROUND : $OPPONENT
      # get new team_id
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi
    INSERT_INFOS_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_TEAM_ID,$OPPONENT_TEAM_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  fi
done