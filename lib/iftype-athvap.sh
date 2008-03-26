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
	else if ["$*" = "a"]; then
		athvap_standard=1
	else if ["$*" = "b"]; then
		athvap_standard=2
	else if ["$*" = "g"]; then
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

iftype_athvap() {
	echo $IFNAME: Create Atheros VAP
	/usr/local/bin/wlanconfig $IFNAME create nounit wlandev $athvap_base wlanmode $athvap_mode
	/sbin/ip link set dev $IFNAME up
	
	if [ "$athvap_standard" ]; then
		iwpriv $IFNAME mode $athvap_standard
	fi

	if ["$athvap_ani"]; then
		echo "$athvap_ani" > /proc/sys/dev/${athvap_base}/intmit
	fi

	if ["$athvap_distance"]; then
		athctrl -i $athvap_base -d $athvap_distance
	fi

	CLEANUP_CMDS="wlanconfig $IFNAME destroy; $CLEANUP_CMDS"
}
