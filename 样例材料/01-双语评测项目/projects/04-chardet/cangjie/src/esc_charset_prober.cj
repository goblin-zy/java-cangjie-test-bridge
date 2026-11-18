/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

import std.collection.*

public class EscCharsetProber <: CharsetProber {

    private var codingSM: ArrayList<CodingStateMachine> = ArrayList<CodingStateMachine>()
    
    private var activeSM: Int32
    private var state: ProbingState = ProbingState.DETECTING
    private var detectedCharset: String = ""

    private static let hzsModel: HZSMModel = HZSMModel()
    private static let iso2022cnModel: ISO2022CNSMModel = ISO2022CNSMModel()

    public init() {
        super()
        this.codingSM.add(CodingStateMachine(hzsModel))
        this.codingSM.add(CodingStateMachine(iso2022cnModel))
		for (i in 0..this.codingSM.size) {
			this.codingSM[i].reset()
		}
		this.activeSM = Int32(this.codingSM.size)
    }

    public func reset() {
        this.state = ProbingState.DETECTING
		for (i in 0..this.codingSM.size) {
			this.codingSM[i].reset()
		}
		this.activeSM = Int32(this.codingSM.size)
		this.detectedCharset = ""
    }

    public func getCharSetName(): String {
        return this.detectedCharset
    }

    public func getConfidence(): Float32 {
        return 0.99
    }

    public func getState(): ProbingState {
        return this.state
    }

    public func handleData(buf: Array<Byte>, offset: Int32, length: Int32): ProbingState {
        if (buf.size == 0) {
            throw ChardetException("this buf is empty")
        }
        var codingState: Int32 = 0
        let maxPos: Int32 = offset + length
        if (maxPos <= 0) {
            throw ChardetException("this length is null")
        }
        var sc: Int32 = this.activeSM
        for (i in offset..maxPos where this.state==ProbingState.DETECTING ) {
            for(j in 0..sc) {
                codingState = this.codingSM[Int64(sc-1-j)].nextState(buf[Int64(i)])
                if (codingState == SMModel.ERROR) {
                    this.activeSM--
                    if (this.activeSM <= 0) {
                        this.state = ProbingState.NOT_ME
                        return this.state
                    } else if ((sc-1-j) != this.activeSM) {
                        var t: CodingStateMachine = CodingStateMachine(hzsModel)
                        t = this.codingSM[Int64(this.activeSM)]
                        this.codingSM[Int64(this.activeSM)] = this.codingSM[Int64(sc-1-j)]
                        this.codingSM[Int64(sc-1-j)] = t
                    }
                } else if (codingState == SMModel.ITSME) {
                    this.state = ProbingState.FOUND_IT;
                    this.detectedCharset = this.codingSM[Int64(sc-1-j)].getCodingStateMachine()
                    return this.state
                }
            }
        }

        return this.state
    }
}