#!/bin/bash

COMMAND_FILE="commands.txt"
declare -a command_list

load_commands() {
    if [[ -f $COMMAND_FILE ]]; then
        while IFS=',' read -r command executed; do
            command_list+=("$command,$executed")
        done < "$COMMAND_FILE"
        echo "${#command_list[@]} commands loaded."
    fi
}

save_commands() {
    printf "%s\n" "${command_list[@]}" > "$COMMAND_FILE"
}

add_command() {
    read -p "Add new command: " user_command
    command_list+=("$user_command,0")
    save_commands  # Speichert die Befehle nach dem Hinzufügen
}

process_commands() {
    for i in "${!command_list[@]}"; do
        command_entry="${command_list[i]}"
        command=$(echo "$command_entry" | cut -d',' -f1)
        executed=$(echo "$command_entry" | cut -d',' -f2)
        if [ "$executed" -eq 0 ]; then
            echo "Executing: $command"
            bash -c "$command"
            command_list[$i]="$command,1"
        fi
    done
    save_commands
}

list_commands() {
    echo "List of commands:"
    for i in "${!command_list[@]}"; do
        command_entry="${command_list[i]}"
        command=$(echo "$command_entry" | cut -d',' -f1)
        executed=$(echo "$command_entry" | cut -d',' -f2)
        echo "[$executed] $command"
    done
}

# main loop
echo ""
echo "### WORKER (c) by dahead 2024 ###"
load_commands

while true; do
    echo "1) ADD new command"
    echo "2) EXECUTE commands"
    echo "3) LIST all commands"
    echo "4) QUIT"
    read -p "Choose an option: " option

    case $option in
        1)
            add_command
            ;;
        2)
            process_commands
            ;;
        3)
            list_commands
            ;;
        4)
            echo "Closing application."
            exit 0
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
done
