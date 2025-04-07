import os
import re
import sys
import subprocess
from mutagen.oggvorbis import OggVorbis

if len(sys.argv) < 2:
    print("Usage: python script.py <spotify_playlist_url>")
    sys.exit(1)

SPOTIFY_PLAYLIST_URL = sys.argv[1]
MUSIC_DIR = "music"
PLAYLIST_FILE = "output.txt"

os.makedirs(MUSIC_DIR, exist_ok=True)
subprocess.run(["spotdl", SPOTIFY_PLAYLIST_URL, "--output", MUSIC_DIR])

def sanitize_filename(filename):
    filename = re.sub(r"[^a-zA-Z0-9\s]", "", filename)
    filename = filename.title().replace(" ", "")
    return filename

song_data = []

for file in os.listdir(MUSIC_DIR):
    if file.endswith(".mp3"):
        input_path = os.path.join(MUSIC_DIR, file)
        base_name = os.path.splitext(file)[0]
        sanitized_name = sanitize_filename(base_name)
        output_path = os.path.join(MUSIC_DIR, f"{sanitized_name}.ogg")

        subprocess.run([
            "ffmpeg", "-i", input_path, "-vn", "-c:a", "libvorbis", "-b:a", "64k", "-ar", "44100", output_path, "-y"
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

        audio = OggVorbis(output_path)
        duration = int(audio.info.length)
        song_data.append((sanitized_name, duration))

        os.remove(input_path)

playlist_entries = '\n\t'.join([f'["{name}", {duration}],' for name, duration in song_data])
cfg_entries = '\n\t'.join([f'class {name}\n\t{{\n\t\tsound[] = {{"121_TACDEVRON_Radio\\data\\music\\{name}.ogg", db+10, 1, 1000}};\n\t\ttitles[] = {{}};\n\t}};' for name, _ in song_data])

playlist_content = f"""
_playlist = [
\t{playlist_entries}
];

class CfgSounds
{{
\t{cfg_entries}
}};
"""

with open(PLAYLIST_FILE, "w", encoding="utf-8") as f:
    f.write(playlist_content)

print("Radio Builder Completed!")