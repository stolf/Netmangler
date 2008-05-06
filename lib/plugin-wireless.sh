# Generic wireless configuration plugin
#
# Provides options for configuring wireless extensions based devices

init_wireless() {
	echo wireless: Plugin loaded
}

newif_wireless() {
	WIRELESS_CMDS="true"
}

wireless_essid(){
	WIRELESS_CMDS="$WIRELESS_CMDS ; iwconfig $IFNAME essid \"$*\""
}

wireless_channel() {
	WIRELESS_CMDS="$WIRELESS_CMDS ; iwconfig $IFNAME channel $*"
}

do_wireless() {
	eval $WIRELESS_CMDS
}


