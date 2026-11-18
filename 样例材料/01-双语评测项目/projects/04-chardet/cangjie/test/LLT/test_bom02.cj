// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*

main() {
    let str: BOM  = BOM.UTF_32_BE
    let str1: BOM  = BOM.UTF_32_LE
    let str2: BOM  = BOM.UTF_8
    let arr = str.toString()
    let arr1 = str1.toString()
    let arr2 = str2.toString()
    if (arr != "UTF-32 big-endian") {
        return 1
    }
    if (arr1 != "UTF-32 little-endian") {
        return 1
    }
    if (arr2 != "UTF-8") {
        return 1
    }
    return 0
}

