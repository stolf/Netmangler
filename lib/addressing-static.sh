
address() {
	ADDRESSES="$ADDRESSES $1"
}

dns(){
	DNS="$DNS $1"
}

addressing_static() {
	if [ -z "$ADDRESSES" ]; then
		echo $IFNAME: ERROR: Missing ADDRESSES
		exit 1
	else
		for IPADDR in $ADDRESSES; do
			echo $IFNAME: adding $IPADDR
			ip addr add "$IPADDR" dev "$IFNAME"
			CLEANUP_CMDS="ip addr del \"$IPADDR\" dev \"$IFNAME\" ; $CLEANUP_CMDS"
		done
		
		for DNSADDR in $DNS; do
			echo $IFNAME: adding dns server $DNSADDR
			CLEANUP_CMDS="ip addr del \"$IPADDR\" dev \"$IFNAME\" ; $CLEANUP_CMDS"
			echo "nameserver $DNSADDR" >> /etc/resolv.conf
		done
		
		
	fi
}
