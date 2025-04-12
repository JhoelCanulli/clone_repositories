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
# Script per rimuovere i file log.txt dalle sottocartelle verificando se il nome della cartella è presente in addresses.txt
# Il file addresses.txt deve essere posizionato nella directory corrente

# Percorso del file addresses.txt
ADDRESSES_FILE="./addresses.txt"

# Verifica se il file addresses.txt esiste
if [ ! -f "$ADDRESSES_FILE" ]; then
    echo "Errore: il file addresses.txt non esiste nella directory corrente."
    exit 1
fi

# Cicla ogni cartella nella directory corrente
for dir in */; do
    # Rimuove la barra finale dal nome della directory
    dir=${dir%/}
    
    echo "----------------------------------------"
    echo "Elaborazione della cartella: $dir"

    # Se esiste un file log.txt all'interno della cartella, lo elimina
    if [ -f "$dir/log.txt" ]; then
        rm "$dir/log.txt"
        echo "File log.txt rimosso da: $dir"
    else
        echo "Nessun file log.txt trovato in: $dir"
    fi

    # Verifica se il nome della cartella è presente nel file addresses.txt
    # Viene cercata la stringa "/<nome_cartella>.git"
    if grep -q "/${dir}.git" "$ADDRESSES_FILE"; then
        echo "La cartella '$dir' è presente in addresses.txt."
    else
        echo "La cartella '$dir' NON è presente in addresses.txt."
    fi
done

echo "----------------------------------------"
echo "Script completato."
