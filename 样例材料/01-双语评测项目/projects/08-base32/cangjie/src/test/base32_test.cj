package hibase32cj.test

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import stdx.log.*
import hibase32cj.*

var strs = [
    '',
    'H',
    'He',
    'Hel',
    'Hell',
    'Hello',
    'Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.',
    'Base64 is a group of similar binary-to-text encoding schemes that represent binary data in an ASCII string format by translating it into a radix-64 representation.'
];

var base32Strs = [
    '',
    'JA======',
    'JBSQ====',
    'JBSWY===',
    'JBSWY3A=',
    'JBSWY3DP',
    'JVQW4IDJOMQGI2LTORUW4Z3VNFZWQZLEFQQG433UEBXW43DZEBRHSIDINFZSA4TFMFZW63RMEBRHK5BAMJ4SA5DINFZSA43JNZTXK3DBOIQHAYLTONUW63RAMZZG63JAN52GQZLSEBQW42LNMFWHGLBAO5UGSY3IEBUXGIDBEBWHK43UEBXWMIDUNBSSA3LJNZSCYIDUNBQXIIDCPEQGCIDQMVZHGZLWMVZGC3TDMUQG6ZRAMRSWY2LHNB2CA2LOEB2GQZJAMNXW45DJNZ2WKZBAMFXGIIDJNZSGKZTBORUWOYLCNRSSAZ3FNZSXEYLUNFXW4IDPMYQGW3TPO5WGKZDHMUWCAZLYMNSWKZDTEB2GQZJAONUG64TUEB3GK2DFNVSW4Y3FEBXWMIDBNZ4SAY3BOJXGC3BAOBWGKYLTOVZGKLQ=',
    'IJQXGZJWGQQGS4ZAMEQGO4TPOVYCA33GEBZWS3LJNRQXEIDCNFXGC4TZFV2G6LLUMV4HIIDFNZRW6ZDJNZTSA43DNBSW2ZLTEB2GQYLUEBZGK4DSMVZWK3TUEBRGS3TBOJ4SAZDBORQSA2LOEBQW4ICBKNBUSSJAON2HE2LOM4QGM33SNVQXIIDCPEQHI4TBNZZWYYLUNFXGOIDJOQQGS3TUN4QGCIDSMFSGS6BNGY2CA4TFOBZGK43FNZ2GC5DJN5XC4==='
];

var utf8Str = [
    '',
    '中文',
    '中文1',
    '中文12',
    'aécio',
    '𠜎',
    'Base64是一種基於64個可列印字元來表示二進制資料的表示方法'
];

var base32Utf8Strs = [
    '',
    '4S4K3ZUWQ4======',
    '4S4K3ZUWQ4YQ====',
    '4S4K3ZUWQ4YTE===',
    'MHB2SY3JN4======',
    '6CQJZDQ=',
    'IJQXGZJWGTTJRL7EXCAOPKFO4WP3VZUWXQ3DJZMARPSY7L7FRCL6LDNQ4WWZPZMFQPSL5BXIUGUOPJF24S5IZ2MAWLSYRNXIWOD6NFUZ46NIJ2FBVDT2JOXGS246NM4V'
];

var base32NonUtf8Strs = [
    '7A======',
    '354Q====',
    '5WQIA===',
    '6SIIBAA=',
    '4S4K3ZUWQ7SLRLPGS2D6JOFN42LIPZFYVXTJNB7EXCW6NFUH4S4K3ZUWQ72JBAEA'
];

var base32Invalid8Strs = ['1 ======'];

@Test
func testAscii() {
    for (i in 0..strs.size) {
        @Expect(encode(strs[i]), base32Strs[i])
    }
}

@Test
func testUtf8() {
      for (i in 0..utf8Str.size) {
        @Expect(encode(utf8Str[i]),base32Utf8Strs[i])
    }
}

@Test
func testArray() {
    @Expect(encode([72]), 'JA======')
    @Expect(encode([72, 101]), 'JBSQ====')
    @Expect(encode([72, 101, 108]), 'JBSWY===')
    @Expect(encode([72, 101, 108, 108]), 'JBSWY3A=')
    @Expect(encode([72, 101, 108, 108, 111]), 'JBSWY3DP')
}

@Test
func testUint8Arryay() {
    var arr = ArrayList<UInt8>([72, 101, 108, 108, 111]).toArray()
    @Expect(encode(arr),'JBSWY3DP')
}

@Test
func testArrayBuffer() {
    var buffer: Array<Byte> = [0]
    @Expect(encode(buffer),'AA======')
}

@Test
func testDecode() {
    for (i in 0..strs.size) {
        @Expect(decodeAsString(base32Strs[i]),strs[i])
    }
}

@Test
func testUtf8Decode() {
    @Expect(decodeAsString(""), "")
    @Expect(decodeAsString("4S4K3ZUWQ4======"), "中文")
    @Expect(decodeAsString("4S4K3ZUWQ4YQ===="), "中文1")
    @Expect(decodeAsString("4S4K3ZUWQ4YTE==="), "中文12")
    @Expect(decodeAsString("MHB2SY3JN4======"), "aécio")
    @Expect(decodeAsString("IJQXGZJWGTTJRL7EXCAOPKFO4WP3VZUWXQ3DJZMARPSY7L7FRCL6LDNQ4WWZPZMFQPSL5BXIUGUOPJF24S5IZ2MAWLSYRNXIWOD6NFUZ46NIJ2FBVDT2JOXGS246NM4V"), "Base64是一種基於64個可列印字元來表示二進制資料的表示方法")
    @Expect(decodeAsString("6CQJZDQ="), "𠜎")
}

@Test
func testUtf8Exception() {
    for (i in 0..base32NonUtf8Strs.size) {
        @AssertThrows[Exception](decodeAsString(base32NonUtf8Strs[i]))
    }
}

@Test
func testInvaildString() {
    for (i in 0..base32Invalid8Strs.size) {
        @AssertThrows[Exception](decodeAsString(base32Invalid8Strs[i]))
        @AssertThrows[Exception](decodeAsBytes(base32Invalid8Strs[i]))
    }
}

@Test
func testUnsignedRightShift() {
    @Expect(unsignedRightShift(2, 1), 1) // 正常情况
    @Expect(unsignedRightShift(-2, 1), 2147483647) // 负数情况
    @Expect(unsignedRightShift(0, 1), 0) // 0情况
    @Expect(unsignedRightShift(1073741824, 1), 536870912) // 大数情况
    @Expect(unsignedRightShift(2, 0), 2) // 移位位数为0的情况
    @Expect(unsignedRightShift(2, 32), 2) // 大于32的移位位数
    @Expect(unsignedRightShift(2, 33), 1) // 非数值输入情况

    //随机数据测试
    @Expect(unsignedRightShift(16,2), 4)
    @Expect(unsignedRightShift(-16,2), 1073741820)
    @Expect(unsignedRightShift(0,2), 0)
    @Expect(unsignedRightShift(-1,0), -1)
    @Expect(unsignedRightShift(1,0), 1)
    @Expect(unsignedRightShift(-2,31), 1)
    @Expect(unsignedRightShift(-2,32), -2)
    @Expect(unsignedRightShift(1, 1), 0)
    @Expect(unsignedRightShift(-2, 32), -2)
    @Expect(unsignedRightShift(1024, 5), 32)
    @Expect(unsignedRightShift(2147483647, 1), 1073741823)
    @Expect(unsignedRightShift(-2147483648, 31), 1)
    @Expect(unsignedRightShift(0, 31), 0)
    @Expect(unsignedRightShift(-1, 31), 1)
    @Expect(unsignedRightShift(123456789, 3), 15432098)
    @Expect(unsignedRightShift(987654321, 10), 964506)
    @Expect(unsignedRightShift(-1, 1), 2147483647)
    @Expect(unsignedRightShift(-2, 1), 2147483647)
}

@Test
func testVaildBase32() {
    @Expect(testVaildBase32("ABC"), true)
    @Expect(testVaildBase32("123"), false)
    @Expect(testVaildBase32("A2B3C4D5"), true)
    @Expect(testVaildBase32("ABC="), true)
    @Expect(testVaildBase32("ABCD567"), true)
    @Expect(testVaildBase32("ABCD567!"), false) // 包含无效字符 '!'
    @Expect(testVaildBase32(""), true) // 空字符串应该是有效的
    @Expect(testVaildBase32("ABCDEFGH234567="), true)
    @Expect(testVaildBase32("ABCD*EFG"), false) // 包含无效字符 '*'
    @Expect(testVaildBase32("abcdefgh"), false) // 小写字母应为无效字符
}
