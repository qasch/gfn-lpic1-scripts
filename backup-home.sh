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
user_to_backup=$1
datum=$(date "+%Y%m%d")
archiv_datei=home_${user_to_backup}_${datum}.tar.gz
backup_dir=/root/backup/


# Prüfung, ob Skrip mit root-Rechten ausgeführt wird
# Hier findet ein Vergleich von zwei Integer Werten (Zahlen) statt, kein Vergleich zweier Strings
if [ $(id -u) -ne 0 ]; then
	echo
	echo "Das Skript muss mit Root-Rechten ausgeführt werden."
	echo "Abbruch."
	echo
	exit 1	
fi


# Prüfung, ob Parameter übergeben wurde
if [ -z $user_to_backup ]; then
	echo
	echo "Fehler: Skript wurde ohne Parameter aufgerufen. Abbruch."
	echo
	echo "Skript muss in der folgenden Form aufgerfufen werden:"
	echo "./backup.sh <username>"
	echo
	exit 1
fi


# TODO: Script durch Aufruf von '_backup` starten, nicht mit kompletten Pfad 

# Prüfung, ob Benutzer/Heimatverzeichnis existiert
if [ ! -d /home/${user_to_backup} ]
then
	echo
	echo "Heimatverzeichnis /home/${user_to_backup} existiert nicht"
	# TODO: Farbig ausgeben (rot)
	echo "Abbruch"
	echo
	# Skript wird mit Fehlercode 1 abgebrochen
	exit 1
fi

echo
echo "Starte Backup des Heimatverzeichnisses /home/${user_to_backup}"
echo "Das Backup wird ausgeführt vom Benutzer ${USER}."
echo

# komprimiertes Archiv des Heimatverzeichnisses erstellen
tar -czf ${archiv_datei} /home/${user_to_backup} 2>/dev/null

mkdir -p ${backup_dir}

echo "Verschiebe Archiv in Verzeichnis /root/backup"
mv ${archiv_datei} ${backup_dir}

echo
echo "Backup für ${user_to_backup} erfolgreich erstellt"
