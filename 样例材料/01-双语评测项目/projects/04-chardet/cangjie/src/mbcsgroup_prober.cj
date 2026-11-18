/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

import std.collection.*

public class MBCSGroupProber <: CharsetProber {

    private var state: ProbingState = ProbingState.DETECTING
    private var probers: ArrayList<CharsetProber> = ArrayList<CharsetProber>()

    private var bestGuess: ?CharsetProber =  Option<CharsetProber>.None
    private var activeNum: Int32 = 0

    public init() {
        super()
        probers.add(UTF8Prober())
        for (prober in this.probers) {
            prober.setActive(true)
            this.activeNum++
        }
    }

    public func reset() {
        this.activeNum = 0
        for (prober in this.probers) {
            prober.setActive(true)
            this.activeNum++
        }
        this.bestGuess = Option<CharsetProber>.None
        this.state = ProbingState.DETECTING
    }

    public func getCharSetName(): String {

        match (this.bestGuess) {
            case Some(_) => ()
            case None =>
                getConfidence()
                match (this.bestGuess) { 
                    case Some(_) => ()
                    case None =>
                        this.bestGuess = probers.get(0)
                }
        }
		return this.bestGuess.getOrThrow().getCharSetName()
    }

    public func getConfidence(): Float32 { 

        var bestConfs: Float32 = 0.0
        var cfs: Float32 = 0.0

        if (this.state == ProbingState.FOUND_IT) {
            return 0.99
        } else if (this.state == ProbingState.NOT_ME) {
            return 0.01
        } else {
            for(probes in probers) {
        		if (!probes.isActive()) {
        			continue
        		}
        		cfs = probes.getConfidence()
                if (bestConfs < cfs) {
                    bestConfs = cfs
                    this.bestGuess = probes
                }
        	}
        }

        return bestConfs
    }

    public func getState(): ProbingState {
        return this.state
    }

    public func handleData(buf: Array<Byte>, offset: Int32, length: Int32): ProbingState {
        if (buf.size == 0) {
            throw ChardetException("this buf is empty")
        }
        var strc: ProbingState = ProbingState.NOT_ME

        var keepNext: Bool = true
        var highbyteBuf: Array<Byte> = Array<Byte>(Int64(length), repeat: 0)
        var highpos: Int32 = 0
        var maxPos: Int32 = offset + length
        if (maxPos <= 0) {
            throw ChardetException("this length is null")
        }
        for (i in offset..maxPos) {
            if ((buf[Int64(i)] & 0x80) != 0) {
                highbyteBuf[Int64(highpos)] = buf[Int64(i)]
                highpos++
                keepNext = true
            } else {
                if (keepNext) {
                    highbyteBuf[Int64(highpos)] = buf[Int64(i)]
                    highpos++
                    keepNext = false
                }
            }
        }

        for(probes in probers) {

            if (!probes.isActive()) {
        		continue
        	}
        	strc = probes.handleData(highbyteBuf, 0, highpos)
        	if (strc == ProbingState.FOUND_IT) {
                this.bestGuess = probes
                this.state = ProbingState.FOUND_IT
                break
            } else if (strc == ProbingState.NOT_ME) {
                probes.setActive(false)
                this.activeNum--
                if (this.activeNum <= 0) {
                    this.state = ProbingState.NOT_ME
                    break
                }
            }
        }
        return this.state
    }
}