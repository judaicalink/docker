import os
import json
import requests

SOLR_URL = "http://localhost:8983/solr"  # Adjust as needed
DATA_DIR = "./indices"  # Where your backups are located
HEADERS = {"Content-Type": "application/json"}

def convert_and_upload(file_path):
    filename = os.path.basename(file_path)
    if not filename.endswith("-backup.json"):
        return

    core_name = filename.replace("-backup.json", "")
    upload_path = os.path.join(DATA_DIR, f"{core_name}.upload.json")

    with open(file_path, "r", encoding="utf-8") as infile:
        try:
            data = json.load(infile)
            docs = data.get("response", {}).get("docs", [])
            if not docs:
                print(f"❌ No docs found in {filename}")
                return
        except Exception as e:
            print(f"❌ Failed to parse {filename}: {e}")
            return

    with open(upload_path, "w", encoding="utf-8") as outfile:
        json.dump(docs, outfile, indent=2)

    print(f"✅ Extracted {len(docs)} docs from {filename} → {upload_path}")

    # Upload to Solr
    post_url = f"{SOLR_URL}/{core_name}/update?commit=true"
    try:
        with open(upload_path, "rb") as f:
            response = requests.post(post_url, headers=HEADERS, data=f)
            response.raise_for_status()
            print(f"✅ Uploaded to core '{core_name}': {response.status_code}")
    except Exception as e:
        print(f"❌ Upload to '{core_name}' failed: {e}")

def main():
    for file in os.listdir(DATA_DIR):
        if file.endswith("-backup.json"):
            convert_and_upload(os.path.join(DATA_DIR, file))

if __name__ == "__main__":
    main()
