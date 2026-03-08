#!/bin/bash
# ==============================================================================
# Sing-Box AdGuard Rule Set Compiler - Ultimate Edition
# Features: Strict mode, Data-driven config, Safe temp workspace, Retry logic
# ==============================================================================

# Enable strict mode: exit on error, undefined variable, or pipe failure
set -euo pipefail

# ==================== Configuration ====================
# Format: output_filename | minimum_srs_size_bytes | URL1 | URL2 | ...
declare -a RULE_SETS=(
    "megamori.srs|1024|https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockdns.txt"
    "hagezi_pro_plus_adblock.srs|1024|https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.plus.txt"
    "hagezi_spam_tlds_adblock.srs|1024|https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/spam-tlds.txt"
    "hagezi_tif_adblock.srs|1024|https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt"
    "yokoffing_privacy_essentials.srs|500|https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/privacy_essentials.txt"
    "respect_my_internet.srs|1024|https://raw.githubusercontent.com/DXC-0/Respect-My-Internet/main/blocklist/respect-my-internet.txt"
    "adguard_japanese.srs|1024|https://adguardteam.github.io/AdguardFilters/JapaneseFilter/sections/adservers.txt|https://adguardteam.github.io/AdguardFilters/JapaneseFilter/sections/adservers_firstparty.txt"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ==================== Dependency Check ====================
for cmd in curl sing-box; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${RED}❌ Error: '$cmd' is not installed. Please install it first.${NC}"
        exit 1
    fi
done

# ==================== Safe Workspace Management ====================
# Create an isolated temporary directory to avoid polluting the working directory
TMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMP_DIR"
    echo -e "${YELLOW}🧹 Temporary workspace cleaned up.${NC}"
}
trap cleanup EXIT

# ==================== Core Compiler Function ====================
process_rule_set() {
    local output_srs="$1"
    local min_size="$2"
    shift 2
    local urls=("$@")

    echo -e "${BLUE}---------------------------------------------------${NC}"
    echo -e "${BLUE}🚀 Processing: ${output_srs}${NC}"

    local combined_txt="$TMP_DIR/combined.txt"
    > "$combined_txt" # Reset the file for the current loop

    # Download and merge all URLs for this specific rule set
    for url in "${urls[@]}"; do
        echo -e "${BLUE}📥 Downloading: ${url}${NC}"
        local chunk_txt="$TMP_DIR/chunk.txt"
        
        # curl explanation:
        # -sSLf: Silent, show errors, follow redirects, FAIL on HTTP errors (404/500)
        # --retry 3: Retry up to 3 times on transient network failures
        if ! curl -sSLf --connect-timeout 10 --max-time 30 --retry 3 -o "$chunk_txt" "$url"; then
            echo -e "${RED}❌ Error: Failed to download from $url${NC}"
            exit 1
        fi

        # Append to the combined file
        cat "$chunk_txt" >> "$combined_txt"
        rm -f "$chunk_txt"
    done

    # Validate the raw combined text size before converting
    local raw_size=$(wc -c < "$combined_txt")
    echo -e "${BLUE}📊 Combined raw size: ${raw_size} bytes${NC}"
    if [ "$raw_size" -lt "$min_size" ]; then
        echo -e "${RED}❌ Error: Raw data size (${raw_size}) is below minimum (${min_size}).${NC}"
        exit 1
    fi

    # Execute sing-box conversion
    echo -e "${BLUE}⚙️ Converting to SRS format...${NC}"
    sing-box rule-set convert --type adguard --output "$output_srs" "$combined_txt" 2>&1 | grep -v "DEBUG" || true

    # Validate output existence
    if [ ! -f "$output_srs" ]; then
        echo -e "${RED}❌ Error: Sing-box failed to generate ${output_srs}.${NC}"
        exit 1
    fi

    # Validate compiled binary size
    local srs_size=$(wc -c < "$output_srs")
    echo -e "${BLUE}📦 Compiled SRS size: ${srs_size} bytes${NC}"
    if [ "$srs_size" -lt "$min_size" ]; then
        echo -e "${RED}❌ Error: ${output_srs} size (${srs_size}) is too small!${NC}"
        echo -e "${YELLOW}💡 Tip: If the source contains only IP addresses, sing-box ignores them and outputs an empty file.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Success: ${output_srs} is ready.${NC}"
}

# ==================== Main Execution ====================
echo -e "${GREEN}🎬 Starting rule set compilation...${NC}"

for entry in "${RULE_SETS[@]}"; do
    # Parse the configuration string safely
    IFS='|' read -r output_filename min_size url_str <<< "$entry"
    IFS='|' read -ra url_array <<< "$url_str"
    
    process_rule_set "$output_filename" "$min_size" "${url_array[@]}"
done

echo -e "${BLUE}---------------------------------------------------${NC}"
echo -e "${GREEN}🎉 All tasks completed successfully!${NC}"
