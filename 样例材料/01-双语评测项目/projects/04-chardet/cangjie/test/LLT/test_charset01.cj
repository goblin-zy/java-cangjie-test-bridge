// EXEC: cjc %import-path %L %l %f  
// EXEC: ./main

import chardet4cj.*

main() {
    var state: ProbingState = ProbingState.DETECTING
    var state1: ProbingState = ProbingState.FOUND_IT
    var state2: ProbingState = ProbingState.NOT_ME
    if (state.toString() != "DETECTING"){
        return 1
    }
    if (state1.toString() != "FOUND_IT"){
        return 1
    }
    if (state2.toString() != "NOT_ME"){
        return 1
    }
    if (state != state1) {
        return 0
    }
    return 1
}

