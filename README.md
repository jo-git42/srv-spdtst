# srv-spdtst
Server speed test. Continuously monitor download speed from a specific server

## configuration
Just set the variables SRV_URL, OUTDIR , STATFILE and DL_TIMEOUT in the srv-spdtst.sh.

### SRV_URL
URT to file which will be downloaded for measuring the download speed. Must be changed to a suitable test file located on a server.

### OUTDIR
Directory where the graphs will be stored.

### STATFILE
Statistics file with the measured download speed.

### DL_TIMEOUT
Maximum time before the download will be interrupted. The download rate will be measured even if it was interrupted by a timeout. This timeout is just to limit the runtime if the download rate drops very much.

## installation
The bash script depends on cURL and gnuplot. For Debian based Linux systems install them just using apt.
~~~~
apt install curl gnuplot
~~~~
Additionally some directories are needed.
~~~~
mkdir /var/cache/srv-spdtst/
chown user:user /var/cache/srv-spdtst/

mkdir /var/www/html/srv-spdtst
chown user:user /var/www/html/srv-spdtst
chmod 755 /var/www/html/srv-spdtst/
~~~~
Change user to the user the script will run. The paths used here have to match the paths configured in the srv-spdtst.sh.


For continuous measurement a cronjob should be added. Example cron configuration to be placed in /etc/cron.d/
~~~~
# cron file for periodic speed test

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user  command
*/15 * * * * user /usr/local/bin/srv-spdtst
~~~~

## Statistics file format
An entry in the statistics file will look like this:
~~~~
2019-08-21T18:45        229,842182      41816685        181936,000
~~~~
1. Date in the format %Y-%m-%dT%H:%M
2. Total time of download in seconds
3. Total amount of bytes transferred
4. Average download speed measured by cURL in Bytes per second
