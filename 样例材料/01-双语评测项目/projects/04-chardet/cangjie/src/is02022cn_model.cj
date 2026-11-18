/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

public class ISO2022CNSMModel <: SMModel {

    public static let ISO2022CN_CLASS_FACTOR: Int32 = 9

    public init() {

        super(
                PkgInt(INDEX_SHIFT_4BITS, SHIFT_MASK_4BITS, BIT_SHIFT_4BITS, UNIT_MASK_4BITS, iso2022cnClassTable),
                ISO2022CN_CLASS_FACTOR,
                PkgInt(INDEX_SHIFT_4BITS, SHIFT_MASK_4BITS, BIT_SHIFT_4BITS, UNIT_MASK_4BITS, iso2022cnStateTable),
                iso2022cnCharLenTable,
                Constants.CHARSET_ISO_2022_CN
            )
    }

    private static let iso2022cnClassTable: Array<Int32> = [

        PkgInt.pack4bits(2,0,0,0,0,0,0,0),  
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),  
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),  
        PkgInt.pack4bits(0,0,0,1,0,0,0,0),  
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,3,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,4,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(0,0,0,0,0,0,0,0),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2), 
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2),   
        PkgInt.pack4bits(2,2,2,2,2,2,2,2)
    ]


    private static let iso2022cnStateTable: Array<Int32> = [
        PkgInt.pack4bits(START,    3,ERROR,START,START,START,START,START),
        PkgInt.pack4bits(START,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR),
        PkgInt.pack4bits(ERROR,ERROR,ITSME,ITSME,ITSME,ITSME,ITSME,ITSME),
        PkgInt.pack4bits(ITSME,ITSME,ITSME,ERROR,ERROR,ERROR,    4,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ITSME,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(    5,    6,ERROR,ERROR,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ITSME,ERROR,ERROR,ERROR,ERROR), 
        PkgInt.pack4bits(ERROR,ERROR,ERROR,ERROR,ERROR,ITSME,ERROR,START)
    ]

    private static let iso2022cnCharLenTable: Array<Int32> = [
        0, 0, 0, 0, 0, 0, 0, 0, 0
    ]
}