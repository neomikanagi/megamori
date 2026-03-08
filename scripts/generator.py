import json
import requests
import os

def generate_megamori():
    print("Processing megamori...")
    url = "https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockdns.txt"
    resp = requests.get(url)
    
    rules = {"version": 2, "rules": [{"domain": [], "domain_suffix": []}]}
    list_content = []
    
    if resp.status_code == 200:
        for line in resp.text.splitlines():
            line = line.strip()
            if line.startswith("||"):
                domain = line[2:].rstrip("^")
                rules["rules"][0]["domain"].append(domain)
                rules["rules"][0]["domain_suffix"].append(f".{domain}")
                list_content.append(f"DOMAIN-SUFFIX,{domain}")
                
        with open("megamori.json", "w") as f:
            json.dump(rules, f, indent=4)
        with open("megamori.list", "w") as f:
            f.write("\n".join(list_content))

def generate_ads_all_lite():
    print("Processing ads-all-lite...")
    url = "https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-category-ads-all.json"
    resp = requests.get(url)
    
    if resp.status_code == 200:
        data = resp.json()
        module_content = set()
        for rule in data.get("rules", []):
            for domain in rule.get("domain", []):
                module_content.add(f"DOMAIN-SUFFIX,{domain}")
                
        megamori_domains = set()
        if os.path.exists("megamori.list"):
            with open("megamori.list", "r") as f:
                megamori_domains = set(f.read().splitlines())
                
        unique = module_content - megamori_domains
        with open("ads-all-lite.list", "w") as f:
            f.write("\n".join(sorted(unique)))

if __name__ == "__main__":
    generate_megamori()
    generate_ads_all_lite()
    print("Python generation completed.")