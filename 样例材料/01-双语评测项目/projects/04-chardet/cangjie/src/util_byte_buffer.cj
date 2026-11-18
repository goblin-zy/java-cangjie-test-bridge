/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

public abstract class Buffer <: ToString {
    // Invariants: mar <= pos <= lim <= capa
    // Read / write mark
    var mar: Int64 = -1
    // Read / write position
    var pos: Int64 = 0
    // Read / write limit
    var lim: Int64
    // Read / write capacity
    var capa: Int64


    Buffer (marks: Int64, position: Int64, limits: Int64, capacity: Int64) {
        if (capacity < 0) {
            throw ChardetException("capacity < 0: ${capacity}")
        }
        this.capa = capacity
        if (limits > this.capa || limits < 0 ) {
            throw ChardetException("limits < 0: ${limits}")
        }
        this.lim = limits
        if (this.pos > this.lim) {
            this.pos = this.lim
        }
        if (this.mar > this.lim) {
            this.mar = -1
        }
        if (position > this.lim || position < 0) {
            throw ChardetException("position < 0: ${position}")
        }
        this.pos = position
        if (mar > pos) {
            this.mar = -1
        }
        if (marks >= 0) {
            if (marks > position) {
                throw ChardetException("marks > position: ${marks} ${position}")
            }
            this.mar = marks
        }
    }

    public func capacity(): Int64 {
        return capa
    }

    public func position(): Int64 {
        return pos
    }

    public open func position(newPosit: Int64): Buffer {
        if (newPosit > lim || newPosit < 0) {
            throw ChardetException("newPosition")
        }
        if (mar > pos) {
            mar = -1
        }
        pos = newPosit
        return this
    }

    public func limit(): Int64 {
        return lim
    }

    public open func limit(newLimits: Int64): Buffer {
        if (newLimits > capa || newLimits < 0) {
            throw ChardetException("newLimit")
        }
        lim = newLimits
        if (pos > lim) {pos = lim}
        if (mar > lim) {mar = -1}
        return this
    }

    public func mark(): Buffer {
        mar = pos
        return this
    }

    public open func reset(): Buffer  {
        var ma = mar
        if (ma < 0){
            throw ChardetException("ma < 0: ${ma}")
        }
        pos = ma
        return this
    }

    public open func clear(): Buffer  {
        pos = 0
        lim = capa
        mar = -1
        return this
    }

    public open func flip(): Buffer  {
        lim = pos
        pos = 0
        mar = -1
        return this
    }

    public open func rewind(): Buffer  {
        pos = 0
        mar = -1
        return this
    }

    public func remaining(): Int64 {
        let rems = lim - pos
        return if (rems > 0) {
            rems
        } else {
            0
        }
    }

    public func hasRemaining(): Bool {
        return pos < lim
    }

    public func arrayOffset(): Int64

    public func slice(): Buffer

    public func duplicate(): Buffer

    public func array(): Array<UInt8>

    func nextGetIndex(): Int64 {
        if (pos >= lim){
            throw ChardetException("index out of bounds")
        }
        let temps = pos
        pos++
        return temps
    }

    func checkIndex(t: Int64): Int64 {
        if ((t < 0) || (t >= lim)){
            throw ChardetException("index out of bounds : ${t}")
        }
        return t
    }

    func markValue(): Int64 {
        return mar
    }

    func discardMark() {
        mar = -1
    }

    func checkBounds(off: Int64, len: Int64, size: Int64) {
        if ((off | len | (off + len) | (size - (off + len))) < 0){
            throw ChardetException("index out of bounds")
        }
    }
}

public abstract class ChardetByteBuffer <: Buffer & ToString & Hashable & Equatable<Buffer>  {

    let hb: Array<Byte>

    let offset: Int64

    init (mark: Int64, position: Int64, limits: Int64, capacity: Int64, hbs: Array<Byte>, offsets: Int64) {
        super(mark, position, limits, capacity)
        this.hb = hbs
        this.offset = offsets
    }

    public static func allocate(capacitys: Int64): ChardetByteBuffer {
        if (capacitys < 0) {
            throw ChardetException("capacitys < 0: ${capacitys}")
        }
        return HeapChardetByteBuffer(capacitys, capacitys)
    }

    public static func wrap(arrays: Array<UInt8>, offset: Int64, length: Int64): ChardetByteBuffer {
        try{
            return HeapChardetByteBuffer(arrays,offset,length)
        } catch (ex: IllegalArgumentException) {
            throw ex
        }
    }

    public static func wrap(arrays: Array<UInt8>): ChardetByteBuffer {
        return wrap(arrays, 0, arrays.size)
    }

    public func slice(): ChardetByteBuffer

    public func duplicate(): ChardetByteBuffer

    public func asReadOnlyBuffer(): ChardetByteBuffer

    public func get(): UInt8

    public func put(bs: UInt8): ChardetByteBuffer

    public func get(indexs: Int64): UInt8


    public func put(indexs: Int64, b: UInt8): ChardetByteBuffer

    public func putLong(val: Int64): ChardetByteBuffer
    public func putInt(val: Int32): ChardetByteBuffer
    public func putShort(val: Int16): ChardetByteBuffer
    public func putUInt64(val: UInt64): ChardetByteBuffer
    public func putUInt32(val: UInt32): ChardetByteBuffer
    public func putUInt16(val: UInt16): ChardetByteBuffer

    public func getLong(): Int64
    public func getInt(): Int32
    public func getShort(): Int16
    public func getUInt64(): UInt64
    public func getUInt32(): UInt32
    public func getUInt16(): UInt16

    public func get(dst: Array<UInt8>, offset: Int64, length: Int64) : ChardetByteBuffer

    public open func get(dst: Array<UInt8>): ChardetByteBuffer {
        return get(dst, 0, dst.size)
    }

    public func put(src: ChardetByteBuffer) : ChardetByteBuffer

    public func put(src: Array<UInt8>, offset:Int64, length: Int64): ChardetByteBuffer

    public open func put(srcs: Array<UInt8>): ChardetByteBuffer {
        return this.put(srcs, 0, srcs.size)
    }

    public open func hasArray(): Bool {
        return false
    }

    public override func array(): Array<UInt8> {
        return this.hb
    }

    public override func arrayOffset(): Int64 {
        return this.offset
    }

    public override func position(newPosit: Int64): ChardetByteBuffer {
        super.position(newPosit)
        return this
    }

    public override func limit(newLim: Int64): ChardetByteBuffer {
        super.limit(newLim)
        return this
    }

    public override func reset(): ChardetByteBuffer {
        super.reset()
        return this
    }

    public override func clear (): ChardetByteBuffer {
        super.clear()
        return this
    }

    public override func flip(): ChardetByteBuffer {
        super.flip()
        return this
    }

    public override func rewind(): ChardetByteBuffer {
        super.rewind()
        return this
    }

    public func compact(): ChardetByteBuffer

    public open func toString(): String {
        let sbd = StringBuilder()
        sbd.append("ChardetByteBuffer: [offset=")
        sbd.append(this.offset)
        sbd.append(" mark=")
        sbd.append(this.mar)
        sbd.append(" pos=")
        sbd.append(position())
        sbd.append(" lim=")
        sbd.append(limit())
        sbd.append(" cap=")
        sbd.append(capacity())
        sbd.append("]")
        let src = sbd.toString()
        sbd.reset()
        return src
    }

    @OverflowWrapping
    public open func hashCode(): Int64 {
        var hc: Int32 = 1
        var p = position()
        for (i in limit()-1..=p:-1) {
            hc = 31 * hc + Int32(get(i))
        }
        return Int64(hc)
    }

    public open operator func == (thats: Buffer): Bool {
        return refEq(this, thats)
    }

    public open operator func != (thats: Buffer): Bool {
        return !refEq(this, thats)
    }

    public func slice(pos: Int64, limit: Int64): ChardetByteBuffer

}

public func ArrayCopy(src: Array<Byte>, srcPos: Int64, dest: Array<Byte>, destPos: Int64, length: Int64) {
    src.copyTo(dest, srcPos, destPos, length)
}

public open class HeapChardetByteBuffer <: ChardetByteBuffer & ToString {

    init (cap: Int64, lims: Int64) {
        super (-1, 0, lims, cap, Array<Byte>(cap, repeat: 0), 0)
    }

    init (bufs: Array<Byte>, off: Int64, len: Int64) {
        super (-1, off, off+len, bufs.size, bufs, 0)
    }

    protected init (bufs: Array<Byte>, mark: Int64, pos: Int64, lim: Int64, cap: Int64, off: Int64) {
        super(mark, pos, lim, cap, bufs, off)
    }

    public override func slice(): ChardetByteBuffer {
        return HeapChardetByteBuffer(this.hb, -1, 0, this.remaining(), this.remaining(), this.position() + offset)
    }

    public override func slice (pos: Int64, limit: Int64): ChardetByteBuffer {
        let rem = limit - pos
        return HeapChardetByteBuffer(hb, -1, 0, rem, rem, pos + offset)
    }

    public override func duplicate(): ChardetByteBuffer {
        return HeapChardetByteBuffer(hb, this.markValue(), this.position(), this.limit(), this.capacity(), offset)
    }

    public override func asReadOnlyBuffer(): ChardetByteBuffer {
        return HeapChardetByteBuffer(hb, this.markValue(), this.position(), this.limit(), this.capacity(), offset)
    }

    protected func ix(ii: Int64): Int64 {
        return ii + offset
    }

    public override func get(): Byte {
        return hb[ix(nextGetIndex())]
    }

    public override func get(i:Int64) : Byte {
        return hb[ix(checkIndex(i))]
    }

    public override func get(dsts: Array<Byte>, offset: Int64, length: Int64): ChardetByteBuffer {
        checkBounds(offset, length, dsts.size)
        if (length > this.remaining()) {
            throw ChardetException("buffer underflow") // BufferUnderflowException
        }
        ArrayCopy(hb, ix(position()), dsts, offset, length)
        position(position() + length)
        return this
    }

    public override func put(x: Byte): ChardetByteBuffer {
        hb[ix(nextGetIndex())] = x
        return this
    }

    public override func put(i: Int64, x: Byte): ChardetByteBuffer {
        hb[ix(checkIndex(i))] = x
        return this
    }

    public override func put(src: Array<Byte>, offsets: Int64, length: Int64): ChardetByteBuffer {
        checkBounds(offsets, length, src.size)
        if (length > remaining()) {
            throw ChardetException("buffer overflow") // BufferOverflowException
        }
        ArrayCopy(src, offsets, hb, ix(position()), length)
        position(position() + length)
        return this
    }

    public override func put(srcs: ChardetByteBuffer): ChardetByteBuffer {
        if (srcs is HeapChardetByteBuffer) {
            if (srcs == this) {
                throw ChardetException("the source buffer is this buffer")
            }
            let sb: HeapChardetByteBuffer = match ((srcs as HeapChardetByteBuffer)) {
                case None => throw ChardetException("data conversion can still fail")
                case Some (v) => v
            }
            let n = sb.remaining()
            if (n > remaining()) {
                throw ChardetException("buffer overflow") // BufferOverflowException
            }
            ArrayCopy(sb.hb, sb.ix(sb.position()), hb, ix(position()), n)
            sb.position(sb.position() + n )
            position(position() +n)
        }
        return this
    }

    public override func compact(): ChardetByteBuffer {
        ArrayCopy(hb, ix(position()), hb, ix(0), remaining())
        position(remaining())
        limit(capacity())
        discardMark()
        return this
    }

    @OverflowWrapping
    public override func putLong(val: Int64): ChardetByteBuffer {
        this.putUInt64(UInt64(val))
    }

    @OverflowWrapping
    public override func putInt(val: Int32): ChardetByteBuffer {
        this.putUInt32(UInt32(val))
    }

    @OverflowWrapping
    public override func putShort(val: Int16): ChardetByteBuffer {
        this.putUInt16(UInt16(val))
    }

    @OverflowWrapping
    public override func getLong(): Int64 {
        return Int64(this.getUInt64())
    }

    @OverflowWrapping
    public override func getInt(): Int32 {
        return Int32(this.getUInt32())
    }

    @OverflowWrapping
    public override func getShort(): Int16 {
        return Int16(this.getUInt16())
    }

    @OverflowWrapping
    public func putUInt64(val: UInt64): ChardetByteBuffer {
        this.put(UInt8((val >> 56) & 0xff))
        this.put(UInt8((val >> 48) & 0xff))
        this.put(UInt8((val >> 40) & 0xff))
        this.put(UInt8((val >> 32) & 0xff))
        this.put(UInt8((val >> 24) & 0xff))
        this.put(UInt8((val >> 16) & 0xff))
        this.put(UInt8((val >> 8) & 0xff))
        this.put(UInt8(val & 0xff))
        return this
    }

    @OverflowWrapping
    public func putUInt32(val: UInt32): ChardetByteBuffer {
        this.put(UInt8((val >> 24) & 0xff))
        this.put(UInt8((val >> 16) & 0xff))
        this.put(UInt8((val >> 8) & 0xff))
        this.put(UInt8(val & 0xff))
        return this
    }

    @OverflowWrapping
    public func putUInt16(val: UInt16): ChardetByteBuffer {
        this.put(UInt8((val >> 8) & 0xff))
        this.put(UInt8(val & 0xff))
        return this
    }

    @OverflowWrapping
    public func getUInt64(): UInt64 {
        return UInt64(this.get()) << 56 | 
            UInt64(this.get()) << 48 | 
            UInt64(this.get()) << 40 | 
            UInt64(this.get()) << 32 | 
            UInt64(this.get()) << 24 | 
            UInt64(this.get()) << 16 |
            UInt64(this.get()) << 8 | 
            UInt64(this.get())
    }

    @OverflowWrapping
    public func getUInt32(): UInt32 {
        return UInt32(this.get()) << 24 | 
            UInt32(this.get()) << 16 | 
            UInt32(this.get()) << 8 | 
            UInt32(this.get())
    }

    @OverflowWrapping
    public func getUInt16(): UInt16 {
        return UInt16(this.get()) << 8 | 
            UInt16(this.get())
    }

    
}



