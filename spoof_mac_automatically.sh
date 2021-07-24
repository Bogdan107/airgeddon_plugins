#!/usr/bin/env bash

# spoof_mac_automatically airgeddon plugin

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
plugin_AIRGEDDON_DO_NOT_SPOOF_MAC_ADDRESS_AUTOMATIC=0

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

# Spoof MAC-address before DoS pursuit mode attacks.
function spoof_mac_automatically_override_et_prerequisites() {

    debug_print

    if [ ${retry_handshake_capture} -eq 1 ]; then
        return
    fi

    clear
    if [ -n "${enterprise_mode}" ]; then
        current_menu="enterprise_attacks_menu"
        case ${enterprise_mode} in
            "smooth")
                language_strings "${language}" 522 "title"
            ;;
            "noisy")
                language_strings "${language}" 523 "title"
            ;;
        esac
    else
        current_menu="evil_twin_attacks_menu"
        case ${et_mode} in
            "et_onlyap")
                language_strings "${language}" 270 "title"
            ;;
            "et_sniffing")
                language_strings "${language}" 291 "title"
            ;;
            "et_sniffing_sslstrip2")
                language_strings "${language}" 292 "title"
            ;;
            "et_sniffing_sslstrip2_beef")
                language_strings "${language}" 397 "title"
            ;;
            "et_captive_portal")
                language_strings "${language}" 293 "title"
            ;;
        esac
    fi

    print_iface_selected
    if [ -n "${enterprise_mode}" ]; then
        print_all_target_vars
    else
        print_et_target_vars
        print_iface_internet_selected
    fi

    if [ "${dos_pursuit_mode}" -eq 1 ]; then
        language_strings "${language}" 512 "blue"
    fi
    print_hint ${current_menu}
    echo

    if [ "${et_mode}" != "et_captive_portal" ]; then
        language_strings "${language}" 275 "blue"
        echo
        language_strings "${language}" 276 "yellow"
        print_simple_separator
        ask_yesno 277 "yes"
        if [ "${yesno}" = "n" ]; then
            if [ -n "${enterprise_mode}" ]; then
                return_to_enterprise_main_menu=1
            else
                return_to_et_main_menu=1
                return_to_et_main_menu_from_beef=1
            fi
            return
        fi
    fi

    if [ ${plugin_AIRGEDDON_DO_NOT_SPOOF_MAC_ADDRESS_AUTOMATIC} -eq 1 ]; then
        ask_yesno 419 "no"
        if [ "${yesno}" = "y" ]; then
            mac_spoofing_desired=1
        fi
    else
        spoof_mac_automatically
    fi

    if [ "${et_mode}" = "et_captive_portal" ]; then

        language_strings "${language}" 315 "yellow"
        echo
        language_strings "${language}" 286 "pink"
        print_simple_separator
        if [ ${retrying_handshake_capture} -eq 0 ]; then
            ask_yesno 321 "no"
        fi

        local msg_mode
        msg_mode="showing_msgs_checking"

        if [[ ${yesno} = "n" ]] || [[ ${retrying_handshake_capture} -eq 1 ]]; then
            msg_mode="silent"
            capture_handshake_evil_twin
            case "$?" in
                "2")
                    retry_handshake_capture=1
                    return
                ;;
                "1")
                    return_to_et_main_menu=1
                    return
                ;;
            esac
        else
            ask_et_handshake_file
        fi
        retry_handshake_capture=0
        retrying_handshake_capture=0

        if ! check_bssid_in_captured_file "${et_handshake}" "${msg_mode}" "also_pmkid"; then
            return_to_et_main_menu=1
            return
        fi

        echo
        language_strings "${language}" 28 "blue"

        echo
        language_strings "${language}" 26 "blue"

        echo
        language_strings "${language}" 31 "blue"
    else
        if ! ask_bssid; then
            if [ -n "${enterprise_mode}" ]; then
                return_to_enterprise_main_menu=1
            else
                return_to_et_main_menu=1
                return_to_et_main_menu_from_beef=1
            fi
            return
        fi

        if ! ask_channel; then
            if [ -n "${enterprise_mode}" ]; then
                return_to_enterprise_main_menu=1
            else
                return_to_et_main_menu=1
            fi
            return
        else
            if [[ "${dos_pursuit_mode}" -eq 1 ]] && [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]] && [[ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]]; then
                echo
                language_strings "${language}" 394 "red"
                language_strings "${language}" 115 "read"
                if [ -n "${enterprise_mode}" ]; then
                    return_to_enterprise_main_menu=1
                else
                    return_to_et_main_menu=1
                fi
                return
            fi
        fi
        ask_essid "noverify"
    fi

    if [ -n "${enterprise_mode}" ]; then
        manage_enterprise_log
    elif [[ "${et_mode}" = "et_sniffing" ]]; then
        manage_ettercap_log
    elif [[ "${et_mode}" = "et_sniffing_sslstrip2" ]] || [[ "${et_mode}" = "et_sniffing_sslstrip2_beef" ]]; then
        manage_bettercap_log
    elif [ "${et_mode}" = "et_captive_portal" ]; then
        manage_captive_portal_log
        language_strings "${language}" 115 "read"
        if set_captive_portal_language; then
            language_strings "${language}" 319 "blue"
        else
            return
        fi
    fi

    if [ -n "${enterprise_mode}" ]; then
        return_to_enterprise_main_menu=1
    else
        return_to_et_main_menu=1
        return_to_et_main_menu_from_beef=1
    fi

    if [ "${is_docker}" -eq 1 ]; then
        echo
        if [ -n "${enterprise_mode}" ]; then
            language_strings "${language}" 528 "pink"
        else
            language_strings "${language}" 420 "pink"
        fi
        language_strings "${language}" 115 "read"
    fi

    if [[ "${channel}" -gt 14 ]]; then
        echo
        language_strings "${language}" 392 "blue"
    fi

    echo
    language_strings "${language}" 296 "yellow"
    language_strings "${language}" 115 "read"
    prepare_et_interface

    if [ -n "${enterprise_mode}" ]; then
        exec_enterprise_attack
    else
        case ${et_mode} in
            "et_onlyap")
                exec_et_onlyap_attack
            ;;
            "et_sniffing")
                exec_et_sniffing_attack
            ;;
            "et_sniffing_sslstrip2")
                exec_et_sniffing_sslstrip2_attack
            ;;
            "et_sniffing_sslstrip2_beef")
                exec_et_sniffing_sslstrip2_beef_attack
            ;;
            "et_captive_portal")
                exec_et_captive_portal_attack
            ;;
        esac
    fi
}
