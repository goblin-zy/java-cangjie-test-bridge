/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

public abstract class SMModel {

    public static let START: Int32 = 0
    public static let ERROR: Int32 = 1
    public static let ITSME: Int32 = 2

    protected var classTable: PkgInt
    protected var classFactor: Int32
    protected var stateTable: PkgInt
    protected var charLenTable: Array<Int32>
    protected var name: String

    public init (classTable: PkgInt, classFactor: Int32, stateTable: PkgInt, charLenTable: Array<Int32>, name: String) {

        this.classTable = classTable
        this.classFactor = classFactor
        this.stateTable = stateTable
        this.charLenTable = charLenTable
        this.name = name
    }

    public func getClass(b: Byte): Int32 {
        let c = Int32(Int64(b) & 0xFF)
        return this.classTable.unpack(c)
    }

    public func getNextState(cls: Int32, currentState: Int32): Int32 {
        return this.stateTable.unpack(currentState * this.classFactor + cls)
    }

    public func getCharLen(cls: Int32): Int32 {
        return this.charLenTable[Int64(cls)]
    }

    public func getName(): String {
        return this.name
    }
}
