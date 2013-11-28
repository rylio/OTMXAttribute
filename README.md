OTMXAttribute
=============
>The xattr command can be used to display, modify or remove the extended attributes of one or more files, including directories and symbolic links.  Extended attributes are arbitrary metadata stored with a file, but separate from the filesystem attributes (such as modification time or file size).  The metadata is often a null-terminated UTF-8 string, but can also be arbitrary binary data.

Examples
--------

### Set
``` objective-c
BOOL success = [OTMXAttribute setAttributeAtPath:filePath name:myKey value:stringOrDataValue error:NULL];
```
### Get
``` objective-c
NSData *attribute = [OTMXAttribute attributeAtPath:filePath name:myKey error:NULL];
NSString *attributeAsString = [OTMXAttribute stringAttributeAtPath:filePath name:myKey error:NULL];
```
###Remove
``` objective-c
BOOL success = [OTMXAttribute removeAttributeAtPath:filePath name:myKey error:NULL];
```
---
License
-------
OTMXAttribute is released under the MIT License. See [LICENSE](LICENSE) for more info.