init_iwpriv() {
	echo iwpriv: Plugin loaded
	
	IWPRIV_CMDS=""
}

iwpriv_option(){
	IWPRIV_CMDS="$IWPRIV_CMDS ; iwpriv $IFNAME $*"
}

do_iwpriv() {
	eval $IWPRIV_CMDS
}


