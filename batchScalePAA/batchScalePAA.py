import os
import subprocess
from PIL import Image

def convert_paa_to_png(file_path):
    png_file_path = file_path.replace('.paa', '.png')
    subprocess.run(["Pal2PacE.exe", file_path, png_file_path])
    return png_file_path

def convert_png_to_paa(png_file_path):
    paa_file_path = png_file_path.replace('.png', '.paa')
    subprocess.run(["Pal2PacE.exe", png_file_path, paa_file_path])
    os.remove(png_file_path)
    return paa_file_path

def scale_image(file_path, scale_factor):
    with Image.open(file_path) as img:
        width, height = img.size
        img = img.resize((width // scale_factor, height // scale_factor))
        img.save(file_path)
        print(f"Scaled down {file_path} by a factor of {scale_factor}")

def process_directory(directory, scale_factor):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith('.paa'):
                file_path = os.path.join(root, file)
                png_file_path = convert_paa_to_png(file_path)
                scale_image(png_file_path, scale_factor)
                convert_png_to_paa(png_file_path)

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Scale down .paa textures to half their size.")
    parser.add_argument("directory", help="Directory containing .paa textures.")
    parser.add_argument("--f", type=int, default=2, help="Factor by which to scale down images (default is 2).")
    args = parser.parse_args()
    process_directory(args.directory, args.f)
