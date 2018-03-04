# File Class
The *File Class* has hierarchical class structure to support storage and various data types.

## Type definitions
### `CNAccessType`: Type of access
1. ReadOnlyAccess
2. WriteOnlyAccess
3. ReadAndWriteAccess

### `CNStorageType`: Type of storage
1. Memory storage
2. File storage

### `CNDataFormatType`: Type of data
1. Data
2. Text

## Class hierarchy
* CNFile: Super class of all file classes
  * CNDataFile
    * CNTextFile
  * CNDataMemory
    * CNTextMemory
