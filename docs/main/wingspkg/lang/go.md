# go.nim

## Imports

- strutils
    - capitalizeAscii
    - contains
    - endsWith
    - indent
    - removePrefix
    - removeSuffix
    - replace
    - split
    - startsWith
    - toLowerAscii
    - unindent
- sets
- tables
    - getOrDefault
- [../util/varname](../util/varname.md)
    - camelCase
- [../util/config](../util/config.md)
- [../util/log](../util/log.md)
- [../lib/wstruct](../lib/wstruct.md)
- [../lib/wenum](../lib/wenum.md)

## Functions

#### `genWEnum: string`

Converts the given `WEnum` object to an enum file.

| Argument | Type     | Description                         |
| :------- | :------- | :---------------------------------- |
| `wenum`  | `WEnum`  | Object with all information needed. |
| `config` | `Config` | User config.                        |

#### `genWStruct: string`

Converts the given `WStruct` object to a struct file.

| Argument  | Type      | Description                         |
| :-------- | :-------- | :---------------------------------- |
| `wstruct` | `WStruct` | Object with all information needed. |
| `config`  | `Config`  | User config.                        |