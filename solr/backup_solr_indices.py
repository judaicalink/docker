import os
import requests
import json
from datetime import datetime
from urllib.parse import urljoin

# === Konfiguration ===
SOLR_URL = os.getenv("SOLR_URL", "http://localhost:8983/solr/")
BACKUP_DIR = os.getenv("BACKUP_DIR", "./indices/backup/")
SAMBA_DIR = os.getenv("SAMBA_BACKUP_DIR")  # z.B. /mnt/samba/solr-backups
MAX_DOCS = int(os.getenv("MAX_DOCS", 10000000))  # Anzahl max. Dokumente pro Core

HEADERS = {"Accept": "application/json"}
TIMESTAMP = datetime.now().strftime("%Y%m%d-%H%M%S")

# === Hilfsfunktionen ===

def ensure_directory(path):
    os.makedirs(path, exist_ok=True)

def get_cores():
    status_url = urljoin(SOLR_URL, "admin/cores?action=STATUS&wt=json")
    response = requests.get(status_url, headers=HEADERS)
    response.raise_for_status()
    return list(response.json()["status"].keys())

def dump_core(core_name):
    print(f"📥 Exporting core: {core_name}")
    query_url = f"{SOLR_URL}{core_name}/select?wt=json&q=*:*&rows={MAX_DOCS}"
    response = requests.get(query_url, headers=HEADERS)
    response.raise_for_status()

    docs = response.json().get("response", {}).get("docs", [])
    print(f"  → {len(docs)} docs")

    filename = f"{core_name}-{TIMESTAMP}.json"
    local_path = os.path.join(BACKUP_DIR, filename)

    with open(local_path, "w", encoding="utf-8") as f:
        json.dump(docs, f, indent=2)

    print(f"  ✅ Saved to {local_path}")

    if SAMBA_DIR:
        samba_path = os.path.join(SAMBA_DIR, filename)
        with open(samba_path, "w", encoding="utf-8") as f:
            json.dump(docs, f, indent=2)
        print(f"  ☁️  Copied to Samba: {samba_path}")

def main():
    ensure_directory(BACKUP_DIR)
    if SAMBA_DIR:
        ensure_directory(SAMBA_DIR)

    try:
        cores = get_cores()
        print(f"🔍 Found {len(cores)} cores: {', '.join(cores)}")
        for core in cores:
            dump_core(core)
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    main()
