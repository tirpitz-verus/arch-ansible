#!/bin/sh
xrandr --output {{ left_screen_name }} --primary --mode 1920x1080 --pos 0x0 --rotate normal --output {{ right_screen_name }} --mode 1920x1080 --pos 1920x0 --rotate normal