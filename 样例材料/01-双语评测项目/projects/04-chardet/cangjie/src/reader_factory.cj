/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

import std.fs.*

import charset4cj.charset.*
import charset4cj.charset.encoding.*

public class ReaderFactory {

    private init() {
        throw ChardetException("no instances allowed")
    }
    
    public static func createBufferedReader(file: File, defaultCharset: Charset): File {
        var cs: Charset = defaultCharset
        var detectedEncoding: String = UniversalDetector.detectCharset(file)
        if (!detectedEncoding.isEmpty()) {
            cs = Charsets.forName(detectedEncoding).getOrThrow()
        }
        if (!cs.nameEquals("UTF-8") || !cs.nameEquals("UTF-16BE") || !cs.nameEquals("UTF-16LE")) {
            return File(file.info.path, OpenMode.Read)
        }

        return  File(file.info.path, OpenMode.Read)
    }

    public static func createBufferedReader(file: File): File {
        return createBufferedReader(file, Charsets.UTF8)
    }
    
    public static func createReaderFromFile(file: File, defaultCharset: Charset): File {
        return createBufferedReader(file, defaultCharset)
    }

    public static func createReaderFromFile(file: File): File {
        return createReaderFromFile(file, Charsets.UTF8)
    }
}
 