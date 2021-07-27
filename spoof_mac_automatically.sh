#!/usr/bin/env bash

# spoof_mac_automatically airgeddon plugin

# Version:    0.2.5
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
function convert_iface_to_ifname() {
    local ifaceNumber="$1";

    option_counter=0
    for interfaceName in ${ifaces}; do
        option_counter=$((option_counter + 1))
        if [[ "${iface}" = "${option_counter}" ]]; then
            echo "${interfaceName}"
            break
        fi
    done
}
function spoof_mac_automatically() {
    # Restore original MAC-addresses:
    restore_spoofed_macs

    # Set new random MAC-address:
    local interfaceName=$(convert_iface_to_ifname ${iface})
    set_spoofed_mac "${interfaceName}"
}

###### PLUGIN REQUIREMENTS ######

plugin_minimum_ag_affected_version="10.42"
plugin_maximum_ag_affected_version=""

plugin_distros_supported=("*")

# Fix spoofed_mac restoring:
function spoof_mac_automatically_posthook_restore_spoofed_macs() {
    debug_print
    spoofed_mac=0
}

# Spoof MAC-address after each interface selection action.
function spoof_mac_automatically_posthook_select_interface() {
    debug_print
    spoof_mac_automatically
    interface_mac="${new_random_mac}"
}

# Spoof MAC-address before WPS-attack.
function spoof_mac_automatically_prehook_set_wps_attack_script() {
    debug_print
    spoof_mac_automatically
}
# Restore MAC-address after WPS-attack (custom PIN).
function spoof_mac_automatically_posthook_exec_wps_custom_pin_bully_attack() {
    debug_print
    restore_spoofed_macs
}
function spoof_mac_automatically_posthook_exec_wps_custom_pin_reaver_attack() {
    debug_print
    restore_spoofed_macs
}
# Restore MAC-address after WPS-attack (Pixie Dust).
function spoof_mac_automatically_posthook_exec_bully_pixiewps_attack() {
    debug_print
    restore_spoofed_macs
}
function spoof_mac_automatically_posthook_exec_reaver_pixiewps_attack() {
    debug_print
    restore_spoofed_macs
}
# Restore MAC-address after WPS-attack (bruteforce).
function spoof_mac_automatically_posthook_exec_wps_bruteforce_pin_bully_attack() {
    debug_print
    restore_spoofed_macs
}
function spoof_mac_automatically_posthook_exec_wps_bruteforce_pin_reaver_attack() {
    debug_print
    restore_spoofed_macs
}
# Restore MAC-address after WPS-attack (PIN database).
function spoof_mac_automatically_posthook_exec_wps_pin_database_bully_attack() {
    debug_print
    restore_spoofed_macs
}
function spoof_mac_automatically_posthook_exec_wps_pin_database_reaver_attack() {
    debug_print
    restore_spoofed_macs
}
# Restore MAC-address after WPS-attack (NULL PIN).
function spoof_mac_automatically_posthook_exec_reaver_nullpin_attack() {
    debug_print
    restore_spoofed_macs
}

# Spoof MAC-address for WEP-attack.
function spoof_mac_automatically_prehook_exec_wep_allinone_attack() {
    debug_print
    spoof_mac_automatically
}
function spoof_mac_automatically_posthook_exec_wep_allinone_attack() {
    debug_print
    restore_spoofed_macs
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
# Restore MAC-address after amok-, aireplay-, wids-, flood- and some other attacks:
function spoof_mac_automatically_posthook_exec_mdkdeauth() {
    debug_print
    restore_spoofed_macs
}
function spoof_mac_automatically_posthook_exec_aireplaydeauth() {
    debug_print
    restore_spoofed_macs
}
function spoof_mac_automatically_posthook_exec_wdsconfusion() {
    debug_print
    restore_spoofed_macs
}
function spoof_mac_automatically_posthook_exec_beaconflood() {
    debug_print
    restore_spoofed_macs
}
function spoof_mac_automatically_posthook_exec_authdos() {
    debug_print
    restore_spoofed_macs
}
function spoof_mac_automatically_posthook_exec_michaelshutdown() {
    debug_print
    restore_spoofed_macs
}

# Suppress ask for spoof MAC-address before DoS pursuit mode attacks.
function spoof_mac_automatically_prehook_et_prerequisites() {
    debug_print
    mac_spoofing_desired=1
}
