# Quickly repath multiple ArmA textures in multiple ArmA models
## Prerequisites
This script needs python and thats it  
## Usage
```python batchRepathing.py "[directory]" -p [path]```  
Directory: (Required) Directory containing models that need to be repathed.  
Path: (Optional) File that contains paths to change, and what to change them to (check paths.txt for examples).  
## Examples
```python batchRepathing.py "H:\Arma 3 Tools [Work Drive]\@Test\addons\temp\test2"```  
```python batchRepathing.py "H:\Arma 3 Tools [Work Drive]\@Test\addons\temp\test2" -p "test.txt"```  

# Extra: Quickly repath multiple ArmA materials (rvmats)
## Usage
```python batchRepathingMat.py "[directory]" -p [path] -c [cfgConvertPath]```  
Directory: (Required) Directory containing materials that need to be repathed.  
Path: (Optional) File that contains paths to change, and what to change them to (check paths.txt for examples).  
CfgConvertPath: (Optional) Path to CfgConvert, by default it assumes the executable is in the same folder as the script. 
## Examples
```python batchRepathingMat.py "H:\Arma 3 Tools [Work Drive]\@Test\addons\temp\test2"```  
```python batchRepathingMat.py "H:\Arma 3 Tools [Work Drive]\@Test\addons\temp\test2" -p "test.txt"```  
```python batchRepathingMat.py "H:\Arma 3 Tools [Work Drive]\@Test\addons\temp\test2" -p "test.txt" -c "H:\SteamLibrary\steamapps\common\Arma 3 Tools\CfgConvert\CfgConvert.exe"```  