#!/bin/bash

DB_DIR=".notes/db"
mkdir -p "$DB_DIR"

COMMAND="$1"

case "$COMMAND" in
    add)
        shift
        CONTENT="$*"

        if [ -z "$CONTENT" ]; then
            echo "Fehler: Die Notiz darf nicht leer sein."
            exit 1
        fi

        HASH=$(echo -n "$CONTENT" | sha256sum | awk '{print $1}')

        echo -n "$CONTENT" > "$DB_DIR/$HASH"
        echo "Notiz gespeichert! Hash: $HASH"
        ;;

    *)
        echo "note-cli - Ein einfaches Notiz-Tool"
        echo "Nutzung: ./note.sh add <text>"
        ;;
        
    delete)
    HASH_TO_DELETE="$2"

    if [ -z "$HASH_TO_DELETE" ]; then
        echo "Fehler: Bitte gib den Hash an."
        exit 1
    fi

    if [ -f "$DB_DIR/$HASH_TO_DELETE" ]; then
        rm "$DB_DIR/$HASH_TO_DELETE"
        echo "Notiz gelöscht."
    else
        echo "Fehler: nicht gefunden."
    fi
    ;;
esac