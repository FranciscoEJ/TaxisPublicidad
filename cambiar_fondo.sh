#!/bin/bash
IMG=$(find /home/admin/Documents/TaxisPublicidad/img -type f | shuf -n 1)
pcmanfm --set-wallpaper "$IMG"
