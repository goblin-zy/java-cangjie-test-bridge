/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

public class HZSMModel <: SMModel {

    public static let HZS_CLASS_FACTOR: Int32 = 6

    public init() {

        super(
                PkgInt(INDEX_SHIFT_4BITS, SHIFT_MASK_4BITS, BIT_SHIFT_4BITS, UNIT_MASK_4BITS, hzsClassTable),
                HZS_CLASS_FACTOR,
                PkgInt(INDEX_SHIFT_4BITS, SHIFT_MASK_4BITS, BIT_SHIFT_4BITS, UNIT_MASK_4BITS, hzsStateTable),
                hzsCharLenTable,
                Constants.CHARSET_HZ_GB_2312
            )
    }

    private static let hzsClassTable: Array<Int32> = [

        PkgInt.pack4bits(1,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,1,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,0,0,0,0,0), 
        PkgInt.pack4bits(0,0,0,4,0,5,2,0), 
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
        PkgInt.pack4bits(1,1,1,1,1,1,1,1), 
        PkgInt.pack4bits(1,1,1,1,1,1,1,1), 
        PkgInt.pack4bits(1,1,1,1,1,1,1,1), 
        PkgInt.pack4bits(1,1,1,1,1,1,1,1) 
    ]

    private static let hzsStateTable: Array<Int32> = [

        PkgInt.pack4bits(START,ERROR,    3,START,START,START,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ITSME,ITSME,ITSME,ITSME), 
        PkgInt.pack4bits(ITSME,ITSME,ERROR,ERROR,START,START,    4,ERROR), 
        PkgInt.pack4bits(    5,ERROR,    6,ERROR,    5,    5,    4,ERROR), 
        PkgInt.pack4bits(    4,ERROR,    4,    4,    4,ERROR,    4,ERROR), 
        PkgInt.pack4bits(    4,ITSME,START,START,START,START,START,START) 
    ]

    private static let hzsCharLenTable: Array<Int32> = [
        0, 0, 0, 0, 0, 0
    ]
}