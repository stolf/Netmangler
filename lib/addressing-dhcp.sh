
addressing_dhcp() {
	echo $IFNAME: Starting dhcp listening on interface $IFNAME

	DHCPC=""

	if [ ! -z `which pump` ]; then
		DHCPC="pump -i $IFNAME"
		# pump doesnt write a pid and forks itself off, so we can't
		# just rely on $! being accurate.
		CLEANUP="ps a | grep [p]ump | grep ${IFNAME} | awk '{ print \$1 }'"
	elif [ ! -z `which udhcpc` ]; then
		DHCPC="udhcpc -b -i $IFNAME -t 20"
		CLEANUP="cat /tmp/nm-dhcpc-${IFNAME}.pid"
	else
		echo "No DHCP client!"
	fi

	if [ ! -z "${DHCPC}" ]; then 
		${DHCPC} &
		echo $! > /tmp/nm-dhcpc-${IFNAME}.pid
		CLEANUP_CMDS="kill -9 `\$(${CLEANUP})`; $CLEANUP_CMDS"
	fi
	
}
