#!/usr/bin/zsh
# https://github.com/JumperPunk/bin/blob/master/xrandr-dmenu 
# Setup outputs with xrandr as a backend and dmenu as a frontend
#
# external commands: cat, cut, dmenu, grep, sed, xrandr
# Released under GPLv2
#
# TODO: add dpi support

typeset XRANDR_TXT # readonly; stdout of running xrandr without any options
typeset -A OUTPUT_CONFIGURED # key=connected output name
typeset -a DISCONNECT_OUTPUTS
typeset OPT_MODE='auto'
typeset OPT_ROTATION='normal'
typeset -ir EXIT_CLEAN=7
typeset -ir ERR_BAD_ARGS=257
typeset -ir ERR_BAD_SELECTION=258
typeset -ir ERR_NO_OPTIONS=259

if ! command -v cat &>/dev/null; then
  echo 'coreutils seem to be missing. You'\''re gonna have a bad time.' >&2
  exit 255
elif ! command -v grep &>/dev/null; then
  echo 'grep seems to be missing. You'\''re gonna have a bad time.' >&2
  exit 255
elif ! command -v xrandr &>/dev/null; then
  echo 'Ran xrandr-dmenu without xrandr? You'\''re gonna have a bad time.' >&2
  exit 255
elif ! command -v dmenu &>/dev/null; then
  echo 'Ran xrandr-dmenu without dmenu? You'\''re gonna have a bad time.' >&2
  exit 255
elif ! xset q &>/dev/null; then
  echo 'Woah there, cowboy! You need to run this from inside X!' >&2
  exit 1
fi

XRANDR_TXT="$(xrandr)" || exit $?

function () {
  typeset opt
  typeset output
  typeset help_msg="usage: xrandr-dmenu [options]
Setup X outputs position, mode, etc
Input 'exit' or press 'ESC' at any point to cancel.

Options:
  -m  Select mode for outputs
  -M  Use current mode for outputs
  -r  Select rotation for outputs
  -R  Use current rotation for outputs"

  while getopts mMrRh opt; do
    case "${opt}" in
      ('m') OPT_MODE='change' ;;
      ('M') OPT_MODE='no_change' ;;
      ('r') OPT_ROTATION='change' ;;
      ('R') OPT_ROTATION='no_change' ;;
      ('h')
        echo "${help_msg}"
        exit 0
        ;;
      ('?')
        echo "${help_msg}"
        exit 1
        ;;
    esac
  done

  for output in $(grep ' connected' <<< "${XRANDR_TXT}" | cut -d ' ' -f 1); do
    OUTPUT_CONFIGURED[${output}]='false'
  done
  for output ($(grep ' disconnected' <<< "${XRANDR_TXT}" | cut -d ' ' -f 1)) {
    DISCONNECTED_OUTPUTS+=("${output}")
  }
} "$@"

typeset -r XRANDR_TXT
typeset -r OPT_MODE
typeset -r OPT_ROTATION
typeset -r DISCONNECTED_OUTPUTS

function main() {
  typeset prompt
  typeset menu
  typeset output
  typeset mode
  typeset rotation
  typeset position
  typeset xrandr_cmd

  # set primary output
  prompt='Select primary output:'
  output="$(menu_select "${prompt}" ${(k)=OUTPUT_CONFIGURED})" || bail $?

  position='--primary'
  mode="$(select_mode ${output})" || bail $?
  rotation="$(select_rotation ${output})" || bail $?

  OUTPUT_CONFIGURED[${output}]='true'
  xrandr_cmd="xrandr --output ${output} ${position} ${rotation} ${mode}"

  # set additional outputs
  prompt='Select next output:'
  while ! all_outputs_configured; do
    menu="$(list_unconfigured_outputs)"
    output="$(menu_select ${prompt} ${=menu})" || bail $?

    position="$(select_position ${output})" || bail $?
    if [[ "${position}" != '--off' ]]; then
      mode="$(select_mode ${output})" || bail $?
      rotation="$(select_rotation ${output})" || bail $?
    fi

    OUTPUT_CONFIGURED[${output}]='true'
    xrandr_cmd+=" --output ${output} ${position} ${rotation} ${mode}"
  done

  # forcibly '--off' disconnected outputs
  for output in ${DISCONNECTED_OUTPUTS}; do
    xrandr_cmd+=" --output ${output} --off"
  done

  # do the deed
  if ! ${=xrandr_cmd}; then
    echo "Failed to execute xrandr command:\n${xrandr_cmd}"
    bail 255
  fi
}

################################################################################
# Uses dmenu to select the position of a given output relative to an already
# configured output. --same-as and --off are considered a position.
# Prints in the form of xrandr option (eg, '--right-of DP1') to stdout
# Global variables:
#  ERR_BAD_ARG
# Arguments:
#  $1=name of output to configure
# Returns:
#  ERR_BAD_ARG for no $1
################################################################################
function select_position() {
  [[ -z $1 ]] && return "${ERR_BAD_ARG}"

  typeset output
  typeset prompt
  typeset -a menu
  typeset anchor
  typeset position
  typeset selection
  output="$1"
  prompt="Select position of ${output}:"

  for anchor in $(list_configured_outputs); do
    for position in 'left of' 'right of' 'above' 'below' 'same as'; do
      menu+=("${position} ${anchor}")
    done
  done
  menu+=('off')
  selection="$(menu_select "${prompt}" ${menu})" || return $?

  case "${selection[(w)1]}" in
    (left|right|same) echo "--${selection/ /-}" ;;
    (above|below|mirror|off) echo "--${selection}" ;;
  esac
}

################################################################################
# Uses dmenu to display the detected mode options for a given output and lets
# the user select a mode to use. Prints choice in xrandr option format
# (eg, '--mode 800x600' or '--auto') to stdout
# Global variables:
#  XRANDR_TXT
#  OPT_MODE
#  ERR_BAD_ARGS
# Arguments:
#  $1 - name of which output we are working with
# Returns:
#  ERR_BAD_ARGS
################################################################################
function select_mode() {
  [[ -z $1 ]] && return "${ERR_BAD_ARGS}"

  typeset output
  typeset prompt
  typeset menu
  typeset selection
  output="$1"
  prompt="Select mode for ${output}:"


  if [[ "${OPT_MODE}" == 'auto' ]]; then
    echo '--auto'
  elif [[ "${OPT_MODE}" == 'no_change' ]]; then
    echo ''
  else
    # TODO: make this not ugly. A better sed should negate the need for cut/grep
    menu="$(echo \"${XRANDR_TXT}\" \
      | sed -n '/^'${output}' /,/^[^ ]/ s/ * //p' \
      | cut -d ' ' -f 1 \
      | grep x \
      | cat <(echo auto) -)"

    selection="$(menu_select "${prompt}" ${=menu})" || return $?

    if [[ 'auto' == "${selection}" ]]; then
      echo '--auto'
    else
      echo "--mode ${selection}"
    fi
  fi
}

################################################################################
# Uses dmenu to select the rotation of a given output. Prints the selection in
# xrandr option format (eg '--rotate inverted') to stdout
# Global variables:
#  OPT_ROTATION
#  ERR_BAD_ARGS
# Arguments:
#  $1 - name of which output we are working with
# Returns:
#  ERR_BAD_ARGS
################################################################################
function select_rotation() {
  [[ -z $1 ]] && return "${ERR_BAD_ARGS}"

  typeset menu
  typeset prompt
  prompt="Select rotation of $1:"
  menu=('normal' 'inverted' 'left' 'right')

  if [[ "${OPT_ROTATION}" == 'normal' ]]; then
    echo '--rotate normal'
  elif [[ "${OPT_ROTATION}" == 'no_change' ]]; then
    echo ''
  else
    echo -n "--rotate ${selection}"
    menu_select "${prompt}" ${menu} || return $?
  fi
}

################################################################################
# Uses dmenu to select an option. Undisplayed 'exit' option or pressing 'ESC'
# will return code ${EXIT_CLEAN} to trigger an abort to the script. Validates to
# make sure the selection is an option. If there is only 1 option, it will
# automatically choose it. Prints selection to stdout
# Global variables:
#  none
# Arguments:
#  $1=prompt
#  $2+=menu items
# Returns:
#  ERR_BAD_ARGS=bad arguments
#  EXIT_CLEAN=user requested exit
################################################################################
function menu_select() {
  [[ -z "$2" ]] && return ${ERR_BAD_ARGS}

  typeset selection
  typeset item
  typeset prompt
  typeset -a menu

  prompt="$1"
  shift
  menu=($*)

  if [[ ${#menu} == 1 ]]; then
    echo "${menu}"
  else
    while [[ -z "${menu[(r)${selection}]}" ]]; do
      echo "${(F)menu}" | dmenu -p "${prompt}" | read selection
      [[ "${(L)selection}" == 'exit' ]] || [[ -z "${selection}" ]] \
        && return ${EXIT_CLEAN}
    done
    echo "${selection}"
  fi
}

function list_configured_outputs() {
  typeset -a list
  typeset output

  for output in ${(k)OUTPUT_CONFIGURED}; do
    ${OUTPUT_CONFIGURED[$output]} && list+=("${output}")
  done
  echo "${(F)list}"
}

function list_unconfigured_outputs() {
  typeset -a list
  typeset output

  for output in ${(k)OUTPUT_CONFIGURED}; do
    ${OUTPUT_CONFIGURED[$output]} || list+=("${output}")
  done
  echo "${(F)list}"
}

function all_outputs_configured() {
  typeset config

  for config in ${OUTPUT_CONFIGURED}; do
    $config || return 257
  done

  return 0
}

function bail() {
  [[ "$1" == ${EXIT_CLEAN} ]] && exit 0 || exit "$1"
}

main

################################################################################
# vim filetype=zsh autoindent expandtab shiftwidth=2 tabstop=2
# End
#
