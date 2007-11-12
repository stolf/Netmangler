iftype_dummy() {
	if [ ! -d /proc/sys/net/ipv4/conf/$IFNAME ]; then
		echo $IFNAME: Creating $IFNAME
		# ip link set name $IFNAME dev dummy0
	fi
}
