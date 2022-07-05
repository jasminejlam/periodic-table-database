#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.atomic_number=$1") 
  else
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.name='$1' OR elements.symbol='$1'")
  fi  
    if [[ -z $ELEMENT ]] 
    then
      echo "I could not find that element in the database."
    else
      echo $ELEMENT | while IFS=" | " read NUMBER SYMBOL NAME TYPE MASS MELTING_PT BOILING_PT 
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_PT celsius and a boiling point of $BOILING_PT celsius."
      done
    fi
else
  echo Please provide an element as an argument.
fi 