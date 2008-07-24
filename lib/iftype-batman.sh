bmparent() {
	parentif $1
}

iftype_batman() {
	echo $IFNAME: Create B.A.T.M.A.N interface
	
	if [ -z "${PARENTIFS}" ]; then
		echo $IFNAME: No B.A.T.M.A.N devices.
		return
	fi

	/sbin/modprobe batman-adv-core
	
	for i in $PARENTIFS; do
		echo $IFNAME: Adding $i to B.A.T.M.A.N
		ip link set "$i" up
		echo $i > /proc/net/batman-adv/interfaces
	done
	
	ip link set "$IFNAME" up
	
	CLEANUP_CMDS="ip link set $IFNAME down; echo > /proc/net/batman-adv/interfaces ; $CLEANUP_CMDS"
}
