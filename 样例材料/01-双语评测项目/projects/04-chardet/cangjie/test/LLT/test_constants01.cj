// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*

main() {

    let str4 = Constants.CHARSET_HZ_GB_2312
    let str5 = Constants.CHARSET_US_ASCCI

    if (str4 != "HZ-GB-2312") {
        return 1
    }
    if (str5 != "US-ASCII") {
        return 2
    }
    return 0
}

