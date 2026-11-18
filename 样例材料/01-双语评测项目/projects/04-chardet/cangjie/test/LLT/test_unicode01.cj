// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {
    let intput: ByteBuffer = ByteBuffer()
    var es = ""
    try{
        UnicodeBOMInputStream(intput)
    } catch (e: ChardetException){
        es = e.toString()
    }
    if (es != "ChardetException: invalid input stream: null is not allowed") {
        return 1
    }
    return 0
}

