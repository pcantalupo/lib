#!/bin/bash

CANCER=$1

if [[ -z $CANCER ]]; then
	echo "Please supply cancer (lowercase) as first parameter on command line"
	exit;
fi

echo "Getting manifest file for $CANCER"
curl -sO https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/$CANCER/bcr/biotab/clin/MANIFEST.txt 


M=MANIFEST.txt
if [[ ! -e $M ]]; then
	echo "$M was not found. Exiting..."
	exit
fi

IFS="  "
while read id file; do
	echo "Downloading $file"
	curl -sO https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/$CANCER/bcr/biotab/clin/${file}
done < $M
