// DEPENDENCE: utf16le.txt
// DEPENDENCE: utf8n.txt
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*
import std.fs.*
import charset4cj.charset.*
import charset4cj.charset.encoding.*

main() {

    var testFile1: File = File("./utf16le.txt",OpenMode.Read)
    var testFile2: File = File("./utf8n.txt",OpenMode.Read)

    var originalEncoding1: File = ReaderFactory.createBufferedReader(testFile1)
    var originalEncoding2: File = ReaderFactory.createReaderFromFile(testFile2)
    let str = originalEncoding1.length
    let str2 = originalEncoding2.length
    println(str)
    if (str != 2128) {
        return 1
    }
    if (str2 != 1765) {
        return 1
    }
    return 0
}

