## ahoCorasick4cj 库

### 介绍
该库使用 Aho-Corasick 字符串搜索算法，能够提供高效的字符串匹配功能

### 1 支持多字符搜索功能

前置条件：NA
场景：
根据给定的一个或多个关键字，在指定字符串中查找，返回匹配到目标的位置。
约束：NA 
性能： 支持版本几何性能持平
可靠性： NA

#### 1.1 主要接口

多字符搜索树类
class Trie

```cangjie

    /**
    * 构造方法，构造出一个 TrieBuilder 类对象
    * 
    * @return 返回一个 TrieBuilder 类对象
    */
    public static func builder(): TrieBuilder

    /**
    * 解析给定的文本，并返回匹配的负载
    *
    * @param text - 传入的文本信息
    *
    * @return 返回一个 ArrayList 集合
    */
    public func parseText(text: String): ArrayList<Emit>

```

多字符搜索树构建类
class TrieBuilder

```cangjie

    /**
    * 在文本搜索关键字列表中添加一个关键字
    *
    * @param keyword - 要添加到列表中的关键字
    *
    * @return 返回这个构建器
    */
    public func addKeyword(keyword: String): TrieBuilder

    /**
    * 构造方法，构造出一个 Trie 类对象
    *
    * @return 返回一个 Trie 类对象
    */
    public func build(): Trie

```

#### 1.2 其它接口

处理发出的负载
class DefaultPayloadEmitHandler

```cangjie

    /**
    * 发现一个匹配时调用的回调函数
    *
    * @param emit - 它接收一个 PayloadEmit，表示匹配的位置和负载
    *
    * @return 返回 Bool 类型
    */
    public func emit(emit: PayloadEmit<T>): Bool

    /**
    * 返回所有发出的负载的集合
    *
    * @return 返回所有发出的负载的集合
    */
    public func getEmits(): ArrayList<PayloadEmit<T>>

```

负载类
class Emit

```cangjie

    /**
    * Emit 的有参构造
    *
    * @param start - 起始位置
    * @param end - 结束位置
    * @param keyword - 关键字
    *
    * @exception 若 end 的值小于 start 的值，则说明构造的 emit 是错误的，长度不可能是负数，抛出非法参数异常 IllegalArgumentException
    */
    public init(start: Int32, end: Int32, keyword: String)

    /**
    * 获取关键字信息
    *
    * @return 返回关键字信息
    */
    public func getKeyword(): String

    /**
    * 判断两个对象是否相等
    *
    * @param rhs - 另一个 Intervalable 对象
    *
    * @return 返回 Bool 类型
    */
    public operator func ==(rhs: Intervalable): Bool

    /**
    * 判断两个对象是否不相等
    *
    * @param rhs - 另一个 Intervalable 对象
    *
    * @return 返回 Bool 类型
    */
    public operator func !=(rhs: Intervalable): Bool

    /**
    * 计算 hash 值
    *
    * @return 返回 Int64 类型
    */
    public func hashCode(): Int64

    /**
    * 重写 toString 方法
    *
    * @return 返回字符串信息
    */
    public func toString(): String
```

时间间隔类
class Interval

```cangjie

    /**
    * Interval 的有参构造
    *
    * @param start - 起始位置
    * @param end - 结束位置
    *
    * @exception 若 end 的值小于 start 的值，则说明构造的 Interval 是错误的，长度不可能是负数，抛出非法参数异常 IllegalArgumentException
    */
    public init(start: Int32, end: Int32)

    /**
    * 获取起始位置
    *
    * @return 返回 Int32 类型
    */
    public func getStart(): Int32

    /**
    * 获取结束位置
    *
    * @return 返回 Int32 类型
    */
    public func getEnd(): Int32

    /**
    * 返回时间间隔长度
    *
    * @return 返回 Int32 类型
    */
    public func size(): Int32

    /**
    * 重写 toString 方法
    *
    * @return 返回字符串信息
    */
    public open func toString(): String

    /**
    * 判断两个对象是否相等
    *
    * @param rhs - 另一个 Intervalable 对象
    *
    * @return 返回 Bool 类型
    */
    public operator func ==(rhs: Intervalable): Bool

    /**
    * 判断两个对象是否不相等
    *
    * @param rhs - 另一个 Intervalable 对象
    *
    * @return 返回 Bool 类型
    */
    public operator func !=(rhs: Intervalable): Bool

    /**
    * 计算 hash 值
    *
    * @return 返回 Int64 类型
    */
    public open func hashCode(): Int64

```

自定义载体类
class Payload

```cangjie

    /**
    * Payload 的有参构造
    *
    * @param keyword - 关键字信息
    * @param data - 对应的 data 数据
    */
    public init(keyword: String, data: ?T)

    /**
    * 获取关键字信息
    *
    * @return 返回 String 类型
    */
    public func getKeyword(): String

    /**
    * 获取对应的 data 数据
    *
    * @return 返回 Option 类型
    */
    public func getData(): ?T

    /**
    * 判断两个对象是否相等
    *
    * @param rhs - 另一个 Payload 对象
    *
    * @return 返回 Bool 类型
    */
    public operator func ==(rhs: Payload<T>): Bool

    /**
    * 判断两个对象是否不相等
    *
    * @param rhs - 另一个 Payload 对象
    *
    * @return 返回 Bool 类型
    */
    public operator func !=(rhs: Payload<T>): Bool

    /**
    * 计算 hash 值
    *
    * @return 返回 Int64 类型
    */
    public open func hashCode(): Int64

    /**
    * 自定义比较器方法
    *
    * @param other - 另一个 Payload 对象
    *
    * @return 返回 Ordering 类型
    */
    public func compare(other: Payload<T>): Ordering

```

自定义载体负载类
class PayloadEmit

```cangjie

    /**
    * PayloadEmit 的有参构造
    *
    * @param start - 起始位置
    * @param end - 结束位置
    * @param keyword - 关键字信息
    * @param payload - 对应的载体数据
    *
    * @exception 若 end 的值小于 start 的值，则说明构造的 PayloadEmit 是错误的，长度不可能是负数，抛出非法参数异常 IllegalArgumentException
    */
    public init(start: Int32, end: Int32, keyword: String, payload: ?T)

    /**
    * 获取关键字信息
    *
    * @return 返回 String 类型
    */
    public func getKeyword(): String

    /**
    * 获取对应的载体数据
    *
    * @return 返回 Option 类型
    */
    public func getPayload(): ?T

    /**
    * 重写 toString 方法
    *
    * @return 返回 String 类型
    */
    public func toString(): String

    /**
    * 判断两个对象是否相等
    *
    * @param rhs - 另一个 Payload 对象
    *
    * @return 返回 Bool 类型
    */
    public operator func ==(rhs: Intervalable): Bool

    /**
    * 判断两个对象是否不相等
    *
    * @param rhs - 另一个 Payload 对象
    *
    * @return 返回 Bool 类型
    */
    public operator func !=(rhs: Intervalable): Bool

    /**
    * 计算 hash 值
    *
    * @return 返回 Int64 类型
    */
    public func hashCode(): Int64

```

载体状态类
class PayloadState

```cangjie

    /**
    * PayloadState 的有参构造
    *
    * @param depth - 关键字的有效大小
    */
    public init(depth: Int32)

    /**
    * 向该状态节点添加一个发出的负载，即当到达该状态节点时，需要输出的负载
    *
    * @param payload - 自定义载荷
    */
    public func addEmit(payload: Payload<T>): Unit

    /**
    * 向该状态节点添加一个子状态节点，即在状态转移图中与该状态节点相连的下一个状态节点

    * @param character - 传入的字符
    *
    * @return 返回 PayloadState 有效载荷状态节点
    */
    public func addState(character: Rune): PayloadState<T>

    /**
    * 获取该状态节点在给定字符下的子状态节点，如果没有匹配的子状态节点，则返回空指针
    *
    * @param character - 传入的字符
    *
    * @return 返回 Option 类型
    */
    public func nextStateIgnoreRootState(character: Rune): ?PayloadState<T>

    /**
    * 获取该状态节点在给定字符下的子状态节点，如果没有匹配的子状态节点，则返回失败状态节点或根状态节点
    *
    * @param character - 传入的字符
    *
    * @return 返回 Option 类型
    */
    public func nextState(character: Rune): ?PayloadState<T>

    /**
    * 获取该状态节点的所有子状态节点的集合
    *
    * @return 返回所有子状态节点的集合
    */
    public func getStates(): Collection<PayloadState<T>>

    /**
    * 设置该状态节点的失败状态节点，即在状态转移图中当没有匹配的子状态节点时，需要跳转到的状态节点
    *
    * @param failState - 传入 PayloadState 对象
    *
    */
    public func setFailure(failState: PayloadState<T>): Unit

    /**
    * 获取该状态节点的所有转移字符的集合
    *
    * @return 返回所有转移字符的集合
    */
    public func getTransitions(): Collection<Rune>

    /**
    * 获取该状态节点的失败状态节点，即在状态转移图中当没有匹配的子状态节点时，需要跳转到的状态节点
    *
    * @return 返回 Option 类型，表示该状态节点的失败状态节点
    */
    public func failures(): ?PayloadState<T>

    /**
    * 向该状态节点添加一个发出的负载集合
    *
    * @param emits - 传入一个发出的负载集合
    */
    public func addEmit(emits: ArrayList<Payload<T>>): Unit

    /**
    * 获取该状态节点的所有发出的负载的集合，即当到达该状态节点时，需要输出的负载
    *
    * @return 返回所有发出的负载的集合
    */
    public func emit(): ArrayList<Payload<T>>
    
```

搜索树配置类
class TrieConfig

```cangjie

    /**
    * 判断 Trie 或 PayloadTrie 是否在找到第一个关键词后停止
    *
    * @return 返回 Bool 类型
    */
    public func isStopOnHit(): Bool
    
    /**
    * 设置是否在找到第一个关键词后停止
    *
    * @param stopOnHit - Bool 类型
    */
    public func setStopOnHit(stopOnHit: Bool): Unit

    /**
    * 判断 Trie 或 PayloadTrie 是否允许重叠
    *
    * @return 返回 Bool 类型
    */
    public func isAllowOverlaps(): Bool

    * 设置是否允许重叠
    *
    * @param allowOverlaps - Bool 类型
    */
    public func setAllowOverlaps(allowOverlaps: Bool): Unit

    /**
    * 判断 Trie 或 PayloadTrie 是否只匹配整个单词
    *
    * @return 返回 Bool 类型
    */
    public func isOnlyWholeWords(): Bool

    /**
    * 设置是否只匹配整个单词的
    *
    * @param onlyWholeWords - Bool 类型
    */
    public func setOnlyWholeWords(onlyWholeWords: Bool): Unit

    /**
    * 判断 Trie 或 PayloadTrie 是否只匹配空格分隔的单词
    *
    * @return 返回 Bool 类型
    */
    public func isOnlyWholeWordsWhiteSpaceSeparated(): Bool

    /**
    * 设置是否只匹配空格分隔的单词
    *
    * @param onlyWholeWordsWhiteSpaceSeparated - Bool 类型
    */
    public func setOnlyWholeWordsWhiteSpaceSeparated(onlyWholeWordsWhiteSpaceSeparated: Bool): Unit

    /**
    * 判断 Trie 或 PayloadTrie 是否忽略大小写
    *
    * @return 返回 Bool 类型
    */
    public func isCaseInsensitive(): Bool

    /**
    * 设置是否忽略大小写
    *
    * @param caseInsensitive - Bool 类型
    */
    public func setCaseInsensitive(caseInsensitive: Bool): Unit
```

表示一个区间树的节点类
class IntervalNode

```cangjie

    /**
    * 构造方法，构造出一个 IntervalNode 类对象
    *
    * @param intervals - 传入一个 ArrayList 集合
    *
    * @return 返回一个 IntervalNode 类对象
    */
    public static func newInstance(intervals: ArrayList<Intervalable>): IntervalNode

    /**
    * 根据该节点包含的所有区间的起点和终点，计算出一个合适的中点值，使得左子树和右子树的区间数量尽量平衡
    *
    * @param intervals - 传入一个 ArrayList 集合
    *
    * @return 返回一个 Int32 类型
    */
    public static func determineMedian(intervals: ArrayList<Intervalable>): Int32

    /**
    * 查找该节点包含或重叠的所有区间
    *
    * @param intervals - 传入一个 Intervalable 类对象
    *
    * @return 返回一个 ArrayList 集合
    */
    public func findOverlaps(interval: Intervalable): ArrayList<Intervalable>
```

表示一个区间树类
class IntervalTree

```cangjie

    /**
    * IntervalTree 的有参构造
    *
    * @param intervals - 传入一个 ArrayList 集合
    */
    public init(intervals: ArrayList<Intervalable>)

    /**
    * 移除该节点包含或重叠的所有区间
    *
    * @param intervals - 传入一个 ArrayList 集合
    *
    * @return 返回移除后的 ArrayList 集合
    */
    public func removeOverlaps(intervals: ArrayList<Intervalable>): ArrayList<Intervalable>

    /**
    * 查找该节点包含或重叠的所有区间
    *
    * @param intervals - 传入一个 Intervalable 类对象
    *
    * @return 返回一个 ArrayList 集合
    */
    public func findOverlaps(interval: Intervalable): ArrayList<Intervalable>
```

负载状态实现构建类
class PayloadTrieBuilder

```cangjie

    /**
    * 构造方法，构造出一个 PayloadTrie 类对象
    *
    * @return 返回一个 PayloadTrie 类对象
    */
    public func build(): PayloadTrie<T>

    /**
    * 在文本搜索关键字列表中添加一个关键字
    *
    * @param keyword - 要添加到列表中的关键字
    *
    * @return 返回这个构建器
    */
    public func addKeyword(keyword: String): PayloadTrieBuilder<T>

    /**
    * 在文本搜索关键字列表中添加一个关键字
    *
    * @param keyword - 要添加到列表中的关键字
    * @param keyword - 要添加的有效载荷
    *
    * @return 返回这个构建器
    */
    public func addKeyword(keyword: String, payload: ?T): PayloadTrieBuilder<T>

```

负载状态实现类
class PayloadTrie

```cangjie

    /**
    * 构造方法，构造出一个 PayloadTrieBuilder 类对象
    *
    * @return 返回一个 PayloadTrieBuilder 类对象
    */
    public static func builder(): PayloadTrieBuilder<T>

    /**
    * 解析给定的文本，并返回匹配的负载
    *
    * @param text - 传入的文本信息
    *
    * @return 返回一个 ArrayList 集合
    */
    public func parseText(text: String): ArrayList<PayloadEmit<T>>

    /**
    * 解析给定的文本，并返回匹配的负载
    *
    * @param text - 传入的文本信息
    * @param emitHandler - 用于处理发出的负载的事件处理器
    *
    * @return 返回一个 ArrayList 集合
    */
    public func parseText(text: String, emitHandler: StatefulPayloadEmitHandler<T>): ArrayList<PayloadEmit<T>>

    /**
    * 解析给定的文本，并返回匹配的负载
    *
    * @param text - 传入的文本信息
    * @param emitHandler - 用于处理发出的负载的事件处理器
    */
    public func parseText(text: String, emitHandler: PayloadEmitHandler<T>): Unit
```

#### 1.3 示例

```cangjie
import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest01 = CharSearchTest01()
    charSearchTest01.testCharSearch01()
    charSearchTest01.testCharSearch02()
    charSearchTest01.testCharSearch03()
    return 0
}

@Test
public class CharSearchTest01 {

    @TestCase
    public func testCharSearch01(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("shier").build()
        var emits = trie.parseText("dasm,nzxmvshier.sa,nd")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch02(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("shisi").build()
        var emits = trie.parseText("xz.jagajgspjlkn")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch03(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("你").addKeyword("好").build()
        var emits = trie.parseText("中国你好，加油仓颉")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }
}
```

执行结果如下:

```shell
10:14=shier
2:2=你
3:3=好
```

### 2 支持关键词库模式功能

前置条件：NA
场景：
通过遍历关键词库进行匹配，可以在遇到匹配项时立即处理匹配项。
约束：NA 
性能： 支持版本几何性能持平
可靠性： NA

#### 2.1 主要接口

它是一个字典树类
class Trie

```cangjie

    /**
    * 根据给定的文本将文本分割成令牌，返回一个集合
    *
    * @param text - 指定的文本
    *
    * @return 返回一个 ArrayList 集合
    */
    public func tokenize(text: String): ArrayList<Token>

    /**
    * 根据给定的文本搜索第一个匹配的字符串和负载，返回一个 Emit 对象或 None
    *
    * @param text - 指定的文本
    *
    * @return 返回一个 Emit 对象或 None
    *
    */
    public func firstMatch(text: String): ?Emit

```

#### 2.2 其他接口

它实现了 StatefulEmitHandler 接口，用于处理匹配到的字符串
abstract class AbstractStatefulEmitHandler

```cangjie

    /**
    * 给匹配器添加负载
    *
    * @param emit - 传入的负载类对象
    *
    */
    public func addEmit(emit: Emit): Unit

    /**
    * 获取匹配器的负载集合
    *
    * @return 返回该匹配器的负载集合
    *
    */
    public func getEmits(): ArrayList<Emit>

```

它实现了 StatefulPayloadEmitHandler 接口，用于处理匹配到的字符串和负载
abstract class AbstractStatefulPayloadEmitHandler

```cangjie

    /**
    * 给匹配器添加负载和有效载荷
    *
    * @param emit - 传入的负载与载荷类对象
    *
    */
    public func addEmit(emit: PayloadEmit<T>): Unit

    /**
    * 获取匹配器的负载和有效载荷的集合
    *
    * @return 返回该匹配器的负载和有效载荷的集合
    *
    */
    public func getEmits(): ArrayList<PayloadEmit<T>>

```

它是一个默认的处理匹配到的字符串的类
class DefaultEmitHandler

```cangjie

    /**
    * 处理匹配到的字符串，返回true表示继续搜索。此方法只打印出匹配到的字符串和位置
    *
    * @param emit - 传入的负载对象
    *
    * @return 返回 Bool 类型
    */
    public func emit(emit: Emit): Bool

    /**
    * 获取匹配器的负载集合
    *
    * @return 返回该匹配器的负载集合
    *
    */
    public func getEmits(): ArrayList<Emit>

```

它是一个默认的表示令牌的类
class DefaultToken

```cangjie

    /**
    * DefaultToken 的有参构造器
    *
    * @param payloadToken - 传入一个 PayloadToken 对象
    *
    */
    public init(payloadToken: PayloadToken<String>)

    /**
    * 判断令牌是否是一个完整的匹配，即令牌的结束位置是否是一个关键词的结束位置
    *
    * @return 返回 Bool 类型
    */
    public func isMatch(): Bool

    /**
    * 获取令牌对应的Emit对象
    *
    * @return 返回 Option 类型
    *
    */
    public func getEmit(): ?Emit

```

它是一个表示匹配到的字符串片段的类
class FragmentToken

```cangjie

    /**
    * FragmentToken 的有参构造器
    *
    * @param fragment - 根据给定的字符串片段创建一个令牌
    *
    */
    public init(fragment: String)

    /**
    * 判断令牌是否是一个完整的匹配，对于这个类，总是返回false
    *
    * @return 返回 Bool 类型
    */
    public func isMatch(): Bool

    /**
    * 获取令牌对应的Emit对象，对于这个类，总是返回 None
    *
    * @return 返回 Option 类型
    *
    */
    public func getEmit(): ?Emit

```

一个实现了Intervalable接口的类，它是一个表示匹配到的字符串的起始和结束位置的类
class Interval

```cangjie

    /**
    * 判断区间是否和另一个区间重叠与否
    *
    * @param other - 传入的另一个 Interval 对象
    *
    * @return 返回 Bool 类型
    */
    public func overlapsWith(other: Interval): Bool

    /**
    * 判断区间是否包含一个点
    *
    * @param point - Int32 类型
    *
    * @return 返回 Bool 类型
    */
    public func overlapsWith(point: Int32): Bool

    /**
    * 判断两个区间是否相等
    *
    * @param other - 传入的另一个 Interval 对象
    *
    * @return 返回 Bool 类型
    *
    */
    public func equals(other: Intervalable): Bool

    /**
    * 比较两个区间的大小，先比较起始位置，再比较结束位置
    *
    * @param o - 传入的另一个 Object 对象
    *
    * @return 返回 Int32 类型
    *
    */
    public func compareTo(o: Object): Int32

```

它是一个表示匹配到的字符串和位置的类
class MatchToken

```cangjie

    /**
    * MatchToken 的有参构造器
    *
    * @param fragment - 根据给定的字符串片段创建一个令牌
    * @param emit - 传入的负载对象
    *
    */
    public init(fragment: String, emit: Emit)

    /**
    * 判断令牌是否是一个完整的匹配，对于这个类，总是返回true
    *
    * @return 返回 Bool 类型
    */
    public func isMatch(): Bool

    /**
    * 获取令牌对应的Emit对象
    *
    * @return 返回 Option 类型
    *
    */
    public func getEmit(): ?Emit

```

它是一个用于将匹配到的字符串和负载委托给另一个处理器的类
class PayloadEmitDelegateHandler

```cangjie

    /**
    * PayloadEmitDelegateHandler 的有参构造器
    *
    * @param handler - 根据给定的处理器创建一个委托处理器
    *
    */
    public init(handler: EmitHandler)

    /**
    * 处理匹配到的字符串和负载，返回是否继续搜索。这个方法会调用委托处理器的emit方法
    *
    * @param emit - 传入一个 PayloadEmit 类对象
    *
    * @return 返回 Bool 类型
    */
    public func emit(emit: PayloadEmit<String>): Bool

```

它是一个表示匹配到的字符串片段和负载的类
class PayloadFragmentToken

```cangjie

    /**
    * MatchToken 的有参构造器
    *
    * @param fragment - 根据给定的字符串片段和负载创建一个令牌
    *
    */
    public init(fragment: String)

    /**
    * 判断令牌是否是一个完整的匹配，对于这个类，总是返回false
    *
    * @return 返回 Bool 类型
    */
    public func isMatch(): Bool

    /**
    * 获取令牌对应的Emit对象，对于这个类，总是返回None
    *
    * @return 返回 Option 类型
    *
    */
    public func getEmit(): ?Emit

```

它是一个表示匹配到的字符串和位置的类
class PayloadMatchToken

```cangjie

    /**
    * MatchToken 的有参构造器
    *
    * @param fragment - 根据给定的字符串片段创建一个令牌
    * @param emit - 传入的 PayloadEmit 类对象
    *
    */
    public init(fragment: String, emit: PayloadEmit<T>)

    /**
    * 判断令牌是否是一个完整的匹配，对于这个类，总是返回true
    *
    * @return 返回 Bool 类型
    */
    public func isMatch(): Bool

    /**
    * 获取令牌对应的Emit对象
    *
    * @return 返回 Option 类型
    *
    */
    public func getEmit(): ?Emit

```

它是一个表示有效载荷状态的类
class PayloadState

```cangjie

    /**
    * 获取深度状态
    *
    * @return 返回 Int32 类型
    *
    */
    public func getDepth(): Int32

```

它是一个携带有效载荷的令牌类
abstract class PayloadToken

```cangjie

    /**
    * PayloadToken 的有参构造器
    *
    * @param fragment - 传入给定的字符串片段
    *
    */
    public init(fragment: String)

    /**
    * 获取字符串片段
    *
    * @return 返回 String 类型
    */
    public func getFragment(): String

    /**
    * 是否匹配到关键词
    *
    * @return 返回 Bool 类型
    *
    */
    public func isMatch(): Bool

    /**
    * 获取负载
    *
    * @return 返回 Option 类型
    *
    */
    public func getEmit(): ?PayloadEmit<T>

```

它是一个用于存储和搜索字符串和负载的数据结构
class PayloadTrie

```cangjie

    /**
    * 根据给定的文本判断文本是否包含匹配的字符串
    *
    * @param text - 指定的文本
    *
    * @return 返回一个 Bool 类型
    */
    public func containsMatch(text: String): Bool

```

#### 2.3 示例

```cangjie
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest05 = CharSearchTest05()
    charSearchTest05.testCharSearch01()
    return 0
}

@Test
public class CharSearchTest05 {

    @TestCase
    public func testCharSearch01(): Unit {

        let speech: String = "The Answer to the Great Question... Of Life, " +
            "the Universe and Everything... Is... Forty-two,' said " +
            "Deep Thought, with infinite majesty and calm."

        var trie = Trie.builder().ignoreOverlaps().onlyWholeWords().ignoreCase()
            .addKeyword("great question")
            .addKeyword("forty-two")
            .addKeyword("deep thought")
            .build()
        var tokens = trie.tokenize(speech)
        var html: StringBuilder = StringBuilder()
        html.append("<html><body><p>")

        for (token in tokens) {
            if (token.isMatch()) {
            html.append("<i>")
        }

        html.append(token.getFragment())
        if (token.isMatch()) {
            html.append("</i>")
        }
    }

        html.append("</p></body></html>")
        println(html)
    }
}

```

执行结果如下：

```shell
<html><body><p>The Answer to the <i>Great Question</i>... Of Life, the Universe and Everything... Is... <i>Forty-two</i>,' said <i>Deep Thought</i>, with infinite majesty and calm.</p></body></html>
```

### 3 支持自定义值输出模式功能

前置条件：NA
场景：
指定关键字及其对应的自定义值，在匹配到该关键字时可以同时获取并处理该自定义值
约束：NA 
性能： 支持版本几何性能持平
可靠性： NA

#### 3.1 主要接口

#### 3.2 其它接口

它是一个用于存储和搜索字符串和负载的数据结构的构建类
class PayloadTrieBuilder

```cangjie

    /**
    * 配置Trie在搜索文本中的关键字时忽略大小写，这个方法必须在调用 addKeyword 之前调用
    *
    * @return 返回这个构建器
    */
    public func ignoreCase(): PayloadTrieBuilder<T>

    /**
    * 配置Trie忽略重叠的关键字
    *
    * @return 返回这个构建器
    */
    public func ignoreOverlaps(): PayloadTrieBuilder<T>

    /**
    * 添加关键字和有效载荷的列表
    *
    * @param keywords - 传入关键字集合
    *
    * @return 返回这个构建器
    */
    public func addKeywords(keywords: ArrayList<Payload<T>>): PayloadTrieBuilder<T>

    /**
    * 将Trie配置为匹配文本中的整个关键字
    *
    * @return 返回这个构建器
    */
    public func onlyWholeWords(): PayloadTrieBuilder<T>

    /**
    * 将Trie配置为匹配用空格分隔的整个关键字
    *
    * @return 返回这个构建器
    */
    public func onlyWholeWordsWhiteSpaceSeparated(): PayloadTrieBuilder<T>

    /**
    * 将Trie配置为在文本中找到第一个关键字后停止
    *
    * @return 返回这个构建器
    */
    public func stopOnHit(): PayloadTrieBuilder<T>

    /**
    * 配置Trie不区分大小写
    *
    * @return 返回这个构建器
    */
    public func caseInsensitive(): PayloadTrieBuilder<T>

    /**
    * 配置Trie删除重叠区间
    *
    * @return 返回这个构建器
    */
    public func removeOverlaps(): PayloadTrieBuilder<T>

```

它是一个用于存储和搜索字符串和负载的数据结构的构建类
class State

```cangjie

    /**
    * State 的有参构造器
    *
    * @param depth - 传入一个 Int32 类型
    */
    public init(depth: Int32)

    /**
    * 根据给定的字符获取下一个状态
    *
    * @param character - 传入一个字符
    *
    * @return 返回 Option 类型
    */
    public func nextState(character: Rune): ?State

    /**
    * 根据给定的字符和是否忽略根状态获取下一个状态，返回一个状态对象或 None
    *
    * @param character - 传入一个字符
    *
    * @return 返回 Option 类型
    */
    public func nextStateIgnoreRootState(character: Rune): ?State

    /**
    * 根据给定的关键字添加一个新的状态到当前状态，并返回新的状态
    *
    * @param keyword - 添加关键字
    *
    * @return 返回这个对象
    */
    public func addState(keyword: String): State

    /**
    * 根据给定的字符添加一个新的状态到当前状态，并返回新的状态
    *
    * @param character - 传入的字符
    *
    * @return 返回这个对象
    */
    public func addState(character: Rune): State

    /**
    * 获取状态的深度
    *
    * @return 返回 Int32 类型
    */
    public func getDepth(): Int32

    /**
    * 添加一个匹配到的字符串到状态中
    *
    * @param keyword - 传入关键字
    *
    */
    public func addEmit(keyword: String): Unit

    /**
    * 添加一个匹配到的字符串的集合到状态中
    *
    * @param emits - 传入一个集合
    *
    */
    public func addEmit(emits: ArrayList<String>): Unit

    /**
    * 获取状态中的所有匹配到的字符串
    *
    * @return 返回一个集合
    *
    */
    public func emit(): ArrayList<String>

    /**
    * 获取当前状态的失败状态节点
    *
    * @return 返回 Option 类型
    *
    */
    public func failures(): ?State

    /**
    * 设置当前状态的失败状态
    *
    * @param failState - 传入一个 State 对象
    *
    */
    public func setFailure(failState: State): Unit

    /**
    * 获取当前状态的所有子状态
    *
    * @return 返回一个集合
    *
    */
    public func getStates(): Collection<State>

    /**
    * 获取当前状态的所有转移字符
    *
    * @return 返回一个集合
    *
    */
    public func getTransitions(): Collection<Rune>

```

一个用于将匹配到的字符串和负载委托给另一个处理器的类
class StatefulPayloadEmitDelegateHandler

```cangjie

    /**
    * StatefulPayloadEmitDelegateHandler 的有参构造器
    *
    * @param handler - 传入 StatefulEmitHandler 对象
    *
    */
    public init(handler: StatefulEmitHandler)

    /**
    * 处理匹配到的字符串和负载，返回是否继续搜索。这个方法会调用委托处理器的emit方法，并更新当前状态
    *
    * @param emit - 传入一个 PayloadEmit 对象
    *
    * @return 返回 Bool 类型
    */
    public func emit(emit: PayloadEmit<String>): Bool

    /**
    * 获取所有的负载集合
    *
    * @return 返回一个 ArrayList 集合
    */
    public func getEmits(): ArrayList<PayloadEmit<String>>

```

它是一个令牌抽象类
abstract class Token

```cangjie

    /**
    * Token 的有参构造器
    *
    * @param fragment - 根据给定的字符串片段创建一个令牌
    *
    */
    public init(fragment: String)

    /**
    * 获取字符串片段
    *
    * @return 返回 String 类型
    */
    public func getFragment(): String

    /**
    * 是否匹配到关键词
    *
    * @return 返回 Bool 类型
    *
    */
    public func isMatch(): Bool

    /**
    * 获取负载
    *
    * @return 返回 Option 类型
    *
    */
    public func getEmit(): ?Emit

```

它是一个字典树类
class Trie

```cangjie

    /**
    * 解析给定的文本，并返回匹配的负载
    *
    * @param text - 传入的文本信息
    * @param emitHandler - 用于处理发出的负载的事件处理器
    *
    * @return 返回一个 ArrayList 集合
    */
    public func parseText(text: String, emitHandler: StatefulEmitHandler): ArrayList<Emit>

    /**
    * 根据给定的文本判断文本是否包含匹配的字符串
    *
    * @param text - 指定的文本
    *
    * @return 返回一个 Bool 类型
    */
    public func containsMatch(text: String): Bool

    /**
    * 解析给定的文本，并返回匹配的负载
    *
    * @param text - 传入的文本信息
    * @param emitHandler - 用于处理发出的负载的事件处理器
    */
    public func parseText(text: String, emitHandler: EmitHandler): Unit

```

它是一个用于存储和搜索字符串和负载的数据结构 class PayloadTrie

```cangjie

    /**
    * 根据给定的文本将文本分割成令牌，返回一个集合
    *
    * @param text - 指定的文本
    *
    * @return 返回一个 ArrayList 集合
    */
    public func tokenize(text: String): ArrayList<PayloadToken<T>>

    /**
    * 根据给定的文本搜索第一个匹配的字符串和负载，返回一个 PayloadEmit 对象或 None
    *
    * @param text - 指定的文本
    *
    * @return 返回一个 PayloadEmit 对象或 None
    *
    */
    public func firstMatch(text: String): ?PayloadEmit<T>
```

它是一个字典树构建类
class TrieBuilder

```cangjie

    /**
    * 配置Trie在搜索文本中的关键字时忽略大小写，这个方法必须在调用 addKeyword 之前调用
    *
    * @return 返回这个构建器
    */
    public func ignoreCase(): TrieBuilder

    /**
    * 配置Trie忽略重叠的关键字
    *
    * @return 返回这个构建器
    */
    public func ignoreOverlaps(): TrieBuilder

    /**
    * 添加关键字和有效载荷的列表
    *
    * @param keywords - 传入关键字数组
    *
    * @return 返回这个构建器
    */
    public func addKeywords(keywords: Array<String>): TrieBuilder

    /**
    * 添加关键字和有效载荷的列表
    *
    * @param keywords - 传入关键字集合
    *
    * @return 返回这个构建器
    */
    public func addKeywords(keywords: ArrayList<Payload<T>>): TrieBuilder

    /**
    * 将Trie配置为匹配文本中的整个关键字
    *
    * @return 返回这个构建器
    */
    public func onlyWholeWords(): TrieBuilder

    /**
    * 将Trie配置为匹配用空格分隔的整个关键字
    *
    * @return 返回这个构建器
    */
    public func onlyWholeWordsWhiteSpaceSeparated(): TrieBuilder

    /**
    * 将Trie配置为在文本中找到第一个关键字后停止
    *
    * @return 返回这个构建器
    */
    public func stopOnHit(): TrieBuilder

    /**
    * 配置Trie不区分大小写
    *
    * @return 返回这个构建器
    */
    public func caseInsensitive(): TrieBuilder

    /**
    * 配置Trie删除重叠区间
    *
    * @return 返回这个构建器
    */
    public func removeOverlaps(): TrieBuilder

```

#### 3.3 示例

```cangjie
import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest06 = CharSearchTest06()
    charSearchTest06.testCharSearch01()
    return 0
}

@Test
public class CharSearchTest06 {

    @TestCase
    public func testCharSearch01(): Unit {
        var trie = PayloadTrie<Word>.builder()
            .addKeyword("hers", Word("f"))
            .addKeyword("his", Word("m"))
            .addKeyword("she", Word("f"))
            .addKeyword("he", Word("m"))
            .addKeyword("nonbinary", Word("nb"))
            .addKeyword("transgender", Word("tg"))
            .build()
        var emits: ArrayList<PayloadEmit<Word>> = trie.parseText("ushers")
        var iter: Iterator<PayloadEmit<Word>> = emits.iterator()
        for (i in iter) {
            println(i.toString() + i.getPayload().getOrThrow().gender)
        }
    }
}

class Word {
    protected var gender: String
    public init(gender: String) {
        this.gender = gender
    }
}


```

执行结果如下：

```shell
1:3=she->f
2:3=he->m
2:5=hers->f
```
