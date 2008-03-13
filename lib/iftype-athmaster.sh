athmaster_base() {
	parentif $1
}

channel() {
	athmaster_chan="$*"
}

essid() {
	athmaster_essid="$*"
}

iftype_athmaster() {
	echo $IFNAME: Create Atheros Master
	/usr/local/bin/wlanconfig $IFNAME create nounit wlandev $PARENTIFS wlanmode master
	/sbin/iwconfig $IFNAME essid $athmaster_essid channel $athmaster_chan
	/sbin/ip link set dev $IFNAME up

	CLEANUP_CMDS="wlanconfig $IFNAME destroy; $CLEANUP_CMDS"
}
