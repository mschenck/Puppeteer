#!/bin/bash

PIDFILE="puppeteer.pid"
LOGFILE="puppeteer.log"

if [ -f $PIDFILE ] ; then
    echo "ERROR: Cannot start pidfile [$PIDFILE] exists"
    exit 1
else
    ruby -rubygems puppeteer.rb 2>&1 > $LOGFILE &
    echo $! > $PIDFILE
    echo "Puppeteer started"
fi
