:us: [:jp:](https://github.com/ryotako/igor-glob/wiki)

# igor-glob

Glob returns the path names of all objects matching pattern as a text wave, where "objects" means waves, global variables, global strings and data folders.

- `*` can match any string of characters not containing `:`
- `**` matches any string of characters containing `:` 

## Example

* root (current folder)
  * folder1
    * subfolder1
      * V_flag
    * subfolder2
  * folder2
    * subfolder1
    * subfolder2

```
glob("root:folder*") //-> {"root:folder1", "root:folder2"}
glob("root:**1") //-> {"root:folder1", "root:folder1:subfolder1", "root:folder2:subfolder1"}
glob(":**:V_flag") // -> {":folder1:subfolder1:V_flag"}
```

## Test
 This function is tested by [igor-unit-testing-framework](https://github.com/t-b/igor-unit-testing-framework).
