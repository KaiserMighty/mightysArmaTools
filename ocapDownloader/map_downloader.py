import io
import os
import sys
import argparse
import py7zr
import time
import gdown

from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload

SCOPES = ['https://www.googleapis.com/auth/drive.readonly']
SERVICE_ACCOUNT_FILE = 'credentials.json'
OUTPUT_DIR = os.getcwd()

def download_file_with_retry(file_url, file_name, retries=3, delay=5):
    file_path = os.path.join(OUTPUT_DIR, file_name)
    
    print(f"Downloading {file_name}...")

    for attempt in range(retries):
        try:
            gdown.download(file_url, file_path, quiet=False)
            print(f"Downloaded: {file_name}")
            return file_path
        except Exception as e:
            print(f"Attempt {attempt + 1}/{retries} failed: {e}")
            if attempt < retries - 1:
                time.sleep(delay)
            else:
                raise RuntimeError(f"Failed to download {file_name} after {retries} attempts: {e}")

def extract_folder_id(folder_url):
    if "folders/" in folder_url:
        return folder_url.split("folders/")[1].split("?")[0]
    raise ValueError("Invalid folder URL.")

def authenticate_drive():
    credentials = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES
    )
    return build('drive', 'v3', credentials=credentials)

def list_files_in_folder(service, folder_id):
    files = []
    page_token = None

    query = f"'{folder_id}' in parents and trashed = false"

    while True:
        response = service.files().list(
            q=query,
            spaces='drive',
            fields='nextPageToken, files(id, name, mimeType)',
            pageToken=page_token
        ).execute()

        for file in response.get('files', []):
            if file['name'].endswith('.7z'):
                files.append(file)

        page_token = response.get('nextPageToken', None)
        if page_token is None:
            break

    return files

def main(folder_url):
    folder_id = extract_folder_id(folder_url)
    service = authenticate_drive()

    print("Fetching file list from Drive API...")
    files = list_files_in_folder(service, folder_id)

    if not files:
        print("No .7z files found in the folder.")
        return

    for file in files:
        try:
            file_url = f"https://drive.google.com/uc?id={file['id']}"
            download_file_with_retry(file_url, file['name'])

            print(f"Extracting {file['name']}...")
            file_path = os.path.join(OUTPUT_DIR, file['name'])
            with py7zr.SevenZipFile(file_path, mode='r') as archive:
                archive.extractall(path=OUTPUT_DIR)

            os.remove(file_path)
            print(f"Deleted: {file['name']} after extraction")

        except Exception as e:
            print(f"Failed to download or extract {file['name']}: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("folder_url", help="Public Google Drive folder URL")
    args = parser.parse_args()

    main(args.folder_url)
