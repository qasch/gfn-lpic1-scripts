#!/bin/bash

####################################################
#
# Einfaches Backups Skript
#
# Erstellt ein gzip komprimiertes tar-Archiv
# des Heimatverzeichnisses eines Benutzers.
# 
# Hinweis: Der Benutzername kann dem Skrip direkt beim Aufruf
# übergeben werden. Ansonsten erfolgt eine Abfrage.
# 
# Author: Gfn Kurs LPIC1
# Datum: 11.04.2022
# Version: 0.5
#
####################################################

# TODO: Script durch Aufruf von '_backup` starten, nicht mit kompletten Pfad 

set +x

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


# bewusst konstruierte Endlosschleife, um immer wieder die folgenden Prüfungen
# zu vollziehen
while true; do
	# Prüfung, ob Parameter übergeben wurde
	if [ -z $user_to_backup ]; then
		echo
		echo "Das Skript wurde ohne Angabe eines zu sichernden Heimatverzeichnisses aufgerufen." 
		echo "Bitte den Benutzernamen des Users angeben, dessen Heimatverzeichnis gesichert werden soll:"
		read -p ">>> "  user_to_backup
		echo
		echo "Das Skript kann auch direkt in der folgenden Form aufgerfufen werden:"
		echo "./backup.sh <username>"
		echo
	fi

	# Prüfung, ob Benutzer/Heimatverzeichnis existiert
	if [ ! -d /home/${user_to_backup} ]
	then
		echo
		echo "Heimatverzeichnis /home/${user_to_backup} existiert nicht"

		echo
		echo "Soll das Skript beendet werden oder der Benutzer erneut eingegeben werden?"
		echo
		echo "Skript [b]eenden"
		echo "[N]euen Benutzernamen eingeben"
		echo
		read -p "Eingabe: " input

		
		# Einzeiler, gleiche Funktionalität wie if Zweig / 
		# folgende (drei) Zeilen
		#[ $input = "b" ] && echo "Na dann nicht." && exit 0
		if [ $input = "b" ];then
			echo "Okay, Skript wird beendet. Ahoi!"
			exit 0
		# else if
		# Prüfung mittels regulärem Ausdruck
		# Achtung: Doppelte Klammern verwenden,
		# geht nur in BASH, nicht sh
		# Keine Anführungszeichen um den regulären Ausdruck 
		#elif [[ $input =~ [nN] ]]; then
 
		# Einzeiler, gleich Funktionalität wie folgenden (vier) Zeilen
		#[[ $input =~ [nN] ]] && read -p "Erneute Eingabe: " user_to_backup
		elif [ $input = "N" ] || [ $input = "n" ]; then
			# Varialbe muss neu gesetzt werden, ansonsten landen wir
			# in einem Endlosloop
			read -p "Bitte erneut eingeben: " user_to_backup
			echo

			# Alternativ wäre auch folgendes möglich:
			# Wir leeren die Variable user_to_backup
			#echo "Bitte erneut eingeben: "
			#unset user_to_backup
		else
			echo "Eingabe ist ungültig"
		fi

	else
		# Heimatverzeichnis existiert, verlasse die while Schleife
		# und führe den Rest des Skriptes aus
		break
	fi
done

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
