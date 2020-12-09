#!/bin/bash

DIR1WC=$(ls -l /opt/liferay/tomcat-7.0.42/logs | wc -l)
DIR2WC=$(ls -l /opt/liferay/tomcat-7.0.42/bin/C\:/liferay_tomcat/liferay-portal-6.2.0-ce-ga1/logs | wc -l)

DIR1SIZE=$(du -sh /opt/liferay/tomcat-7.0.42/logs)
DIR2SIZE=$(du -sh /opt/liferay/tomcat-7.0.42/bin/C\:/liferay_tomcat/liferay-portal-6.2.0-ce-ga1/logs)

echo "Dir1 has $DIR1WC file(s) and is $DIR1SIZE." | tee -a log
echo "Dir2 has $DIR2WC file(s) and is $DIR2SIZE." | tee -a log
