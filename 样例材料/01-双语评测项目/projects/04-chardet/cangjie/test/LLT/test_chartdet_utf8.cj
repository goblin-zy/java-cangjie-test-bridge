// DEPENDENCE: utf8.txt
// DEPENDENCE: utf8n.txt
// DEPENDENCE: utf8n-emoji.txt
// DEPENDENCE: utf16le.txt
// DEPENDENCE: utf16be.txt
// DEPENDENCE: iso2022cn.txt
// EXEC: cjc %import-path %L %l %f  
// EXEC: ./main

import std.fs.*
import chardet4cj.*

main() {
    var testFile1: File = File("./iso2022cn.txt",OpenMode.Read)
    var originalEncoding1: String = UniversalDetector.detectCharset(testFile1)
    println(originalEncoding1)

    var testFile: File = File("./utf8n-emoji.txt",OpenMode.Read)
    var originalEncoding: String = UniversalDetector.detectCharset(testFile)
    println(originalEncoding)

    var testFiles: File = File("./utf16le.txt",OpenMode.Read)
    var originalEncodings: String = UniversalDetector.detectCharset(testFiles)
    println(originalEncodings)

    var testFiles2: File = File("./utf16be.txt",OpenMode.Read)
    var originalEncodings2: String = UniversalDetector.detectCharset(testFiles2)
    println(originalEncodings2)
    
    if (originalEncoding != "UTF-8") {
        return 1
    }
    if (originalEncodings != "UTF-16LE") {
        return 2
    }
    if (originalEncodings2 != "UTF-16BE") {
        return 3
    }
    return 0
}

