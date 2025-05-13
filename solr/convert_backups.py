import os
import json

SOURCE_DIR = "./indices"  # Change this to your actual path

def convert_solr_backup_to_update_format(input_path, output_path):
    with open(input_path, "r", encoding="utf-8") as infile:
        data = json.load(infile)

    docs = [
        {k: v for k, v in doc.items() if k != "_version_"}
        for doc in data.get("response", {}).get("docs", [])
    ]
    if not docs:
        raise ValueError(f"No 'docs' found in {input_path}")

    with open(output_path, "w", encoding="utf-8") as outfile:
        json.dump(docs, outfile, indent=2)

    print(f"✅ Converted {len(docs)} docs → {output_path}")

def batch_convert_backups(source_dir):
    for filename in os.listdir(source_dir):
        if filename.endswith("-backup.json"):
            core_name = filename.replace("-backup.json", "")
            input_path = os.path.join(source_dir, filename)
            output_path = os.path.join(source_dir, f"{core_name}.json")
            try:
                convert_solr_backup_to_update_format(input_path, output_path)
            except Exception as e:
                print(f"❌ Failed to convert {filename}: {e}")

if __name__ == "__main__":
    batch_convert_backups(SOURCE_DIR)
