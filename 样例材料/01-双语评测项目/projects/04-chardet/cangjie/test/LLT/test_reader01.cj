// DEPENDENCE: utf8n.txt
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*
import std.fs.*
import charset4cj.charset.*
import charset4cj.charset.encoding.*

main() {

    var testFile1: File = File("./utf8n.txt",OpenMode.Read)
    var originalEncoding1: File = ReaderFactory.createReaderFromFile(testFile1,Charsets.UTF8)
    let str = originalEncoding1.length
    println(str)
    if (str != 1765) {
        return 1
    }
    return 0
}

