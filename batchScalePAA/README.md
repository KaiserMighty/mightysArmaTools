# Quickly downscale multiple ArmA textures
## Prerequisites
This script needs python and pillow  
```pip install pillow```  
## Usage
```python batchScalePAA.py "[directory]" -f [factor]```  
Directory: (Required) Directory containing textures that need to be downscaled.  
Factor: (Optional) Scales down the texture by this factor, default is 2.  
## Examples
```python batchScalePAA.py "H:\Arma 3 Tools [Work Drive]\@Test\addons\temp\test"```  
```python batchScalePAA.py "H:\Arma 3 Tools [Work Drive]\@Test\addons\temp\test" -f 4```  