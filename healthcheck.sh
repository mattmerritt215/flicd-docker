#!/bin/sh
/bin/netstat -an | grep LISTEN | grep -c ${PORT}