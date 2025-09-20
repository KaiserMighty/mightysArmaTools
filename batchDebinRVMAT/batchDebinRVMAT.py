import os
import subprocess

def debinarize_configs(directory):
    if not os.path.isdir(directory):
        print(f"The directory {directory} does not exist.")
        return
    
    for root, _, files in os.walk(directory):
        for filename in files:
            if filename.endswith('.rvmat'):
                file_path = os.path.join(root, filename)
                base_name = os.path.splitext(filename)[0]
                cpp_filename = f"{base_name}.cpp"
                cpp_file_path = os.path.join(root, cpp_filename)

                try:
                    subprocess.run(
                        ["CfgConvert.exe", "-txt", "-dst", cpp_file_path, file_path],
                        check=True
                    )
                    print(f"Successfully debinarized {file_path} -> {cpp_file_path}")
                except subprocess.CalledProcessError as e:
                    print(f"Failed to debinarize {file_path}: {e}")
                except Exception as e:
                    print(f"An error occurred with {file_path}: {e}")

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Recursively debinarize config .rvmat files to .cpp.")
    parser.add_argument("directory", help="Directory containing .rvmat files.")
    args = parser.parse_args()
    debinarize_configs(args.directory)