# chardet4cj 库

### 介绍

chardet4cj 是一个字符编码高效识别检测库。

### 1 提供字符编码识别功能

前置条件：NA 

场景：
1. 提供字符编码识别，是一个字符编码高效识别检测库
2. 类型为 Chinese(ISO-2022-CN), UTF-8, UTF-16BE, UTF-16LE

约束：NA

性能：支持版本几何性能持平

可靠性：NA

#### 1.1 提供 UTF-8 编码字符识别功能

提供 UTF-8 编码字符识别功能

##### 1.1.1 主要接口

```cangjie
public abstract class CharsetProber {
    
    /*
     * 默认构造函数
     */
    public init()

    /*
     * 获取编码名称，抽象函数
     * 返回值 String - 编码名称
     */
    public func getCharSetName(): String

    /*
     * 处理原数据，抽象函数
     * 参数 buf - 要处理的原数据
     * 参数 offset - 起始位置
     * 参数 length - 长度
     * 返回值 ProbingState - 当前状态
     */
    public func handleData(buf: Array<Byte>, offset: Int32, length: Int32): ProbingState

    /*
     * 获取当前状态，抽象函数
     * 返回值 ProbingState - 当前状态
     */
    public func getState(): ProbingState

    /*
     * 重置解析器，抽象函数
     */
    public func reset(): Unit

    /*
     * 抽象函数，获取检测出的编码的置信度，该函数会根据检测出的各种编码的概率分布以及内部的算法模型，计算出检测出的编码是正确的概率，并将结果以浮点数的形式返回。通常情况下，置信度的值越高，表示检测出的编码的准确性越高。
     * 返回值 Float32 - 置信度
     */
    public func getConfidence(): Float32

    /*
     * 忽略英文字符
     * 参数 buf - 要处理的原数据
     * 参数 offset - 起始位置
     * 参数 length - 长度
     * 返回值 ChardetByteBuffer - 处理后的 ChardetByteBuffer
     * 异常 ChardetException 当buf是个空数组时，offset和length之和小于等于零时，抛出异常
     */
    public func filterWithoutEnglishLetters(buf: Array<Byte>, offset: Int32, length: Int32): ChardetByteBuffer

    /*
     * 使用英文字符填充
     * 参数 buf - 要处理的原数据
     * 参数 offset - 起始位置
     * 参数 length - 长度
     * 返回值 ChardetByteBuffer - 处理后的 ChardetByteBuffer
     * 异常 ChardetException 当buf是个空数组时，offset和length之和小于等于零时，抛出异常
     */
    public func filterWithEnglishLetters(buf: Array<Byte>, offset: Int32, length: Int32): ChardetByteBuffer

    /*
     * 判断是否活动
     * 返回值 Bool - 是否活动
     */
    public func isActive(): Bool

    /*
     * 设置活动标签
     */
    public func setActive(active: Bool): Unit
}

public enum ProbingState <: Equatable<ProbingState> & ToString {
    | DETECTING  // 解析中
    | FOUND_IT   // 已解析出对应的编码编码
    | NOT_ME  // 未成功解析出对应的编码

    /*
     * 转成字符串
     * 返回值 String - 转换后的 String
     */
    public func toString(): String

    /*
     * 等号操作符
     * 返回值 如果相等，则返回true；否则，返回false
     */
    public operator func == (that: ProbingState): Bool

    /*
     * 不等号操作符
     * 返回值 如果不相等，则返回true；否则，返回false
     */
    public operator func != (that: ProbingState): Bool
}

public class CodingStateMachine {
    /*
     * 构造函数
     * 参数 model - 一个 SMModel
     */
    public init(model: SMModel)

    /*
     * 获取下一步
     * 参数 c - UInt8 值
     * 返回值 Int32 - 状态值
     */
    public func nextState(c: Byte): Int32

    /*
     * 获取当前字符长度
     * 返回值 Int32 - 字符长度
     */
    public func getCurrentCharLen(): Int32

    /*
     * 重置解析器
     */
    public func reset(): Unit

    /*
     * 获取编码器状态
     * 返回值 String - 状态
     */
    public func getCodingStateMachine(): String
}

public class EncodingDetectorInputStream <: InputStream {
    /*
     * 构造函数
     * 返回值 input - 输入流
     */
    public init(input: InputStream)

    /*
     * 是否可用
     * 返回值 Int32 - 返回 0 代表可用
     */
    public func available(): Int32

    /*
     * 关闭输入流
     */
    public func close(): Unit

    /*
     * 
     * 参数 readlimit - Int32 值
     * 异常 ChardetException 当readlimit为0时,抛出异常
     */
    public func mark(readlimit: Int32): Unit

    /*
     * 是否支持标记值，输入流返回值始终为 false
     * 返回值 Bool - Bool 值
     */
    public func markSupported(): Bool

    /*
     * 读取流
     * 返回值 Int64 - 读取的字节数
     * 异常 ChardetException 当输入流为空时,抛出异常
     */
    public func read(): Int64

    /*
     * 读取流
     * 返回值 Int64 - 读取的字节数
     * 异常 ChardetException 当输入流为空时，或者b数组长度为零时,抛出异常
     */
    public func read(b: Array<Byte>): Int64

    /*
     * 重置流
     * 异常 ChardetException ,抛出异常
     */
    public func reset(): Unit

    /*
     * 跳过指定字节
     * 参数 n - 跳过的数量
     * 返回值 Int64 - 实际跳过的数量
     * 异常 ChardetException 当输入流为空时,抛出异常
     */
    public func skip(n: Int64): Int64

    /*
     * 获取流数据的编码
     * 返回值 String - 编码值
     */
    public func getDetectedCharset(): String
}

public class EncodingDetectorOutputStream <: OutputStream {
     /*
     * 构造函数
     * 返回值 out - 输出流
     */
    public init(out: OutputStream)

    /*
     * 关闭输出流
     */
    public func close(): Unit

    /*
     * 刷新流
     */
    public func flush(): Unit

    /*
     * 写入数组数据
     * 参数 b - 要写入的 Array<UInt8> 数组
     * 异常 ChardetException 当输出流已经关闭时,抛出异常
     */
    public func write(b: Array<UInt8>): Unit

    /*
     * 写入一个字节，将会转换成 UInt8 写入
     * 参数 b - 要写入的值
     * 异常 ChardetException 当输出流已经关闭时,抛出异常
     */
    public func write(b: Int32): Unit

    /*
     * 获取流数据的编码
     * 返回值 String - 编码值
     */
    public func getDetectedCharset(): String
}

public class EscCharsetProber <: CharsetProber {
    /*
     * 默认构造函数
     */
    public init()

    /*
     * 重置检测器
     */
    public func reset(): Unit

    /*
     * 获取检测到的编码
     * 返回值 String - 检测到的编码名
     */
    public func getCharSetName(): String

    /*
     * 获取检测出的编码的置信度，该函数会根据检测出的各种编码的概率分布以及内部的算法模型，计算出检测出的编码是正确的概率，并将结果以浮点数的形式返回。通常情况下，置信度的值越高，表示检测出的编码的准确性越高。
     * 返回值 Float32 - 置信度
     */
    public func getConfidence(): Float32

    /*
     * 当前检测状态
     * 返回值 ProbingState - ProbingState对象
     */
    public func getState(): ProbingState

    /*
     * 检测数据
     * 参数 buf - 要检测的原数据
     * 参数 offset - 起始位置
     * 参数 length - 长度
     * 返回值  ProbingState - ProbingState对象
     * 异常 ChardetException 当buf数组为空时，当offset和length之和小于等于零时，抛出异常
     */
    public func handleData(buf: Array<Byte>, offset: Int32, length: Int32): ProbingState
}

public class HZSMModel <: SMModel {
    /*
     * 默认构造函数
     */
    public init()
}

public class ISO2022CNSMModel <: SMModel {
    /*
     * 默认构造函数
     */
    public init()
}

public class MBCSGroupProber <: CharsetProber {
    /*
     * 默认构造函数
     */
    public init()

    /*
     * 重置检测器
     */
    public func reset(): Unit

    /*
     * 获取检测到的编码
     * 返回值 String - 检测到的编码名
     */
    public func getCharSetName(): String

    /*
     * 获取检测出的编码的置信度，该函数会根据检测出的各种编码的概率分布以及内部的算法模型，计算出检测出的编码是正确的概率，并将结果以浮点数的形式返回。通常情况下，置信度的值越高，表示检测出的编码的准确性越高。
     * 返回值 Float32 - 置信度
     */
    public func getConfidence(): Float32

    /*
     * 当前检测状态
     * 返回值 ProbingState - ProbingState对象
     */
    public func getState(): ProbingState

    /*
     * 检测数据
     * 参数 buf - 要检测的原数据
     * 参数 offset - 起始位置
     * 参数 length - 长度
     * 返回值  ProbingState - ProbingState对象
     * 异常 ChardetException 当buf数组为空时，当offset和length之和小于等于零时，抛出异常
     */
    public func handleData(buf: Array<Byte>, offset: Int32, length: Int32): ProbingState
}

public class PkgInt {
    /*
     * 默认构造函数
     * 参数 indexShift -Int32 位移值
     * 参数 shiftMask - Int32 值
     * 参数 bitShift - Int32 值
     * 参数 unitMask - Int32 值
     * 参数 data - Array<Int32> 数组数据
     */
    public init (indexShift: Int32, shiftMask: Int32, bitShift: Int32, unitMask: Int32, data: Array<Int32>)

    /*
     * 将两个16位大小的数字转换成 int32 数
     * 参数 a - 16位大小的数据
     * 参数 b - 16位大小的数据
     * 返回值  Int32 - 合并后的数据
     */
    public static func pack16bits(a: Int32, b: Int32): Int32

    /*
     * 将4个8位数字转换成 int32 数
     * 参数 a - 8位大小的数据
     * 参数 b - 8位大小的数据
     * 参数 c - 8位大小的数据
     * 参数 d - 8位大小的数据
     * 返回值  Int32 - 合并后的数据
     */
    public static func pack8bits(a: Int32, b: Int32, c: Int32, d: Int32): Int32

    /*
     * 将8个4位数字转换成 int32 数
     * 参数 a - 4位大小的数据
     * 参数 b - 4位大小的数据
     * 参数 c - 4位大小的数据
     * 参数 d - 4位大小的数据
     * 参数 e - 4位大小的数据
     * 参数 f - 4位大小的数据
     * 参数 g - 4位大小的数据
     * 参数 h - 4位大小的数据
     * 返回值  Int32 - 合并后的数据
     */
    public static func pack4bits(a: Int32, b: Int32, c: Int32, d: Int32, e: Int32, f: Int32, g: Int32, h: Int32): Int32

    /*
     * 从一个整数数组中解包出一个整数值
     * 参数 i - 数组下标
     * 返回值  Int32 - 解包出的数据
     */
    public func unpack(i: Int32): Int32
}

public class ReaderFactory {
    /*
     * 从文件创建带缓冲区的输入流
     * 参数 file - 文件
     * 参数  Charset - 文件编码
     * 返回值  File - 文件流
     */
    public static func createBufferedReader(file: File, defaultCharset: Charset): File

    /*
     * 从文件创建带缓冲区的输入流
     * 参数 file - 文件
     * 返回值  File - 文件流
     */
    public static func createBufferedReader(file: File): File

    /*
     * 从文件创建带缓冲区的输入流
     * 参数 file - 文件
     * 参数 defaultCharset - 文件编码
     * 返回值  File - 文件流
     */
    public static func  createReaderFromFile(file: File, defaultCharset: Charset): File

    /*
     * 从文件创建带缓冲区的输入流
     * 参数 file - 文件
     * 返回值  File - 文件流
     */
    public static func createReaderFromFile(file: File): File
}

public abstract class SMModel {
   /*
     * 构造函数
     * 参数 classTable - PkgInt 值
     * 参数 classFactor - Int32 值
     * 参数 stateTable - PkgInt 值
     * 参数 charLenTable - Array<Int32> 值
     * 参数 name - String 值
     * 返回值  BufferedInputStream - 带缓冲区的输入流
     */
    public init (classTable: PkgInt, classFactor: Int32, stateTable: PkgInt, charLenTable: Array<Int32>, name: String)

    /*
     * 获取保存的 classTable 值
     * 参数 file - Byte 值
     * 返回值  Int32 - Int32 值
     */
    public func getClass(b: Byte): Int32

    /*
     * 获取保存的 classTable 值
     * 参数 cls - Int32 值
     * 参数 currentState - Int32 值
     * 返回值  Int32 - Int32 值
     */
    public func getNextState(cls: Int32, currentState: Int32): Int32

    /*
     * 获取保存的 charLenTable 值
     * 参数 cls - Int32 值
     * 返回值  Int32 - Int32 值
     */
    public func getCharLen(cls: Int32): Int32

    /*
     * 获取保存的 Name 值
     * 返回值  String - 字符串
     */
    public func getName(): String
}

public class UnicodeBOMInputStream <: InputStream {
    /*
     * 构造函数
     * 参数  inputStream - 输入流
     * 异常 ChardetException 当inputStream数组为空时，抛出异常
     */
    public init(inputStream: InputStream)

    /*
     * 构造函数
     * 参数  inputStream - 输入流
     * 参数  skipIfFound - 跳过已找到的字符
     * 异常 ChardetException 当inputStream数组为空时，抛出异常
     */
    public init(inputStream: InputStream, skipIfFound: Bool)

    /*
     * 获取当前字节顺序标记
     * 返回值  BOM - 返回当前字节顺序标记
     */
    public func getBOM(): BOM

    /*
     * 把数据读取到字节数组中
     * 参数  buffer - 保存到的字节数组
     * 返回值  Int64 - 返回读取字节数
     */
    public func read(buffer: Array<Byte>): Int64
}

public class BOM {
    /*
     * 获取当前的字节数组
     * 返回值  Array<Byte> - 返回当前字节数组
     */
    public func getBytes(): Array<Byte>

    /*
     * 返回字节顺序标记名
     * 返回值  String - 字节顺序标记名
     */
    public func toString(): String    
}

public class UniversalDetector {
    /*
     * 默认构造函数
     */
    public init()

    /*
     * 构造函数
     * 参数 listener - 传入一个 CharsetListener
     */
    public init (listener: ?CharsetListener)

    /*
     * 是否完成检测
     * 返回值 Bool - 是否完成检测
     */
    public func isDone(): Bool

    /*
     * 获取检测到的编码
     * 返回值 String - 检测到的编码名
     */
    public func getDetectedCharset(): String

    /*
     * 设置一个 CharsetListener
     * 参数 listener - 设置的 CharsetListener
     */
    public func setListener(listener: CharsetListener): Unit

    /*
     * 获取设置的 CharsetListener
     * 返回值 CharsetListener - 获取到设置的 CharsetListener
     */
    public func getListener(): CharsetListener

    /*
     * 检测所有数据
     * 参数 buf - 要检测的原数据
     * 异常 ChardetException 当b数组长度为空时，抛出异常
     */
    public func handleData(b: Array<Byte>): Unit

    /*
     * 检测数据
     * 参数 buf - 要检测的原数据
     * 参数 off - 起始位置
     * 参数 len - 长度
     * 异常 ChardetException 当b数组长度为空时，抛出异常
     */
    public func handleData(buf: Array<Byte>, off: Int32, len: Int32): Unit

     /*
     * 根据字节顺序标记检测编码
     * 参数 buf - 要检测的原数据
     */
    public static func detectCharsetFromBOM(buf: Array<Byte>): String

    /*
     * 数据检测到末尾
     */
    public func dataEnd(): Unit

    /*
     * 重置检测器
     */
    public func reset(): Unit

   /*
     * 根据文件路径检测编码
     * 参数 path - 文件路径
     * 返回值 String - 编码名
     * 异常 ChardetException 当path路径的文件流长度为零时，抛出异常
     */
    public static func detectCharset(path: Path): String

    /*
     * 根据文件检测编码
     * 参数 file - 要检测的文件
     * 返回值 String - 编码名
     * 异常 ChardetException 当file的文件流长度为零时，抛出异常
     */
    public static func detectCharset(file: File): String

    /*
     * 根据输入流数据检测编码
     * 参数 inputStream - 输入流
     * 返回值 String - 编码名
     * 异常 ChardetException 当inputStream输入流长度为零时，抛出异常
     */
    public static func detectCharset(inputStream: InputStream): String
}

public enum InputState <: Equatable<InputState> & ToString{
    | PURE_ASCII  // 纯 ascll 编码
    | ESC_ASCII  // 带 ESC 转义字符的 ascll 编码
    | HIGHBYTE  // 带有高位字节的编码

    /*
     * 转成字符串
     * 返回值 String - 转换后的 String
     */
    public func toString(): String

    /*
     * 等号操作符
     * 返回值 如果相等，则返回true；否则，返回false
     */
    public operator func == (that: InputState): Bool

    /*
     * 不等号操作符
     * 返回值 如果不相等，则返回true；否则，返回false
     */
    public operator func != (that: InputState): Bool
}

public class CharsetListener {
    /*
     * 报告编码，空处理函数
     * 参数 charset - 编码名
     */
	public func report(charset: String): Unit
}

public class UTF8SMModel <: SMModel {
    /*
     * 默认构造函数
     */
    public init()
}

public class UTF8Prober <: CharsetProber {
    /*
     * 默认构造函数
     */
    public init()

    /*
     * 重置检测器
     */
    public func reset(): Unit

    /*
     * 获取检测到的编码
     * 返回值 String - 检测到的编码名
     */
    public func getCharSetName(): String

    /*
     * 检测数据
     * 参数 buf - 要检测的原数据
     * 参数 offset - 起始位置
     * 参数 length - 长度
     * 返回值  ProbingState - ProbingState对象
     * 异常 ChardetException 当buf数组为空时，当offset和length之和小于等于零时，抛出异常
     */
    public func handleData(buf: Array<Byte>, offset: Int32, length: Int32): ProbingState

    /*
     * 当前检测状态
     * 返回值 ProbingState - ProbingState对象
     */
    public func getState(): ProbingState

    /*
     * 获取检测出的编码的置信度，该函数会根据检测出的各种编码的概率分布以及内部的算法模型，计算出检测出的编码是正确的概率，并将结果以浮点数的形式返回。通常情况下，置信度的值越高，表示检测出的编码的准确性越高。
     * 返回值 Float32 - 置信度
     */
    public func getConfidence(): Float32
}
public class ChardetException <: Exception {
    /**
     * 异常初始化
     */
    public init()

    /**
     * 异常初始化
     *
     * 参数 messages - 异常信息
     */
    public init(messages: String)

    /**
     * 获取异常信息
     *
     * 返回值 String - 异常信息
     */
    public func getMessage(): String

    /**
     * 异常信息转换为 String 类型
     *
     * 返回值 String
     */
    public override func toString(): String
}
```

##### 1.1.2 示例

```
import std.fs.*
import chardet4cj.*

main() {
    var testFile1: Path = Path("./utf8.txt")
    var originalEncoding1: String = UniversalDetector.detectCharset(testFile1)
    println(originalEncoding1)

    var testFile: Path = Path("./utf8n.txt")
    var originalEncoding: String = UniversalDetector.detectCharset(testFile)
    println(originalEncoding)
    
    if (originalEncoding1 != "UTF-8") {
        return 1
    }
    if (originalEncoding != "UTF-8") {
        return 2
    }
    return 0
}
```

#### 1.2 提供 UTF-16BE 编码字符识别功能

提供 UTF-16BE 编码字符识别功能

##### 1.2.1 主要接口

主要接口同 UTF-8

##### 1.2.2 示例

```
import std.fs.*
import chardet4cj.*

main() {
    var testFiles2: File = File("./utf16be.txt",OpenMode.Read)
    var originalEncodings2: String = UniversalDetector.detectCharset(testFiles2)
    println(originalEncodings2)
    if (originalEncodings2 != "UTF-16BE") {
        return 1
    }
    return 0
}
```

#### 1.3 提供 UTF-16LE 编码字符识别功能

提供 UTF-16BLE 编码字符识别功能

##### 1.3.1 主要接口

主要接口同 UTF-8

##### 1.3.2 示例

```
import std.fs.*
import chardet4cj.*

main() {
    var testFiles2: File = File("./utf16le.txt",OpenMode.Read)
    var originalEncodings2: String = UniversalDetector.detectCharset(testFiles2)
    println(originalEncodings2)
    if (originalEncodings2 != "UTF-16LE") {
        return 1
    }
    return 0
}
```

#### 1.4 提供 Chinese(ISO-2022-CN) 编码字符识别功能

提供 Chinese(ISO-2022-CN) 编码字符识别功能

##### 1.4.1 主要接口

主要接口同 UTF-8

##### 1.4.2 示例

```
import std.fs.*
import chardet4cj.*

main() {
    var testFiles: File = File("./utf8.txt",OpenMode.Read)
    var originalEncodings: String = UniversalDetector.detectCharset(testFiles)
    println("ISO-2022-CN")
    if (originalEncodings != "UTF-8") {
        return 1
    }
    return 0
}
```