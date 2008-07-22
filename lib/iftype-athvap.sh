# Create and configure an Atheros VAP

athvap_base() {
	parentif $1
	athvap_base="$*"
}

# Usage:
# mode [master|managed|ad-hoc|ahdemo]
mode() {
	athvap_mode="$*"
}

# Usage:
# standard [a|b|g|auto]
standard() {
	if [ "$*" = "auto" ]; then
		athvap_standard=0
	elif [ "$*" = "a" ]; then
		athvap_standard=1
	elif [ "$*" = "b" ]; then
		athvap_standard=2
	elif [ "$*" = "g" ]; then
		athvap_standard=3
	fi
}

# Turn on or off Ambient Noise Immunity
ani() {
	athvap_ani="$*"
}

# Set the link distance (ack timeout) in kilometers
distance() {
	athvap_distance="$*"
}

# Enable or disable four-frame (WDS) mode
wds() {
	athvap_wds="$*"
}

# Add a peer MAC for WDS
wds_mac() {
	athvap_wdsmac="$athvap_wdsmac $1"
}

iftype_athvap() {
	echo "${IFNAME}: Create Atheros VAP (${athvap_mode})"
	/usr/bin/wlanconfig $IFNAME create nounit wlandev $athvap_base wlanmode $athvap_mode

	# This comes from the mtu plugin
	if [ ! -z "${MTU}" ]; then
		/sbin/ip link set mtu ${MTU} dev $IFNAME
	fi
	
	/sbin/ip link set dev $IFNAME up
	
	if [ -n "$athvap_standard" ]; then
		iwpriv $IFNAME mode $athvap_standard
	fi

	if [ -n "$athvap_ani" ]; then
		echo "$athvap_ani" > /proc/sys/dev/${athvap_base}/intmit
	fi

	if [ -n "$athvap_distance" ]; then
		/usr/bin/athctrl -i $athvap_base -d $athvap_distance
	fi

	if [ -n "$athvap_wds" ]; then
		iwpriv $IFNAME wds $athvap_wds
	fi

	for WDSMAC in $athvap_wdsmac; do
		iwpriv $IFNAME wds_add $WDSMAC
	done

	CLEANUP_CMDS="wlanconfig $IFNAME destroy; $CLEANUP_CMDS"
}
