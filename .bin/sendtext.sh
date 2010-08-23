#!/bin/bash
#
# sendtext
#
# a commandline text sender to a number of carriers with
# quasi-phonebook support -- uses existing mail binary
# to send the message
#
# pbrisbin 2010
#
# brisbin v3: http://pbrisbin.com:8080/bin/sendtext             added phonebook/multi
# ghost   v2: http://pasteit.ghost1227.com/162                  added carriers
# brisbin v1: http://pbrisbin.com:8080/pages/text_from_cli.html verizon only
#
###

errorout () { echo "error $*"; exit 1; }

usage() {
  echo "usage: (echo message |) sendtext [-m] [--<carrier>] [-s <number> <name> | <number> | <name>] (<message>)"
  echo
  echo "  -m  split and send multiple messages if over 160 characters"
  echo "  -s  save <name> and <number> to a phonebook"
  echo
  echo "  available carriers:"
  echo "    --alltel --att --boost --cricket"
  echo "    --net10 --nextel --sprint --tmobile"
  echo "    --uscell --verizon (default) --virgin"
  echo
  exit 1
}

add_entry() { echo "$1|$number|$service" >> "$phonebook"; }

find_entry() {
  local IFS='|' name="$1" _name _number _service

  read -r _name _number _service < <(tac "$phonebook" | grep -m 1 "^$name|" 2>/dev/null)

  [ -n "$_number" ] && number="$_number" || errorout "$name: no number matched"

  [ -n "$_service" ] && service="$_service"
}

set_number() {
  [ -n "${number//[0-9]/}" ] && find_entry "$number"
  [ -n "${number//[0-9]/}" ] && errorout "$number: invalid number"

  [ "${#number}" -eq 9 ]  && number="1$number"
  [ "${#number}" -ne 10 ] && errorout "$number: invalid number"
}

send() {
  local message="$*"

  #echo "would send \"$message\" to \"$number\" on \"$service\""
  echo $message | mail "$number@$service"

  [ $? -eq 0 ] && echo "($count/$total) message successfully sent to $number"
}

send_one() {
  [ -z "$message" ] && errorout 'no message to send'
  [ "${#message}" -gt 160 ] && errorout 'message length is over 160 chars'

  send "$message"
}

send_multi() {
  local len="${#message}" string='' i

  [ -z "$message" ] && errorout 'no message to send'

  if [ $len -le 160 ]; then
    send "$message"
    return
  fi

  # set total required
  [ $((len%160)) -eq 0 ] && total=$((len/160)) || total=$((len/160+1))

  # read message char by char
  for ((i=0; i<$len; i++)); do
    string="$string${message:i:1}"

    # send/reset when we hit 160
    if [ "${#string}" -eq 160 ]; then
      send "$string"
      string=''
      count=$((count+1))
    fi
  done

  # send any leftover text
  [ -n "$string" ] && send "$string"
}

# TODO: better error message
which mail &>/dev/null || errorout 'you gots no mail'

# service:
#
# the default service is verizon; pass --service to override
###
service='vtext.com'

# phone book support:
#
# new option -s <number> <name> (<message>)
#
# saves name and number to text file $phonebook. pass name in place of
# number in a normal send and the most recent match in $phonebook will
# be used. the service used when -s is passed is also saved/reused
###
phonebook="$HOME/.sendtext.pb"
add=false

# multi-text support:
#
# pass -m to allow messages greater than 160 to be split and sent as
# separate messages -- script errors otherwise
###
allowmulti=false

while [ -n "$1" ]; do
  case "$1" in 
    -h|--help)     usage                                    ;;
    --alltel)      shift; service='message.alltel.com'      ;;
    --att|--net10) shift; service='txt.att.com'             ;;
    --boost)       shift; service='myboostmobile.com'       ;;
    --cricket)     shift; service='mms.mycricket.com'       ;;
    --nextel)      shift; service='messaging.nextel.com'    ;;
    --sprint)      shift; service='messaging.sprintpcs.com' ;;
    --tmobile)     shift; service='tmomail.net'             ;;
    --uscell)      shift; service='email.uscc.net'          ;;
    --verizon)     shift; service='vtext.com'               ;;
    --virgin)      shift; service='vmobl.com'               ;;
    -s|--save)     shift; add=true                          ;;
    -m|--multi)    shift; allowmulti=true                   ;;
    --)            shift; break                             ;;
    -*)            errorout "invalid option $1"             ;;
    --*)           errorout "invalid option $1"             ;;
    *)             break                                    ;;
  esac
done

number="${1//-/}"; shift
set_number

if $add; then
  add_entry "$1"; shift
fi

message="${*:-$(cat /dev/stdin)}"

count=1
total=1

$allowmulti && send_multi || send_one
