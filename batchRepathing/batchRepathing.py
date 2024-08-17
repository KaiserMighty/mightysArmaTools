import os

def replace_string_in_p3d_files(directory, paths):
    if not os.path.isdir(directory):
        print(f"The directory {directory} does not exist.")
        return

    if not os.path.isfile(paths):
        print(f"The paths file {paths} does not exist.")
        return

    replacements = []
    with open(paths, 'r') as file:
        for line in file:
            parts = line.strip().split('" "')
            if len(parts) == 2:
                old = parts[0].strip('"')
                new = parts[1].strip('"')
                replacements.append((old.encode('utf-8'), new.encode('utf-8')))

    for filename in os.listdir(directory):
        if filename.endswith('.p3d'):
            filepath = os.path.join(directory, filename)
            with open(filepath, 'rb') as file:
                file_contents = file.read()
            for old_bytes, new_bytes in replacements:
                file_contents = file_contents.replace(old_bytes, new_bytes)
            with open(filepath, 'wb') as file:
                file.write(file_contents)
            print(f"Repathed {filename}")

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Replace a path in all .p3d files in a directory.")
    parser.add_argument("directory", type=str, help="The directory containing .p3d files")
    parser.add_argument("-p", type=str, default="paths.txt", help="The path to the file containing all paths")
    args = parser.parse_args()
    replace_string_in_p3d_files(args.directory, args.p)