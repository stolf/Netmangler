
addressing_dhcp() {
	echo $IFNAME: Starting dhcp listening on interface $IFNAME
	udhcpc -i $IFNAME
}
