import os
import subprocess

def debinarize_files(directory):
    if not os.path.isdir(directory):
        print(f"The directory {directory} does not exist.")
        return
    
    for filename in os.listdir(directory):
        if filename.endswith('.p3d') and not filename.endswith('_mlod.p3d'):
            file_path = os.path.join(directory, filename)
            try:
                subprocess.run(["P3DDebinarizer-1.exe", file_path], check=True)
                print(f"Successfully debinarized {filename}")
                base_name = filename[:-4]
                mlod_filename = f"{base_name}_mlod.p3d"
                mlod_file_path = os.path.join(directory, mlod_filename)
                if os.path.exists(mlod_file_path):
                    os.remove(file_path)
                    final_filename = f"{base_name}.p3d"
                    final_file_path = os.path.join(directory, final_filename)
                    os.rename(mlod_file_path, final_file_path)
                else:
                    print(f"Error: Expected output file {mlod_filename} not found.")
            except subprocess.CalledProcessError as e:
                print(f"Failed to debinarize {filename}: {e}")
            except Exception as e:
                print(f"An error occurred: {e}")

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Bulk debinarize P3D models.")
    parser.add_argument("directory", help="Directory containing .p3d files.")
    args = parser.parse_args()
    debinarize_files(args.directory)