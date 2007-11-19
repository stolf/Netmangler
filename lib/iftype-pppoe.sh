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
		pppd \
			noauth \
			defaultroute \
			persist \
			noaccomp \
			default-asyncmap \
			user "$pppoe_user" \
			plugin rp-pppoe.so $PARENTIFS \
			linkname "$IFNAME"
		CLEANUP_CMDS="kill \$(</var/run/ppp-$IFNAME.pid); $CLEANUP_CMDS"
	fi
}
