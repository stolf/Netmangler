
# Internal command to executa a command and output what failed
_iptables() {
	iptables $@ || echo Failed: iptables $@ 1>&2
}

init_firewall() {
	echo Firewall: Plugin loaded
	_iptables --table mangle --new-chain forward-out
	# nat doesn't have a forward chain
	_iptables --table filter --new-chain forward-out
}

newif_firewall() {
	FWRULES=true

	# mangle table rules
	_iptables --table mangle --new-chain ${IFNAME}-prerouting
	_iptables --table mangle --new-chain ${IFNAME}-in
	_iptables --table mangle --new-chain ${IFNAME}-out
	_iptables --table mangle --new-chain ${IFNAME}-postrouting
	_iptables --table mangle --new-chain ${IFNAME}-forward-in
	_iptables --table mangle --new-chain ${IFNAME}-forward-out

	_iptables --table mangle --insert PREROUTING --in-interface $IFNAME --jump ${IFNAME}-prerouting
	_iptables --table mangle --insert INPUT --in-interface $IFNAME --jump ${IFNAME}-in
	_iptables --table mangle --insert OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out
	_iptables --table mangle --insert POSTROUTING --out-interface $IFNAME --jump ${IFNAME}-postrouting
	_iptables --table mangle --insert FORWARD --in-interface $IFNAME --jump ${IFNAME}-forward-in
	_iptables --table mangle --insert forward-out --out-interface $IFNAME --jump ${IFNAME}-forward-out

	# NAT table rule
	_iptables --table nat --new-chain ${IFNAME}-prerouting
	_iptables --table nat --new-chain ${IFNAME}-postrouting
	_iptables --table nat --new-chain ${IFNAME}-out
	_iptables --table nat --insert PREROUTING --in-interface $IFNAME --jump ${IFNAME}-prerouting
	_iptables --table nat --insert POSTROUTING --out-interface $IFNAME --jump ${IFNAME}-postrouting
	_iptables --table nat --insert OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out

	# Filter table rules
	_iptables --table filter --new-chain ${IFNAME}-in
	_iptables --table filter --new-chain ${IFNAME}-out
	_iptables --table filter --new-chain ${IFNAME}-forward-in
	_iptables --table filter --new-chain ${IFNAME}-forward-out
	_iptables --table filter --insert INPUT --in-interface $IFNAME --jump ${IFNAME}-in
	_iptables --table filter --insert OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out
	_iptables --table filter --insert FORWARD --in-interface $IFNAME --jump ${IFNAME}-forward-in
	_iptables --table filter --insert forward-out --out-interface $IFNAME --jump ${IFNAME}-forward-out
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
	if [ "$chain" == "${IFNAME}-forward-in" -a "$target" == "ACCEPT"]; then
		target="forward-out"
	fi
	case $table in
		ip-*)
			FWRULES="$FWRULES; iptables --table ${table#ip-} --append $chain --jump $target $@"
			;;
		ip6-*)
			FWRULES="$FWRULES; iptables6 --table ${table#ip6-} --append $chain --jump $target $@"
			;;
		eb-*)
			FWRULES="$FWRULES; ebtables --table ${table#eb-} --append $chain --jump $target $@"
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
	_iptables --table mangle --delete PREROUTING --in-interface $IFNAME --jump ${IFNAME}-prerouting;
	_iptables --table mangle --delete INPUT --in-interface $IFNAME --jump ${IFNAME}-in;
	_iptables --table mangle --delete OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out;
	_iptables --table mangle --delete POSTROUTING --out-interface $IFNAME ${IFNAME}-postrouting;
	_iptables --table mangle --delete FORWARD --in-interface $IFNAME ${IFNAME}-forward-in;
	_iptables --table mangle --delete forward-out --out-interface $IFNAME ${IFNAME}-forward-out;
	_iptables --table mangle --delete-chain ${IFNAME}-prerouting;
	_iptables --table mangle --delete-chain ${IFNAME}-in;
	_iptables --table mangle --delete-chain ${IFNAME}-out;
	_iptables --table mangle --delete-chain ${IFNAME}-postrouting;
	_iptables --table mangle --delete-chain ${IFNAME}-forward-in;
	_iptables --table mangle --delete-chain ${IFNAME}-forward-out;

	_iptables --table nat --delete OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out;
	_iptables --table nat --delete PREROUTING --in-interface $IFNAME --jump ${IFNAME}-prerouting;
	_iptables --table nat --delete POSTROUTING --out-interface $IFNAME --jump ${IFNAME}-postrouting;
	_iptables --table nat --delete-chain ${IFNAME}-out;
	_iptables --table nat --delete-chain ${IFNAME}-prerouting;
	_iptables --table nat --delete-chain ${IFNAME}-postrouting;
	_iptables --table filter --delete INPUT --in-interface $IFNAME --jump ${IFNAME}-in;
	_iptables --table filter --delete OUTPUT --out-interface $IFNAME --jump ${IFNAME}-out;
	_iptables --table filter --delete FORWARD --in-interface $IFNAME --jump ${IFNAME}-forward-in;
	_iptables --table filter --delete forward-out --out-interface $IFNAME --jump ${IFNAME}-forward-out;
	_iptables --table filter --delete-chain ${IFNAME}-in;
	_iptables --table filter --delete-chain ${IFNAME}-out;
	_iptables --table filter --delete-chain ${IFNAME}-forward-in;
	_iptables --table filter --delete-chain ${IFNAME}-forward-out;
	$CLEANUP_CMDS"
}
