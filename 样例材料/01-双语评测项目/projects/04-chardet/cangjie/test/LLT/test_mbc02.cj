// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import chardet4cj.*
import std.io.*

main() {

    let intput: MBCSGroupProber = MBCSGroupProber()
    let str: ProbingState = intput.getState()
    if (str != ProbingState.DETECTING) {
        return 1
    }
    return 0
}

