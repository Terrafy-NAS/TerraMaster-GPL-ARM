#!/bin/sh
#the ownership of directories. (refer to android_filesystem_config.h)
if [ -d /tmp/data/app ];then
   chown 1000:1000 /tmp/data/app
fi
if [ -d /tmp/data/app-private ]; then
   chown 1000:1000 /tmp/data/app-private
fi
if [ -d /tmp/data/dalvik-cache ]; then
   chown 1000:1000 /tmp/data/dalvik-cache
fi
if [ -d /tmp/data/data ]; then
   chown 1000:1000 /tmp/data/data
fi
if [ -d /tmp/data/local/tmp ]; then
   chown 2000:2000 /tmp/data/local/tmp
fi
if [ -d /tmp/data/local ]; then
   chown 2000:2000 /tmp/data/local
fi
if [ -d /tmp/data/misc ]; then
   chown 1000:9998 /tmp/data/misc
fi
if [ -d /tmp/data/misc/dhcp ]; then
   chown 1014:1014 /tmp/data/misc/dhcp
fi
if [ -d /tmp/data/media ]; then
   chown 1023:1023 /tmp/data/media
fi
if [ -d /tmp/data/media/Music ]; then
   chown 1023:1023 /tmp/data/media/Music
fi
if [ -d /tmp/system/bin ]; then
   chown 0:2000 /tmp/system/bin
fi
if [ -d /tmp/system/vendor ]; then
   chown 0:2000 /tmp/system/vendor
fi
if [ -d /tmp/system/xbin ]; then
   chown 0:2000 /tmp/system/xbin
fi
if [ -d /tmp/system/etc/ppp ]; then
   chown 0:0 /tmp/system/etc/ppp
fi

#the permission of directories. (refer to android_filesystem_config.h)
if [ -d /tmp/data/app ]; then
   chmod 771 /tmp/data/app
fi
if [ -d /tmp/data/app-private ]; then
   chmod 771 /tmp/data/app-private
fi
if [ -d /tmp/data/dalvik-cache ]; then
   chmod 771 /tmp/data/dalvik-cache
fi
if [ -d /tmp/data/data ]; then
   chmod 771 /tmp/data/data
fi
if [ -d /tmp/data/local/tmp ]; then
   chmod 771 /tmp/data/local/tmp
fi
if [ -d /tmp/data/local ]; then
   chmod 771 /tmp/data/local
fi
if [ -d /tmp/data/misc ]; then
   chmod 771 /tmp/data/misc
fi
if [ -d /tmp/data/misc/dhcp ]; then
   chmod 770 /tmp/data/misc/dhcp
fi
if [ -d /tmp/data/media ]; then
   chmod 775 /tmp/data/media
fi
if [ -d /tmp/data/media/Music ]; then
   chmod 775 /tmp/data/media/Music
fi
if [ -d /tmp/system/bin ]; then
   chmod 755 /tmp/system/bin
fi
if [ -d /tmp/system/vendor ]; then
   chmod 755 /tmp/system/vendor
fi
if [ -d /tmp/system/xbin ]; then
   chmod 755 /tmp/system/xbin
fi
if [ -d /tmp/system/etc/ppp ]; then
   chmod 755 /tmp/system/etc/ppp
fi

#the ownership of files. (refer to android_filesystem_config.h)
if [ -d /sbin ]; then
   find /sbin/* -type f -o -type d | xargs chown 0:1000
fi
if [ -d /bin ]; then
   find /bin/* -type f -o -type d | xargs chown 0:0
fi
if [ -e /init* ]; then
   find /init* -type f -o -type d | xargs chown 0:1000
fi
if [ -e /tmp/system/etc* ]; then
   find /tmp/system/etc* -type f -o -type d | xargs chown 0:0
fi
if [ -f /tmp/system/etc/dhcpcd/dhcpcd-run-hooks ]; then
   chown 1014:2000 /tmp/system/etc/dhcpcd/dhcpcd-run-hooks
fi
if [ -f /tmp/system/etc/dbus.conf ]; then
   chown 1002:1002 /tmp/system/etc/dbus.conf
fi
if [ -d /tmp/system/etc/ppp ]; then
   find /tmp/system/etc/ppp/* -type f -o -type d | xargs chown 0:0
fi
if [ -e /tmp/system/etc/rc.* ]; then
   find /tmp/system/etc/rc.* -type f -o -type d | xargs chown 0:0
fi
if [ -d /tmp/data/app ]; then
   find /tmp/data/app/* -type f -o -type d | xargs chown 1000:1000
fi
if [ -d /tmp/data/media ]; then
   find /tmp/data/media/* -type f -o -type d | xargs chown 1023:1023
fi
if [ -d /tmp/data/app-private ]; then
   find /tmp/data/app-private/* -type f -o -type d | xargs chown 1000:1000
fi
if [ -d /tmp/data/data ]; then
   find /tmp/data/data/* -type f -o -type d | xargs chown 10000:10000
fi
if [ -d /tmp/system/bin ]; then
   find /tmp/system/bin/* -type f -o -type d | xargs chown 0:2000
fi
if [ -f /tmp/system/bin/ping ]; then
   chown 0:3004 /tmp/system/bin/ping
fi
if [ -f /tmp/system/bin/netcfg ]; then
   chown 0:3003 /tmp/system/bin/netcfg
fi
if [ -d /tmp/system/xbin ]; then
   find /tmp/system/xbin/* -type f -o -type d | xargs chown 0:2000
fi
if [ -f /tmp/system/xbin/su ]; then
   chown 0:0 /tmp/system/xbin/su
fi
if [ -f /tmp/system/xbin/librank ]; then
   chown 0:0 /tmp/system/xbin/librank
fi
if [ -f /tmp/system/xbin/procrank ]; then
   chown 0:0 /tmp/system/xbin/procrank
fi
if [ -f /tmp/system/xbin/procmem ]; then
   chown 0:0 /tmp/system/xbin/procmem
fi
if [ -f /tmp/system/xbin/tcpdump ]; then
   chown 0:0 /tmp/system/xbin/tcpdump
fi
if [ -d /tmp/system/lib/valgrind ]; then
   find /tmp/system/lib/valgrind/* -type f -o -type d | xargs chown 0:0
fi
if [ -d /tmp/system/vendor/bin ]; then
   find /tmp/system/vendor/bin/* -type f -o -type d | xargs chown 0:2000
fi
if [ -d /tmp/system/rtk_rootfs ]; then
   find /tmp/system/rtk_rootfs/* -type f -o -type d | xargs chown 2000:2000
fi
if [ -d /tmp/system/rtk_rootfs/usr/local/bin ]; then
   find /tmp/system/rtk_rootfs/usr/local/bin/* -type f -o -type d | xargs chown 0:2000
fi

#the permission of files. (refer to android_filesystem_config.h)
if [ -d /sbin ]; then
   find /sbin/* -type f -o -type d | xargs chmod 750
fi
if [ -d /bin ]; then
   find /bin/* -type f -o -type d | xargs chmod 755
fi
if [ -e /init* ]; then
   find /init* -type f -o -type d | xargs chmod 750
fi
if [ -e /tmp/system/etc* ]; then
   find /tmp/system/etc* -type f -o -type d | xargs chmod 755
fi
if [ -f /tmp/system/etc/dhcpcd/dhcpcd-run-hooks ]; then
   chmod 550 /tmp/system/etc/dhcpcd/dhcpcd-run-hooks
fi
if [ -f /tmp/system/etc/dbus.conf ]; then
   chmod 440 /tmp/system/etc/dbus.conf
fi
if [ -d /tmp/system/etc/ppp ]; then
   find /tmp/system/etc/ppp/* -type f -o -type d | xargs chmod 555
fi
if [ -e /tmp/system/etc/rc.* ]; then
   find /tmp/system/etc/rc.* -type f -o -type d | xargs chmod 555
fi
if [ -d /tmp/data/app ]; then
   find /tmp/data/app/* -type f -o -type d | xargs chmod 644
fi
if [ -d /tmp/data/media ]; then
   find /tmp/data/media/* -type f -o -type d | xargs chmod 644
fi
if [ -d /tmp/data/app-private ]; then
   find /tmp/data/app-private/* -type f -o -type d | xargs chmod 644
fi
if [ -d /tmp/data/data ]; then
   find /tmp/data/data/* -type f -o -type d | xargs chmod 644
fi
if [ -d /tmp/system/bin ]; then
   find /tmp/system/bin/* -type f -o -type d | xargs chmod 755
fi
if [ -f /tmp/system/bin/ping ]; then
   chmod 755 /tmp/system/bin/ping
   chmod g+s /tmp/system/bin/ping
fi
if [ -f /tmp/system/bin/netcfg ]; then
   chmod 750 /tmp/system/bin/netcfg
   chmod g+s /tmp/system/bin/netcfg
fi 
if [ -d /tmp/system/xbin ]; then
   find /tmp/system/xbin/* -type f -o -type d | xargs chmod 755
fi
if [ -f /tmp/system/xbin/su ]; then
   chmod 755 /tmp/system/xbin/su
fi
if [ -f /tmp/system/xbin/librank ]; then
   chmod 755 /tmp/system/xbin/librank
fi
if [ -f /tmp/system/xbin/procrank ]; then
   chmod 755 /tmp/system/xbin/procrank
fi 
if [ -f /tmp/system/xbin/procmem ]; then
   chmod 755 /tmp/system/xbin/procmem
fi
if [ -f /tmp/system/xbin/tcpdump ]; then
   chmod 755 /tmp/system/xbin/tcpdump
fi
if [ -d /tmp/system/lib/valgrind ]; then
   find /tmp/system/lib/valgrind/* -type f -o -type d | xargs chmod 755
fi 
if [ -d /tmp/system/vendor/bin ]; then
   find /tmp/system/vendor/bin/* -type f -o -type d | xargs chmod 755
fi
if [ -d /tmp/system/rtk_rootfs ]; then
   find /tmp/system/rtk_rootfs/* -type f -o -type d | xargs chmod 755
fi
if [ -d /tmp/system/rtk_rootfs/usr/local/bin ]; then
   find /tmp/system/rtk_rootfs/usr/local/bin/* -type f -o -type d | xargs chmod 755
fi
