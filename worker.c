#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_COMMANDS 100
#define COMMAND_FILE "jobs.txt"

char *command_list[MAX_COMMANDS];
int executed_status[MAX_COMMANDS];
int command_count = 0;

void change_filename() {
    char new_filename[256];
    printf("Enter new filename: ");
    scanf("%255s", new_filename);

    // Update COMMAND_FILE variable (not persistent like in Bash)
    printf("Filename changed to: %s\n", new_filename);
}

void load_commands() {
    FILE *file = fopen(COMMAND_FILE, "r");
    if (file == NULL) {
        printf("No commands file found. Starting with empty command list.\n");
        return;
    }

    while (command_count < MAX_COMMANDS && !feof(file)) {
        char buffer[256];
        if (fgets(buffer, sizeof(buffer), file) != NULL) {
            command_list[command_count] = strdup(buffer);
            executed_status[command_count] = 0; // Initially not executed
            command_count++;
        }
    }
    fclose(file);
    printf("%d commands loaded.\n", command_count);
}

void clear_commands() {
    FILE *file = fopen(COMMAND_FILE, "w");
    if (file != NULL) {
        fclose(file);
    }
    for (int i = 0; i < command_count; i++) {
        free(command_list[i]);
        command_list[i] = NULL;
    }
    command_count = 0;
    printf("Commands cleared.\n");
}

void save_commands() {
    FILE *file = fopen(COMMAND_FILE, "w");
    if (file == NULL) {
        perror("Could not open command file for writing");
        return;
    }
    for (int i = 0; i < command_count; i++) {
        fprintf(file, "%s", command_list[i]);
    }
    fclose(file);
    printf("Commands saved.\n");
}

void add_command() {
    char user_command[256];
    printf("Add new command: ");
    scanf(" %[^\n]", user_command);

    if (command_count < MAX_COMMANDS) {
        command_list[command_count] = strdup(user_command);
        executed_status[command_count] = 0; // Not executed
        command_count++;
        save_commands();
        printf("Command added: %s\n", user_command);
    } else {
        printf("Command list is full!\n");
    }
}

void execute_commands() {
    if (command_count == 0) {
        printf("No commands to execute.\n");
        return;
    }

    for (int i = 0; i < command_count; i++) {
        if (executed_status[i] == 0) {
            printf("Executing: %s", command_list[i]);
            system(command_list[i]);  // Execute command
            executed_status[i] = 1;    // Mark as executed
        }
    }
    save_commands();
}

void list_commands() {
    printf("Total commands: %d\n", command_count);
    if (command_count == 0) {
        printf("No commands available.\n");
        return;
    }

    printf("List of commands:\n");
    for (int i = 0; i < command_count; i++) {
        printf("[%d] %s", executed_status[i], command_list[i]);
    }
}

void process_cli_args(int argc, char *argv[]) {
    if (argc > 1) {
        if (strcmp(argv[1], "ADD") == 0 && argc > 2) {
            strcpy(command_list[command_count], argv[2]);
            executed_status[command_count] = 0; // Not executed
            command_count++;
            save_commands();
            printf("Command added: %s\n", argv[2]);
            exit(0);
        } else if (strcmp(argv[1], "EXECUTE") == 0) {
            execute_commands();
            exit(0);
        } else if (strcmp(argv[1], "LIST") == 0) {
            list_commands();
            exit(0);
        } else {
            printf("Invalid command. Use 'ADD <command>', 'EXECUTE', or 'LIST'.\n");
            exit(1);
        }
    }
}

int main(int argc, char *argv[]) {
    printf("\n### C Command Manager by dahead 2024 ###\n");
    printf("### This program executes commands from a command file ###\n\n");
    load_commands();

    process_cli_args(argc, argv);

    while (1) {
        printf("\nOptions:\n");
        printf("  1) ADD new command\n");
        printf("  2) EXECUTE commands\n");
        printf("  3) LIST all commands\n");
        printf("  4) CHANGE commands file filename\n");
        printf("  5) CLEAR all commands\n");
        printf("  q) Quit\n");

        char option;
        printf("\nChoose an option: ");
        scanf(" %c", &option);

        switch (option) {
            case '1':
                add_command();
                break;
            case '2':
                execute_commands();
                break;
            case '3':
                list_commands();
                break;
            case '4':
                change_filename();
                break;
            case '5':
                clear_commands();
                break;
            case 'q':
                printf("Closing.\n");
                exit(0);
            default:
                printf("Invalid option!\n");
                break;
        }
    }

    return 0;
}
