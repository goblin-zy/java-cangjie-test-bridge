/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

import std.io.*

public class UnicodeBOMInputStream <: InputStream & Seekable {

    private var ins: InputStream

    private var bom: BOM = BOM(Array<Byte>(), "")

    private var skipped: Bool = false

    public init(inputStream: InputStream) {
        this(inputStream, true)
    }

    public init(inputStream: InputStream, skipIfFound: Bool) {
        
        if ((inputStream as Seekable).getOrThrow().length == 0) {
			throw ChardetException("invalid input stream: null is not allowed")
		}
        ins = inputStream
        var boms: Array<Byte> = Array<Byte>(4, repeat: 0)

        var read = ins.read(boms)

        match (read) {
		    case 4 =>
		    	if (checkval(boms)) {
		    		this.bom = BOM.UTF_32_LE
                    
		    	} else if (checkval2(boms)) {
		    		this.bom = BOM.UTF_32_BE
                    
		    	}
            case 3 =>
			    if (checkval3(boms)){
			    	this.bom = BOM.UTF_8	
                    
			    }
            case 2 =>
			    if ((boms[0] == 0xFF) && (boms[1] == 0xFE)) {
			    	this.bom = BOM.UTF_16_LE
                    
			    } else if ((boms[0] == 0xFE) && (boms[1] == 0xFF)) {
			    	this.bom = BOM.UTF_16_BE
                    
			    }
            case _ =>
                this.bom = BOM.NONE    
        }

        if (bom.toString().isEmpty()) {
		    this.bom = BOM.NONE
		}

        if (skipIfFound) {
			if (!skipped) {
			    var bytesToSkip: Int64 = bom.bytes.size
                var bytesSkipped: Int64 = -1
                if (bytesToSkip < (ins as Seekable).getOrThrow().length) {
                    bytesSkipped = bytesToSkip
                } else {
                    bytesSkipped = (ins as Seekable).getOrThrow().length
                }
                if (bytesSkipped > 0) {
                    var skips: Array<Byte> = Array<Byte>(bytesSkipped, repeat: 0)
                    ins.read(skips)
                }
                var byteskips: Array<Byte> = Array<Byte>(1, repeat: 0)
			    for (_ in bytesSkipped..bytesToSkip) {
			    	ins.read(byteskips)
			    }
			    skipped = true
		    }
		
	    }
		
    }   

    private func checkval(boms: Array<Byte>): Bool {
        return (boms[0] == 0xFF) && (boms[1] == 0xFE) && (boms[2] == 0x00) && (boms[3] == 0x00)
    }

    private func checkval2(boms: Array<Byte>): Bool {
        return (boms[0] == 0x00) && (boms[1] == 0x00) && (boms[2] == 0xFE) && (boms[3] == 0xFF)
    }

    private func checkval3(boms: Array<Byte>): Bool {
        return (boms[0] == 0xEF) && (boms[1] == 0xBB) && (boms[2] == 0xBF)
    }

    public func getBOM(): BOM {
		return this.bom
	}

    public func read(buffer: Array<Byte>): Int64 {
        return ins.read(buffer)
    }

    public override func seek(_: SeekPosition): Int64 {
        return 0
    }

    public prop length: Int64 {
        get() {
            return (ins as Seekable).getOrThrow().length
        }
    }

    public prop remainLength: Int64 {
        get() {
            return (ins as Seekable).getOrThrow().remainLength
        }
    }

    public prop position: Int64 {
        get() {
            return (ins as Seekable).getOrThrow().position
        }
    }
}

public class BOM {

    protected var bytes: Array<Byte>

    private var description: String

    init (bom: Array<Byte>, description: String) {
        this.bytes = bom
		this.description = description
    }

    public func getBytes(): Array<Byte> {

        let length = bytes.size
        var result: Array<Byte> = Array<Byte>(length, repeat: 0)
        this.bytes.copyTo(result,0,0,length)
        return result
    }

    public func toString(): String {
        return description
    }

    public static let UTF_32_BE: BOM = BOM([ 0x00, 0x00, 0xFE, 0xFF ], "UTF-32 big-endian")

    public static let UTF_32_LE: BOM = BOM([ 0xFF, 0xFE, 0x00, 0x00 ],"UTF-32 little-endian")

    public static let UTF_16_BE: BOM = BOM([ 0xFE, 0xFF ], "UTF-16 big-endian")

    public static let UTF_16_LE: BOM = BOM([ 0xFF, 0xFE ], "UTF-16 little-endian")

    public static let UTF_8: BOM = BOM([ 0xEF, 0xBB, 0xBF ], "UTF-8")

    public static let NONE: BOM = BOM(Array<Byte>(), "NONE")

}