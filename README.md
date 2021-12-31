# LRLastModified

---
Lightroom Classic plugin which add last modified photos to a collection.  
The sarch not only looks for the last edit photos (i.e. property touchTime). This is what a smart collection
would do if you choose ```Date/Edit Date```. It also looks for the EXIF dateTime
property which is set when a photo is changed by Photoshop.


#Requirments

---
none
## Installation

---
1. Download the zip archive for your operating system from [GitHub](https://github.com/sto3014/LRLastModified/archive/refs/tags/1.1.1.1.zip).
2. Extract the archive in the download folder
3. Copy plug-in and resources into the configuration folder of Lightroom
    1. On Windows  
       Goto ```Downloads/LRLastModified-1.1.1.1``` and double click install.bat.
       Install.bat copies the plug-in into:
       ```
       <User Home>\AppData\Roaming\Adobe\Lightroom\Modules\LRLastModified.lrplugin
       ```
    2. On macOS
       Open a terminal window, change to ```Downloads/LRLastModified-1.1.1.1``` and execute install.sh:
        ```
        -> ~ cd Downloads/LRLastModified-1.1.1.1
        -> ./install.sh 
        ```
       Install.sh copies the plug-in into:
        ``` 
        ~/Library/Application Support/Adobe/Lightroom/Modules/LRLastModified.lrplugin
        ```

4. Restart Lightroom

## Usage

---
The plug-in searches for photos which where changed in the last X days. The resulting photos will be added to the 
collection ```Last Modified```.
The sarch not only looks for the last edit photos (i.e. property touchTime). This is what a smart collection 
would do if you choose ```Date/Edit Date```. It also looks for the EXIF dateTime
property which is set when a photo is changed by Photoshop.

Goto Libray/Plug-in Extras/Search last modified photos. The _Search Last Modified_ dialog box appears:
* Input field: ```Last modified before X day(s)```  
    All photos will be found which were edited by lightroom or photoshop in the last X days.
* Checkbox: ```Clear collection```  
    If selected existing photos in ```Last Modified``` will be removed from the collection



