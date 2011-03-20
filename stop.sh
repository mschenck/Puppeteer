#!/bin/bash

PIDFILE="puppeteer.pid"
LOGFILE="puppeteer.log"

kill `cat $PIDFILE` 2>&1 > $LOGFILE
rm $PIDFILE
echo "Puppeteer stopped"
