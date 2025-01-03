#!/bin/bash

USERID=$(id -u)

LOG_FOLDER="/var/log/mysql-logs"
LOG_FILE=$( echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d--%H:%M:%S)
LOG_FILE_NAME="$LOG_FOLDER/$LOG_FILE.log------$TIMESTAMP"



# echo "Three"

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

dnf module disable nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "Disable the default nodeJs"

dnf module enable nodejs:20 -y &>>$LOG_FILE_NAME
VALIDATE $? "Enable NodeJS 20"

dnf install nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? " Install NodeJS"

useradd expense &>>$LOG_FILE_NAME
VALIDATE $? "Creating expense User"

mkdir /app &>>$LOG_FILE_NAME
VALIDATE $? "Creating app Directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "Downloading Backend"

cd /app

unzip /tmp/backend.zip &>>$LOG_FILE_NAME
VALIDATE $? "UNZIP Backend"

npm install &>>$LOG_FILE_NAME
VALIDATE $? " Install the Dependencies"

cp home/ec2-user/expense-shell /etc/systemd/system/backend.service
#prepare Mysql schema

dnf install mysql -y &>>$LOG_FILE_NAME
VALIDATE $? " install Mysql client"

mysql -h 172.31.21.105 -u root -pRavi123 < /app/schema/backend.sql &>>$LOG_FILE_NAME
VALIDATE $? "setting up the transactions schems and tables"

systemctl daemon-reload
VALIDATE $? "daemon Reload"

systemctl start backend
VALIDATE $? " Start Backend"

systemctl enable backend
VALIDATE $? "Enable Backend"

