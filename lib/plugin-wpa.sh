init_wpa() {
	echo wpa: Plugin loaded
}

newif_wpa() {
	_wpa_identity=
	_wpa_password=
	_wpa_driver=
	_wpa_ssid=
	_wpa_client_cert=
	_wpa_private_key=
	_wpa_key_mgmt=
	_wpa_eap=TLS
	_wpa_priority=
	_wpa_phase2=
	_wpa_proto=
}

wpa_identity() { 
	_wpa_identity=$1
}

wpa_password() {
	_wpa_password=$1
}

wpa_driver() {
	_wpa_driver=$1
}

wpa_ssid() {
	_wpa_ssid=$1
}

wpa_client_cert() {
	_wpa_client_cert=$1
}

wpa_private_key() {
	_wpa_private_key=$1
}

wpa_key_mgmt() {
	_wpa_key_mgmt=$1
}

wpa_eap() {
	_wpa_key_eap=$1
}

wpa_priority() {
	_wpa_priority=$1
}

wpa_phase2() {
	_wpa_phase2=$1
}

wpa_pairwise() {
	_wpa_pairwise=$1
}

wpa_group() {
	_wpa_group=$1
}

wpa_ca_cert() {
	_wpa_ca_cert=$1
}

wpa_private_key_passwd() {
	_wpa_private_key_passwd=$1
}

wpa_proto() {
	_wpa_proto="$1"
}

do_wpa() {
	if [ ! -z "${_wpa_driver}" ]; then
		echo $IFNAME: wpa configuring
		cat >/tmp/$IFNAME.wpa <<EOF
		network={
			ssid="${_wpa_ssid}"
			key_mgmt=${_wpa_key_mgmt}
			identity="${_wpa_identity}"
			password="${_wpa_password}"
			proto=${_wpa_proto}
			pairwise=${_wpa_pairwise}
			group=${_wpa_group}
			eap=${_wpa_eap}
			client_cert="${_wpa_client_cert}"
			private_key="${_wpa_private_key}"
			private_key_passwd="${_wpa_private_key_passwd}"
		}
EOF
		wpa_supplicant -i$IFNAME -c /tmp/$IFNAME.wpa -P /tmp/$IFNAME.wpa_pid -B
		CLEANUP_CMDS="kill \$(</tmp/$IFNAME.wpa_pid); $CLEANUP_CMDS"
	fi
}
