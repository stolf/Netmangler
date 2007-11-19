athsta_base() {
	parentif $1
}

iftype_athsta() {
	echo $IFNAME: Create Atheros Station
	/usr/local/bin/wlanconfig $IFNAME create nounit wlandev $PARENTIFS wlanmode sta

	CLEANUP_CMDS="wlanconfig $IFNAME destroy; $CLEANUP_CMDS"
}
