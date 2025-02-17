import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Read the base URL and save directory from the .env file
BASE_URL = os.getenv('BASE_URL')
SAVE_DIR = os.getenv('SAVE_DIR', 'downloads')  # Default to 'downloads' if not set


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



if __name__ == "__main__":
    if not BASE_URL or not BASE_URL.endswith('/'):
        print("Error: Ensure the BASE_URL in the .env file ends with a `/` for proper directory scanning.")
    else:
        print(f"Starting download from {BASE_URL} to {SAVE_DIR}")
        download_directory(BASE_URL, SAVE_DIR)
        print("Download complete.")
