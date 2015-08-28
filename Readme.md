# User defined functions for [FireBird](http://firebirdsql.org)

## Description
The library contains functions for working with files such as:
 Text files, [DBF](https://en.wikipedia.org/wiki/.dbf), [XML](https://en.wikipedia.org/wiki/XML). With it you can create and read text files, DBF, XML. It is also possible to parse and serialize XML document from / to strings, BLOB.

 AFUDF also allow you to:
 * calculate the hash CRC32, SHA1, MD5 files, strings, BLOB
 * Scan the file system,create a directories, delete files of the server where you installed FireBird RDBMS
 * Create or unpack ZIP archives
 * [DTD](https://en.wikipedia.org/wiki/Document_type_definition) for XML document
 * XPath XML

## Documentation

 * [Build](build.md)
 * [Installation](install.md)
 * [Examples](examples.md)
 * [Changelog](changelog.txt)

## Dependencies

Library afuxml for Xml dependent on a shared library [libiconv](http://www.gnu.org/software/libiconv/).
Necessary assembly can be found [here](http://mlocati.github.io/gettext-iconv-windows/). AFUDF installer for Windows already contains a library iconv.dll

### Tests

**Only version: 1.5.7**

Supported:
 * Win32 32-bit/64-bit Classic, Superclassic & Superserver
 * Win64 64-bit Classic, Superclassic & Superserver
 * Linux x86 32-bit Classic, Superclassic
 * Linux AMD64 64-bit Classic, Superclassic

**In the version of "Embedded" not tested**

Tested on versions FireBird

Platform | Architecture | Versions FireBird
---------|--------------|------------------
Windows  | x86_64       | 2.5.4.26856
Windows  | x32          | 2.5.4.26856
Linux    | x86_64       | CS+SS:2.5.3.26765-0.amd64
Linux    | x32          | CS+SS:2.5.3.26765-0.i686

_SS - Super Server_
_CS - Classic Server_

## License
MIT:

## Author
Arteev Aleksey
