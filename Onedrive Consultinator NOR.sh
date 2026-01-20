#!/bin/zsh

# --- DEL 1: SJEKK OG OPPRETT ALIAS AUTOMATISK ---
ALIAS_NAME="nykunde"
ZSHRC="$HOME/.zshrc"
SCRIPT_PATH="${0:a}" # Henter full sti til denne filen

# Sjekker om aliaset allerede finnes i .zshrc
if ! grep -q "alias $ALIAS_NAME=" "$ZSHRC"; then
    echo "🔧 Førstegangsoppsett: Legger til snarvei..."
    
    # Legger til en ny linje for sikkerhets skyld, og deretter aliaset
    echo "" >> "$ZSHRC"
    echo "# Auto-generated alias for OneDrive setup" >> "$ZSHRC"
    echo "alias $ALIAS_NAME='$SCRIPT_PATH'" >> "$ZSHRC"
    
    echo "✅ Alias '$ALIAS_NAME' er lagt til i $ZSHRC"
    echo "💡 Merk: Du må skrive 'source ~/.zshrc' eller starte terminalen på nytt for at snarveien skal virke."
    echo "-----------------------------------------------"
fi


# --- DEL 2: KONFIGURASJON AV ONEDRIVE ---
ONEDRIVE_BASE="$HOME/Library/CloudStorage"
ONEDRIVE_PATH=$(find "$ONEDRIVE_BASE" -maxdepth 1 -name "OneDrive-*" | head -n 1)

if [ -z "$ONEDRIVE_PATH" ]; then
    echo "❌ Kunne ikke finne OneDrive-mappen i $ONEDRIVE_BASE."
    exit 1
fi

echo "✅ Fant OneDrive: $ONEDRIVE_PATH"
echo "-----------------------------------------------"
echo "Hva vil du gjøre?"
echo "1) Sett opp Hovedstruktur (Førstegangs-oppsett)"
echo "2) Legg til ny Kunde (bruker mal)"
echo "q) Avslutt"
echo "-----------------------------------------------"
read -r "choice?Velg et alternativ (1/2/q): "

case $choice in
    1)
        echo "🚀 Oppretter hovedstruktur..."
        mkdir -p "$ONEDRIVE_PATH/01_Administrasjon_HR"/{Arbeidskontrakt_og_Personal,Timelister_og_Utlegg,Kurs_og_Sertifiseringer,Medarbeidersamtaler}
        mkdir -p "$ONEDRIVE_PATH/02_Kunder"/{_MALER,Arkiv_Avsluttede_Kunder}
        mkdir -p "$ONEDRIVE_PATH/03_Faglig_Bibliotek"/{Scripts_og_Kode,How-To_Guider,Whitepapers_og_PDFer,Best_Practice_Templates}
        mkdir -p "$ONEDRIVE_PATH/04_Salg_og_Pre-sale"/{Tilbud_Utkast,Produktark_og_Prislister}
        mkdir -p "$ONEDRIVE_PATH/05_Prosjekter_Internt"/{Migrering_Internt,Sikkerhetsrutiner}
        mkdir -p "$ONEDRIVE_PATH/99_Personlig_og_Diverse"/{Notater_Kladder,Screenshots_Temp}
        
        echo "✅ Hovedstruktur er ferdig montert!"
        ;;
    
    2)
        read -r "customer_name?Skriv inn navnet på kunden: "
        if [ -z "$customer_name" ]; then
            echo "❌ Kundenavn kan ikke være tomt."
            exit 1
        fi
        
        KUNDE_STIER=(
            "01_Møtereferater"
            "02_Prosjekter"
            "03_Dokumentasjon/Skyløsninger_og_Tenant"
            "03_Dokumentasjon/Nettverk_og_Infrastruktur"
            "03_Dokumentasjon/Servere_og_Tjenester"
            "03_Dokumentasjon/Brukerstøtte_Rutiner"
            "04_Korrespondanse"
            "05_Avtaler_og_SLA"
            "06_Tilganger_og_Info"
        )

        echo "🏗️ Oppretter mapper for kunde: $customer_name..."
        for subfolder in "${KUNDE_STIER[@]}"; do
            mkdir -p "$ONEDRIVE_PATH/02_Kunder/$customer_name/$subfolder"
        done
        
        echo "✅ Kunde '$customer_name' er opprettet!"
        ;;

    q)
        exit 0
        ;;
esac
