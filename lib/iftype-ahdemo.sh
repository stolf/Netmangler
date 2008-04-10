ahdemo_base() {
	parentif $1
}

iftype_ahdemo() {
	echo $IFNAME: Create ahdemo interface
	/usr/bin/wlanconfig $IFNAME create nounit wlandev $PARENTIFS wlanmode ahdemo
	
	ip link set "$IFNAME" up

	CLEANUP_CMDS="wlanconfig $IFNAME destroy; $CLEANUP_CMDS"
}

