#
#   _____                    _____             _   _
#  |  |  |___ ___ ___ ___   |   __|_ _ ___ ___| |_|_|___ ___ ___
#  |  |  |_ -| -_|  _|_ -|  |   __| | |   |  _|  _| | . |   |_ -|
#  |_____|___|___|_| |___|  |__|  |___|_|_|___|_| |_|___|_|_|___|
#
#                                                     Version 0.1
#
#  --------------------------------------- Paul Mercier-Handisyde
#  ---------------------------------------- p.mercier.h@gmail.com
#  ------------------------------------- Last Edited : 05.12.2018
#
#
# OUTPUT = file
# INPUT = file
# display_output = msgbox to display results
#

function select_a_user(){
  local _outvar=$1
  local _user_list=
  local _normal_users=
  local _system_users=
  local _user=
  #local _UID_MIN=$(grep -w UID_MIN /etc/login.defs | tr -s " " | cut -d" " -f2)
  local _UID_MIN=$(grep -v "^#" /etc/login.defs | grep -w UID_MIN | tr -s " " | cut -d" " -f2)
  local _uid=

  # get users
  while read -r _line
  do
    # _user_list="$_user_list $_user -"
    _user=$(echo "$_line" | cut -d: -f1)
    _uid=$(echo "$_line" | cut -d: -f3)
    if [ "$_uid" -ge "$_UID_MIN" ]; then
      _normal_users="$_normal_users $_user"
    else
      _system_users="$_system_users $_user"
    fi
  done < /etc/passwd
  # remove space, sort, add type
  _normal_users=$(echo "$_normal_users" | sed 's/ //' | tr " " "\n" | sort -b)
  _normal_users=$(echo "$_normal_users" | tr "\n" " " | sed -e 's/ / - /g')
  _system_users=$(echo "$_system_users" | sed 's/ //' | tr " " "\n" | sort -b)
  _system_users=$(echo "$_system_users" | tr "\n" " " | sed -e 's/ / sys /g')

  _user_list="$_normal_users $_system_users"
  _user=

  # show users
  dialog --clear --backtitle "$BTITLE" \
  --title "[ USERS ]" \
  --menu "Users: normal(-) system(sys)" 15 50 15 \
  $_user_list 2>"${INPUT}"

  if test $? -eq 0
  then
    #  echo "ok pressed"
    _user=$(<"${INPUT}")
  fi

  eval $_outvar=\$_user
}

function select_a_group(){
  local _outvar=$1
  local _groups_list=
  local _group=

  # get groups
  # while read -r line
  for line in $(sort /etc/group)
  do
    _group=$(echo $line | cut -d: -f1)
    # count users with this group as primary
    local _gid=$(echo $line | cut -d: -f3)
    local _primary_users=0
    local _secondary_users=0
    if [ -n "$(cut -d: -f4 /etc/passwd | grep -w $_gid)" ]; then
      _primary_users=$(cut -d: -f4 /etc/passwd | grep -w $_gid | wc -l)
    fi
    # count users with this group as secondary
    local _users=$(echo $line | cut -d: -f4)
    if [ -n "$_users" ]; then
      # count the ',' and add 1 (a,b,c = 3)
      _users=$(echo $_users | tr -cd , | wc -c)
      _secondary_users=$((_users+1))
    fi
    # echo $group $users $line >>$OUTPUT
    _groups_list=$(echo "$_groups_list $_group $_primary_users/$_secondary_users")
  # done < /etc/group
  done

  # show groups
  dialog --clear --backtitle "$BTITLE" \
  --title "[ GROUPS ]" \
  --menu "format: [group] [primary/secondary users]" 15 50 15 \
  $_groups_list 2>"${INPUT}"

  _group=

  if test $? -eq 0
  then
    #  echo "ok pressed"
    _group=$(<"${INPUT}")
  fi

  eval $_outvar=\$_group
}

#  Add a group
#     the only difference between normal and system
#     groups is the GID range
#
function add_group(){
  local type="$1"

  # show an inputbox
  dialog --title "ADD GROUP" \
  --backtitle "$BTITLE" \
  --inputbox "Enter a group name " 8 60 2>$INPUT

  if test $? -eq 0
  then
    #  echo "ok pressed"
    name=$(<"${INPUT}")
  else
    #  echo "cancel pressed"
    return
  fi

  local out=
  if [ "$type" = "sys" ]; then
    out=$(groupadd -r "$name" 2>&1)
  else
    out=$(groupadd "$name" 2>&1)
  fi

  # check result
  if test $? -eq 0
  then
    echo "Group created" >$OUTPUT
  else
    echo "ERROR:" >$OUTPUT
    echo "$out" >>$OUTPUT
  fi

  display_output 20 60 "Add Group"
}

#  Add a user
#     normal user - with default homedir and /bin/bash shell if it exists
#     system user - no homedir, no shell, no login
#
function add_user(){
  local type="$1"

  # show an inputbox
  dialog --title "ADD USER" \
  --backtitle "$BTITLE" \
  --inputbox "Enter a user name " 8 60 2>$INPUT

  if test $? -eq 0
  then
    #  echo "ok pressed"
    name=$(<"${INPUT}")
  else
    #  echo "cancel pressed"
    return
  fi

  local shell=
  local out=
  if [ "$type" = "sys" ]; then
    shell=$(whereis -b nologin | cut -d" " -f2)
    if [ -z "$shell" ]; then
      shell="/usr/sbin/nologin"
    fi
    out=$(useradd -rMs "$shell" "$name" 2>&1)
  else
    if [ -e "/bin/bash" ]; then
      shell="/bin/bash"
    fi
    out=$(useradd -m "$name" -s "$shell" 2>&1)
  fi

  if test $? -eq 0
  then
    local out2=$(echo "$name:default" | chpasswd)
    chage -d 0 "$name"
    echo -e "User $name created\n\nThe new user will be prompted to change password at first login\n\nUse 'default' at first login" >$OUTPUT
  else
    echo "ERROR:" >$OUTPUT
    echo "$out" >>$OUTPUT
    echo "$out2" >>$OUTPUT
  fi

  display_output 20 60 "Add User"
}

#  List all groups
#
function all_groups(){
  >$OUTPUT
  >$INPUT
  printf "%17s | %s | %s\n" "Group" "Password" "Users #" >$OUTPUT
  printf "%s\n" "--------------------------------------" >>$OUTPUT

  while read -r line
  do
    group=$(echo $line | cut -d: -f1)
    #
    password=$(echo $line | cut -d: -f2)
    if [ -n "$password" ] || [ "$password" = "x" ]; then
      password="NO"
    else
      password="YES"
    fi
    #
    # count users with this group as primary
    gid=$(echo $line | cut -d: -f3)
    local user_count=
    if [ -n "$(cut -d: -f4 /etc/passwd | grep -w $gid)" ]; then
      user_count=$(cut -d: -f4 /etc/passwd | grep -w $gid | wc -l)
    fi
    # count users with this group as secondary
    users=$(echo $line | cut -d: -f4)
    if [ -n "$users" ]; then
      # count the ',' and add 1 (a,b,c = 3)
      users=$(echo $users | tr -cd , | wc -c)
      user_count=$((user_count+users+1))
    fi
    printf "%17s | %5s | %3s \n" $group $password $user_count >>$INPUT
  done < /etc/group

  cat $INPUT | sort >>$OUTPUT
  display_output 20 60 "Groups"
}

#  List all users
#
function all_users(){
  >$INPUT
  >$OUTPUT
  # cache groups
  local fGroups=$(cat /etc/group)

  printf "%18s | %s | %s\n" "User" "Primary Group" "Login" >$OUTPUT
  printf "%s\n" "------------------------------------------------" >>$OUTPUT
  while read -r line
  do
    user=$(echo $line | cut -d: -f1)
    #
    group=$(echo $line | cut -d: -f4)
    for gline in $(echo "$fGroups" | grep $group)
    do
      if [ $(echo $gline | cut -d: -f3 | grep $group) ]; then
        group=$(echo $gline | cut -d: -f1 )
        break
      fi
    done
    #
    shell=$(echo $line | cut -d: -f7)
    if [ $(echo "$shell" | grep -w "bash") ] || \
      [ $(echo "$shell" | grep -w "ash") ] || \
      [ $(echo "$shell" | grep -w "sh") ]
    then
      shell="YES [$shell]"
    elif [ -z "$shell" ]; then
      shell="YES [/bin/sh]" # by default
    elif [ $(echo "$shell" | grep -w "nologin") ] || \
      [ $(echo "$shell" | grep -w "false") ]
    then
      shell="" # NO login
    else
      shell="? [$shell]"
    fi

    pads="__________________"
    printf "%18s | %s%s | %5s \n" $user "${pads:${#group}}" $group "$shell" >>$INPUT
  done < /etc/passwd

  cat $INPUT | sort >>$OUTPUT

  display_output 25 70 "Users"
}

#  Change the primary group a user is in
#
function change_primary_group(){
  local user=
  select_a_user user

  if [ -z "$user" ]; then
    return
  fi


  local primary_group_id=
  local groups_list=
  # get GID of primary group
  while read -r line
  do
    if [ $(echo $line | cut -d: -f1 | grep -w $user) ]; then
      primary_group_id=$(echo $line | cut -d: -f4 )
      break
    fi
  done < /etc/passwd

  # get all groups
  for line in $(sort /etc/group)
  do
    # mark primary group as selected
    if [ "$primary_group_id" = $(echo "$line" | cut -d: -f3) ]; then
      groups_list=$(printf "%s %s %s %s" "$groups_list" $(echo "$line" | cut -d: -f1) "-" "on")
    else
      groups_list=$(printf "%s %s %s %s" "$groups_list" $(echo "$line" | cut -d: -f1) "-" "off")
    fi
  done

  # show groups
  dialog --clear --backtitle "$BTITLE" \
  --title "[ CHANGE PRIMARY GROUP ]" \
  --radiolist "Select primary group" 22 40 30 \
  $groups_list 2>"${INPUT}"

  if test $? -eq 0
  then
    #  echo "ok pressed"
    local selected_group=$(<"${INPUT}")
  else
    #  echo "cancel pressed"
    return
  fi

  usermod -g "$selected_group" "$user" >$OUTPUT 2>&1

  # check result
  if test $? -eq 0
  then
    echo "Primary group changed" >$OUTPUT
  fi

  display_output 20 60 "Change primary group"
}

#  Change the (secondary) groups a user is in
#
function change_secondary_groups(){
  local user=
  select_a_user user

  if [ -z "$user" ]; then
    return
  fi

  local groupid=
  local user_groups=
  local groups_list=
  # get GID of primary group
  while read -r line
  do
    if [ $(echo $line | cut -d: -f1 | grep -w $user) ]; then
      groupid=$(echo $line | cut -d: -f4 )
      break
    fi
  done < /etc/passwd
  # get secondary groups
  for line in $(sort /etc/group)
  do
    # ignore/hide primary group
    if [ "$groupid" != $(echo "$line" | cut -d: -f3) ]; then
      # check to which groups the user belongs
      if [ $(echo "$line" | cut -d: -f4 | grep $user) ]; then
        groups_list=$(printf "%s %s %s %s" "$groups_list" $(echo "$line" | cut -d: -f1) "-" "on")
        user_groups=$(printf "%s %s" "$user_groups" $(echo "$line" | cut -d: -f1))
      else
        groups_list=$(printf "%s %s %s %s" "$groups_list" $(echo "$line" | cut -d: -f1) "-" "off")
      fi
    fi
  done

  # select groups
  local selected_groups=
  dialog --clear --backtitle "$BTITLE" \
  --title "[ GROUPS ]" \
  --checklist "Select groups" 22 40 30 \
  $groups_list 2>"${INPUT}"

  if test $? -eq 0
  then
    #  echo "ok pressed"
    selected_groups=$(<"${INPUT}")
  else
    #  echo "cancel pressed"
    return
  fi

  echo "ERROR:">$OUTPUT
  local flagerr=0
  local fe=
  # remove (in user_groups but not in selected)
  for group in $(echo "$user_groups")
  do
    if [ -z "$(echo "$selected_groups" | grep -w $group)" ]; then
      gpasswd -d "$user" "$group" >>$OUTPUT 2>&1
      fe=$?
      [ "$flagerr" -eq 0 ] && flagerr=$fe
    fi
  done

  # add (in selected but not in user_groups)
  for group in $(echo "$selected_groups")
  do
    if [ -z "$(echo "$user_groups" | grep -w $group)" ]; then
      echo "gpasswd -a $user $group"
      gpasswd -a "$user" "$group" >>$OUTPUT 2>&1
      fe=$?
      [ "$flagerr" -eq 0 ] && flagerr=$fe
    fi
  done


  # check result
  # if test $? -eq 0
  if test $flagerr -eq 0
  then
    echo "Groups changed" >$OUTPUT
  fi

  display_output 20 60 "Change Groups"
}

#  Delete a group
#
function delete_group(){
  local group=
  select_a_group group

  if [ -z "$group" ]; then
    return
  fi

  groupdel "$group" >$OUTPUT 2>&1

  # check result
  if test $? -eq 0
  then
    echo "Group deleted" >$OUTPUT
  fi

  display_output 20 60 "Delete group"
}

#  Delete a user
#
function delete_user(){
  local user=
  select_a_user user

  if [ -z "$user" ]; then
    return
  fi

  dialog --title "Delete files" \
  --backtitle "$BTITLE" \
  --yesno "Also delete homedir and mail spool?" 7 60

  # Get exit status
  # 0 means user hit [yes] button.
  # 1 means user hit [no] button.
  # 255 means user hit [Esc] key.
  response=$?
  case $response in
     0) # "Yes"
        userdel -r "$user" >$OUTPUT 2>&1
        ;;
     1) # "No"
        userdel "$user" >$OUTPUT 2>&1
        ;;
     255) return;;
  esac

  # check result
  if test $? -eq 0
  then
    echo "User deleted" >$OUTPUT
  fi

  display_output 20 60 "Delete user"
}

#  List the groups a user is in
#
function groups_for_user(){
  local user=
  select_a_user user

  if [ -z "$user" ]; then
    return
  fi

  local groupid
  >$OUTPUT
  # primary - get GID
  while read -r line
  do
    if [ $(echo $line | cut -d: -f1 | grep -w $user) ]; then
      groupid=$(echo $line | cut -d: -f4 )
      break
    fi
  done < /etc/passwd
  # primary - get GID name
  for line in $(grep -w "$groupid" /etc/group)
  do
      if [ $(echo $line | cut -d: -f3 | grep $groupid) ]; then
        printf "[ %s ]\n" $(echo $line | cut -d: -f1) >>$OUTPUT
        break
      fi
  done
  # secondary
  for line in $(grep -w "$user" /etc/group)
  do
      if [ $(echo $line | cut -d: -f4 | grep $user) ]; then
        echo $line | cut -d: -f1 >>$OUTPUT
      fi
  done

  display_output 13 25 "Groups"
}

#  List the users that belong to a group
#
function users_in_group(){
  local group=
  select_a_group group

  if [ -z "$group" ]; then
    return
  fi

  local groupid=
  local user_list=
  >$OUTPUT
  # get GID
  for line in $(grep -w $group /etc/group)
  do
    if [ "$(echo $line | cut -d: -f1)" = "$group" ]; then
      groupid="$(echo $line | cut -d: -f3)"
      secondary_users="$(echo $line | cut -d: -f4)"
      secondary_users="$(echo "$secondary_users" | tr ',' ' ')"
      break
    fi
  done
  # get primary users
  for line in $(grep -w $groupid /etc/passwd)
  do
    if [ -n "$(echo $line | cut -d: -f4 | grep -w $groupid)" ]; then
      # user_list="$user_list [ $(echo $line | cut -d: -f1) ]"
      echo "[ $(echo $line | cut -d: -f1) ]" >>$OUTPUT
    fi
  done
  # separate secondary users
  for line in ${secondary_users}
  do
    echo "$line" >>$OUTPUT
  done

  display_output 13 25 "Users"
}
