#!/bin/bash

dnf install mysql -y

if [ $? -ne 0 ]
then
    echo "ERROR:: You must have sudo access to execute this script"
    exit 1
fi

dnf list installed mysql

if [ $? -ne 0]
then
    dnf install mysql -y
    if [ $? -ne 0 ]
    then
        echo "server failure"
    else
        echo "server success"
    fi
else
    echo "server already"
fi

