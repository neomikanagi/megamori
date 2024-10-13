import json
import requests

# Step 1: Fetch the TXT rules from the URL
url = "https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockdns.txt"
response = requests.get(url)

rules = {
    "version": 2,
    "rules": [
        {
            "domain": [],
            "domain_suffix": []
        }
    ]
}

# Step 2: Parse the fetched TXT file
if response.status_code == 200:
    lines = response.text.splitlines()
    for line in lines:
        line = line.strip()
        if line.startswith("||"):
            domain = line[2:].rstrip("^")
            rules["rules"][0]["domain"].append(domain)
            rules["rules"][0]["domain_suffix"].append(f".{domain}")

# Step 3: Write to a JSON file
with open("megamori.json", "w") as json_file:
    json.dump(rules, json_file, indent=4)

print("Conversion completed. The megamori.json file has been generated.")
