#!/bin/bash
# SPDX-License-Identifier: MIT

## configuration
# url to sever file
# Speedtest will be performed by downloading this file
SRV_URL="https://someserver.tld/somefile"

# statistics file
# All download statistics will be saved to this file
STATFILE="/var/lib/srv-spdtst/statfile.log"

# image location
# Images with statistics will be placed in this folder
OUTDIR="/var/www/html/srv-spdtst/"

# maximum time
DL_TIMEOUT=300


## condition checks
# statistics file
if [[ ! -d $(dirname ${STATFILE}) ]]; then
	echo "Error: Statistics directory does not exist" >> /dev/stderr
	exit 1
fi
if [[ -e ${STATFILE} ]]; then
	# file exists check if it is writable
	if [[ ! -w ${STATFILE} ]]; then
		echo "Error: Unable to write to statistics file" >> /dev/stderr
		exit 2
	fi
else
	# file does not exist => try to create it
	echo "Notice: Statistics file does not exist, trying to create it" >> /dev/stderr
	touch ${STATFILE}
	if [[ ! -w ${STATFILE} ]]; then
		echo "Error: Unable to create statistics file" >> /dev/stderr
		exit 3
	fi
fi
#output dir
if [[ ! -d ${OUTDIR} ]]; then
	echo "Error: No output directory given" >> /dev/stderr
	exit 4
fi
if [[ ! -w ${OUTDIR} ]]; then
	echo "Error: Output directory not writable" >> /dev/stderr
	exit 5
fi


## data collection
# log time
echo -en "$(date +%Y-%m-%dT%H:%M)\\t" >> ${STATFILE}
# download and log data
curl -s -S ${SRV_URL} -o /dev/null -m ${DL_TIMEOUT} -w "%{time_total}\\t%{size_download}\\t%{speed_download}\\n" >> ${STATFILE}

## create graphs
gnuplot -persist <<-EOFMarker
  set terminal png transparent size 800,600 crop
  set xdata time
  set timefmt "%Y-%m-%dT%H:%M"
  set xlabel ""
  set title "Download speed"
  set ytics format "%.1s%c"
  set ylabel "bit/s"
  set output "${OUTDIR}/out.png"
  plot "${STATFILE}" using 1:4 title '' with lines
EOFMarker
