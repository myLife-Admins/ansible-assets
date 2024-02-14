#!/bin/bash

clear
# Definiere ein Array mit den Menüoptionen
options=(
    "Manage"
    "Test"
    "Entwicklung (No autopatch: inet1)"
    "Upla"
    "AD (No autopatch: myrootca1, myweb1)"
    "PM"
    "Produktion"
    "ProduktionKrit (Not autopatch: FTP1, FTP2, FS5)"
    "debug"
)

# Funktion, um das Menü anzuzeigen
print_menu() {
    echo "Wähle eine Option für das Patching:"
    for i in "${!options[@]}"; do
        printf "[%2d] %s\n" "$i" "${options[$i]}"
    done
    echo "  Geben Sie die Zahl für die Auswahl ein und drücken Sie [ENTER]:"
}

# Menü anzeigen
print_menu

# Benutzerauswahl einlesen
read -rp "" selection

# Auswahl validieren
if [[ $selection =~ ^[0-9]+$ ]] && [ "$selection" -ge 0 ] && [ "$selection" -lt "${#options[@]}" ]; then
    # Entsprechende Aktion ausführen
    if [ "$selection" -eq 10 ]; then
        # Logik für die Auswahl eines spezifischen Servers
        read -rp "Geben Sie den Namen des spezifischen Servers ein: " specific_server
        target_hosts="windows_$specific_server"
    else
        target_hosts="windows_${options[$selection]}"
    fi
    
    # Ersetze Leerzeichen und Sonderzeichen in target_hosts
    target_hosts=$(echo "$target_hosts" | sed -e 's/ .*//' -e 's/[^a-zA-Z0-9_]/_/g')

    echo "Starte Playbook mit target_hosts=$target_hosts"
    
    # Ansible-Playbook mit der gewählten target_hosts-Variable ausführen
    ansible-playbook /opt/ansible-assets/playbooks/update-windows-server.yml -e "target_hosts=$target_hosts"
else
    echo "Ungültige Auswahl."
fi
