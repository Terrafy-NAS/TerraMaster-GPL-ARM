#!/bin/sh

. /lib/functions/leds.sh

LOCK=/var/lock/watchhome.lock

do_terminate() {
    if [ $LOCK ]; then
        rm $LOCK
    fi
}

trap 'do_terminate' TERM

if [ ! -f $LOCK ]; then
touch $LOCK

while [ -z $mounted ]
do
    mounted="`cat /proc/self/mounts | grep /mnt/sda1`"
    sleep 1
done

[ ! -d /mnt/sda1/home ] && mkdir /mnt/sda1/home

led_on usb

threshold=`cat /etc/threshold`
/usr/bin/inotifywait -mq -r --exclude '/\..+' -e moved_to --format "%w%f" /mnt/sda1 | while read file
do
    path=`dirname $file`
    filename=`basename $file`
    [ ! -d "$path/.chksum" ] && mkdir "$path/.chksum"
    md5sum  $path/$filename  | awk  '{print $1}' > $path/.chksum/${filename}.md5
    usage=`df -h /mnt/sda1 | grep -vE '^Filesystem' | awk '{print $5}' | cut -d'%' -f1`
    if [ $usage -gt $threshold ]; then
        echo 1 > /proc/net/r8168oob/eth0/lanwake
	echo "Wake Up Host to do backup\n"
    fi
done
fi
