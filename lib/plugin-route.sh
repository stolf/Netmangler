
init_route() {
	echo route: Plugin loaded
}

newif_route() {
	ROUTE_CMDS=true
	ROUTE_CLEANUP=
}

route() {
	ROUTE_CMDS="$ROUTE_CMDS ; ip route add $*"
	ROUTE_CLEANUP="ip route del $*; $ROUTE_CLEANUP"
}

do_route() {
	echo $IFNAME: route commands: $ROUTE_CMDS
	echo $IFNAME: route cleanup commands: $ROUTE_CLEANUP
	eval $ROUTE_CMDS
	CLEANUP_CMDS="$ROUTE_CLEANUP $CLEANUP_CMDS"
}

