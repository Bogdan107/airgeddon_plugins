#!/usr/bin/env bash

# Regdomain airgeddon plugin

# Version:    0.1
# Author:     Bogdan107
# Repository: https://github.com/Bogdan107/airgeddon-plugins
# License:    GNU General Public License v3.0, https://opensource.org/licenses/GPL-3.0

#Global shellcheck disabled warnings
#shellcheck disable=SC2034,SC2154

###### GENERIC PLUGIN VARS ######

plugin_name="Auto-spoof MAC address"
plugin_description="Automatically spoof MAC-address in front of critical moments that can betray the pentester"
plugin_author="Bogdan107"

plugin_enabled=1

###### CUSTOM FUNCTIONS ######

function spoof_mac_automatically() {
    option_counter=0
    for interfaceName in ${ifaces}; do
        option_counter=$((option_counter + 1))
        if [[ "${iface}" = "${option_counter}" ]]; then
            interface_mac=$(set_spoofed_mac "${interfaceName}")
            break
        fi
    done   
}

###### PLUGIN REQUIREMENTS ######

plugin_minimum_ag_affected_version="10.0"
plugin_maximum_ag_affected_version=""

plugin_distros_supported=("*")

# Spoof MAC-address after each interface selection action.
function spoof_mac_automatically_posthook_select_interface() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address after each interface selection action.
# Used for losing MAC-address, which compromised by attack with previously selected interface.
function spoof_mac_automatically_prehook_select_interface() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address at application exit
# Used for losing MAC-address, which compromised by attack with last selected interface.
function spoof_mac_automatically_prehook_exit_script_option() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address before WPS-attack.
function spoof_mac_automatically_prehook_set_wps_attack_script() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address before WEP-attack.
function spoof_mac_automatically_prehook_set_wep_script() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address before DoS pursuit mode attacks.
function spoof_mac_automatically_prehook_et_prerequisites() {
    debug_print
    spoof_mac_automatically
}

# Spoof MAC-address before amok-, aireplay-, wids-, flood- and some other attacks:
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
