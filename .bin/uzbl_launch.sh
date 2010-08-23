#!/bin/bash
#
# pbrisbin 2010
#
# an all around launcher that auto-adds http://, checks
# if it should be file://, and passes non-urls/non-files
# off to google directly. also works when called from
# CLI.
#
# @cbind o<uri:>_ spawn @scripts_dir/launch our %r
# @cbind O<uri:>_ spawn @scripts_dir/launch new %r
#
# /scripts/launch new "$url"
#
###

. "$(dirname "$0")/common"

# check if a scheme was passed
has_scheme() {
  string="$target_url"

  # contains '://' -> has scheme
  [[ "$string" != "${string/\:\/\//}" ]] && return 0

  return 1
}

# check if a file exists
is_a_file() {
  string="$(rel2abs "$target_url")"

  # doesn't exist -> not a file
  if [[ -e "$string" ]]; then
    target_url="$string"
    return 0
  fi

  return 1
}

# check that it's a search term
not_a_url() {
  string="$target_url"
  
  # spaces -> not a url
  [[ "$string" != "${string// /}" ]] && return 0

  # no dots -> not a url
  [[ "$string" != "${string//./}" ]] || return 0

  return 1
}

launch_url() {
  # no url -> use home
  target_url="${target_url:-$home_uri}"

  # if a scheme is passed, use URL as is
  if has_scheme; then
    target_url="$target_url"

  # if a file exists, use file://URL
  elif is_a_file; then
    target_url="file://$target_url"

  # if URL contains spaces and/or no dots, google it
  elif not_a_url; then
    target_url="http://www.google.com/search?q=${target_url// /+}"

  # otherwise add http://
  else
    target_url="http://$target_url"

  fi

  # open in new window or our window
  case $launch_mode in
    our) echo "uri $target_url" | to_socket &>/dev/null & ;;
    new) $uzbl $uzbl_opts -u "$target_url" &>/dev/null &  ;;
  esac
}

launch_mode="${args[0]}"
target_url="${args[1]}"

launch_url
