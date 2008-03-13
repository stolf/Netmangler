
addressing_dhcp() {
	echo $IFNAME: Starting dhcp listening on interface $IFNAME
	udhcpc -b -i $IFNAME -t 20 &
}
