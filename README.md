# ILSFileManager
ILSFileManager will helps you create create file, create directory ,Delete Files,Move Files,Copy Files,Get the list of files in your directory from Apple File System(APFS).
ILSFileManager is a interface that helps to store your large media files or any files and helps to return the file name and using that file name you can easily retrieve the file from the APFS.
ILSFileManager also helps to get know of your device diskspac

<img src="./Assets/art.png?raw=true">

## Features

* Creates Directory
* Create Files
* Copy Files
* Move Files
* List out files
* Delete Files
* Device Disk Utlities


## Installation

### Compatibility

-  iOS 9.0+

- Xcode 9.0+, Swift 4+

#### Manual installation
1. Download and drop the 'ILSFileManager.framework' into your Xcode project.
2. Make Sure you add it by Embedded Binaries
3. Please Set Enable Bitcode as NO during app submission
4. Import ILSFileManager to your respective Classes



## Usage

1. Create Directory or Create Folder which returns your directory name
```swift
ILSFileManager.createDirectory(directoryName: ‘FOLDER_NAME’)
```

2. Create File or Create Data which returns the folder path in which it saved and can be used for future retrivel
```swift
ILSFileManager.createFile(fileName: 'FILE_NAME', folderName: 'FOLDER_NAME', data: 'DATA_TO_BE_SAVE.Extension(.jpg,.png,mov,.mp4,.pdf,etc..)')
```

3. Get the list of path saved in a directory or sub directory both methods can be used if there is no folder then set it as nil return an array of string paths
```swift
ILSFileManager.getDirectorylistatPath(folderName: 'FOLDERNAME if any or nil')

ILSFileManager.getfileListatPath(folderName: 'FOLDERNAME')
```

4. Move File to a new location path consist of three return types success : Bool error:NSError and message : String  
```swift 
LSFileManager.moveDatatonewLocation(existingpath: 'FOLDERNAME/FILENAME', folderName: 'DESTINATIONFOLDER')
```
5. Copy File to another path consist of three return types success : Bool error:NSError and message : String  
```swift 
ILSFileManager.copyDatatonewLocation(existingpath: 'FOLDERNAME/FILENAME', folderName: 'DESTINATIONFOLDER')

```

6. Helps to check whether a file exist at path or not returns a boolean value

```swift
ILSFileManager.fileExistorNot(filePath: 'FOLDERNAME/FILENAME')
```

7. Helps to retrieve a file as data from the presaved path from create file

```swift
ILSFileManager.getDatafileatPath(filePath: 'FOLDERNAME/FILENAME')

```
8. Removes Directory as well as file from the storage

```swift
ILSFileManager.removeDirectory(foldername: 'FOLDERNAME')

ILSFileManager.removeFile(filepath: 'FOLDERNAME/FILENAME')

```
9. ILSFileManager helps to to get the free space,total disk space,total used disk space of your device

```swift
ILSFileManager.totalDiskSpaceInGB

ILSFileManager.totalDiskSpaceInMB

ILSFileManager.usedDiskSpaceInGB

ILSFileManager.usedDiskSpaceInMB

ILSFileManager.freeDiskSpaceInGB

ILSFileManager.freeDiskSpaceInMB
```

## Author

iLeaf Solutions
[http://www.ileafsolutions.com](http://www.ileafsolutions.com)
