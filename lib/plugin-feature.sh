
init_feature() {
	echo Feature: Plugin loaded
}

newif_feature() {
	IFFEATURES="true"
}

if_feature() {
	IFFEATURES="$IFFEATURES; echo $2 >/proc/sys/net/ipv4/conf/$IFFNAME/$1"
}

do_firewall() {
	echo $IFNAME: features: $IFFEATURES
	# Execute rules
	eval $IFFEATURES
}
