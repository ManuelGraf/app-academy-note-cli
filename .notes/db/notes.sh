#!/bin/bash
#comment!
#again
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

    list)
        if [ ! -d "$DB_DIR" ] || [ -z "$(find "$DB_DIR" -type f ! -name ".keep" 2>/dev/null)" ]; then
            echo "Keine Notizen gefunden."
            exit 0
        fi

        for FILE in "$DB_DIR"/*; do
            if [ -f "$FILE" ] && [ "$(basename "$FILE")" != ".keep" ]; then
                HASH=$(basename "$FILE")
                CONTENT=$(cat "$FILE")
                echo "$HASH  -  $CONTENT"
            fi
        done
        ;;

    *)
        echo "note-cli - Ein einfaches Notiz-Tool"
        echo "Nutzung:"
        echo "  add <text>"
        echo "  list"
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