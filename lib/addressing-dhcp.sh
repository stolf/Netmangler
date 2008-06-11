
addressing_dhcp() {
	echo $IFNAME: Starting dhcp listening on interface $IFNAME

	if [ `which pump` != "" ]; then
		pump -i $IFNAME &
	elif [ `which udhcpc` != "" ]; then
		udhcpc -b -i $IFNAME -t 20 &
	else
		echo "No DHCP client!"
	fi
}
