# bashworker
Small bash script that runs commands in a list.

# examples

## run the script and use the CLI
```./worker.sh```

## run the script by passing arguments
```
./worker.sh LIST
./worker.sh EXECUTE
./worker.sh ADD <command>
```

## examples
```
./worker.sh ADD "notify-send hello world"
./worker.sh ADD "notify-send 10"
./worker.sh ADD "notify-send 9"
./worker.sh ADD "notify-send 8"
./worker.sh ADD "notify-send 7"
./worker.sh ADD "notify-send 6"
./worker.sh ADD "notify-send 5"
./worker.sh ADD "notify-send 4"
./worker.sh ADD "notify-send 3"
./worker.sh ADD "notify-send 2"
./worker.sh ADD "notify-send 1"
./worker.sh ADD "notify-send DONE!!!"
```

## content of commands.txt file
```
notify-send hello world,0
notify-send 10,0
notify-send 9,0
notify-send 8,0
notify-send 7,0
notify-send 6,0
notify-send 5,0
notify-send 4,0
notify-send 3,0
notify-send 2,0
notify-send 1,0
notify-send DONE!!!,0
```

## run this with
./worker.sh EXECUTE
