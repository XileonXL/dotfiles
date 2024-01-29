#!/bin/sh
current_options=$(gsettings get org.gnome.desktop.input-sources xkb-options)
gsettings set org.gnome.desktop.input-sources xkb-options "$(echo $current_options | sed 's/\[.*\]$/['"'"'caps:swapescape'"'"']/')"
