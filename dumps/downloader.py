import os
import re
import tarfile
import requests
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup
from datetime import datetime
import threading
import sys
import time
import shutil
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Read the base URL and save directory from the .env file
BASE_URL = os.getenv('BASE_URL')
SAVE_DIR = os.getenv('SAVE_DIR', 'downloads')  # Default to 'downloads' if not set
COPY_DIR = os.getenv('COPY_DIR', '/data/dumps')  # Default to 'copy' if not set


def download_file(url, save_path):
    """Downloads a file from a URL and saves it locally."""
    try:
        # If the save_path ends with a '/', treat it as a directory
        if os.path.isdir(save_path) or save_path.endswith('/'):
            print(f"Skipping directory: {save_path}")
            return

        response = requests.get(url, stream=True)
        response.raise_for_status()

        # Ensure the directory exists
        os.makedirs(os.path.dirname(save_path), exist_ok=True)

        # Write the content to the file
        with open(save_path, 'wb') as file:
            for chunk in response.iter_content(chunk_size=1024):
                file.write(chunk)

        print(f"Downloaded: {save_path}")
    except requests.exceptions.RequestException as e:
        print(f"Failed to download {url}: {e}")
    except IsADirectoryError:
        print(f"Error: {save_path} is a directory, not a file. Skipping.")


def download_directory(url, save_directory):
    """Recursively downloads all files and subdirectories from the given URL."""
    if not is_directory(url):
        parsed_url = urlparse(url)

        # Ensure the save_path is treated as a file, not a directory
        if parsed_url.path.endswith('/'):
            print(f"Skipping URL treated as a directory: {url}")
            return

        save_path = os.path.join(save_directory, parsed_url.path.lstrip('/'))
        download_file(url, save_path)
        return

    links = get_links(url)
    for link in links:
        print(f"Processing: {link}")
        if is_directory(link):
            download_directory(link, save_directory)
        else:
            parsed_url = urlparse(link)
            save_path = os.path.join(save_directory, parsed_url.path.lstrip('/'))
            download_file(link, save_path)

def get_links(url):
    """Retrieves all links from a given URL (assuming an HTML page)."""
    try:
        response = requests.get(url)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')

        links = []
        for link in soup.find_all('a', href=True):
            href = link['href']
            full_url = urljoin(url, href)
            links.append(full_url)

        return links
    except requests.exceptions.RequestException as e:
        print(f"Failed to fetch links from {url}: {e}")
        return []


def is_directory(url):
    """Checks if the URL represents a directory (heuristic: ends with `/`)."""
    return url.endswith('/')


def spinner():
    while not spinner_stop:
        for cursor in '|/-\\':
            sys.stdout.write(f'\rDownloading... {cursor}')
            sys.stdout.flush()
            time.sleep(0.1)

def download_file(url, save_path):
    global spinner_stop
    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    response = requests.get(url, stream=True)
    total_size = int(response.headers.get('content-length', 0))

    spinner_thread = threading.Thread(target=spinner)
    spinner_thread.start()

    with open(save_path, 'wb') as f:
        for chunk in response.iter_content(1024 * 1024):  # 1MB chunks
            if chunk:
                f.write(chunk)
    spinner_stop = True
    spinner_thread.join()
    print(f"\nDownloaded to {save_path}")
    return save_path

def extract_tar_gz(archive_path, extract_to):
    print(f"Unpacking {archive_path}...")
    with tarfile.open(archive_path, "r:gz") as tar:
        safe_members = [
            m for m in tar.getmembers()
            if not m.name.startswith(".git") and "/.git/" not in m.name and not m.name.endswith(".git")
        ]
        tar.extractall(path=extract_to, members=safe_members)
    print("Unpacking complete.")


def download_complete_dumps(url=BASE_URL, save_directory=SAVE_DIR):
    global spinner_stop
    try:
        response = requests.get(url)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        dump_links = []

        pattern = re.compile(r'dumps-complete-(\d{4}-\d{2}-\d{2})\.tar\.gz')

        for link in soup.find_all('a', href=True):
            href = link['href']
            match = pattern.search(href)
            if match:
                date_str = match.group(1)
                try:
                    date_obj = datetime.strptime(date_str, '%Y-%m-%d')
                    dump_links.append((date_obj, urljoin(url, href)))
                except ValueError:
                    continue

        if not dump_links:
            print("No complete dumps found.")
            return

        # Find the latest dump
        latest_date, latest_url = max(dump_links, key=lambda x: x[0])
        filename = os.path.basename(latest_url)
        save_path = os.path.join(save_directory, filename)

        print(f"Latest complete dump: {filename}")
        print("Starting download...")

        spinner_stop = False
        archive_path = download_file(latest_url, save_path)

        print("Download complete. Starting extraction...")
        extract_tar_gz(archive_path, save_directory)

    except requests.exceptions.RequestException as e:
        print(f"Failed to fetch complete dumps from {url}: {e}")


def copy_dumps(source_dir, target_dir):
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    for item in os.listdir(source_dir):
        s = os.path.join(source_dir, item)
        d = os.path.join(target_dir, item)

        if os.path.isdir(s):
            if os.path.exists(d):
                # merge contents instead of failing
                for sub_item in os.listdir(s):
                    sub_s = os.path.join(s, sub_item)
                    sub_d = os.path.join(d, sub_item)
                    if os.path.isdir(sub_s):
                        shutil.copytree(sub_s, sub_d, dirs_exist_ok=True)
                    else:
                        shutil.copy2(sub_s, sub_d)
            else:
                shutil.copytree(s, d)
        else:
            shutil.copy2(s, d)

if __name__ == "__main__":
    if not BASE_URL or not BASE_URL.endswith('/'):
        print("Error: Ensure the BASE_URL in the .env file ends with a `/` for proper directory scanning.")
    else:
        print(f"Starting download from {BASE_URL} to {SAVE_DIR}")
       #download_directory(BASE_URL, SAVE_DIR)
        download_complete_dumps(BASE_URL, SAVE_DIR)
        copy_dumps(SAVE_DIR, COPY_DIR)
        print("Download complete.")


