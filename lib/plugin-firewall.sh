
init_firewall() {
	echo Firewall: Plugin loaded
}

newif_firewall() {
	FWRULES=true
	iptables --table nat --new-chain ${IFNAME}-prerouting
	iptables --table nat --new-chain ${IFNAME}-postrouting
	iptables --table nat --new-chain ${IFNAME}-in
	iptables --table nat --new-chain ${IFNAME}-out
	iptables --table nat --insert PREROUTING --in-interface $IFNAME --jump ${IFNAME}-prerouting
	iptables --table nat --insert POSTROUTING --out-interface $IFNAME --jump ${IFNAME}-postrouting
	iptables --table nat --insert INPUT --in-interface $IFNAME --jump ${IFNAME}-in
	iptables --table nat --insert OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out
	iptables --table filter --new-chain ${IFNAME}-in
	iptables --table filter --new-chain ${IFNAME}-out
	iptables --table filter --insert INPUT --in-interface $IFNAME --jump ${IFNAME}-in
	iptables --table filter --insert OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out
}

# usage:
#  firewall <table> <chain> <target> <rules>...
# tables can be:
#  ip-* for normal iptables
#  ip6-* for iptables6
#  eb-* for ebtables
firewall() {
	table=$1
	shift
	chain=${IFNAME}-$1
	shift
	target=$1
	shift
	case $table in
		ip-*)
			FWRULES="$FWRULES; iptables --table ${table#ip-} --append $chain --jump $target $@"
			;;
		ip6-*)
			FWRULES="$FWRULES; iptables6 --table ${table#ip-} --append $chain --jump $target $@"
			;;
		eb-*)
			FWRULES="$FWRULES; ebtables --table ${table#ip-} --append $chain --jump $target $@"
			;;
		*)
			echo firewall: $IFNAME: Unknown table $table
			;;
	esac
}

do_firewall() {
	echo $IFNAME: fwrules: $FWRULES
	# Execute rules
	eval $FWRULES
	CLEANUP_CMDS="
	iptables --table nat --delete INPUT --in-interface $IFNAME --jump ${IFNAME}-in;
	iptables --table nat --delete OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out;
	iptables --table nat --delete-chain ${IFNAME}-in;
	iptables --table nat --delete-chain ${IFNAME}-out;
	iptables --table filter --delete INPUT --in-interface $IFNAME --jump ${IFNAME}-in;
	iptables --table filter --delete OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out;
	iptables --table filter --delete-chain ${IFNAME}-in;
	iptables --table filter --delete-chain ${IFNAME}-out;
	iptables --table filter --delete INPUT --in-interface $IFNAME --jump ${IFNAME}-in
	iptables --table filter --delete OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out
	$CLEANUP_CMDS"
}
