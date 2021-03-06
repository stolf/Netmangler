mac() {
	MAC=$1
}

iftype_ethernet() {
	if [ -z "$MAC" ]; then
		echo $IFNAME: mac not specified
		exit 1
	else
		OLDNAME=$(ip -o link |
			grep -i "^[0-9]*: [^.:]*: .* link/ether $MAC" |
			sed 's/^[0-9]*: \([^.:]*\): .*/\1/' |
			while read int; do [ ! -d /proc/sys/dev/$int -a ! -d /proc/net/madwifi/$int ] && echo $int; done)

		echo $IFNAME: configuring interface with mac=$MAC as $OLDNAME =\> $IFNAME
		ip link set "$OLDNAME" down
		ip link set "$OLDNAME" name "$IFNAME"

		# This comes from the mtu plugin
		if [ ! -z "${MTU}" ]; then
			/sbin/ip link set mtu ${MTU} dev $IFNAME
		fi

		ip link set "$IFNAME" up
		CLEANUP_CMDS="ip link set $IFNAME down; $CLEANUP_CMDS"
	fi
}
