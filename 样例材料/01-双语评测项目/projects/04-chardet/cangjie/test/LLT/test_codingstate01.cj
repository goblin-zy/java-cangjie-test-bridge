// EXEC: cjc %import-path %L %l %f  
// EXEC: ./main

import chardet4cj.*

main() {
    var codingstate: CodingStateMachine  = CodingStateMachine(UTF8SMModel())
    
    let model: String = codingstate.getCodingStateMachine()
    println(model)

    if (model != "UTF-8") {
        return 1
    }
    return 0
}

