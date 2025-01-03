#!/bin/bash

echo " First"
dnf list installed mysql


if [ $? -eq 0 ]
then 
    echo "First One"
    dnf remove mysql  
fi

echo "hiiiiiiiiiii"



USERID=$(id -u)

LOG_FOLDER="/var/log/mysql-logs"
LOG_FILE=$( echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d--%H:%M:%S)
LOG_FILE_NAME="$LOG_FOLDER/$LOG_FILE.log------$TIMESTAMP"



echo "Three"

VALIDATE(){
     if [ $1 -ne 0 ]
    then
        echo "$2 failure"
        exit 1
    else
        echo "$2 success"
    fi
}

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
    echo "ERROR:: You must have sudo access to execute this script"
    exit 1
    fi
}

echo "Script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT


dnf list installed mysql &>>$LOG_FILE_NAME



if [ $? -ne 0 ]
then
    dnf install mysql -y &>>$LOG_FILE_NAME
    VALIDATE $? " MYSQL SERVER "
else
    echo "MYSQL SERVER installed already"
fi

