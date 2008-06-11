
addressing_dhcp() {
	echo $IFNAME: Starting dhcp listening on interface $IFNAME

	DHCPC=""

	if [ ! -z `which pump` ]; then
		DHCPC="pump -i $IFNAME"
	elif [ ! -z `which udhcpc` ]; then
		DHCPC="udhcpc -b -i $IFNAME -t 20"
	else
		echo "No DHCP client!"
	fi

	if [ ! -z "${DHCPC}" ]; then 
		${DHCPC} &
		echo $! > /tmp/nm-dhcpc-${IFNAME}.pid
		CLEANUP_CMDS="kill -9 \$(cat /tmp/nm-dhcpc-${IFNAME}.pid); $CLEANUP_CMDS"
	fi
	
}
