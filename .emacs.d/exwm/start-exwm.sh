#!/bin/sh
# Set the screen DPI
xrdb ~/.emacs.d/exwm/Xresource


compton &

wmname LG3D
export _JAVA_AWT_WM_NONREPARENTING=1

exec dbus-launch --exit-with-session emacs -mm --debug-init -l ~/.emacs.d/desktop.el
