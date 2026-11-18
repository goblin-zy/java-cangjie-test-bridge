// EXEC: cjc %import-path %L %l %f  
// EXEC: ./main

import chardet4cj.*

main() {
    var codingstate: CodingStateMachine  = CodingStateMachine(ISO2022CNSMModel())
    
    let model: String = codingstate.getCodingStateMachine()
    println(model)

    if (model != "ISO-2022-CN") {
        return 1
    }
    return 0
}

