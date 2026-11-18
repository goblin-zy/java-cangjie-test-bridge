/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj


public class CodingStateMachine {

    protected var model: SMModel

    protected var currentState: Int32
    protected var currentCharLen: Int32 = 0
    protected var currentBytePos: Int32 = 0

    public init(model: SMModel) {

        this.model = model
        this.currentState = SMModel.START
    }

    public func nextState(c: Byte): Int32 { 
        let byteCls: Int32 = this.model.getClass(c)
        if (this.currentState == SMModel.START) {
            this.currentBytePos = 0
            this.currentCharLen = this.model.getCharLen(byteCls)
        }

        this.currentState = this.model.getNextState(byteCls, this.currentState)
        this.currentBytePos++

        return this.currentState
    }

    public func getCurrentCharLen(): Int32 {
        return this.currentCharLen
    }

    public func reset() {
        this.currentState = SMModel.START
    }

    public func getCodingStateMachine(): String {
        return this.model.getName()
    }
}
