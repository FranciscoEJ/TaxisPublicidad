# TaxisPublicidad
Repositorio para contenido de taxis

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now cambiar_fondo.timer

systemctl --user status cambiar_fondo.timer

systemd-run --user --on-active=1s --once --property=Environment="DISPLAY=:0" --property=Environment="XAUTHORITY=/home/admin/.Xauthority" --property=Environment="DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus" /home/admin/cambiar_fondo_pcmanfm.sh

