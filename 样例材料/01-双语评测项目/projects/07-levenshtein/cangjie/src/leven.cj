package leven4cj

public func leven(firstString: String, secondString: String): Int64 {
   
    if (firstString == secondString) {
        return 0
    }
    if (firstString.isEmpty()) {
        return secondString.size
    }
    if (secondString.isEmpty()) {
        return firstString.size
    }
    
    let firstRuneArray = firstString.toRuneArray()
    let secondRuneArray = secondString.toRuneArray()
    let dynamicTable = Array(firstRuneArray.size + 1, {_ => Array(secondRuneArray.size + 1, repeat: 0)})

    for (i in 0..=firstRuneArray.size) {
        dynamicTable[i][0] = i
    }
    for (j in 0..=secondRuneArray.size) {
        dynamicTable[0][j] = j
    }

    for (i in 1..=firstRuneArray.size) {
        for (j in 1..=secondRuneArray.size) {
            if (firstRuneArray[i - 1] == secondRuneArray[j - 1]) {
                dynamicTable[i][j] = dynamicTable[i - 1][j - 1]
            } else {
                let insert = dynamicTable[i][j - 1] + 1
                let delete = dynamicTable[i - 1][j] + 1
                let substitute = dynamicTable[i - 1][j - 1] + 1

                dynamicTable[i][j] = min(min(insert, delete), substitute)
            }
        }
    }

    return dynamicTable[firstRuneArray.size][secondRuneArray.size]
}
