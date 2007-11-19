
addressing_dhcp() {
	echo $IFNAME: Starting dhcp listening on interface $IFNAME
	udhcpc -b -i $IFNAME & > /dev/null
}
