#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
	echo "Please provide an element as an argument."
	exit 0
fi

if [[ $1 =~ ^[0-9]+$ ]]; then
	QUERY=$($PSQL "select * from types right join properties using(type_id) right join elements using(atomic_number) where atomic_number=$1")
else
	QUERY=$($PSQL "select * from types right join properties using(type_id) right join elements using(atomic_number) where symbol='$1' or name='$1'")
fi

if [[ -z "$QUERY" ]]; then
	echo "I could not find that element in the database."
	exit 0
fi

IFS='|' read -r A_N TYPE_ID TYPE A_M M_P B_P SYMBOL NAME <<<"$QUERY"

echo "The element with atomic number $A_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_M amu. $NAME has a melting point of $M_P celsius and a boiling point of $B_P celsius."
