init_iwpriv() {
	echo iwpriv: Plugin loaded
}

newif_iwpriv() {
	IWPRIV_CMDS="true"
}

iwpriv_option(){
	IWPRIV_CMDS="$IWPRIV_CMDS ; iwpriv $IFNAME $*"
}

do_iwpriv() {
	case "$IFTYPE" in
		athvap) ;;
		athmaster) ;;
		ahdemo) ;;
		athsta) ;;
		*) 
			echo iwpriv: Interface $IFTYPE is not supported
			;;
	esac
	eval $IWPRIV_CMDS
}


