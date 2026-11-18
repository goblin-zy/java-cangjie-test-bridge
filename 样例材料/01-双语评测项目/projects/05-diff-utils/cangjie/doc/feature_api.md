# diffutil4cj 库

### 介绍

该库可以逐行比对两个字符串的差异，并按行将差异按格式展示出来，提供补丁打包和添加功能，

文档和数据的对比需要先转换为字符串数组再使用该库进行逐行比对。

### 1 提供比对两组字符串之间差异的功能

前置条件：NA 

场景：
1. 该库可以逐行比对两个字符串的差异，并按行将差异展示出来，提供补丁打包和添加功能。文档和数据的对比需要先转换为字符串数组再使用该库进行逐行比对。

约束：NA

可靠性：NA

#### 1.1 对比两组字符串之间的差异

提供差异对比，可以自定义对比内容

##### 1.1.1 主要接口

```cangjie
public class DiffUtils {
    /*
     * 对比两个ArrayList的差异
     * 参数 original - 要处理的原数据
     * 参数 revised - 要对比的修订数据
     * 返回值 Patch<T> - 返回差异对象
     */
    public static func diff<T>( original: ArrayList<T>, revised: ArrayList<T>): Patch<T> where T <: Equal<T> & ToString

    /*
     * 对比两个ArrayList的差异
     * 参数 original - 要处理的原数据
     * 参数 revised - 要对比的修订数据
     * 参数 algorithm - 差异算法
     * 返回值 Patch<T> - 返回差异对象
     */
    public static func diff<T>(original: ArrayList<T>, revised: ArrayList<T>,algorithm: DiffAlgorithm<T>): Patch<T> where T <: Equal<T> & ToString
    
    /*
     * 对比两个ArrayList的差异
     * 参数 original - 要处理的原数据
     * 参数 revised - 要对比的修订数据
     * 参数 equalizer - 排序算法
     * 返回值 Patch<T> - 返回差异对象
     */
    public static func diff<T>(original: ArrayList<T>, revised: ArrayList<T>,equalizer: Equalizer<T>): Patch<T> where T <: Equal<T> & ToString
}

public class Patch<T> where T <: Equal<T> & ToString {
	/*
     * 添加一个差异
     * 参数 delta - 要添加的差异
     */
	public func addDelta(delta: Delta<T>): Unit
	
	/*
     * 获取差异列表
     * 返回值 ArrayList<Delta<T>> - 返回当前保存的差异列表
     */
	public func getDeltas(): ArrayList<Delta<T>>
}

public abstract class Delta<T> where T <: Equal<T> & ToString{
	/*
     * 默认构造
     * 参数 original - 原始文本受影响的部分
     * 参数 revised - 修订文本中受影响的部分
     */
	public init(original: Chunk<T>, revised: Chunk<T>)
	
	/*
     * 获取差异类型
     * 返回值 DeltaType - 差异类型
     */
	public func getType(): DeltaType
	
	/*
     * 获取该差异原始文本受影响的部分
     * 返回值 Chunk<T> - 返回差异信息对象
     */
	public func getOriginal(): Chunk<T>
	
	/*
     * 设置该差异原始文本受影响的部分
     * 参数 original - 原始文本受影响的部分
     */
	public func setOriginal(original: Chunk<T>): Unit
	
	/*
     * 获取该差异修订文本受影响的部分
     * 返回值 Chunk<T> - 返回差异信息对象
     */
	public func getRevised(): Chunk<T>
	
	/*
     * 设置差异修订文本受影响的部分
     * 参数 original - 修订文本受影响的部分
     */
	public func setRevised(revised: Chunk<T>)
}

public enum DeltaType {
    /** 差异类型为更新 */
    | CHANGE
    /** 差异类型为删除 */
    | DELETE
    /** 差异类型为插入 */
    | INSERT
}

public class ChangeDelta<T> <:  Delta<T> where T <: Equal<T> & ToString{
	/*
     * 默认构造
     * 参数 original - 原始文本受影响的部分
     * 参数 revised - 修订文本中受影响的部分
     */
	public init(original: Chunk<T>, revised: Chunk<T>)
	
	/*
     * 获取差异类型
     * 返回值 DeltaType - 差异类型
     */
	public func getType(): DeltaType
}

public class DeleteDelta<T> <:  Delta<T> where T <: Equal<T> & ToString {
	/*
     * 默认构造
     * 参数 original - 原始文本受影响的部分
     * 参数 revised - 修订文本中受影响的部分
     */
	public init(original: Chunk<T>, revised: Chunk<T>)
	
	/*
     * 获取差异类型
     * 返回值 DeltaType - 差异类型
     */
	public func getType(): DeltaType
}

public class InsertDelta<T> <: Delta<T> where T <: Equal<T> & ToString {
	/*
     * 默认构造
     * 参数 original - 原始文本受影响的部分
     * 参数 revised - 修订文本中受影响的部分
     */
	public init(original: Chunk<T>, revised: Chunk<T>)
	
	/*
     * 获取差异类型
     * 返回值 DeltaType - 差异类型
     */
	public func getType(): DeltaType
}

public class Chunk<T> where T <: Equal<T> & ToString {
     /*
     * 构造函数
     * 参数 position - 差异位置
     * 参数 lines - 差异值
     */
    public init(position: Int64, lines: ArrayList<T>)

     /*
     * 构造函数
     * 参数 position - 差异位置
     * 参数 lines - 差异值
     */
    public init(position: Int64, lines: Array<T>)

	/*
     * 获取该差异位置
     * 返回值 Int64 - 差异位置
     */
    public func getPosition(): Int64 

	/*
     * 设置差异值
     * 参数 lines - 差异值
     */
    public func setLines(lines: ArrayList<T>): Unit

	/*
     * 获取差异值
     * 返回值 ArrayList<T> - 差异值
     */
    public func getLines(): ArrayList<T>

	/*
     * 获取差异值的大小
     * 返回值 Int64 - 差异值的大小
     */
    public func size(): Int64

    /*
     * 返回最后一个值的下标位置，即position值 + 差异值大小 - 1
     * 返回值 Int64 - 最后一个值的下标位置
     */
    public func last(): Int64

    	/*
     * 判断两个差异是否相同
     * 参数 obj - 一个 Chunk<T> 差异
     * 返回值 Bool - 是否相同
     */
    public func equals(obj: Chunk<T>): Bool

    	/*
     * 将差异转换成字符串
     * 参返回值 String - 转换成字符串
     */
    public func toString(): String

    /*
     * 验证差异相对目标列表是否合法，即差异位置不大于目标列表长度，且不小于0, 不合法则抛 PatchFailedException 异常
     * 参数 target - 目标列表
     */
    public func verify(target: ArrayList<T>): Unit
}


public interface DiffAlgorithm<T> where T <: Equal<T> & ToString{
    /*
     * 对比两个Array的差异
     * 参数 original - 要处理的原数据
     * 参数 revised - 要对比的修订数据
     * 返回值 Patch<T> - 返回差异对象
     */
    func diff(original: Array<T>, revised: Array<T>): Patch<T>
    
    /*
     * 对比两个ArrayList的差异
     * 参数 original - 要处理的原数据
     * 参数 revised - 要对比的修订数据
     * 返回值 Patch<T>- 返回差异对象
     */
    func diff(original : ArrayList<T>, revised: ArrayList<T>): Patch<T>
}

public class MyersDiff<T> <: DiffAlgorithm<T> where T <: Equal<T> & ToString {
	/*
     * 默认构造
     */
    public init()
    
    /*
     * 指定对比函数的构造方法
     * 参数 equalizer - 值对比函数
     */
    public init(equalizer: Equalizer<T>)
    
    /*
     * 对比两个Array的差异，对比失败则抛 DiffException 异常
     * 参数 original - 要处理的原数据
     * 参数 revised - 要对比的修订数据
     * 返回值 Patch<T>- 返回差异对象
     */
    public func diff(original: Array<T>, revised: Array<T>): Patch<T>
    
    /*
     * 对比两个ArrayList的差异, 对比失败则抛 DiffException 异常
     * 参数 original - 要处理的原数据
     * 参数 revised - 要对比的修订数据
     * 返回值 Patch<T> 返回差异对象
     */
    public func diff(original: ArrayList<T>, revised: ArrayList<T>): Patch<T>
    
    /*
     * 构建一个表示原始文本和修订文本之间的最短编辑路径的PathNode对象，构建失败则抛 DifferentiationFailedException 异常
     * 参数 original - 原始文本
     * 参数 revised - 修订文本
     * 返回值 PathNode - PathNode对象
     */
    public func buildPath(orig:  ArrayList<T>, rev:  ArrayList<T>): PathNode
    
    /*
     * 根据一个差异路径构建一个Patch对象, 构建失败则抛 DifferentiationFailedException 异常
     * 参数 path - PathNode对象
     * 参数 orig - 原始文本的元素列表
     * 参数 rev - 修订文本的元素列表
     * 返回值 Patch<T> - 返回差异对象
     */
    public func buildRevision(path: PathNode, orig: ArrayList<T>, rev: ArrayList<T>): Patch<T>
}

public abstract class PathNode {
	/*
     * 构造函数
     * 参数 i - 新节点在原始文本中的位置
     * 参数 j - 新节点在修订文本中的位置
     * 参数 prev - 差异路径中的前一个节点
     */
    public init(i: Int64, j: Int64, prev: Option<PathNode>)
    
    /*
     * 判断该节点是否是 Snake 节点
     * 返回值 Bool - 返回 true 是 Snake，false 不是 Snake
     */
    public func isSnake(): Bool
    
    /*
     * 判断该节点是否是 Bootstrap
     * 返回值 Bool - 返回 true 是 Bootstrap，false 不是 Bootstrap
     */
    public func isBootstrap(): Bool
    
    /*
     * 遍历查询最近的 Snake 节点，找到了，返回该节点，找不到返回 None
     * 返回值 Option<PathNode> - 返回一个节点
     */
    public func previousSnake(): Option<PathNode>
    
    /*
     * 转换成字符串
     * 返回值 String - 返回字符串
     */
    public func toString(): String
}

public class DiffNode <: PathNode {
	/*
     * 构造函数
     * 参数 i - 新节点在原始文本中的位置
     * 参数 j - 新节点在修订文本中的位置
     * 参数 prev - 差异路径中的前一个节点
     */
    public init(i: Int64, j: Int64, prev: Option<PathNode>)
    
    /*
     * 判断该节点是否是 Snake 节点
     * 返回值 Bool - 返回 true 是 Snake，false 不是 Snake
     */
    public func isSnake(): Bool
}

public  class Snake <: PathNode {
	/*
     * 构造函数
     * 参数 i - 新节点在原始文本中的位置
     * 参数 j - 新节点在修订文本中的位置
     * 参数 prev - 差异路径中的前一个节点
     */
    public init(i: Int64, j: Int64, prev: Option<PathNode>)
    
    /*
     * 判断该节点是否是 Snake 节点
     * 返回值 Bool - 返回 true 是 Snake，false 不是 Snake
     */
    public func isSnake(): Bool
}

public class DeltaComparator<T> where T <: Equal<T> & ToString {
	/*
     * 构造函数
     */
    public init()
    
    /*
     * 比较两个 Delta<T> 存储的差异位置的大小
     * 返回值 Ordering - 排序大小
     */
	public func deltaComparator(a:Delta<T>,b:Delta<T>): Ordering
}

public open class DiffException <: Exception {
     /*
     * 构造函数
     * 参数 msg - 异常信息
     */
     public init(msg: String)

    /*
     * 返回异常信息。
     * 返回值 String - 返回异常信息字符串
     */
     public func toString(): String
}

public class DifferentiationFailedException <: DiffException {
    /*
     * 构造函数
     * 参数 msg - 异常信息
     */
     public init(msg: String)

    /*
     * 返回异常信息。
     * 返回值 String - 返回异常信息字符串
     */
     public func toString(): String
}

public class PatchFailedException <: DiffException {
     /*
     * 默认构造函数
     */
     public init()

     /*
     * 构造函数
     * 参数 msg - 异常信息
     */
     public init(msg: String)

    /*
     * 返回异常信息。
     * 返回值 String - 返回异常信息字符串
     */
     public func toString(): String
}
```

##### 1.1.2 示例

```cangjie
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main() {
    let ccc = Test_FeatureApi02()
    let tester = ccc.asTestSuite()
    let res = tester.runTests()
    res.failedCount
}
@Test
public class Test_FeatureApi01 {
    @TestCase
    public func testFeatureApi01(): Unit {
		var patch:  Patch<String>= DiffUtils.diff(ArrayList<String>(["hhh"]), ArrayList<String>(["hhh", "jjj", "kkk"]))
		@Assert(patch.getDeltas().isEmpty(),false)
		@Assert(patch.getDeltas().size,1)

		var  delta = patch.getDeltas().get(0).getOrThrow()
		@Assert(delta is InsertDelta<String>, true)
        @Assert(delta.getOriginal().getLines().isEmpty(), true)
        @Assert(delta.getRevised().getLines().toArray().toString(), "[jjj, kkk]")
    }
}
```

执行结果如下：

```shell
[ PASSED ] CASE: testFeatureApi01
```

#### 1.2 提供添加和打包补丁的功能

提供对原数据添加给定补丁和打包补丁的功能

##### 1.2.1 主要接口

```cangjie
public class DiffUtils {
    /*
     * 用给定的补丁修补原始文本
     * 参数 original - 原始文本
     * 参数 patch - 差异补丁
     * 返回值 ArrayList<T> - 修订后文本
     */
    public static func patch<T>(original: ArrayList<T>, patch: Patch<T>): ArrayList<T>

    /*
     * 用给定的补丁还原修订文本
     * 参数 revised - 修订后文本
     * 参数 patch - 差异补丁
     * 返回值 ArrayList<T> - 原始文本
     */
    public static func unpatch<T>(revised: ArrayList<T>, patch: Patch<T>): ArrayList<T>
}

public class Patch<T> where T <: Equal<T> & ToString {
    /*
     * 把该 Patch 内的 Delta 差异应用到文本
     * 参数 target - 要应用的文本
     * 返回值 ArrayList<T> - 修订后的文本
     */
     public func applyTo(target: ArrayList<T>): ArrayList<T>

    /*
     * 使用 Patch 内的 Delta 差异还原到文本
     * 参数 target - 要还原的文本
     * 返回值 ArrayList<T> - 还原后的文本
     */
     public func restore(target: ArrayList<T>): ArrayList<T>
}

public abstract class Delta<T> where T <: Equal<T> & ToString{
    /*
     * 把当前 Delta 差异应用到文本
     * 参数 target - 要应用的文本
     */
     public func applyTo(target: ArrayList<T>): Unit

    /*
     * 使用当前 Delta 差异还原到文本
     * 参数 target - 要还原的文本
     */
     public func restore(target: ArrayList<T>): Unit

    /*
     * 验证差异相对目标列表是否合法
     * 参数 target - 目标列表
     */
     public func verify(target: ArrayList<T>): Unit

    /*
     * 判断两个 Delta 是否相同
     * 参数 obj - 一个 Delta<T>
     * 返回值 Bool - 是否相同
     */
     public func equals(obj: Delta<T>): Bool
}

public class ChangeDelta<T> <:  Delta<T> where T <: Equal<T> & ToString{
    /*
     * 把当前 Delta 差异应用到文本，chunk 的 position > target size 时抛 PatchFailedException
     * 参数 target - 要应用的文本
     */
     public func applyTo(target: ArrayList<T>): Unit

    /*
     * 使用当前 Delta 差异还原到文本, chunk 的 position < 0 时抛 DiffException
     * 参数 target - 要还原的文本
     */
     public func restore(target: ArrayList<T>): Unit

    /*
     * 验证差异相对目标列表是否合法，即差异位置不大于目标列表长度，且不小于0, 不合法则抛 PatchFailedException 异常
     * 参数 target - 目标列表
     */
     public func verify(target: ArrayList<T>): Unit

    /*
     * 转换成字符串
     * 返回值 String - 返回字符串
     */
     public func toString(): String
}

public class DeleteDelta<T> <:  Delta<T> where T <: Equal<T> & ToString {
    /*
     * 把当前 Delta 差异应用到文本, chunk 的 position > target size 时抛 PatchFailedException
     * 参数 target - 要应用的文本
     */
     public func applyTo(target: ArrayList<T>): Unit

    /*
     * 使用当前 Delta 差异还原到文本, chunk 的 position < 0 时抛 DiffException
     * 参数 target - 要还原的文本
     */
     public func restore(target: ArrayList<T>): Unit

    /*
     * 验证差异相对目标列表是否合法，即差异位置不大于目标列表长度，且不小于0, 不合法则抛 PatchFailedException 异常
     * 参数 target - 目标列表
     */
     public func verify(target: ArrayList<T>): Unit

    /*
     * 转换成字符串
     * 返回值 String - 返回字符串
     */
     public func toString(): String
}

public class InsertDelta<T> <: Delta<T> where T <: Equal<T> & ToString {
    /*
     * 把当前 Delta 差异应用到文本，chunk 的 position > target size 时抛 PatchFailedException
     * 参数 target - 要应用的文本
     */
     public func applyTo(target: ArrayList<T>): Unit

    /*
     * 使用当前 Delta 差异还原到文本, chunk 的 position < 0 时抛 DiffException
     * 参数 target - 要还原的文本
     */
     public func restore(target: ArrayList<T>): Unit

    /*
     * 验证差异相对目标列表是否合法，即差异位置不大于目标列表长度，且不小于0, 不合法则抛 PatchFailedException 异常
     * 参数 target - 目标列表
     */
     public func verify(target: ArrayList<T>): Unit

    /*
     * 转换成字符串
     * 返回值 String - 返回字符串
     */
     public func toString(): String
}
```

##### 1.2.2 示例

```cangjie
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main() {
    let ccc = Test_FeatureApi02()
    let tester = ccc.asTestSuite()
    let res = tester.runTests()
    res.failedCount
}
@Test
public class Test_FeatureApi02 {
    @TestCase
    public func testFeatureApi02(): Unit {
		var rev = ArrayList<String>(["hhh", "jjj", "kkk"])
		var orig= ArrayList<String>()
		var patch:  Patch<String>= DiffUtils.diff(rev, orig)
		var res = DiffUtils.patch(rev,patch)
        @Assert(res == orig, true)
    }
}
```

执行结果如下：

```shell
[ PASSED ] CASE: testFeatureApi02
```

#### 1.3 固定格式显示两组字符串的差异

固定格式逐行显示两组字符串之间的差异

##### 1.3.1 主要接口

```cangjie
public class DiffUtils {
    /*
     * 生成 Unified 格式的差异文本
     * 参数 original - 原始文本内容
     * 参数 revised - 修改后的文本内容
     * 参数 originalLines - 原始文本按行分割的列表
     * 参数 patch - 表示差异的 Patch 对象
     * 参数 contextSize - 上下文大小，表示差异文本中添加的上下文行数
     * 返回值 Patch<T> - 返回差异对象
     */
    public static func generateUnifiedDiff(original: String, revised: String, originalLines: ArrayList<String>, patch: Patch<String>,contextSize: Int64): ArrayList<String>

    /*
     * 解析 Unified 格式的差异文本并生成一个 Patch 对象
     * 参数 diff - Unified 格式的差异文本
     * 返回值 Patch<String> - 解析后的差异信息
     */
    public static func parseUnifiedDiff(diff: ArrayList<String>): Patch<String>
}

public class DiffRowGenerator {
    /*
     * 生成差异行列表
     * 参数 original - 原始文本列表
     * 参数 revised - 修改后的文本列表
     * 返回值 ArrayList<DiffRow> - 保存差异信息的 DiffRow 列表
     */
     public func generateDiffRows(original: ArrayList<String>, revised: ArrayList<String>): ArrayList<DiffRow>

    /*
     * 生成差异行列表
     * 参数 original - 原始文本列表
     * 参数 revised - 修改后的文本列表
     * 参数 patch - 差异 Patch 对象
     * 返回值 ArrayList<DiffRow> - 保存差异信息的 DiffRow 列表
     */
     public func generateDiffRows(original: ArrayList<String>, revised: ArrayList<String>, patch: Patch<String>): ArrayList<DiffRow>

    /*
     * 将指定位置范围内的字符串列表中的元素用指定的 HTML 标签和 CSS 类进行包装
     * 参数 sequence - 字符串列表，表示要进行包装操作的序列
     * 参数 startPosition - 起始位置，要进行包装的范围的起始索引
     * 参数 endPosition - 结束位置，要进行包装的范围的结束索引
     * 参数 tag - 要包装的 HTML 标签
     * 参数 ?cssClass - 要应用的 CSS 类
     * 返回值 ArrayList<String> - 包装后的字符串列表
     */
     public static func wrapInTag(sequence: ArrayList<String>, startPosition: Int64, endPosition: Int64,tag: String, cssClass: ?String): ArrayList<String>

    /*
     * 将指定位置范围内的字符串中的元素用指定的 HTML 标签和 CSS 类进行包装
     * 参数 sequence - 字符串，表示要进行包装操作的序列
     * 参数 tag - 要包装的 HTML 标签
     * 参数 ?cssClass - 要应用的 CSS 类
     * 返回值 ArrayList<String> - 包装后的字符串
     */
     public static func wrapInTag(line: String, tag: String, ?cssClass: String): String
}

public class Builder {
    /*
     * 设置是否在生成的差异行中显示内联差异
     * 参数 val - 是否显示内联差异
     * 返回值 Builder - 返回一个 Builder 对象
     */
     public func showInlineDiffs(val: Bool): Builder

    /*
     * 设置是否在生成的差异行中忽略空白字符的差异
     * 参数 val - 是否显示内联差异
     * 返回值 Builder - 返回一个 Builder 对象
     */
     public func ignoreWhiteSpaces(val: Bool): Builder

    /*
     * 设置是否忽略空白行的差异
     * 参数 val - 是否忽略
     * 返回值 Builder - 返回一个 Builder 对象
     */
     public func ignoreBlankLines(val: Bool): Builder

    /*
     * 设置内联显示差异行中旧文本的标签
     * 参数 tag - 标签名
     * 返回值 Builder - 返回一个 Builder 对象
     */
     public func InlineOldTag(tag: String): Builder

    /*
     * 设置内联显示差异行中新文本的标签
     * 参数 tag - 标签名
     * 返回值 Builder - 返回一个 Builder 对象
     */
     public func InlineNewTag(tag: String): Builder

    /*
     * 设置内联显示差异行中旧文本的 CSS 类
     * 参数 cssClass - CSS 类名
     * 返回值 Builder - 返回一个 Builder 对象
     */
     public func InlineOldCssClass(cssClass: String): Builder

    /*
     * 设置内联显示差异行中新文本的 CSS 类
     * 参数 cssClass - CSS 类名
     * 返回值 Builder - 返回一个 Builder 对象
     */
     public func InlineNewCssClass(cssClass: String): Builder

    /*
     * 设置差异行生成器中列的宽度
     * 参数 width - 行宽
     * 返回值 Builder - 返回一个 Builder 对象
     */
     public func columnWidth(width: Int64): Builder

    /*
     * 生成一个 DiffRowGenerator 对象
     * 返回值 DiffRowGenerator - 返回一个 DiffRowGenerator 对象
     */
     public func build(): DiffRowGenerator
}

public class DiffRow <: ToString {
    /*
     * 默认构造
     * 参数 tag - 差异行的标签 Tag
     * 参数 oldLine - 旧文本行
     * 参数 newLine - 新文本行
     */
     public init(tag: Tag, oldLine: String, newLine: String)

    /*
     * 获取差异行标签 Tag
     * 返回值 Tag - 标签 Tag
     */
     public func getTag(): Tag

    /*
     * 设置差异行标签 Tag
     * 参数 tag - 标签 Tag
     */
     public func setTag(tag: Tag): Unit

    /*
     * 获取旧文本
     * 返回值 String - 旧文本
     */
     public func getOldLine():String

    /*
     * 设置旧文本
     * 参数 oldLine - 旧文本
     */
     public func setOldLine(oldLine: String): Unit

    /*
     * 获取新文本
     * 返回值 String - 新文本
     */
     public func getNewLine(): String

    /*
     * 设置新文本
     * 参数 String - 新文本
     */
     public func setNewLine(newLine: String): Unit

    /*
     * 转换成字符串
     * 返回值 String - 返回字符串
     */
     public func toString(): String
}

public enum Tag <: ToString {
     /** 插入标签 */
    | INSERT
    /** 删除标签 */
    | DELETE
    /** 更新标签 */
    | CHANGE
    /** 相同标签 */
    | EQUAL

    /*
     * 转换成字符串
     * 返回值 String - 返回字符串
     */
    public func toString(): String
}

public class StringUtills {
    /*
     * 将一个可迭代对象中的元素用指定的分隔符连接成一个字符串
     * 参数 objs - 一个实现了 Iterable<T> 的可迭代对象
     * 参数 delimiter - 指定的分隔符
     * 返回值 String - 连接后的字符串
     */
     public static func join<T>(objs: Iterable<T>, delimiter: String): String where T <: ToString

    /*
     * 将字符串中的制表符转换为相应数量的空格字符
     * 参数 str - 要转换的字符串
     * 返回值 String - 转换后的字符串
     */
     public static func expandTabs(str: String): String

    /*
     * 将字符串中的特殊字符转换为对应的HTML实体编码
     * 参数 str - 要转换的字符串
     * 返回值 String - 转换后的字符串
     */
     public static func htmlEntites(str: String): String

    /*
     * 将字符串中的特殊字符转换为对应的 HTML 实体编码，并将制表符转换为相应数量的空格字符
     * 参数 str - 要转换的字符串
     * 返回值 String - 转换后的字符串
     */
     public static func normalize(str: String): String

    /*
     * 对列表中的每个字符串进行规范化处理，将每个字符串中的特殊字符转换为对应的 HTML 实体编码，并将制表符转换为相应数量的空格字符
     * 参数 list - 要转换的列表
     * 返回值 ArrayList<String> - 转换后的列表
     */
     public static func normalize(list: ArrayList<String>): ArrayList<String>

    /*
     * 将字符串列表中的每个字符串按指定的列宽进行换行处理
     * 参数 list - 要转换的列表
     * 参数 columnWidth - 列宽
     * 返回值 ArrayList<String> - 转换后的列表
     */
     public static func wrapText( list: ArrayList<String>, columnWidth: Int64): ArrayList<String>

    /*
     * 将字符串按指定的列宽进行换行处理
     * 参数 line - 要转换字符串
     * 参数 columnWidth - 列宽
     * 返回值 String - 转换后的字符串
     */
     public static func wrapText(line: String, columnWidth: Int64): String
}
```

##### 1.3.2 示例

```cangjie
import std.math.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main() {
    let ccc = Test_FeatureApi03()
    let tester = ccc.asTestSuite()
    let res = tester.runTests()
    res.failedCount
}
@Test
public class Test_FeatureApi03 {
    @TestCase
    public func testFeatureApi03(): Unit {
		var first = "anything \n \nother\nmore lines"
		var second ="anything\n\nother\nsome more lines"
		var generator = Builder().ignoreWhiteSpaces(true).columnWidth(Int64.Max).build()
		var rows = generator.generateDiffRows(ArrayList<String>(first.split("\n")), ArrayList<String>(second.split("\n")))
			
		@Assert(rows.size,4)
		@Assert(rows.get(0).getOrThrow().getTag().toString(),"EQUAL")
		@Assert(rows.get(1).getOrThrow().getTag().toString(),"EQUAL")
        @Assert(rows.get(2).getOrThrow().getTag().toString(),"EQUAL")
        @Assert(rows.get(3).getOrThrow().getTag().toString(),"CHANGE")
    }
}
```

执行结果如下：

```shell
[ PASSED ] CASE: testFeatureApi03
```