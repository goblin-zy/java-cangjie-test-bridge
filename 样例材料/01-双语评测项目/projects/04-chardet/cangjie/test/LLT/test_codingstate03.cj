// EXEC: cjc %import-path %L %l %f  
// EXEC: ./main

import chardet4cj.*

main() {
    var codingstate: CodingStateMachine  = CodingStateMachine(HZSMModel())
    
    let model: String = codingstate.getCodingStateMachine()
    println(model)

    if (model != "HZ-GB-2312") {
        return 1
    }
    return 0
}

