#!/bin/sh
if [ $# -ne 1 ] ; then
echo alala
exit 1
else  echo o
fi
echo `du -sk $1| awk '{print $1}' `

