#!/bin/sh

####################################################
#
# Einfaches Backups Skript
#
# Erstellt ein gzip komprimiertes tar-Archiv
# des Heimatverzeichnisses eines Benutzers.
# 
# Hinweis: Der Benutzername muss dem Skrip beim Aufruf
# übergeben werden.
# 
# Author: Gfn Kurs LPIC1
# Datum: 08.04.2022
# Version: 0.2
#
####################################################

# Variablen
user=$1
datum=$(date "+%Y%m%d")
archiv_datei=home_${user}_${datum}.tar.gz
backup_dir=/root/backup/

# TODO: Prüfung, ob Benutzer übergeben wurde
# TODO: Prüfung, ob mit root-Rechten ausgeführt
# TODO: Script durch Aufruf von '_backup` starten, nicht mit kompletten Pfad 
# TODO: git einrichten

# Prüfung, ob Benutzer/Heimatverzeichnis existiert
if test ! -d /home/${user}
then
	echo "Heimatverzeichnis /home/${user} existiert nicht"
	echo "Abbruch"
	# Skript wird mit Fehlercode 1 abgebrochen
	exit 1
fi

echo "Starte Backup des Heimatverzeichnisses /home/${user}"
echo "Das Backup wird ausgeführt vom Benutzer ${USER}."

# komprimiertes Archiv des Heimatverzeichnisses erstellen
tar -czf ${archiv_datei} /home/${user} 2>/dev/null

mkdir -p ${backup_dir}

echo "Verschiebe Archiv in Verzeichnis /root/backup"
mv ${archiv_datei} ${backup_dir}

echo "Backup für ${user} erfolgreich erstellt"
