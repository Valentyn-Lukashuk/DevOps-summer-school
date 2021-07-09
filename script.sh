#!/bin/bash

mysql_check=`systemctl status mysql | grep running`
if [[ ${#mysql_check} == 0 ]]
then 
echo "sql not running"
exit 1
else 
currentdate=`date +%d%m%Y_%H%M`
mysql_dump=`mysqldump -u luk -ppassword lukva >date_$currentdate.sql`
fi

