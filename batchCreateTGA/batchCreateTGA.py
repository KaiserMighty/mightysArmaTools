import os
import subprocess
from PIL import Image

def convert_paa_to_png(file_path):
    png_file_path = file_path.replace('.paa', '.png')
    subprocess.run(["Pal2PacE.exe", file_path, png_file_path])
    return png_file_path

def convert_png_to_tga(png_file_path):
    tga_file_path = png_file_path.replace('.png', '.tga')
    with Image.open(png_file_path) as img:
        img.save(tga_file_path)
        print(f"Converted {png_file_path} to {tga_file_path}")
    return tga_file_path

def process_paa_file(file_path):
    if file_path.lower().endswith('.paa'):
        png_file_path = convert_paa_to_png(file_path)
        convert_png_to_tga(png_file_path)
        os.remove(png_file_path)

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Create a duplicated .tga file from a .paa file.")
    parser.add_argument("directory", help="Directory containing .paa images.")
    args = parser.parse_args()
    for root, dirs, files in os.walk(args.directory):
        for file in files:
            file_path = os.path.join(root, file)
            process_paa_file(file_path)
