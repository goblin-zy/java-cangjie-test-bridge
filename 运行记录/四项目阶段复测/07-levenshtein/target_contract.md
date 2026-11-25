# 本轮接口前提与实际源码证据

仅验证无阈值距离方法和原十组ASCII输入；不把结果扩展到阈值、null、参数化实例或Unicode差异。

源AssertJ的assertThat(...).isEqualTo(...)对应目标实际@Assert；目标Int64数值表示覆盖本轮期望。

未实现距离算法或构造常量结果，所有输出均由仓颉业务leven计算。

testGetLevenshteinDistance_StringString：原UNLIMITED_DISTANCE为无阈值、无跨次可变状态的距离对象，适配为实际leven函数；保留同一方法内十组ASCII输入及全部原期望值0、1、7、1、3、7、7、8、8、1。

leven.cj SHA-256=f6b3271cc3ec9ec6cc2f728c56cfb393af66f4f4b1a716761539a83f5182ea3b

```cangjie

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


```