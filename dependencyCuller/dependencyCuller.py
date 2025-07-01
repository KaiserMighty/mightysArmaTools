import os
import re

TARGET_DIR = "target"
DEPENDENCIES_DIR = "dependencies"
OUTPUT_FILE = "output.txt"

referenced_paths = set()

def extract_paths_from_rvmat(rvmat_rel_path):
    rvmat_full_path = os.path.join(DEPENDENCIES_DIR, rvmat_rel_path)
    if not os.path.isfile(rvmat_full_path):
        return

    try:
        with open(rvmat_full_path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()

        matches = re.findall(r'texture\s*=\s*["\']([^"\']+\.paa)["\']\s*;', content, re.IGNORECASE)
        for match in matches:
            normalized_path = os.path.normpath(match).lower()
            referenced_paths.add(normalized_path)
    except Exception as e:
        print(f"Error reading .rvmat: {rvmat_rel_path}: {e}")

def extract_paths_from_p3d(file_path):
    with open(file_path, "rb") as f:
        data = f.read()

    for match in re.finditer(rb'[\w./\\-]{5,260}\.(paa|rvmat)', data, flags=re.IGNORECASE):
        try:
            path = match.group(0).decode('utf-8')
            normalized_path = os.path.normpath(path).lower()
            referenced_paths.add(normalized_path)
            if normalized_path.endswith(".rvmat"):
                extract_paths_from_rvmat(normalized_path)
        except UnicodeDecodeError:
            continue

def collect_p3d_references():
    for root, _, files in os.walk(TARGET_DIR):
        for file in files:
            if file.lower().endswith(".p3d"):
                p3d_path = os.path.join(root, file)
                extract_paths_from_p3d(p3d_path)

def extract_paths_from_configs():
    print("Scanning config.bin and config.cpp for picture references...")
    for root, _, files in os.walk(TARGET_DIR):
        for file in files:
            if file.lower() == "config.bin":
                config_path = os.path.join(root, file)
                try:
                    with open(config_path, "rb") as f:
                        data = f.read()
                    matches = re.findall(rb'picture\s+([\\/][\w./\\-]{5,260}\.paa)', data, flags=re.IGNORECASE)
                    for match in matches:
                        try:
                            path = match.decode("utf-8")
                            normalized_path = os.path.normpath(path).lower()
                            referenced_paths.add(normalized_path)
                        except UnicodeDecodeError:
                            continue
                except Exception as e:
                    print(f"Failed to read binary config: {config_path}: {e}")

            elif file.lower() == "config.cpp":
                config_path = os.path.join(root, file)
                try:
                    with open(config_path, "r", encoding="utf-8", errors="ignore") as f:
                        content = f.read()
                    matches = re.findall(r'picture\s*=\s*["\']([\\/][^"\']+\.paa)["\']', content, flags=re.IGNORECASE)
                    for match in matches:
                        normalized_path = os.path.normpath(match).lower()
                        referenced_paths.add(normalized_path)
                except Exception as e:
                    print(f"Failed to read cpp config: {config_path}: {e}")

def verify_dependencies():
    print("Verifying referenced paths...")
    all_existing_files = set()

    for root_dir in [DEPENDENCIES_DIR, TARGET_DIR]:
        for root, _, files in os.walk(root_dir):
            for file in files:
                rel_path = os.path.relpath(os.path.join(root, file), root_dir)
                normalized = os.path.normpath(rel_path).lower()
                all_existing_files.add(normalized)

    for path in referenced_paths:
        if path.lower().startswith("a3\\") or path.lower().startswith("a3/"):
            continue
        if path.lower() not in all_existing_files:
            print(f"Missing: {path}")

def find_extra_files():
    print("Searching for unreferenced files...")
    all_dependency_files = set()
    for root, _, files in os.walk(DEPENDENCIES_DIR):
        for file in files:
            if file.lower().endswith((".paa", ".rvmat")):
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, DEPENDENCIES_DIR)
                normalized_path = os.path.normpath(rel_path).lower()
                all_dependency_files.add(normalized_path)

    referenced_lower = set(path.lower() for path in referenced_paths)
    extra_files = sorted(all_dependency_files - referenced_lower)

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        for file in extra_files:
            f.write(file + "\n")

    print(f"Unreferenced files written to: {OUTPUT_FILE}")

def delete_unreferenced_files():
    print("Deleting unreferenced files...")

    if not os.path.isfile(OUTPUT_FILE):
        print(f"{OUTPUT_FILE} not found. Skipping deletion.")
        return

    with open(OUTPUT_FILE, "r", encoding="utf-8") as f:
        extra_files = set(os.path.normpath(line.strip()).lower() for line in f if line.strip())

    deleted = 0
    for root, _, files in os.walk(DEPENDENCIES_DIR):
        for file in files:
            full_path = os.path.join(root, file)
            rel_path = os.path.relpath(full_path, DEPENDENCIES_DIR)
            normalized_rel = os.path.normpath(rel_path).lower()

            if normalized_rel in extra_files:
                try:
                    os.remove(full_path)
                    print(f"Deleted: {rel_path}")
                    deleted += 1
                except Exception as e:
                    print(f"Failed to delete {rel_path}: {e}")

    print(f"Finished. Deleted {deleted} files.")

def main():
    collect_p3d_references()
    extract_paths_from_configs()
    verify_dependencies()
    find_extra_files()
    delete_unreferenced_files()

if __name__ == "__main__":
    main()
