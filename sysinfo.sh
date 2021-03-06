#! /bin/sh
# dark shell grave. 

OS=$(hostnamectl | awk '{$1=$3="";sub(/^[ \t]+/, "")}NR==7' | sed 's/System:  //g') # get operating system
DISTRO=$(lsb_release -sirc | awk '{print $3 " " $2}'  | sed 's/-rc//g') # get distro (this is for non lts )
KERNEL=$(hostnamectl | awk -F- '/Kernel/{ OFS="-";NF--; print }'|awk '{print $3}') # get kernel version
MODEL=$(awk </sys/devices/virtual/dmi/id/board_name '{print $1}')  # get device model
VENDOR=$(awk </sys/devices/virtual/dmi/id/board_vendor '{print $1}')  # get device vendor
DE=$(plasmashell --version | awk '{print $2}') # i use kde plasma, feel free to change this according to your DE/WM. // slow
CPU=$(awk < /proc/cpuinfo '/model name/{print $5}' | head -1) # get cpu model
TEMP=$(awk </sys/class/hwmon/hwmon0/temp1_input '{print $1 / 1000}') # get cpu temp
GPU=$(lspci | awk '/VGA/{print $11,$12,$13}' | tr -d '[]') # slow af
ROOT=$(df -h | awk '/^\/dev\/sda1/ {print $4"B/"$2"B"}') # replace /dev/sda1 wwith your root disk name
MEMORY_TOTAL=$(awk </proc/meminfo '/MemTotal/{ print substr($2/1000/1000,1,4)}') # total memory
MEMORY=$(awk </proc/meminfo '/MemAvailable/{ print substr($2/1000/1000,1,4)}') # free memory
SHELL=$(zsh --version | awk '{sub(".", substr(toupper($i),1,1) , $i); print $1" "$2}') # i use zsh if you use another shell change this accordingly.
Packages=$(pacman -Q | awk 'END {print NR}') # if you dont use pacman then what??
ICONS=$(awk <~/.kde4/share/config/kdeglobals '/Theme/{print $1}' | sed 's/Theme=//g; s/-icon-theme//g; s/[-]/ /g') # get plasma icons 
COLORS=$(awk <~/.kde4/share/config/kdeglobals '/ColorScheme/{print $1}' | sed 's/ColorScheme=//g') # get plasma color scheme
FONT=$(awk <~/.kde4/share/config/kdeglobals '/font/{print $1}' | sed 's/,7.5,-1,5,57,0,0,0,0,0,Medium//g; s/font=//g') # get plasma fonts
WIDGET=$(awk <~/.kde4/share/config/kdeglobals '/widgetStyle/{print $1}' | sed 's/widgetStyle=//g') # get plasma widgets
TERM_FONT=$(awk <~/.local/share/konsole/Shell.profile '/Font=/{print $1}' | sed 's/,9,-1,5,50,0,0,0,0,0,Regular//g; s/Font=//g') #change profile name according to yours 
# get currently playing song (spotify and juk only).
if pgrep -x "spotify" > /dev/null
then
	Playing=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 \
            org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
            string:'Metadata' |\
            awk -F 'string "' '/string|array/ {printf "%s",$2; next}{print ""}' |\
            awk -F '"' '/artist/ {a=$2} /title/ {t=$2} END{print a " - " t}')
	m_ICON=$(echo )
else if pgrep -x "vlc" > /dev/null
then
	Playing=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 \
            org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
            string:'Metadata' |\
            awk -F 'string "' '/string|array/ {printf "%s",$2; next}{print ""}' |\
            awk -F '"' '/artist/ {a=$2} /title/ {t=$2} END{print  t}')
	#m_ICON=$(echo ♬)
else 
	Playing=$(echo "No Supported Player Is Running")
	#m_ICON=$(echo Ⴃ)
fi
fi

clear # clear the screen first before processing output.
 echo  ""
 echo -e "\\e[91m   --------------------"
 echo "   SYSTEM INFORMATION"
 echo "   --------------------"
 echo  ""
 echo -e "\\e[94m   \\e[39m$VENDOR $MODEL"
 echo -e "\\e[94m   \\e[39m$DISTRO"
 echo -e "\\e[94m   \\e[39m$OS$KERNEL"
 echo -e "\\e[94m   \\e[39m$SHELL"
 echo -e "\\e[94m   \\e[39m$CPU [$TEMP.0°C]"
 echo -e "\\e[94m   \\e[39m$GPU" 
 echo -e "\\e[94m   \\e[39m"$MEMORY"G/"$MEMORY_TOTAL"G Free" 
  echo -e "\\e[94m   \\e[39m"$ROOT" Free" 
 echo -e "\\e[94m   ---------------------"
 echo -e "\\e[94m   \\e[39mPlasma $DE"
 echo -e "\\e[94m   \\e[39m$WIDGET Style" 
 echo -e "\\e[94m   \\e[39m$FONT" 
 echo -e "\\e[94m   \\e[39m$TERM_FONT"
 echo -e "\\e[94m   \\e[39m$ICONS Icons"
 echo -e "\\e[94m   \\e[39m$COLORS"
 echo -e "\\e[94m   \\e[39m$Packages Packages"
 echo -e "\\e[94m   ---------------------"
 echo -e "\\e[94m   \\e[39m$Playing"
 echo  ""
 