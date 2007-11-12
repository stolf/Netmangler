
addressing_none() {
	echo $IFNAME: Not configuring any address
	ip link set "$IFNAME" up
}
