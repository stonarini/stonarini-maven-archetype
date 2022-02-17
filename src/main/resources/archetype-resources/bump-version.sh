#!/bin/sh

NEWVERSION=$1
OLDVERSION=$(grep -m 1 -oP '(?<=<version>).*(?=</version)' pom.xml)

if [ -z "$1" ]; then
	NEWVERSION=$(echo "${OLDVERSION}" | head -c 2)$(expr $(echo "${OLDVERSION}" | tail -c 2 ) + 1 ) 
fi

echo "Version will be set as: ${NEWVERSION}"
read -p "Continue? [y/n]: " REPLY

echo $REPLY

if [ "$REPLY" != "y" ]; then
	echo "Version not changed"
	exit 1
fi

sed -i -e "/<version>.*/{s//<version>"${NEWVERSION}"<\/version>/;:a" -e '$!N;$!ba' -e '}' pom.xml
sed -i -e "/${OLDVERSION}/s//${NEWVERSION}/g" Dockerfile
