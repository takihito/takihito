#!/bin/sh

tday=`date +%d`
dumpfile=/home/akihito/backups/dbdump/`date +%Y-%m-%d`.sql
archive=/home/akihito/backups/dbdump/archive/

exec 2>&1
mysqldump --default-character-set=binary -u root dbname > $dumpfile
gzip $dumpfile

if [ "$tday" -eq 01 ] || [ "$tday" -eq 10 ] || [ "$tday" -eq 20 ] ; then
  cp $dumpfile.gz $archive
fi

## remove file
tdayago=`date -d '100 days ago' '+%Y-%m-%d'`
removefile=/home/akihito/backups/dbdump/$tdayago.sql.gz

if [ -f $removefile ] ; then
#  echo "exit "$removefile;
rm $removefile
fi

