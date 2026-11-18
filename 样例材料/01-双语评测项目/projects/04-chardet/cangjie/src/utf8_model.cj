/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

public class UTF8SMModel <: SMModel {

    public static let UTF8_CLASS_FACTOR: Int32 = 16

    public init() {
        super(
            PkgInt(INDEX_SHIFT_4BITS, SHIFT_MASK_4BITS, BIT_SHIFT_4BITS, UNIT_MASK_4BITS, utf8ClassTable),
            UTF8_CLASS_FACTOR,
            PkgInt(INDEX_SHIFT_4BITS, SHIFT_MASK_4BITS, BIT_SHIFT_4BITS, UNIT_MASK_4BITS, utf8StateTable),
            utf8CharLenTable,
            Constants.CHARSET_UTF_8
        )

    }

    private static let utf8ClassTable: Array<Int32> = [

        PkgInt.pack4bits(1,1,1,1,1,1,1,1),  
        PkgInt.pack4bits(1,1,1,1,1,1,0,0),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,0,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),      
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(1,1,1,1,1,1,1,1),   
        PkgInt.pack4bits(2,2,2,2,3,3,3,3),   
        PkgInt.pack4bits(4,4,4,4,4,4,4,4),   
        PkgInt.pack4bits(4,4,4,4,4,4,4,4),   
        PkgInt.pack4bits(4,4,4,4,4,4,4,4),   
        PkgInt.pack4bits(5,5,5,5,5,5,5,5),   
        PkgInt.pack4bits(5,5,5,5,5,5,5,5),   
        PkgInt.pack4bits(5,5,5,5,5,5,5,5),   
        PkgInt.pack4bits(5,5,5,5,5,5,5,5),   
        PkgInt.pack4bits(0,0,6,6,6,6,6,6),   
        PkgInt.pack4bits(6,6,6,6,6,6,6,6),   
        PkgInt.pack4bits(6,6,6,6,6,6,6,6),   
        PkgInt.pack4bits(6,6,6,6,6,6,6,6),   
        PkgInt.pack4bits(7,8,8,8,8,8,8,8),   
        PkgInt.pack4bits(8,8,8,8,8,9,8,8),   
        PkgInt.pack4bits(10,11,11,11,11,11,11,11),  
        PkgInt.pack4bits(12,13,13,13,14,15,0,0)
    ]

    private static let utf8StateTable: Array<Int32> = [
        PkgInt.pack4bits(ERROR,START,ERROR,ERROR,ERROR,ERROR,   12,   10),
        PkgInt.pack4bits(    9,   11,    8,    7,    6,    5,    4,    3),
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR),
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR),
        PkgInt.pack4bits(ITSME,ITSME,ITSME,ITSME,ITSME,ITSME,ITSME,ITSME),
        PkgInt.pack4bits(ITSME,ITSME,ITSME,ITSME,ITSME,ITSME,ITSME,ITSME),
        PkgInt.pack4bits(ERROR,ERROR,    5,    5,    5,    5,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,    5,    5,    5,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,    7,    7,    7,    7,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,    7,    7,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,    9,    9,    9,    9,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,    9,    9,ERROR,ERROR),  
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,   12,   12,   12,   12,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,   12,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,   12,   12,   12,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,START,START,START,START,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR) 
    ]

    private static let utf8CharLenTable: Array<Int32> = [
        0, 1, 0, 0, 0, 0, 2, 3,
        3, 3, 4, 4, 5, 5, 6, 6
    ]
}