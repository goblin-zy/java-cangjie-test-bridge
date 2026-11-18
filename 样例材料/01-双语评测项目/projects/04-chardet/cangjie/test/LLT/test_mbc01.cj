// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: MBCSGroupProber = MBCSGroupProber()
    let str = intput.getCharSetName()
    println(str)
    if (str != "UTF-8") {
        return 1
    }
    return 0
}

