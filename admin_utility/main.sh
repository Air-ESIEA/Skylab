#!/bin/bash
#
#   _____     _        _____
#  |     |___|_|___   |     |___ ___ _ _
#  | | | | .'| |   |  | | | | -_|   | | |
#  |_|_|_|__,|_|_|_|  |_|_|_|___|_|_|___|
#
#                             Version 0.1
#
#  --------------- Paul Mercier-Handisyde
#  ---------------- p.mercier.h@gmail.com
#  ------------- Last Edited : 05.12.2018
#

# Check availability of dialog utility
which dialog &> /dev/null
[ $? -ne 0 ]  && echo "Dialog utility is not available, Install it" && exit 1

# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$

# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$

# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

# script location
MYDIR="$(dirname "$0")"
MYSCRIPTSDIR="$MYDIR"/functions

# log all errors
ERRORLOG="$MYDIR"/error_log
exec 2> $ERRORLOG

BTITLE="Admin Utilitary"

# include functions script
. $MYSCRIPTSDIR/functions_display.sh
. $MYSCRIPTSDIR/functions_users.sh

# check for root permissions
if [ "$EUID" -ne 0 ]; then
  echo -e "You are not root!\nYou won't be able to do any modification." >$OUTPUT
  display_output 8 60 "Warning !"
fi

while true
do

  ### display user management menu ###
  dialog --clear --backtitle "$BTITLE" \
  --title "[ USER MANAGEMENT ]" \
  --cancel-label "Exit" \
  --menu "Choose an option" 21 60 21 \
  "All Users" "List all the users" \
  "All Groups" "List all the groups" \
  "User groups" "List the groups of a user" \
  "Group with users" "List the users of a group" \
  " " " " \
  "Add user" "Add a normal user" \
  "Add group" "Add a group" \
  "Add system user" "Without home, shell, login" \
  "Add system group" "Add a system group" \
  " " " " \
  "Change groups" "Change the groups a user is in" \
  "Change primary group" "Change a user primary group" \
  "Delete user" "Delete a user" \
  "Delete group" "Delete a group" 2>"${INPUT}"

  if test $? -eq 0
  then
    #  echo "ok pressed"
    menuitem=$(<"${INPUT}")
  else
    #  echo "cancel pressed"
     menuitem="Exit"
  fi

  # make decision
  case $menuitem in
    "All Users") all_users;;
    "All Groups") all_groups;;
    "User groups") groups_for_user;;
    "Group with users") users_in_group;;
    "Add user") add_user;;
    "Add system user") add_user "sys";;
    "Add group") add_group;;
    "Add system group") add_group "sys";;
    "Change groups") change_secondary_groups;;
    "Change primary group") change_primary_group;;
    "Delete user") delete_user;;
    "Delete group") delete_group;;
    Exit) clear; break;;
  esac

done

if [ -s $ERRORLOG ]; then
  echo "--- Error Log ---"
  cat $ERRORLOG
fi
if [ -f $ERRORLOG ]; then
  rm $ERRORLOG
fi
# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
