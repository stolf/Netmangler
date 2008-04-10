athsta_base() {
	parentif $1
}

iftype_athsta() {
	echo $IFNAME: Create Atheros Station
	/usr/bin/wlanconfig $IFNAME create nounit wlandev $PARENTIFS wlanmode sta
	
	ip link set "$IFNAME" up

	CLEANUP_CMDS="wlanconfig $IFNAME destroy; $CLEANUP_CMDS"
}
