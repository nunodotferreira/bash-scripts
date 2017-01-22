#!/bin/bash

USER="mysqluser"
PASSWORD="mysqlpassword"
OUTPUT="your_output_folder"
MAILTO="mail_to_send"
OTHERMAILS="other_email,other_email"
LOGFILE="dbackup.log"
NOW=$(date +"%F %H:%M")
PATHLOG=$OUTPUT/$LOGFILE

touch $OUTPUT/$LOGFILE

> $OUTPUT/$LOGFILE

# Delete files older than 30 days
# comment this if you don't want these
find $OUTPUT/*.gz -mmin +1 -exec rm {} \;

echo "################################################################" >> $PATHLOG
echo $NOW  " Beginning backup service" >> $PATHLOG
echo "################################################################" >> $PATHLOG

# uncomment this if you want to delete all existing files before backup
#rm "$OUTPUT/*.gz" > /dev/null 2>&1

databases=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
   if [ "$db" != 'information_schema' ] && [ "$db" != _* ] && [ "$db" != 'performance_schema' ] && [ "$db" != 'mysql' ]
   then
       echo "Backup database: $db" >> $PATHLOG
       mysqldump --force --opt --user=$USER --password=$PASSWORD --databases $db > $OUTPUT/`date +%Y%m%d`.$db.sql
       gzip $OUTPUT/`date +%Y%m%d`.$db.sql
       du -h $OUTPUT/`date +%Y%m%d`.$db.sql.gz | cut -f1 >> $PATHLOG
       echo "$db Backup success!" >> $PATHLOG
	
		echo "################################################################" >> $PATHLOG
   fi
done

ENDNOW=$(date +"%F %H:%M")
echo $ENDNOW  " Backup service, over and out" >> $PATHLOG
mailx -s "$db Backup MySql Report!" $MAILTO -b $OTHERMAILS < $OUTPUT/$LOGFILE