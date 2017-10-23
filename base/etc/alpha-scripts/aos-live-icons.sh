#!/bin/bash -
#
#   Name    :   litebook-file-manager-setup.sh
#   Author  :   Richard Buchanan II for Alpha Universal, LLC
#   Brief   :   A pared-down version of the original that 
#				enables Pantheon desktop icons for the 
#				Alpha OS live distro.
#

set -o errexit      # exits if non-true exit status is returned
set -o nounset      # exits if unset vars are present

PATH=/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin

# needed for this external script to call the current display
DISPLAY=:0
export DISPLAY
XAUTHORITY=/home/alpha/.Xauthority
export XAUTHORITY

# create all needed directories
if [[ ! -d /home/alpha/.local/share/applications ]] ; then
	sudo -u alpha mkdir /home/alpha/.local/share/applications
fi

if [[ ! -d /home/alpha/.config/autostart ]] ; then
	sudo -u alpha mkdir /home/alpha/.config/autostart
fi

# set default desktop icons
dbus-launch --sh-syntax gsettings set org.gnome.nautilus.desktop home-icon-visible true
dbus-launch --sh-syntax gsettings set org.gnome.nautilus.desktop trash-icon-visible true
dbus-launch --sh-syntax gsettings set org.gnome.nautilus.desktop volumes-visible true

# set pantheon to monitor nautilus
dbus-launch --sh-syntax gsettings set org.pantheon.desktop.cerbere monitored-processes "['wingpanel', 'plank', 'slingshot-launcher --silent', 'nautilus -n']"

# ensure that pantheon remains the default file manager, and use the yes
# binary to handle the interactive prompt
yes | sudo -u alpha xdg-mime default pantheon.desktop inode/directory application/x-gnome-saved-search

# hide nautilus from the start menu
cp /usr/share/applications/nautilus.desktop /home/alpha/.local/share/applications
chown alpha:alpha /home/alpha/.local/share/applications/nautilus.desktop
cd /home/alpha/.local/share/applications/ ; sed -i '/\[Desktop Entry\]/a NoDisplay=true' ./nautilus.desktop

# nautilus initial start
gksu -u alpha -l /etc/alpha-scripts/litebook-desktop-icons-start.sh

exit 0
