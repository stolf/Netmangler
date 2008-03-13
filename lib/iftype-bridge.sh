brparent() {
	parentif $1
}

iftype_bridge() {
	echo $IFNAME: Create bridge
	brctl addbr $IFNAME
	for i in $PARENTIFS; do
		echo $IFNAME: Adding $i to bridge
		ip link set "$i" up
		brctl addif "$IFNAME" "$i"
	done
	
	ip link set "$IFNAME" up
	
	CLEANUP_CMDS="ip link set $IFNAME down; brctl delbr $IFNAME ; $CLEANUP_CMDS"
}
