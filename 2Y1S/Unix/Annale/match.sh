#!/bin/sh
ps -ef | grep -v UID | cut -d' ' -f1 | sort > liste
uniq liste > liste2
for i in liste2
do
	grep $i liste
	 
