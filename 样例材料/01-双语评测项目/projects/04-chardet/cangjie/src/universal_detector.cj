/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

import std.fs.*
import std.collection.*
import std.io.*

public class UniversalDetector {
    public static let  SHORTCUT_THRESHOLD: Float32 = 0.95
    public static let  MINIMUM_THRESHOLD: Float32 = 0.20

    private var inputState: InputState = InputState.PURE_ASCII
    private var done: Bool = false
    private var start: Bool = true
    private var gotData: Bool = false
    private var onlyPrintableASCII: Bool = true
    private var lastChar: UInt8 = 0
    private var detectedCharset: String = ""

    private var probers: ArrayList<CharsetProber> = ArrayList<CharsetProber>()
    private var escCharsetProber: ?CharsetProber
    
    private var listener: ?CharsetListener

    public init() {
        this(Option<CharsetListener>.None)
    }

    public init (listener: ?CharsetListener) {
        this.listener = listener
        this.escCharsetProber = Option<CharsetProber>.None
        match (this.escCharsetProber) {
            case None => ()
            case Some(_) => this.escCharsetProber.getOrThrow().reset()
        }
        for (i in 0..this.probers.size) {
            this.probers[i].reset()
        }
    }

    public func isDone(): Bool {
        return this.done
    }

    public func getDetectedCharset(): String {
        return this.detectedCharset
    }

    public func setListener(listener: CharsetListener)  {
        this.listener = Option<CharsetListener>.Some(listener)
    }

    public func getListener(): CharsetListener {
        return this.listener.getOrThrow()
    }

    public func handleData(b: Array<Byte>) {
    	handleData(b, 0, Int32(b.size))
    }

    private func processData(buf: Array<Byte>, off: Int32, len: Int32) {
        let maxPos: Int32 = off + len
        if (maxPos <= 0) { throw ChardetException("this length is null") }
        for(i in off..maxPos) {
            var c = buf[Int64(i)] & 0xFF
            if ((c & 0x80) != 0 && c != 0xA0) {
                if (this.inputState != InputState.HIGHBYTE) {
                    this.inputState = InputState.HIGHBYTE
                    match (this.escCharsetProber) {
                        case None => ()
                        case Some(_) => this.escCharsetProber = Option<CharsetProber>.None
                    }
                    if (this.probers.isEmpty()) {
                        this.probers.add(MBCSGroupProber())
                    }
                }
            } else {
                if (this.inputState == InputState.PURE_ASCII && (c == 0x1B || (c == 0x7B && this.lastChar == 0x7E))) {
                    this.inputState = InputState.ESC_ASCII
                }
                if (this.inputState == InputState.PURE_ASCII && onlyPrintableASCII) {
                	onlyPrintableASCII = (c >= 0x20 && c <= 0x7e) || c == 0x0A  || c == 0x0D || c== 0x09
                }
                this.lastChar = buf[Int64(i)]
            }
        }
    }

    public func handleData(buf: Array<Byte>, off: Int32, len: Int32){
        if (this.done) {
            return
        }
        if (len > 0) {
            this.gotData = true
        }
        if (buf.size == 0) {
            throw ChardetException("this buf is empty")
        }
        if (this.start) {
            this.start = false;
            if (len > 3) {
                var detectedBOM: String = detectCharsetFromBOM(buf, off)
                if (!detectedBOM.isEmpty()) {
                	this.detectedCharset = detectedBOM
                    this.done = true
                    return
                }
            }
        }
        processData(buf, off, len)
        var st: ProbingState = ProbingState.NOT_ME
        if (this.inputState == InputState.ESC_ASCII) {
            match (this.escCharsetProber) {  
                case None => this.escCharsetProber = Option<CharsetProber>.Some(EscCharsetProber())
                case Some(_) => ()
            }
            st = this.escCharsetProber.getOrThrow().handleData(buf, off, len)
            if (st == ProbingState.FOUND_IT) {
                this.done = true
                this.detectedCharset = this.escCharsetProber.getOrThrow().getCharSetName()
            }
        } else if (this.inputState == InputState.HIGHBYTE) {
            for(i in 0..this.probers.size){
                st = this.probers[i].handleData(buf, off, len)
                if (st == ProbingState.FOUND_IT) {
                    this.done = true
                    this.detectedCharset = this.probers[i].getCharSetName()
                    return
                }
            }
        } else { return }
    }

    public static func detectCharsetFromBOM(buf: Array<Byte>): String {
    	return detectCharsetFromBOM(buf, 0)
    }

    private static func detectCharsetFromBOM(buf: Array<Byte>, offset: Int32): String {
        if (buf.size > Int64(offset + 3)) {
			let b1 = buf[Int64(offset)] & 0xFF
			let b2 = buf[Int64(offset+1)] & 0xFF
			let b3 = buf[Int64(offset+2)] & 0xFF
			let b4 = buf[Int64(offset+3)] & 0xFF
            match (b1) {
                case 0xEF =>
                    if (b2 == 0xBB && b3 == 0xBF) {
			            return Constants.CHARSET_UTF_8
			        }
                
                case 0xFE =>
                    if (b2 == 0xFF && b3 == 0x00 && b4 == 0x00) {
                        return "CHARSET_X_ISO_10646_UCS_4_3412"
			        } else if (b2 == 0xFF) {
			            return Constants.CHARSET_UTF_16BE
			        }
                case 0x00 =>
                    if (b2 == 0x00 && b3 == 0xFE && b4 == 0xFF) {
                        return "CHARSET_UTF_32BE"
			        } else if (b2 == 0x00 && b3 == 0xFF && b4 == 0xFE) {
                        return "CHARSET_X_ISO_10646_UCS_4_2143"
			        } 
                case 0xFF => 
                    if (b2 == 0xFE && b3 == 0x00 && b4 == 0x00) {
                        return "CHARSET_UTF_32LE"
			        } else if (b2 == 0xFE) {
			            return Constants.CHARSET_UTF_16LE
			        }   
                case _ =>
                    ()
            }
		   
        }
        return ""  
    }

    public func dataEnd() {
        if (!this.gotData) {
            return
        }
        
        if (!this.detectedCharset.isEmpty()) {
            this.done = true
            match (this.listener) {
                case None => ()
                case Some(_) => this.listener.getOrThrow().report(this.detectedCharset)
            }
            return
        }
        if (this.inputState == InputState.HIGHBYTE) {
            var proberConfidence: Float32 = 0.0
            var maxProberConfidence: Float32 = 0.0
            var maxProber: Int32 = 0
            
            for(i in 0..this.probers.size) {
                proberConfidence = this.probers[i].getConfidence()
                if (proberConfidence > maxProberConfidence) {
                    maxProberConfidence = proberConfidence
                    maxProber = Int32(i)
                }
            }
            
            if (maxProberConfidence > MINIMUM_THRESHOLD) {
                this.detectedCharset = this.probers[Int64(maxProber)].getCharSetName()
                match (this.listener) {
                    case None => ()
                    case Some(_) => this.listener.getOrThrow().report(this.detectedCharset)
                }
            }

        } else if (this.inputState == InputState.PURE_ASCII && this.onlyPrintableASCII) {
        	this.detectedCharset = Constants.CHARSET_US_ASCCI
        }
    }

    public func reset() {
        this.done = false;
        this.start = true;
        this.detectedCharset = ""
        this.gotData = false;
        this.inputState = InputState.PURE_ASCII;
        this.lastChar = 0
        match (this.escCharsetProber) {
            case None => ()
            case Some(_) => this.escCharsetProber.getOrThrow().reset()
        }
        
        for (i in 0..this.probers.size) {
            if (!this.probers.isEmpty()) {
                this.probers[i].reset()
            }
        }
    }

    public static func detectCharset(path: Path): String {
        return detectCharset(File(path,OpenMode.Read))
    }

    public static func detectCharset(file: File): String {
        var outbuf: InputStream = (file as InputStream).getOrThrow()
        return detectCharset(outbuf)
    }
    
    public static func detectCharset(inputStream: InputStream): String {
        var tempBuf: Array<Byte> = Array<Byte>(4096, repeat: 0)
        if ((inputStream as Seekable).getOrThrow().length <= 0) {
            throw ChardetException("this inputStream is empty")
        }
        var detector: UniversalDetector = UniversalDetector(CharsetListener())

        while (true) {
            var readNum = inputStream.read(tempBuf)
            if (readNum <= 0) {
                (inputStream as Resource)?.close()
                break
            } 
            let utf8data = tempBuf[0..readNum]
            detector.handleData(utf8data, 0, Int32(readNum))
        }
        detector.dataEnd()

        let encoding: String = detector.getDetectedCharset()
        detector.reset()
        return encoding
    }

}

public enum InputState <: Equatable<InputState> & ToString{
    | PURE_ASCII
    | ESC_ASCII
    | HIGHBYTE

    public func toString(): String {
        match(this) {
            case PURE_ASCII => return "PURE_ASCII"
            case ESC_ASCII  => return "ESC_ASCII"
            case HIGHBYTE  => return "HIGHBYTE"
        }
    }

    public operator func == (that: InputState): Bool {
        if (this.toString() == that.toString()) {
            return true
        }
        return false
    }

    public operator func != (that: InputState): Bool {
        return !(this == that)
    }
}

public class CharsetListener {
	
	public func report(charset: String): Unit {
        if (charset.isEmpty()) {}
    }
}

