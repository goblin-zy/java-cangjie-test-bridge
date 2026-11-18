// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*

main() {
    let str: BOM  = BOM.UTF_8
    let arr = str.getBytes()
    if (arr.size != 3) {
        return 1
    }
    return 0
}

