init_hostapd() {                                                                
        echo hostapd: Plugin loaded                                             
}                                                                               
                                                                                
newif_hostapd() {                                                               
        _hostapd_bridge=                                                        
        _hostapd_driver=                                                        
        _hostapd_ssid=                                                          
        _hostapd_hw_mode=g                                                      
        _hostapd_channel=                                                       
        _hostapd_wpa=2                                                          
        _hostapd_wpa_passphrase=                                                
        _hostapd_wpa_key_mgmt=WPA-PSK                                           
        _hostapd_wpa_pairwise=CCMP                                              
        _hostapd_wpa_group_rekey=600                                            
        _hostapd_wpa_gmk_rekey=86400                                            
}                                                                               
                                                                                
hostapd_bridge() {                                                              
        _hostapd_bridge=$1                                                      
}                                                                               
                                                                                
hostapd_driver() {                                                              
        _hostapd_driver=$1                                                      
}                                                                               
hostapd_ssid() {                                                                
        _hostapd_ssid=$1                                                        
}                                                                               
hostapd_hw_mode() {                                                             
        _hostapd_hw_mode=$1                                                     
}
hostapd_channel() {                                                             
        _hostapd_channel=$1
}                                                                               
hostapd_wpa() {                                                                 
        _hostapd_wpa=$1                                                         
}                                                                               
hostapd_wpa_passphrase() {                                                      
        _hostapd_wpa_passphrase=$1                                              
}                                                                               
hostapd_wpa_key_mgmt() {                                                        
        _hostapd_wpa_key_mgmt=$1                                                
}                                                                               
hostapd_wpa_pairwise() {                                                        
        _hostapd_wpa_pairwise=$1                                                
}
hostapd_wpa_group_rekey() {                                                     
        _hostapd_wpa_group_rekey=$1                                             
}                                                                               
hostapd_wpa_gmk_rekey() { 
        _hostapd_wpa_gmk_rekey=$1
}
                                                                                

do_hostapd() {
        if [ ! -z "${_hostapd_driver}" ]; then
                echo $IFNAME: hostapd configuring
                cat >/tmp/$IFNAME.hostapd <<EOF
interface=${IFNAME}
bridge=${_hostapd_bridge}
driver=${_hostapd_driver}
ssid=${_hostapd_ssid}
hw_mode=${_hostapd_hw_mode}
channel=${_hostapd_channel}
wpa=${_hostapd_wpa}
wpa_passphrase=${_hostapd_wpa_passphrase}
wpa_key_mgmt=${_hostapd_wpa_key_mgmt}
wpa_pairwise=${_hostapd_wpa_pairwise}
wpa_group_rekey=${_hostapd_wpa_group_rekey}
wpa_gmk_rekey=${_hostapd_wpa_gmk_rekey}
EOF
                # We add starting hostapd to the TODO file, as the bridge needs to be completed before
                # hostapd is started if it is on a bridge
                echo hostapd -B -P /tmp/$IFNAME.hostapd_pid /tmp/$IFNAME.hostapd >>$STATEDIR/TODO
                CLEANUP_CMDS="kill \$(cat /tmp/$IFNAME.hostapd_pid); $CLEANUP_CMDS"
        fi
}
