# Quickly remove excess files from dependencies
## Setup
This script needs the `target` and `dependencies` directory to contain unpacked mod PBOs.  
## Usage
```python dependencyCuller.py```  
The `output.txt` file will list all the deleted files, and the terminal output shows any dependencies that isn't present within the `dependencies` directory.