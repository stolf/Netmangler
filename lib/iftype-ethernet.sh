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
			while read int; do [ ! -d /proc/sys/dev/$int -a ! -f /prr
			oc/net/madwifi/$int ] && echo $int; done)

		echo $IFNAME: configuring interface with mac=$MAC as $OLDNAME =\> $IFNAME
		ip link set "$OLDNAME" down
		ip link set "$OLDNAME" name "$IFNAME"
		CLEANUP_CMDS="ip link set $IFNAME down; $CLEANUP_CMDS"
	fi
}
