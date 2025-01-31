import os
import subprocess
import re

def convert_rvmat_to_cpp(rvmat_path, cfgconvert_path):
    cpp_path = os.path.splitext(rvmat_path)[0] + ".cpp"
    subprocess.run([cfgconvert_path, "-txt", "-dst", cpp_path, rvmat_path], check=True)
    return cpp_path

def convert_cpp_to_rvmat(cpp_path, cfgconvert_path):
    rvmat_path = os.path.splitext(cpp_path)[0] + ".rvmat"
    subprocess.run([cfgconvert_path, "-bin", "-dst", rvmat_path, cpp_path], check=True)
    return rvmat_path

def case_insensitive_replace(content, old, new):
    def replace_match(match):
        matched_text = match.group(0)
        if matched_text.isupper():
            return new.upper()
        elif matched_text[0].isupper():
            return new.capitalize()
        else:
            return new
        
    pattern = re.compile(re.escape(old), re.IGNORECASE)
    return pattern.sub(replace_match, content)

def repath(directory, paths, cfgconvert_path):
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
                replacements.append((old, new))

    for filename in os.listdir(directory):
        if filename.endswith('.rvmat'):
            rvmat_path = os.path.join(directory, filename)
            
            try:
                cpp_path = convert_rvmat_to_cpp(rvmat_path, cfgconvert_path)
                os.remove(rvmat_path)

                with open(cpp_path, 'r', encoding='utf-8') as file:
                    file_contents = file.read()

                for old, new in replacements:
                    file_contents = case_insensitive_replace(file_contents, old, new)

                with open(cpp_path, 'w', encoding='utf-8') as file:
                    file.write(file_contents)

                convert_cpp_to_rvmat(cpp_path, cfgconvert_path)
                os.remove(cpp_path)
                
                print(f"Repathed {filename}")

            except subprocess.CalledProcessError:
                print(f"Error processing {filename}")

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Replace a path in all .p3d files in a directory.")
    parser.add_argument("directory", type=str, help="The directory containing .p3d files")
    parser.add_argument("-p", type=str, default="paths.txt", help="The path to the file containing all paths")
    parser.add_argument("-c", type=str, default="CfgConvert.exe", help="Path to CfgConvert.exe")
    args = parser.parse_args()
    repath(args.directory, args.p, args.c)