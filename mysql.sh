#!/bin/bash

USERID=$(id -u)

LOG_FOLDER="/var/log/mysql-logs"
LOG_FILE=$( echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d--%H:%M:%S)
LOG_FILE_NAME="$LOG_FOLDER/$LOG_FILE.log------$TIMESTAMP"

dnf list installed mysql
if [ $? -eq 0 ]
then    
    dnf remove mysql
else
    exit 0
fi

if [ $USERID -ne 0 ]
then
    echo "ERROR:: You must have sudo access to execute this script"
    exit 1
fi

dnf list installed mysql &>>$LOG_FILE_NAME

if [ $? -ne 0 ]
then
    dnf install mysql -y &>>$LOG_FILE_NAME
    if [ $? -ne 0 ]
    then
        echo "server failure"
        exit 1
    else
        echo "server success"
    fi
else
    echo "server already"
fi

