#!/bin/zsh

# --- PART 1: AUTO-ALIAS SETUP ---
ALIAS_NAME="newcustomer"  # <-- Endret her
ZSHRC="$HOME/.zshrc"
SCRIPT_PATH="${0:a}" # Gets the absolute path of this script

# Checks if the alias already exists in .zshrc
if ! grep -q "alias $ALIAS_NAME=" "$ZSHRC"; then
    echo "🔧 First time setup: Adding shortcut..."
    
    # Appends the alias to .zshrc
    echo "" >> "$ZSHRC"
    echo "# Auto-generated alias for OneDrive setup (English)" >> "$ZSHRC"
    echo "alias $ALIAS_NAME='$SCRIPT_PATH'" >> "$ZSHRC"
    
    echo "✅ Alias '$ALIAS_NAME' added to $ZSHRC"
    echo "💡 Note: Please run 'source ~/.zshrc' or restart your terminal for the shortcut to work."
    echo "-----------------------------------------------"
fi


# --- PART 2: ONEDRIVE CONFIGURATION ---
ONEDRIVE_BASE="$HOME/Library/CloudStorage"
# Finds the OneDrive folder automatically
ONEDRIVE_PATH=$(find "$ONEDRIVE_BASE" -maxdepth 1 -name "OneDrive-*" | head -n 1)

if [ -z "$ONEDRIVE_PATH" ]; then
    echo "❌ Could not find OneDrive folder in $ONEDRIVE_BASE."
    exit 1
fi

echo "✅ Found OneDrive: $ONEDRIVE_PATH"
echo "-----------------------------------------------"
echo "What would you like to do?"
echo "1) Setup Main File Structure (First run)"
echo "2) Add New Customer (Uses template)"
echo "q) Quit"
echo "-----------------------------------------------"
read -r "choice?Select an option (1/2/q): "

case $choice in
    1)
        echo "🚀 Creating main structure..."
        
        # 01 Admin & HR
        mkdir -p "$ONEDRIVE_PATH/01_Admin_HR"/{Contracts_Personnel,Timesheets_Expenses,Certifications_Training,Appraisals}
        
        # 02 Customers (Endret navn på hovedmappe for å matche 'Customer')
        mkdir -p "$ONEDRIVE_PATH/02_Customers"/{_TEMPLATES,Archive_Closed_Customers}
        
        # 03 Knowledge Library
        mkdir -p "$ONEDRIVE_PATH/03_Knowledge_Library"/{Scripts_Code,How-To_Guides,Whitepapers_PDFs,Best_Practice_Templates}
        
        # 04 Sales & Pre-sale
        mkdir -p "$ONEDRIVE_PATH/04_Sales_Presale"/{Proposals_Drafts,Product_Sheets_Pricing}
        
        # 05 Internal Projects
        mkdir -p "$ONEDRIVE_PATH/05_Internal_Projects"/{Internal_Migration,Security_Procedures}
        
        # 99 Personal & Misc
        mkdir -p "$ONEDRIVE_PATH/99_Personal_Misc"/{Notes_Drafts,Screenshots_Temp}
        
        echo "✅ Main structure successfully created!"
        ;;
    
    2)
        read -r "customer_name?Enter Customer Name: "
        if [ -z "$customer_name" ]; then
            echo "❌ Customer name cannot be empty."
            exit 1
        fi
        
        CLIENT_PATHS=(
            "01_Meeting_Minutes"
            "02_Projects"
            "03_Documentation/Cloud_Tenant_Config"
            "03_Documentation/Network_Infrastructure"
            "03_Documentation/Servers_Services"
            "03_Documentation/Support_Routines"
            "04_Correspondence"
            "05_Agreements_SLA"
            "06_Access_Info"
        )

        echo "🏗️ Creating folders for customer: $customer_name..."
        for subfolder in "${CLIENT_PATHS[@]}"; do
            # Endret hovedstien her også til 02_Customers
            mkdir -p "$ONEDRIVE_PATH/02_Customers/$customer_name/$subfolder"
        done
        
        echo "✅ Customer '$customer_name' created successfully!"
        ;;

    q)
        exit 0
        ;;
    *)
        echo "Invalid selection."
        ;;
esac
