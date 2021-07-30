#! /bin/bash

check_username=$1
if
user=`cut -d: -f1  /etc/passwd |grep $check_username`
then
echo "well done" > /dev/null
else
echo "wrong user"
fi

check_folder=$2
if
folder=`ls -l |grep $check_folder`
then
`chown -f  $user $folder`
else
echo "folder does not exist"
fi
