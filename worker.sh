#!/bin/bash

change_filename() {
    read -p "Enter new filename: " new_filename
    sed -i "s|^COMMAND_FILE=.*|COMMAND_FILE=\"$new_filename\"|" "$0"
    echo "Filename changed to: $new_filename"
}

process_cli_args() {
    if [[ $# -gt 0 ]]; then
        case "$1" in
            "ADD")
                user_command="$2"
                command_list+=("$user_command,0")
                save_commands  # Speichert die Befehle nach dem Hinzufügen
                echo "Command added: $user_command"
                exit 0
                ;;
            "EXECUTE")
                # list_commands
                execute_commands
                exit 0
                ;;
            "LIST")
                list_commands
                exit 0
                ;;
            *)
                echo "Invalid command. Use 'ADD <command>', 'EXECUTE', or 'LIST'."
                exit 1  # Beendet das Skript mit einem Fehlercode
                ;;
        esac
    fi
}

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
    echo "Commands saved."
}

add_command() {
    read -p "Add new command: " user_command
    command_list+=("$user_command,0")
    save_commands
}

execute_commands() {
    for i in "${!command_list[@]}"; do
        command_entry="${command_list[i]}"
        command=$(echo "$command_entry" | cut -d',' -f1)
        executed=$(echo "$command_entry" | cut -d',' -f2)
        echo "Executing command $command"
        # if not already executed, execute it
        if [ "$executed" -eq 0 ]; then
            echo "Executing: $command"
            bash -c "$command"
            # remember command finished
            command_list[$i]="$command,1"
            # notify-send "Command executed! $command"
        fi
        # save commands every iteration
        # save_commands
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

declare -a command_list
COMMAND_FILE="jobs.txt"
echo ""
echo "### bash worker (c) by dahead 2024 ###"
echo "### this script executes commands from a commandfile"
echo ""
echo "Loading commands from $COMMAND_FILE"
load_commands
echo ""

# main loop
process_cli_args "$@"

while true; do
    echo ""
    echo "Options:"
    echo "  1) ADD new command"
    echo "  2) EXECUTE commands"
    echo "  3) LIST all commands"
    echo "  4) CHANGE commands file filename"
    echo ""
    echo "  q) Quit"
    echo ""
    read -p "Choose an option: " option

    case $option in
        1)
            add_command
            ;;
        2)
            execute_commands
            ;;
        3)
            list_commands
            ;;
        4)
            change_filename
            ;;

        q)
            echo "Closing."
            exit 0
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
done

