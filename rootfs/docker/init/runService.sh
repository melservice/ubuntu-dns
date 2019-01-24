#!/bin/bash
#
# Start des Services

pidfile="/var/run/dhcpd.pid";

# ----------------------------------------------------------------------------------------------

function stopService {
	if [ -f "$pidfile" ]; then
		kill -15 $(cat "$pidfile");
	fi;
	
	# Die vergebenen Leases retten
	#cp -p /var/lib/dhcp/dhcpd.leases /docker/output;
	
	return 0;
}

# ----------------------------------------------------------------------------------------------

# per Trap wird der Dienst wieder heruntergefahren
trap 'stopService; exit $?' EXIT SIGINT SIGKILL SIGTERM

# Die alten Output-Dateien wiederherstellen
#if [ -f /docker/output/dhcpd.leases ]; then
#	cp -p /docker/output/dhcpd.leases /var/lib/dhcp/;
#fi;

# Die neuen Eingabedatei aufbereiten
#if [ -f /docker/inut/dhcpd.conf ]; then
#fi;

# Der DNS-Dämon wird gestartet
/usr/sbin/bind9

# Auf das Beenden des DHCP-Daemons warten
sleep 100;
if [ -f "$pidfile" ]; then
	waitPID=$(cat "$pidfile");
	while ps aux | grep "$pidfile" 2>/dev/null >/dev/null; do
		sleep 10;
	done;
else
	echo "PID-File '$pidfile' ist nicht vorhanden";
fi;
