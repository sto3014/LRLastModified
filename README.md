# LRLastModified
Lightroom Classic plugin which add last modified photos to a collection.
This plugin not only looks for the last edit photos (i.e. property touchTime) it also looks for the EXIF dateTime propertery of Photoshop photos.
The reason for this is, that the touchTime will never be changed when saving photos in Photoshop.

1.1.0.0
Add "Cleanup Collection" checkbox.
The default is "false", which means that existing photos will not be removed from target collection.
This means also, the default behavior changed from 1.0.0.0