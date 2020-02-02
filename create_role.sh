#!/bin/bash

MAIN_DIR=roles/$1/tasks
MAIN_FILE=$MAIN_DIR/main.yml

mkdir -p $MAIN_DIR
touch $MAIN_FILE
echo "# $1 - $2" >> $MAIN_FILE
echo "tasks:" >> $MAIN_FILE
