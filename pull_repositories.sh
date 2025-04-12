#!/bin/bash
# ------------------------------------------------------------------------------
# Script Name: pull_repositories.sh
# Author: Jhoel Canulli
# Copyright (c) 2025
#
# This code is released under the MIT License.
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# See the LICENSE file or the full MIT License text for more details.
# ------------------------------------------------------------------------------

# Descrizione:
# Script che processa una lista di repository.
# Ogni repository viene clonato in una cartella avente lo stesso nome (senza ".git"),
# inizializzato con git, viene aggiunto il remote, si esegue il fetch,
# si chiede all'utente di scegliere il branch per il checkout e poi si rimuove il collegamento git.
# Tutte le operazioni vengono loggate in un file (log.txt) e gli URL in un file separato (addresses.txt).

# Imposto la directory dello script e i file di log
SCRIPT_DIR="$(dirname "$0")"
LOG_FILE="${SCRIPT_DIR}/log.txt"
ADDR_FILE="${SCRIPT_DIR}/addresses.txt"
REPO_FILE="${SCRIPT_DIR}/repos.txt"

# Ripulisco (o creo) i file di log
> "$LOG_FILE"
> "$ADDR_FILE"

# Funzione per scrivere messaggi nel log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Verifico che il file esista
if [ ! -f "$REPO_FILE" ]; then
    log "Errore: il file $REPO_FILE non esiste."
    exit 1
fi

# Itero per ogni URL contenuto nel file
while IFS= read -r repo_url; do

    # Stampo debug per verificare la riga letta
    log "Riga letta: '$repu_url'"
    # Salto righe vuote o commenti
    if [[ -z "$repo_url" || "$repo_url" =~ ^# ]]; then
        continue
    fi

    log "Inizio elaborazione repository: $repo_url"
    echo "$repo_url" >> "$ADDR_FILE"

    # Estraggo il nome del repository (rimuovo .git se presente)
    repo_name=$(basename "$repo_url")
    repo_name=${repo_name%.git}

    # Creo la cartella con il nome del repository
    mkdir "$repo_name"
    if [ $? -eq 0 ]; then
        log "Cartella '$repo_name' creata con successo."
    else
        log "Errore nella creazione della cartella '$repo_name'."
        continue
    fi

    cd "$repo_name" || { log "Errore nel cambiare directory in '$repo_name'."; continue; }

    # Inizializzo git
    git init .
    if [ $? -eq 0 ]; then
        log "git init eseguito con successo in '$repo_name'."
    else
        log "Errore in git init in '$repo_name'."
        cd ..
        continue
    fi

    # Aggiunge il remote "origin"
    git remote add origin "$repo_url"
    if [ $? -eq 0 ]; then
        log "Remote 'origin' aggiunta con successo: $repo_url."
    else
        log "Errore nell'aggiunta della remote 'origin'."
        cd ..
        continue
    fi

    # Esegue git fetch
    git fetch origin
    if [ $? -eq 0 ]; then
        log "git fetch origin eseguito con successo."
    else
        log "Errore in git fetch origin."
        cd ..
        continue
    fi

    # Mostra i branch remoti disponibili
    echo "Branch remoti disponibili (senza il prefisso 'origin/'):"
    git branch -r | sed 's/origin\///'

    # Ciclo per richiedere il branch fino a quando non viene eseguito correttamente il checkout
    checkout_success=0
    while [ $checkout_success -eq 0 ]; do
        echo "Inserisci il nome del branch da fare checkout:"
        
        # Leggo l'input dal terminale, non dallo standard input del ciclo
        read -r chosen_branch </dev/tty

        if [ -z "$chosen_branch" ]; then
            log "Nessun branch inserito, saltando il repository."
            cd ..
            continue
        fi

        # Se il branch non esiste localmente, lo creo tracciandolo da origin
        if git show-ref --verify --quiet "refs/heads/$chosen_branch"; then
            git checkout "$chosen_branch"
        else
            git checkout -b "$chosen_branch" "origin/$chosen_branch"
        fi

        if [ $? -eq 0 ]; then
            log "Checkout del branch '$chosen_branch' eseguito con successo."
            checkout_success=1;
        else
            log "Errore nel checkout del branch '$chosen_branch'."
        fi
    done

    # Rimuove il collegamento a git eliminando la cartella .git
    rm -rf .git
    if [ $? -eq 0 ]; then
        log "Rimozione della cartella .git eseguita con successo."
    else
        log "Errore nella rimozione della cartella .git."
    fi

    cd ..
    log "Elaborazione del repository '$repo_name' completata."
done < "$REPO_FILE"

log "Script completato."
