// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*

main() {
    let str = Constants.CHARSET_UTF_8
    let str1 = Constants.CHARSET_ISO_2022_CN
    let str2 = Constants.CHARSET_UTF_16BE
    let str3 = Constants.CHARSET_UTF_16LE

    if (str != "UTF-8") {
        return 1
    }
    if (str1 != "ISO-2022-CN") {
        return 2
    }
    if (str2 != "UTF-16BE") {
        return 3
    }
    if (str3 != "UTF-16LE") {
        return 4
    }
    return 0
}

