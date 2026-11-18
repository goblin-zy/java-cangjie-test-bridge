// DEPENDENCE: utf8.txt
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.fs.*
import chardet4cj.*

main() {
    var testFiles: File = File("./utf8.txt",OpenMode.Read)
    var originalEncodings: String = UniversalDetector.detectCharset(testFiles)
    println("ISO-2022-CN")
    if (originalEncodings != "UTF-8") {
        return 1
    }
    return 0
}