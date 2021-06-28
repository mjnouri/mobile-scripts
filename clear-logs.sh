#!/bin/bash

cd /home/ubuntu/mobile-scripts

if ! test -e log
then
  echo "------------------------" > log
fi

echo "------------------------"

DATETIME=$(date +%F" "%r)
echo $DATETIME | tee -a log

DIR1WCBEFORE=$(ls -l /opt/liferay/tomcat-7.0.42/logs | wc -l)
DIR2WCBEFORE=$(ls -l /opt/liferay/tomcat-7.0.42/bin/C\:/liferay_tomcat/liferay-portal-6.2.0-ce-ga1/logs | wc -l)

DIR1SIZEBEFORE=$(du -sh /opt/liferay/tomcat-7.0.42/logs)
DIR2SIZEBEFORE=$(du -sh /opt/liferay/tomcat-7.0.42/bin/C\:/liferay_tomcat/liferay-portal-6.2.0-ce-ga1/logs)

echo "Dir1 has $DIR1WCBEFORE file(s) and is $DIR1SIZEBEFORE." | tee -a log
echo "Dir2 has $DIR2WCBEFORE file(s) and is $DIR2SIZEBEFORE." | tee -a log

echo "Stopping Liferay. Wait 1 minute." | tee -a log
sudo /opt/liferay/tomcat-7.0.42/bin/shutdown.sh
sleep 60

# Copy logs to S3
DATETIMES3=$(date +%F"_"%T"_"%A)
echo "Copying Liferay logs to s3://bucketname/$DATETIMES3"
aws s3 cp /opt/liferay/tomcat-7.0.42/logs/ s3://bucketname/$DATETIMES3/dir1 --recursive --quiet
aws s3 cp /opt/liferay/tomcat-7.0.42/bin/C\:/liferay_tomcat/liferay-portal-6.2.0-ce-ga1/logs/ s3://bucketname/$DATETIMES3/dir2 --recursive --quiet
echo "Done. Logs copied to s3://bucketname/$DATETIMES3" | tee -a log-s3

echo "Clearing dir1." | tee -a log
sudo rm -f /opt/liferay/tomcat-7.0.42/logs/*

echo "Clearing dir2." | tee -a log
sudo rm -f /opt/liferay/tomcat-7.0.42/bin/C\:/liferay_tomcat/liferay-portal-6.2.0-ce-ga1/logs/*.log

DIR1WCAFTER=$(ls -l /opt/liferay/tomcat-7.0.42/logs | wc -l)
DIR2WCAFTER=$(ls -l /opt/liferay/tomcat-7.0.42/bin/C\:/liferay_tomcat/liferay-portal-6.2.0-ce-ga1/logs | wc -l)

DIR1SIZEAFTER=$(du -sh /opt/liferay/tomcat-7.0.42/logs)
DIR2SIZEAFTER=$(du -sh /opt/liferay/tomcat-7.0.42/bin/C\:/liferay_tomcat/liferay-portal-6.2.0-ce-ga1/logs)

echo "Dir1 now has $DIR1WCAFTER file(s) and is $DIR1SIZEAFTER." | tee -a log
echo "Dir2 now has $DIR2WCAFTER file(s) and is $DIR2SIZEAFTER." | tee -a log

# echo "Restarting Liferay." | tee -a log
# sudo /opt/liferay/tomcat-7.0.42/bin/startup.sh

echo "Rebooting server." | tee -a log
sudo reboot

echo "------------------------" | tee -a log
