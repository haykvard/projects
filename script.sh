#!/bin/bash

FirstName=$1
SecondName=$2
LastName=$3
Show=$4

if [ "$Show" = "true" ]; then
  echo "Hello, $FirstName $SecondName $LastName"
else
  echo "If you want to see the name, please mark the show option"
fi

