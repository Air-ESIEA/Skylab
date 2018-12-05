#
#   ____  _         _            _____             _   _
#  |    \|_|___ ___| |___ _ _   |   __|_ _ ___ ___| |_|_|___ ___ ___
#  |  |  | |_ -| . | | .'| | |  |   __| | |   |  _|  _| | . |   |_ -|
#  |____/|_|___|  _|_|__,|_  |  |__|  |___|_|_|___|_| |_|___|_|_|___|
#              |_|       |___|
#                                                         Version 0.1
#
#  ------------------------------------------- Paul Mercier-Handisyde
#  -------------------------------------------- p.mercier.h@gmail.com
#  ----------------------------------------- Last Edited : 27.11.2018
#
# Display output using msgbox
#  $1 -> set msgbox height
#  $2 -> set msgbox width
#  $3 -> set msgbox title
#

function display_output(){
  local h=${1-10}      # box height default 10
  local w=${2-41}     # box width default 41
  local t=${3-Output}   # box title
  dialog --backtitle "Admin GUI script" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
}

function display_text_output(){
  local h=${1-10}      # box height default 10
  local w=${2-41}     # box width default 41
  local t=${3-Output}   # box title
  dialog --backtitle "Admin Utilitary" --title "${t}" --clear --textbox "$(<$OUTPUT)" ${h} ${w}
}
