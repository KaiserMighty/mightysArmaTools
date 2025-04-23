import os
import math
import requests
from io import BytesIO
from PIL import Image

API_KEY = "abcdefghijklmnopqrstuvwxyz"
TILE_SIZE = 256  # pixels
TILESET = "satellite"  # MapTiler tileset


def latlon_to_tile(lat, lon, zoom):
    lat_rad = math.radians(lat)
    n = 2.0 ** zoom
    xtile = int((lon + 180.0) / 360.0 * n)
    ytile = int((1.0 - math.log(math.tan(lat_rad) + (1 / math.cos(lat_rad))) / math.pi) / 2.0 * n)
    return xtile, ytile

def tile_bounds(xtile, ytile, zoom):
    n = 2.0 ** zoom
    lon1 = xtile / n * 360.0 - 180.0
    lat1 = math.degrees(math.atan(math.sinh(math.pi * (1 - 2 * ytile / n))))
    lon2 = (xtile + 1) / n * 360.0 - 180.0
    lat2 = math.degrees(math.atan(math.sinh(math.pi * (1 - 2 * (ytile + 1) / n))))
    return (lat2, lon1, lat1, lon2)  # (top, left, bottom, right)

def meters_to_degrees_lat(meters):
    return meters / 111320  # Rough estimate

def meters_to_degrees_lon(meters, lat):
    return meters / (40075000 * math.cos(math.radians(lat)) / 360)

def estimate_zoom_for_resolution(meters_per_pixel=1):
    return int(math.log2(40075016.686 / (meters_per_pixel * TILE_SIZE)))


def download_satellite_image(lat, lon, distance_m):
    zoom = estimate_zoom_for_resolution()
    deg_lat = meters_to_degrees_lat(distance_m)
    deg_lon = meters_to_degrees_lon(distance_m, lat)

    top = lat + deg_lat
    bottom = lat - deg_lat
    left = lon - deg_lon
    right = lon + deg_lon

    x_min, y_max = latlon_to_tile(bottom, left, zoom)
    x_max, y_min = latlon_to_tile(top, right, zoom)

    width = x_max - x_min + 1
    height = y_max - y_min + 1
    total_tiles = width * height

    print(f"Zoom level: {zoom}")
    print(f"Downloading {width}x{height} tiles...")

    stitched_image = Image.new('RGB', (width * TILE_SIZE, height * TILE_SIZE))

    tile_count = 1
    for x in range(x_min, x_max + 1):
        for y in range(y_min, y_max + 1):
            print(f"Downloading tile {tile_count}/{total_tiles} at zoom {zoom}: ({x}, {y})")
            url = f"https://api.maptiler.com/tiles/{TILESET}/{zoom}/{x}/{y}.jpg?key={API_KEY}"
            try:
                response = requests.get(url)
                response.raise_for_status()
                tile_img = Image.open(BytesIO(response.content))
                stitched_image.paste(tile_img, ((x - x_min) * TILE_SIZE, (y - y_min) * TILE_SIZE))
            except Exception as e:
                print(f"Failed to get tile ({x}, {y}): {e}")
            tile_count += 1

    output_path = f"satellite_{lat}_{lon}_{distance_m}m_zoom{zoom}.jpg"
    stitched_image.save(output_path)
    print(f"Saved stitched image to: {output_path}")

if __name__ == "__main__":
    latitude = 32.51131950056268
    longitude = -114.41448758092505
    distance_in_meters = 20480

    download_satellite_image(latitude, longitude, distance_in_meters/2)
