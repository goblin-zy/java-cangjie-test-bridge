// DEPENDENCE: utf16be.txt
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.fs.*
import chardet4cj.*

main() {
    var testFiles2: File = File("./utf16be.txt",OpenMode.Read)
    var originalEncodings2: String = UniversalDetector.detectCharset(testFiles2)
    println(originalEncodings2)
    if (originalEncodings2 != "UTF-16BE") {
        return 1
    }
    return 0
}