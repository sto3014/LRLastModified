# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0.0] - 2019-11-08
Creation

### Added
### Changed
### Fixed

## [1.1.0.0] - 2019-11-08

### Added
Add "Cleanup Collection" checkbox.
The default is "false", which means that existing photos will not be removed from target collection.
This means also, the default behavior changed from 1.0.0.0
### Changed
### Fixed

## [1.1.1.0] - 2019-12-27

### Added
Add lastmodified.lrplugin with compiled files
### Changed
### Fixed

## [1.1.1.1]  - 2021-12-31

### Added
Add installation scripts
### Changed
Add installation documentation.
The plug-in file name was renamed from LastModified.lrplugin to 
LRLastModified.lrplugin. If you make an update now or in thenfuture, you have to
remove the old file manually:  
* On Windows
    ```
    <User Home>\AppData\Roaming\Adobe\Lightroom\Modules\LastModified.lrplugin
    ```
* On macOS 
    ``` 
    ~/Library/Application Support/Adobe/Lightroom/Modules/LastModified.lrplugin
    ```
### Fixed

