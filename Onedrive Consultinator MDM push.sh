#!/bin/zsh

# --- CONFIGURATION ---
# We are running as the signed-in user, so $HOME works correctly
ALIAS_NAME="newcustomer"
ZSHRC="$HOME/.zshrc"

# We need to know where the permanent tool script should live.
# Since Intune runs this script temporarily and then discards it, we must 
# WRITE the "New Customer" tool to a persistent file on the user's Mac 
# so the alias has something to point to later.
DESTINATION_SCRIPT="$HOME/Library/Scripts/create_customer.sh"

# Check if the scripts folder exists, create if not
if [ ! -d "$HOME/Library/Scripts" ]; then
    mkdir -p "$HOME/Library/Scripts"
fi

# --- STEP 1: ONEDRIVE STRUCTURE SETUP ---
ONEDRIVE_BASE="$HOME/Library/CloudStorage"
# Find the OneDrive folder automatically
ONEDRIVE_PATH=$(find "$ONEDRIVE_BASE" -maxdepth 1 -name "OneDrive-*" | head -n 1)

if [ -z "$ONEDRIVE_PATH" ]; then
    echo "❌ OneDrive not found. OneDrive must be signed in before running this."
    exit 1 # Fail so Intune can report the error
fi

echo "✅ Found OneDrive: $ONEDRIVE_PATH"
echo "🚀 Creating standard folder structure..."

# Create folders directly (silent mode, no user prompt)
mkdir -p "$ONEDRIVE_PATH/01_Admin_HR"/{Contracts_Personnel,Timesheets_Expenses,Certifications_Training,Appraisals}
mkdir -p "$ONEDRIVE_PATH/02_Customers"/{_TEMPLATES,Archive_Closed_Customers}
mkdir -p "$ONEDRIVE_PATH/03_Knowledge_Library"/{Scripts_Code,How-To_Guides,Whitepapers_PDFs,Best_Practice_Templates}
mkdir -p "$ONEDRIVE_PATH/04_Sales_Presale"/{Proposals_Drafts,Product_Sheets_Pricing}
mkdir -p "$ONEDRIVE_PATH/05_Internal_Projects"/{Internal_Migration,Security_Procedures}
mkdir -p "$ONEDRIVE_PATH/99_Personal_Misc"/{Notes_Drafts,Screenshots_Temp}

echo "✅ Folder structure created."


# --- STEP 2: INSTALL "NEW CUSTOMER" TOOL ---
# Here we write the actual customer generator code to a persistent file on the Mac
cat << 'EOF' > "$DESTINATION_SCRIPT"
#!/bin/zsh
# This script was installed via Intune
ONEDRIVE_BASE="$HOME/Library/CloudStorage"
ONEDRIVE_PATH=$(find "$ONEDRIVE_BASE" -maxdepth 1 -name "OneDrive-*" | head -n 1)

if [ -z "$ONEDRIVE_PATH" ]; then
    echo "❌ Could not find OneDrive."
    exit 1
fi

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
    mkdir -p "$ONEDRIVE_PATH/02_Customers/$customer_name/$subfolder"
done
echo "✅ Customer '$customer_name' created successfully!"
EOF

# Make the new script executable
chmod +x "$DESTINATION_SCRIPT"


# --- STEP 3: CONFIGURE ALIAS ---
# Check if the alias already exists to avoid duplicates
if ! grep -q "alias $ALIAS_NAME=" "$ZSHRC"; then
    echo "🔧 Adding alias to .zshrc..."
    echo "" >> "$ZSHRC"
    echo "# Intune generated alias" >> "$ZSHRC"
    echo "alias $ALIAS_NAME='$DESTINATION_SCRIPT'" >> "$ZSHRC"
    echo "✅ Alias added."
else
    echo "ℹ️ Alias already exists."
fi

exit 0
