import json
import requests

# Step 1: Fetch the JSON rules from the URL
url = "https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-category-ads-all.json"
response = requests.get(url)

# Initialize the list for module
module_content = set()

# Step 2: Parse the fetched JSON file
if response.status_code == 200:
    data = response.json()
    for rule in data.get("rules", []):
        domains = rule.get("domain", [])
        for domain in domains:
            # For module format, remove REJECT and change to "list" suffix
            module_content.add(f"DOMAIN-SUFFIX,{domain},list")

# Step 3: Read the existing megamori.module to remove duplicates
with open("megamori.module", "r") as megamori_file:
    megamori_domains = set(megamori_file.read().splitlines())

# Step 4: Remove duplicate domains
unique_domains = module_content - megamori_domains

# Step 5: Write to a new module file
with open("ads-all-lite.module", "w") as lite_module_file:
    lite_module_file.write("\n".join(unique_domains))

print("ads-all-lite.module has been generated after removing duplicates.")
