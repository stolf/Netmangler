# usage:
#  pppoeif <parent-interface>
pppoeif() {
	parentif $1
}

# usage:
#  pppoeuser <username>
pppoeuser() {
	pppoe_user="$*"
}

# usage:
#  pppoepass <password>
pppoepass() {
	pppoe_pass="$*"
}

iftype_pppoe() {
	if [ -z "$PARENTIFS" ]; then
		echo $PARENTIFS: pppoe interface is not specified
		exit 1
	else
		echo $IFNAME: configuring pppoe interface $IFNAME on $PARENTIFS
		modprobe pppoe
		echo \"$pppoe_user\" \* \"$pppoe_pass\" >/etc/ppp/pap-secrets
		echo \"$pppoe_user\" \* \"$pppoe_pass\" >/etc/ppp/chap-secrets
		echo /sbin/ip addr set \"\$IFNAME\" name \"$IFNAME\" \
			>/etc/ppp/if-pre-up
		pppd \
			noauth \
			defaultroute \
			persist \
			noaccomp \
			default-asyncmap \
			user "$pppoe_user" \
			lcp-echo-interval 30 \
			lcp-echo-failure 5 \
			linkname $IFNAME \
			maxfail 0 \
			persist \
			usepeerdns \
			plugin rp-pppoe.so $PARENTIFS \
			ifname "$IFNAME" 			
		CLEANUP_CMDS="kill \$(cat /tmp/ppp-$IFNAME.pid); $CLEANUP_CMDS"
	fi
}
