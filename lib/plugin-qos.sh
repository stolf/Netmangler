init_qos() {
	echo qos: Plugin loaded
}

newif_qos() {
	CLASS_ID=0
	PARENT_ID=
	PARENT_QDISC=
	QOS_CMDS=true
}

# usage:
# queue <qtype> <qargs>
queue() {
	CLASS_ID=$[ $CLASS_ID + 1 ]
	QOS_CMDS="$QOS_CMDS; tc queue add dev $IFNAME parent $[ $PARENT_QDISC + 1 ]:$PARENT_CLASS classid $[ $PARENT_QDISC + 1 ]:$[ $CLASS_ID + 0 ] $@"
}

# usage:
#  class <classtype> <cargs>
#  ...
#  end_class
class() {
	CLASS_STACK="$CLASS_STACK $PARENT_CLASS $CLASS_ID"
	PARENT_CLASS=$CLASS_ID

	CLASS_ID=$[ $CLASS + 1 ]

	QOS_CMD="$QOS_CMDS; tc class add dev $IFNAME parent $[ $PARENT_QDISC + 1 ]:$PARENT_CLASS classid $[ $PARENT_QDISC + 1 ]: $[ $CLASS_ID + 1 ] $@"
}

end_class() {
	read PARENT_CLASS CLASS_ID CLASS_STACK <<< CLASS_STACK
}

# usage:
#  match <rules>
match() {
	QOS_CMD="$QOS_CMDS; tc filter add dev $IFNAME parent $[ $QDISC + 1 ]:0 protocol ip prio 10 $@ flow_id $[ $QDISC + 1 ]:$[ $CLASS_ID + 0 ]"
}


do_qos() {
	echo $IFNAME: qos cmds: $QOS_CMD
}

