# Utility per la Gestione e Pulizia di Repository

Questo repository contiene una serie di script shell pensati per aiutare nella gestione e “ripulizia” di una serie di repository Git. In particolare, include:

- **pull_repositories.sh**:<br>
  Uno script che legge da un file di testo (`repos.txt`) contenente URL di repository, clona ciascun repository in una cartella dedicata (con il nome corrispondente), inizializza il controllo versione, aggiunge il remote, esegue il fetch e permette di effettuare il checkout di un branch specificato dall’utente. Al termine, rimuove la cartella nascosta `.git` per scollegare il repository dalla gestione Git (operazione utile per creare una copia “pulita”).

- **remove_childs_log.sh**:<br>
  Uno script che scansiona le sottocartelle alla ricerca del file `log.txt` (creato dallo script precedente), lo rimuove e verifica se il nome della cartella è presente in `addresses.txt`.

- **repos.txt** :<br>
  Un file di testo contenente la lista degli URL dei repository da processare.

---

## Prerequisiti

Assicurati di avere installato sul tuo sistema:

- **Bash** (oppure un ambiente Unix/Linux compatibile)
- **Git** (necessario per clonare i repository)
- Permessi di esecuzione per gli script (vedi Istruzioni sotto)

---

## Installazione e Download

1. **Clona il repository Git:**  
   Apri un terminale ed esegui:
   ``` bash
   git clone <URL-del-repository>
    ```
## Istruzioni di Utilizzo
1. ### Configurazione
- **Modifica** `repos.txt`:<br>
   Aggiorna il file repos.txt con la lista degli URL dei repository che desideri processare. Assicurati che ogni URL sia riportato in una riga separata.
-  (Facoltativo) Se previsto, verifica o crea il file `addresses.txt` nella stessa directory. Questo file verrà usato dallo script **remove_childs_log**.sh per controllare se il nome della cartella è presente.

2. ### Esecuzione degli Script
- **`pull_repositories.sh`**:<br>
    Questo script gestisce il processo di clonazione e configurazione dei repository.

    1. Rendi eseguibile lo script:
        ``` bash
        chmod +x pull_repositories.sh
        ```
    2. Esegui lo script:
        ``` bash
        ./pull_repositories.sh
        ```
    Durante l’esecuzione:
    - Verrà creata una cartella per ogni repository (basata sul nome dedotto dall’URL).
    - Verrà inizializzata la repository in locale, impostato il remote e effettuato il fetch.
    - Ti verrà chiesto di inserire il nome del branch da usare per il checkout.
    - Infine, verrà rimosso il collegamento Git (la cartella .git) per ottenere una copia “pulita”.

    Tutte le operazioni verranno loggate in un file `log.txt`, mentre gli URL dei repository processati saranno salvati in `addresses.txt`.

- **`remove_childs_log.sh`**:<br>
    Questo script rimuove i file `log.txt` presenti nelle sottocartelle e verifica la presenza del nome della cartella in `addresses.txt`.
    1. Rendi eseguibile lo script:
        ``` bash
        chmod +x remove_childs_log.sh
        ```
    2. Assicurati che il file `addresses.txt` si trovi nella directory corrente.
    3. Esegui lo script:
        ``` bash
        ./remove_childs_log.sh
        ```
    Verrà eseguito un ciclo su tutte le sottocartelle per rimuovere i file log.txt (se presenti) e per controllare la corrispondenza dei nomi con il file addresses.txt.
---
# Note
- ## Logging:
    I dettagli delle operazioni vengono riportati in log.txt (creato dallo script pull_repositories.sh). Puoi consultare questo file per verificare eventuali errori o la corretta esecuzione delle operazioni.

- ## Personalizzazione:
    Gli script possono essere modificati e adattati in base alle esigenze specifiche della community. Contribuzioni e miglioramenti sono benvenuti!