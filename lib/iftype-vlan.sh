vlanparentif() {
	parentif $1
}

vlan_tag(){
	VLAN="$1"
}

iftype_vlan() {
	for i in $PARENTIFS; do
		VLANNAME=${IFNAME#*.}
		VLAN=${VLAN:-$VLANNAME}
		#VLAN=${IFNAME#*.} #Took this out so we can configure VLAN tags without changing the NM filename
		echo $IFNAME: Configuring $IFNAME vlan $VLAN with a master interface of $i
		ERR=$(vconfig set_name_type DEV_PLUS_VID_NO_PAD) || echo $ERR >&2
		ERR=$(vconfig add $i $VLAN) || echo $ERR >&2
		CLEANUP_CMDS="vconfig rem $IFNAME &>/dev/null; $CLEANUP_CMDS"
	done
}

