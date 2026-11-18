/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

public let INDEX_SHIFT_4BITS: Int32   = 3
public let INDEX_SHIFT_8BITS: Int32   = 2
public let INDEX_SHIFT_16BITS: Int32  = 1
    
public let SHIFT_MASK_4BITS: Int32    = 7
public let SHIFT_MASK_8BITS: Int32    = 3
public let SHIFT_MASK_16BITS: Int32  = 1
    
public let BIT_SHIFT_4BITS: Int32     = 2
public let BIT_SHIFT_8BITS: Int32     = 3
public let BIT_SHIFT_16BITS: Int32    = 4

public let UNIT_MASK_4BITS: Int32 = 0x0000000F
public let UNIT_MASK_8BITS: Int32 = 0x000000FF
public let UNIT_MASK_16BITS: Int32 = 0x0000FFFF

public class PkgInt {

    private var indexShift: Int32
    private var shiftMask: Int32
    private var bitShift: Int32
    private var unitMask: Int32
    private var data: Array<Int32>

    public init (indexShift: Int32, shiftMask: Int32, bitShift: Int32, unitMask: Int32, data: Array<Int32>) {
        this.indexShift = indexShift
        this.shiftMask = shiftMask
        this.bitShift = bitShift
        this.unitMask = unitMask
        this.data = data
    }

    public static func pack16bits(a: Int32, b: Int32): Int32 {
        return ((b << 16) | a)
    }

    public static func pack8bits(a: Int32, b: Int32, c: Int32, d: Int32): Int32 {
        return pack16bits((b << 8) | a, (d << 8) | c)
    }

    public static func pack4bits(a: Int32, b: Int32, c: Int32, d: Int32, e: Int32, f: Int32, g: Int32, h: Int32): Int32 {
        return pack8bits((b << 4) | a, (d << 4) | c, (f << 4) | e, (h << 4) | g)
    }

    public func unpack(i: Int32): Int32 {
        return ((this.data[Int64(i>>this.indexShift)] >> ((i&this.shiftMask)<<this.bitShift)) & this.unitMask)
                
    }
}