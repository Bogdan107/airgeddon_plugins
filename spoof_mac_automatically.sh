#!/usr/bin/env bash

#Global shellcheck disabled warnings
#shellcheck disable=SC2034,SC2154

#Start modifying below this line. You can safely remove comments but be pretty sure to know what you are doing!

###### GENERIC PLUGIN VARS ######

plugin_name="Auto-spoof MAC address"
plugin_description="Automatically spoof MAC-address in front of critical moments that can betray the pentester"
plugin_author="Bogdan107"

plugin_enabled=1

###### CUSTOM FUNCTIONS ######
function spoof_mac_automatically() {
    option_counter2=0
    for item2 in ${ifaces}; do
        option_counter2=$((option_counter2 + 1))
        if [[ "${iface}" = "${option_counter2}" ]]; then
            interface=${item2}
            interface_mac=$(set_spoofed_mac "${interface}")
            break
        fi
    done   
}

###### PLUGIN REQUIREMENTS ######

plugin_minimum_ag_affected_version="10.0"
plugin_maximum_ag_affected_version=""

plugin_distros_supported=("*")

# Spoof MAC-address after each interface selection action:
function spoof_mac_automatically_posthook_select_interface() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address before WPS-attack:
function spoof_mac_automatically_prehook_set_wps_attack_script() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address before WEP-attack:
function spoof_mac_automatically_prehook_set_wep_script() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address before DoS pursuit mode attacks:
function spoof_mac_automatically_prehook_et_prerequisites() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address before amok-, aireplay-, wids- and flood- attacks:
function spoof_mac_automatically_prehook_exec_mdkdeauth() {
    debug_print
    spoof_mac_automatically
}
function spoof_mac_automatically_prehook_exec_aireplaydeauth() {
    debug_print
    spoof_mac_automatically
}
function spoof_mac_automatically_prehook_exec_wdsconfusion() {
    debug_print
    spoof_mac_automatically
}
function spoof_mac_automatically_prehook_exec_beaconflood() {
    debug_print
    spoof_mac_automatically
}
function spoof_mac_automatically_prehook_exec_authdos() {
    debug_print
    spoof_mac_automatically
}
function spoof_mac_automatically_prehook_exec_michaelshutdown() {
    debug_print
    spoof_mac_automatically
}
