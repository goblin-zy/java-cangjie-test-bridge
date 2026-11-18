// DEPENDENCE: utf16be.txt
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*
import std.fs.*
import charset4cj.charset.*
import charset4cj.charset.encoding.*

main() {

    var testFile1: File = File("./utf16be.txt",OpenMode.Read)
    var originalEncoding1: File = ReaderFactory.createBufferedReader(testFile1,Charsets.UTF8)
    let src = originalEncoding1.length
    println(src)
    if (src != 2128) {
        return 1
    }
    return 0
}

