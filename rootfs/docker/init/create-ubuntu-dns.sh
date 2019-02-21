#!/bin/bash
#
# Initialisierung des Service beim Erstellen des Images

/docker/init/aptInstall.sh bind9

mkdir -p /docker/daten /docker/config
