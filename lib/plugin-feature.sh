
init_feature() {
	echo Feature: Plugin loaded
}

newif_feature() {
	IFFEATURES="true"
}

if_feature() {
	IFFEATURES="$IFFEATURES; echo $2 >/proc/sys/net/ipv4/conf/$IFFNAME/$1"
}

do_feature() {
	echo $IFNAME: features: $IFFEATURES
	# Execute rules
	eval $IFFEATURES
}
