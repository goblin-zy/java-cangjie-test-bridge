# html4cj

## html4cj 开放 api

### 介绍

- 将html解析为dom系列对象

### 主要接口

#### class Html4cj

```cangjie
/*
 * 核心公共访问指向 Html4cj 功能
 */
public class Html4cj
```

##### 输入html文本

```cangjie
    /*
     * 将 HTML 解析为一个文档. 
     * @param html      待解析HTML
     * @param baseUri   源URL, 用以解析相对路径URL
     * @return dom对象
     */
    public static func parse(html: String, baseUri: String): Document

    /*
     * 将 HTML 解析为一个文档, 使用提供的Parser.
     * @param html      待解析HTML
     * @param baseUri   源URL, 用以解析相对路径URL
     * @param parser    解析器
     * @return dom对象
     */
    public static func parse(html: String, baseUri: String, parser: Parser): Document

    /*
     * 将 HTML 解析为一个文档, 使用提供的Parser.
     * @param html      待解析HTML
     * @param parser    解析器
     * @return dom对象
     */
    public static func parse(html: String, parser: Parser): Document

    /*
     * 将 HTML 解析为一个文档
     * @param html  待解析HTML
     * @return dom对象
     */
    public static func parse(html: String): Document

    /*
     * 解析 HTML 片段，假设它属于 HTML 的body
     * @param bodyHtml  HTML body 片段
     * @param baseUri   源URL, 用以解析相对路径URL
     * @return dom对象
     */
    public static func parseBodyFragment(bodyHtml: String, baseUri: String): Document

    /*
     * 解析 HTML 片段，假设它属于 HTML 的body
     * @param bodyHtml  HTML body 片段
     * @return dom对象
     */
    public static func parseBodyFragment(bodyHtml: String): Document
```

### 示例

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    let doc: Document = Html4cj.parseBodyFragment("<head><script>aaaa</script></head><tag2/>")
    let doc1: Document = Html4cj.parse("<script>aaaa</script><tag1/><body><tag2/></body>")

    println(doc)
    println(doc1)
}
```

输出
```shell
<html>
 <head></head>
 <body>
  <script>aaaa</script><tag2 />
 </body>
</html>
<html>
 <head>
  <script>aaaa</script>
 </head>
 <body>
  <tag1 /><tag2 />
 </body>
</html>
```

## 解析html

### 介绍

- 将html解析为dom系列对象

### 主要接口

#### class Parser

```cangjie
/*
 * 将 HTML 解析为文档.
 */
public class Parser
```

##### init

```cangjie
    /*
     * 创建一个新的解析器作为它的深层副本: 包括初始化一个新的 TreeBuilder.
     * @return Parser对象
     */
    public func newInstance(): Parser

    /*
     * 创建一个新的解析器
     * @return Parser对象
     */
    public static func htmlParser(): Parser
```

##### 解析成Document

```cangjie
    /*
     * 将HTML解析为Document.
     * @param html      html文本
     * @param baseUri   用于解析相对链接
     * @return Document对象
     */
    public func parseInput(html: String, baseUri: String): Document

    /*
     * 将HTML解析为Document.
     * @param html      html文本
     * @param baseUri   用于解析相对链接.
     * @return Document对象
     */
    public static func parse(html: String, baseUri: String): Document

    /*
     * 将html片段解析为ArrayList<Node>, 插入body.
     * @param bodyHtml  html body片段
     * @param baseUri   用于解析相对链接
     * @return Document, 空head, 解析后的body
     */
    public static func parseBodyFragment(bodyHtml: String, baseUri: String): Document
```

##### 解析成Node列表

```cangjie
    /*
     * 解析HTML片段, 上下文元素(如果提供)提供解析上下文.
     * @param fragmentHtml  html片段
     * @param context       (可选)HTML片段的上下文(用于隐式元素创建).
     * @param baseUri       用于解析相对链接
     * @return node列表. 如果提供context, 不会修改.
     */
    public func parseFragmentInput(fragment: String, context: ?Element, baseUri: String): ArrayList<Node>

    /*
     * 解析HTML片段, 上下文元素(如果提供)提供解析上下文.
     * @param fragmentHtml  html片段
     * @param context       (可选)HTML片段的上下文(用于隐式元素创建).
     * @param baseUri       用于解析相对链接
     * @return node列表. 如果提供context, 不会修改.
     */
    public static func parseFragment(fragmentHtml: String, context: ?Element, baseUri: String): ArrayList<Node>

    /*
     * 解析HTML片段, 上下文元素(如果提供)提供解析上下文.
     * @param fragmentHtml  html片段
     * @param context       (可选)HTML片段的上下文(用于隐式元素创建).
     * @param baseUri       用于解析相对链接
     * @param errorList     用于添加异常信息
     * @return node列表. 如果提供context, 不会修改.
     */
    public static func parseFragment(fragmentHtml: String, context: ?Element, baseUri: String, errorList: ParseErrorList): ArrayList<Node>
```

##### ParseSettings

```cangjie
    /*
     * 设置ParseSettings, 控制标记和属性区分大小写.
     * @param 新设置
     * @return Parser对象
     */
    public func settings(settings: ParseSettings): Parser

    /*
     * 获取当前ParseSettings
     * @return ParseSettings对象
     */
    public func settings(): ParseSettings
```

##### 异常追踪

```cangjie
    /*
     * 是否已经开启异常追踪.
     * @return Bool
     */
    public func isTrackErrors(): Bool

    /*
     * 启用/停用异常追踪
     * @param maxErrors 最大异常数量, 0:无限制
     * @return Parser对象
     */
    public func setTrackErrors(maxErrors: Int64): Parser

    /*
     * 从上次解析中获取解析错误(如果有).
     * @return 一组parseError, 和最大异常数量相同
     */
    public func getErrors(): ParseErrorList

    /*
     * 是否启用位置跟踪. 默认不开启.
     * @return Bool
     */
    public func isTrackPosition(): Bool

    /*
     * 启用/停用位置跟踪. 如果true,节点将有一个position来跟踪它们在原始输入源中的创建位置.
     * @param trackPosition true启用 false停用
     * @return Parser对象
     */
    public func setTrackPosition(trackPosition: Bool): Parser
```

##### other

```cangjie
    /*
     * 从字符串还原出html实体
     * @param string        HTML转义字符串
     * @param inAttribute   是否属性字符串
     * @return html原文
     */
    public static func unescapeEntities(string: String, inAttribute: Bool): String
```

#### class ParseSettings

```cangjie
/*
 * 标签属性设置工具类
 */
public class ParseSettings{
    /*
     * 构造函数
     *
     * @param tag       是否保留标签大小写
     * @param attribute 是否保留属性大小写
     */
    public init(tag:Bool, attribute:Bool)
    
     /*
     * 是否保留标记名称大小写
     *
     * @return 是否保留标记名称大小写
     */
    public func preserveTagCase(): Bool
    
     /*
     * 是否保留属性大小写
     *
     * @return 是否保留属性大小写
     */
    public func preserveAttributeCase(): Bool
    
     /*
     * 标签规范化, 去首尾空白, 大小写转换
     *
     * @param name 需要处理的字符串
     * @return 转换过后的字符串
     */
    public func normalizeTag(name:String): String
    
    /*
     * 属性规范化, 去首尾空白, 大小写转换
     *
     * @param name 需要处理的字符串
     * @return 转换过后的字符串
     */
    public func normalizeAttribute(name:String): String
}
```

#### class Tag

```cangjie
/*
 * HTML标签, 一些html场景的属性
 * 预定义标签: html标准标签, tag对象预加载
 * 自定义标签: tag对象每次创建新
 */
public class Tag <: Equatable<Tag> & ToString & Hashable
```

##### init

```cangjie
    /*
     * 获取标签
     * @param tagName 标签名
     * @param settings 大小写设置
     * @return Tag对象
     */
    public static func valueOf(tagName: String, settings: ParseSettings): Tag

    /*
     * 获取标签, 保留大小写
     * @param tagName 标签名, 保留大小写
     * @return Tag对象
     */
    public static func valueOf(tagName: String): Tag
```

##### 属性

```cangjie
    /*
     * 标签名
     * @return 标签名
     */
    public func getName(): String

    /*
     * 标准标签名(小写)
     * @return 标准标签名
     */
    public func normalName(): String

    /*
     * 是否block tag.
     * @return Bool
     */
    public func isBlock(): Bool

    /*
     * 是否以block/inline形式格式化
     * @return Bool
     */
    public func formatAsBlock(): Bool

    /*
     * 是否inline tag.
     * @return Bool
     */
    public func isInline(): Bool

    /*
     * 是否空标签
     * @return Bool
     */
    public func isEmpty(): Bool

    /*
     * 是否self-closing标签
     * @return Bool
     */
    public func isSelfClosing(): Bool

    /*
     * 是否预定义标签
     * @return Bool
     */
    public func isKnownTag(): Bool

    /*
     * 是否预定义标签
     * @param tagName 标签名
     * @return Bool
     */
    public static func checkKnownTag(tagName: String): Bool

    /*
     * 是否保留空白
     * @return Bool
     */
    public func preserveWhitespace(): Bool

    /*
     * 是否表示与窗体关联的控件. E.g. input, textarea, output
     * @return Bool
     */
    public func isFormListed(): Bool

    /*
     * 是否表示应与表单一起提交的元素. E.g. input, option
     * @return Bool
     */
    public func isFormSubmittable(): Bool
```

##### other

```cangjie
    public operator func ==(tag: Tag): Bool

    public operator func !=(tag: Tag): Bool

    public func hashCode(): Int64

    public func toString(): String
```

#### class ParserError

```cangjie
/*
 * Parse Error 记录HTML中的错误
 */
public class ParseError <: ToString
```

##### 信息

```cangjie
    /*
     * 获取异常信息
     * @return 异常信息
     */
    public func getErrorMessage(): String

    /*
     * 获取异常点坐标
     * @return 异常点在input中的offset
     */
    public func getPosition(): Int64

    /*
     * 获取坐标, line:column 格式
     * @return line:number 格式坐标
     */
    public func getCursorPos(): String

    public func toString(): String
```

#### class ParserErrorList

```cangjie
/*
 * Parse Error List
 */
public class ParseErrorList <: Iterable<ParseError>
```

##### init

```cangjie
    /*
     * 空list
     * @return ParseErrorList对象
     */
    public static func noTracking(): ParseErrorList

    /*
     * 指定长度list
     * @param maxSize 最大长度
     * @return ParseErrorList对象
     */
    public static func tracking(maxSize: Int64): ParseErrorList
```

##### 获取元素

```cangjie
    public prop size: Int64

    public operator func [](index: Int64): ParseError

    public func iterator(): Iterator<ParseError>
```

### 示例

#### class ParseSettings

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    let bothOn: ParseSettings = ParseSettings(true, true)
    let bothOff: ParseSettings = ParseSettings(false, false)
    if ("IMG" == bothOn.normalizeTag("IMG")) {
        println("pass1")
    }
    if ("ID" == bothOn.normalizeAttribute("ID")) {
        println("pass2")
    }
    if ("img" == bothOff.normalizeTag("IMG")) {
        println("pass3")
    }
    if ("id" == bothOff.normalizeTag("IMG")) {
        println("pass4")
    }
    let parseSettings: ParseSettings = ParseSettings(false, false)
    let normalizedAttribute: String = parseSettings.normalizeAttribute("HIDDEN")
    if ("hidden" == normalizedAttribute) {
        println("pass5")
    }
    if (!ParseSettings.htmlDefault.preserveTagCase()) {
        println("pass6")
    }
    if (!ParseSettings.htmlDefault.preserveAttributeCase()) {
        println("pass7")
    }
    if (ParseSettings.preserveCase.preserveTagCase()) {
        println("pass8")
    }
    if (ParseSettings.preserveCase.preserveAttributeCase()) {
        println("pass9")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
pass9
```

#### class Tag

```cangjie 
import cangjie_tpc::html4cj.*

main(): Int64 {
    let p1: Tag = Tag.valueOf("P")
    let p2: Tag = Tag.valueOf("p")
    if (p1 == p2) {
        println("pass1")
    }
    let div: Tag = Tag.valueOf("div")
    if (div.isBlock()) {
        println("pass2")
    }
    if (div.formatAsBlock()) {
        println("pass3")
    }
    let p: Tag = Tag.valueOf("p")
    if (p.isBlock()) {
        println("pass4")
    }
    if (!p.formatAsBlock()) {
        println("pass5")
    }
    let img: Tag = Tag.valueOf("img")
    if (img.isInline()) {
        println("pass6")
    }
    if (img.isSelfClosing()) {
        println("pass7")
    }
    if (!img.isBlock()) {
        println("pass8")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
```

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    let html: String = "<p One=One ONE=Two Two=two one=Three One=Four two=Five>Text</p>"
    let parser: Parser = Parser.htmlParser().setTrackErrors(10)
    let doc: Document = parser.parseInput(html, "")
    let p: Element = doc.selectFirst("p").getOrThrow()

    println(p.outerHtml()) // normalized names due to lower casing

    println(parser.getErrors().size)
    println(parser.getErrors()[0].getErrorMessage())
}
```

输出

```shell
<p one="One" two="two">Text</p>
1
Dropped duplicate attribute(s) in tag [p]
```

## 选择器

### 介绍

- 解析选择器语句, 查询dom节点

```css选择器
标签选择器      div
类选择器        .class1
id选择器        #id1
属性            [attribute]
关系            :nth-child(n)
```

### 主要接口

#### class Selector

```cangjie
/*
 * 根据css选择器查询dom节点
 */
public class Selector
```

##### 查询

```cangjie
    /*
     * 查找匹配选择器的元素
     * @param query CSS选择器
     * @param root  查询的起始节点
     * @return 匹配元素，如果没有则为空Elements
     */
    public static func select(query: String, root: Element): Elements

    /*
     * 查找匹配选择器的元素
     * @param evaluator 自定义过滤器 对遍历的每个节点执行
     * @param root 查询的起始节点
     * @return 匹配元素，如果没有则为空Elements
     */
    public static func select(evaluator: Evaluator, root: Element): Elements

    /*
     * 查找匹配选择器的元素
     * @param query CSS选择器
     * @param roots 查询的起始节点 多个
     * @return 匹配元素，如果没有则为空Elements
     */
    public static func select(query: String, roots: Iterable<Element>): Elements

    /*
     * 查找第一个匹配选择器的元素
     * @param cssQuery CSS选择器
     * @param root 查询的起始节点
     * @return 匹配元素，如果没有则为None
     */
    public static func selectFirst(cssQuery: String, root: Element): ?Element
```

#### class Elements

```cangjie
/*
 * 节点列表, 以及作用于每个节点的方法.
 */
public class Elements <: ToString & Iterable<Element> & Equatable<Elements>
```

##### init

```cangjie
    /*
     * 构造函数
     */
    public init()
    /*
     * 构造函数
     * @param initialCapacity 初始化列表长度
     */
    public init(initialCapacity: Int64)

    /*
     * 构造函数
     * @param elements 初始化列表
     */
    public init(elements: Collection<Element>)

    /*
     * 构造函数
     * @param elements 初始化列表
     */
    public init(elements: Array<Element>)
```

##### 列表信息

```cangjie
    /*
     * 真实列表
     */
    public prop elementArr: ArrayList<Element>

    /*
     * 列表大小
     */
    public prop size: Int64

    public operator func [](i: Int64): Element

    public func iterator(): Iterator<Element>
```

##### 元素属性

```cangjie
    /*
     * 从第一个具有attributeKey的匹配元素中获取属性值.
     * @param attributeKey 属性key.
     * @return 来自具有该属性的第一个匹配元素的属性值. 如果没有, 返回空string.
     */
    public func attr(attributeKey: String): String

    /*
     * 检查是否有任何匹配的元素定义了此属性.
     * @param attributeKey 属性key
     * @return Bool
     */
    public func hasAttr(attributeKey: String): Bool

    /*
     * 获取每个匹配元素的属性值. 如果元素没有此属性,则该元素的结果集中不包含任何值.
     * @param attributeKey 属性名. 可以将 abs: 前缀添加到键中, 以从相对 URL 获得绝对 URL. 例如: doc.select("a").eachAttr("abs:href")
     * @return 属性值的列表
     */
    public func eachAttr(attributeKey: String): ArrayList<String>

    /*
     * 为所有匹配的元素设置属性. 
     * @param attributeKey 属性名
     * @param attributeValue 属性值
     * @return Elements对象
     */
    public func attr(attributeKey: String, attributeValue: String): Elements

    /*
     * 从每个匹配的元素中删除一个属性. 
     * @param attributeKey 要删除的属性名
     * @return Elements对象
     */
    public func removeAttr(attributeKey: String): Elements

    /*
     * 将类名添加到每个匹配元素的 class 属性中. 
     * @param className 要添加的类名
     * @return Elements对象
     */
    public func addClass(className: String): Elements

    /*
     * 如果存在, 则从每个匹配元素的 class 属性中删除类名. 
     * @param className 要添加的类名
     * @return Elements对象
     */
    public func removeClass(className: String): Elements

    /*
     * 在每个匹配元素上toggleClass
     * @param className 要添加的类名
     * @return Elements对象
     */
    public func toggleClass(className: String): Elements

    /*
     * 确定任何元素的 class 属性中是否设置了这个类名. 
     * @param className 要检查的类名
     * @return 有值为true，没有为false
     */
    public func hasClass(className: String): Bool

    /*
     * 获取第一个匹配元素的val()
     * @return val数据 或者 ""
     */
    public func val(): String

    /*
     * 在每个匹配的元素中设置val(value)
     * @param value 要设置到每个匹配元素中的值
     * @return Elements对象
     */
    public func val(value: String): Elements

    /*
     * 更新(重命名)每个匹配元素的标签名.
     * @param tagName 新标签名
     * @return Elements对象
     */
    public func tagName(tagName: String): Elements
```

##### 标签内容

```cangjie
    /*
     * 获取所有匹配元素的组合文本
     * @return string 原文 非HTML源码
     */
    public func text(): String

    /*
     * 测试任何匹配的 Element 是否有任何非空文本内容
     * @return true 如果任意节点含有非空文本内容.
     */
    public func hasText(): Bool

    /*
     * 获取每个匹配元素的文本内容. 如果一个元素没有文本, 那么它就不包含在结果中. 
     * @return 所有匹配元素的text列表
     */
    public func eachText(): ArrayList<String>

    /*
     * 获取所有匹配元素的组合内部 HTML. 
     * @return 所有元素内部 HTML 的字符串
     */
    public func html(): String

    /*
     * 获取所有匹配元素的组合外部 HTML
     * @return 所有元素的外部 HTML 的字符串
     */
    public func outerHtml(): String

    /*
     * 获取所有匹配元素的组合外部 HTML. outerHtml()别名.
     * @return 所有元素的外部 HTML 的字符串
     */
    public func toString(): String

    /*
     * 设置每个匹配元素的内部 HTML.
     * @param html 解析 HTML 并设置到每个匹配的元素中.
     * @return this, for chaining
     */
    public func html(html: String): Elements
```

##### 更改结构

```cangjie
    /*
     * 将提供的 HTML 添加到每个匹配元素的内部 HTML 的开头.
     * @param html 在每个元素内添加 HTML, 在现有的 HTML 之前
     * @return Elements对象
     */
    public func prepend(html: String): Elements

    /*
     * 将提供的 HTML 添加到每个匹配元素的内部 HTML 的末尾.
     * @param html 在每个元素中添加 HTML, 在现有的 HTML 之后
     * @return Elements对象
     */
    public func append(html: String): Elements

    /*
     * 在每个元素中添加 HTML, 在现有的 HTML 之后.
     * @param html 在每个元素之前插入 HTML
     * @return Elements对象
     */
    public func before(html: String): Elements

    /*
     * 在每个匹配元素的外部 HTML 之后插入提供的 HTML.
     * @param html 在每个元素后面插入 HTML
     * @return Elements对象
     */
    public func after(html: String): Elements

    /*
     * 将提供的 HTML 包装在每个匹配的元素前后
     * For example, with HTML <p><b>This</b> is <b>Jsoup</b></p>, 
     * doc.select("b").wrap("<i></i>"); 
     * becomes <p><i><b>This</b></i> is <i><b>jsoup</b></i></p>
     * @param html 包围每个元素的 HTML, e.g. <div class="head"></div>.
     * @return Elements对象
     */
    public func wrap(html: String): Elements

    /*
     * 从 DOM 中删除匹配的元素, 并将其子元素移动到其父元素中. 这样做的效果是, 删除了元素, 但保留了它们的子元素.
     * E.g. with HTML:
     * <div><font>One</font> <font><a href="/">Two</a></font></div>
     * doc.select("font").unwrap();
     * HTML = <div>One <a href="/">Two</a></div>
     * @return Elements对象
     */
    public func unwrap(): Elements

    /*
     * 清空(删除所有子节点)每个匹配的元素. 
     * E.g. HTML: <div><p>Hello <b>there</b></p> <p>now</p></div> 
     * doc.select("p").empty(); 
     * HTML = <div><p></p> <p></p></div>
     * @return Elements对象
     */
    public func empty(): Elements

    /*
     * 从 DOM 中删除每个匹配的元素. 这类似于将每个元素的外部 HTML 设置为空.
     * E.g. HTML: <div><p>Hello</p> <p>there</p> <img /></div> 
     * doc.select("p").remove(); 
     * HTML = <div> <img /></div>
     * @return Elements对象
     */
    public func remove(): Elements
```

##### 以列表中元素为root进行上下文匹配/过滤

###### tip

```cangjie
节点 = 元素 = element

父节点 = 上级节点
子节点 = 下级节点

前节点 = 兄节点 = 同级前节点 = 下一个同级节点
后节点 = 弟节点 = 同级后节点 = 上一个同级节点

直接 = 只匹配一次就返回 = 非贪婪匹配
all = 所有 = 匹配所有 = 贪婪匹配
```

###### api

```cangjie
    /*
     * 在此元素列表中查找匹配的元素.
     * @param query 选择器查询
     * @return 匹配列表或空列表
     */
    public func select(query: String): Elements

    /*
     * 获取此列表中每个元素的直接后元素.
     * @return 下一个同级Elements对象。
     */
    public func next(): Elements

    /*
     * 获取此列表中每个元素的直接后元素, 并通过查询进行筛选.
     * @param query CSS query 用于匹配后元素
     * @return 下一个同级Elements对象。
     */
    public func next(query: String): Elements

    /*
     * 获取列表中每个元素的所有后元素.
     * @return 所有的后元素.
     */
    public func nextAll(): Elements

    /*
     * 获取与查询匹配的列表中每个元素的所有后元素.
     * @param query CSS query 用于匹配后元素
     * @return 所有匹配的后元素.
     */
    public func nextAll(query: String): Elements

    /*
     * 获取此列表中每个元素的直接前元素.
     * @return 前元素列表.
     */
    public func prev(): Elements

    /*
     * 获取此列表中每个元素的直接前元素, 并通过查询进行筛选.
     * @param query CSS query 用于匹配前元素
     * @return 前元素列表.
     */
    public func prev(query: String): Elements

    /*
     * 获取此列表中每个元素的所有前元素.
     * @return 所有前元素列表.
     */
    public func prevAll(): Elements

    /*
     * 获取此列表中每个元素的所有前元素, 并通过查询进行筛选.
     * @param query CSS query 用于匹配前元素
     * @return 所有匹配的前元素列表.
     */
    public func prevAll(query: String): Elements

    /*
     * 获取匹配元素的所有父元素和祖先元素.
     * @return 获取匹配元素的所有父元素和祖先元素
     */
    public func parents(): Elements

    /*
     * 获取注释节点, 它们是所选元素的直接子节点.
     * @return 注释节点, 如果没有, 则为空列表.
     */
    public func comments(): ArrayList<Comment>

    /*
     * 获取作为所选元素的直接子节点的 TextNode 节点.
     * @return TextNode 节点, 如果没有, 则为空列表.
     */
    public func textNodes(): ArrayList<TextNode>

    /*
     * 获取作为所选元素的直接子节点的 DataNode 节点
     * DataNode 节点包含脚本、样式等标记的内容, 与 TextNode 不同.
     * @return 数据节点, 如果没有, 则为空列表.
     */
    public func dataNodes(): ArrayList<DataNode>
```

##### 对列表中元素进行匹配/过滤

```cangjie
    /*
     * 从此列表中删除与选择器查询匹配的元素.
     * E.g. HTML: <div class=logo>One</div> <div>Two</div> 
     * Elements divs = doc.select("div").not(".logo"); 
     * Result: divs: [<div>Two</div>]
     * @param query 应从这些元素中删除其结果的选择器查询
     * @return 只包含筛选结果的新元素列表
     */
    public func not(query: String): Elements

    /*
     * 获取第 n 个匹配的元素作为 Elements 对象.
     * @param index 要保留的列表中元素的(从零开始的)索引
     * @return 只包含指定元素的元素, 如果该元素不存在, 则为空列表.
     */
    public func eq(index: Int64): Elements

    /*
     * 测试是否有任何匹配的元素与提供的查询匹配.
     * @param query 选择器
     * @return 如果列表中至少有一个元素与查询匹配, 则为 true.
     */
    public func check(query: String): Bool

    /*
     * 获取第一个匹配的元素.
     * @return 第一个元素或None
     */
    public func first(): ?Element

    /*
     * 获取最后一个匹配的元素.
     * @return 最后一个元素或None
     */
    public func last(): ?Element

    /*
     * 如果有的话, 从选定的元素中获取 FormElement 表单.
     * @return 从匹配的元素中提取的 FormElements 列表. 如果元素不包含表单, 则该列表为空.
     */
    public func forms(): ArrayList<FormElement>
```

##### 自定义遍历/过滤

```cangjie
    /*
     * 对每个选定的元素执行深度优先遍历.
     * @param nodeVisitor 要在每个节点上执行的visitor
     * @return Elements对象
     */
    public func traverse(nodeVisitor: NodeVisitor): Elements

    /*
     * 对每个选定的元素执行深度优先过滤.
     * @param nodeFilter 要在每个节点上执行的filter
     * @return Elements对象
     */
    public func filter(nodeFilter: NodeFilter): Elements
```

##### 其他

```cangjie
    /*
     * 创建这些元素的深度副本
     * @return 深拷贝
     */
    public func clone(): Elements

    public operator func !=(that: Elements): Bool

    public operator func ==(that: Elements): Bool
```

#### interface NodeVisitor

```cangjie
/*
 * 节点访问者接口, 为 NodeTraversor 提供一个实现类以循环访问节点.
 * 这个接口提供了两个方法, head 和 tail. 当首次看到节点时调用 head 方法, 当访问了节点的所有子节点时调用 tail 方法. 例如, head 可用于发出节点的开始标记, tail 可用于创建结束标记.
 */
public interface NodeVisitor
```

##### func

```cangjie
    /*
     * 首次访问节点时的回调
     * 可以修改节点(例如 Node.attr(String)、替换 Node.replaceWith(Node))或删除 Node.remove(). * 如果是 instanceOf Element, 则可以将其强制转换为 Element 并访问这些方法. 
     * @param node 正在访问的节点.
     * @param depth 节点的深度, 相对于根节点.例如, 根节点的深度为0, 其子节点的深度为1
     */
    func head(node: Node, depth: Int64): Unit

    /*
     * 节点最后一次被访问时的回调, 在所有子节点被访问之后
     * 此方法具有默认的无操作实现
     * 注意, tail()期间既不支持用 Node.replaceWith(Node)替换, 也不支持用 Node.remove()删除
     * @param node 正在访问的节点.
     * @param depth 节点的深度, 相对于根节点.例如, 根节点的深度为0, 其子节点的深度为1
     */
    func tail(node: Node, depth: Int64): Unit
```

#### interface NodeFilter

```cangjie
/*
 * 节点过滤器接口. 为 NodeTraversor 提供一个实现类以迭代遍历节点.
 * 这个接口提供了两个方法, head 和 tail. 当首次看到节点时调用 head 方法, 当访问了节点的所有子节点时调用 tail 方法. 例如, head 可用于创建节点的开始标记, tail 可用于创建结束标记.
 * 对于每个节点, 筛选器必须决定是否:
    继续 (FilterResult.CONTINUE),
    跳过所有的子节点 (FilterResult.SKIP_CHILDREN),
    完全跳过节点 (FilterResult.SKIP_ENTIRELY),
    删除子树(节点及其子节点) (FilterResult.REMOVE),
    中断迭代并返回 (FilterResult.STOP).
 * SKIP_CHILDREN 和 SKIP_ENTIRELY 之间的区别是前者将在节点上调用 tail(Node, int), 而后者不会. 在 tail(Node, int)中, 两者都等效于 FilterResult.CONTINUE.
 */
public interface NodeFilter
```

##### func

```cangjie
    /*
     * 首次访问节点时的回调
     * 可以修改节点(例如 Node.attr(String)、替换 Node.replaceWith(Node))或删除 Node.remove(). 
     * 如果类型是Element, 则可以将其强制转换为 Element 并访问这些方法. 
     * @param node 正在访问的节点.
     * @param depth 节点的深度, 相对于根节点.例如, 根节点的深度为0, 其子节点的深度为1
     */
    func head(node: Node, depth: Int64): FilterResult

    /*
     * 节点最后一次被访问时的回调, 在所有子节点被访问之后
     * 此方法具有默认的无操作实现
     * 注意, tail()期间既不支持用 Node.replaceWith(Node)替换, 也不支持用 Node.remove()删除
     * @param node 正在访问的节点.
     * @param depth 节点的深度, 相对于根节点.例如, 根节点的深度为0, 其子节点的深度为1
     */
    func tail(node: Node, depth: Int64): FilterResult
```

#### enum FilterResult

```cangjie
/*
 * 过滤结果.
 */
public enum FilterResult <: Equatable<FilterResult> & ToString {
    // 继续处理树
    | CONTINUE
    // 跳过子节点, 会调用 NodeFilter.tail(Node, Int64).
    | SKIP_CHILDREN
    // 跳过子树, 不会调用 NodeFilter.tail(Node, Int64).
    | SKIP_ENTIRELY
    // 删除节点及其子节点
    | REMOVE
    // 停止
    | STOP

    public func toString(): String

    public operator func ==(r: FilterResult): Bool

    public operator func !=(r: FilterResult): Bool
}
```

#### class Evaluator

```cangjie
/*
 * 计算某个元素是否与选择器匹配.
 */
public abstract class Evaluator <: ToString
```

##### func

```cangjie
    /*
     * 测试元素是否满足计算器的要求.
     * @param root    待匹配子树的根
     * @param element 待匹配节点
     * @return 如果满足要求则返回 true, 否则返回 false
     */
    public func matches(root: ?Element, element: Element): Bool
```

### 示例

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    let h: String = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>"
    let doc: Document = Html4cj.parse(h)
    let sibs: Elements = doc.select("li#1 + li#2")
    println(sibs.size)
    println(sibs[0].text())
}
```

输出

```shell
1
Two
```

## HTML文档结构节点 - 节点属性

### 介绍

### 主要接口

#### class Attribute

```cangjie
/*
 * 单个键+值属性。
 */
public class Attribute <: Hashable & Equatable<Attribute> & ToString {
    /*
     * 根据未编码的（原始）键和值创建一个新属性
     *
     * @参数 key 属性键
     * @参数 value 属性值（可以为None）
     * @throws ValidationException 当key为空
     */
    public init(key: String, value: ?String)

    /*
     * 根据未编码的（原始）键和值创建一个新属性
     *
     * @参数 key 属性键
     * @参数 value 属性值（可以为None）
     * @参数 parent 属性列表（可以为None）
     * @throws ValidationException 当key为空
     */
    public init(key: String, val: ?String, parent: ?Attributes)

    /*
     * 获取属性密钥
     *
     * @返回值 属性键
     */
    public func getKey(): String

    /*
     * 获取属性值。如果未设置值，将返回一个空字符串。
     *
     * @返回值 属性值
     */
    public func getValue(): String

    /*
     * 设置属性键
     *
     * @参数 key 新密钥；不得为None
     * @throws ValidationException 当key为空
     */
    public func setKey(key: String): Unit

    /*
     * 设置新的属性值。
     *
     * @参数 val 新的属性值；可以为None（设置启用的布尔属性）
     * @返回值 旧的属性值，如果旧属性值为None返回为空字符串。
     */
    public func setValue(val: ?String): String

    /*
     * 检查此属性是否有值。
     *
     * @返回值 此属性有值为true,此属性没有值为false
     */
    public func hasDeclaredValue(): Bool

    /*
     * 检查此属性名称是否在HTML5中定义为布尔属性
     *
     * @参数 key 属性键
     * @返回值 是定义过的属性为true，不是定义过的属性为false
     */
    public static func isBooleanAttribute(key: String): Bool

    /*
     * 获取此属性的HTML表示形式
     *
     * @返回值 HTML
     */
    public func html(): String

    /*
     * toString方法，和html()方法相同
     *
     * @返回值 HTML
     */
    public func toString(): String

    /*
     * 克隆当前对象，返回新的对象
     *
     * @返回值 新的对象
     */
    public func clone(): Attribute

    /*
     * hash值
     *
     * @返回值 对象的hash值
     */
    @OverflowWrapping
    public func hashCode(): Int64

    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 o 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: Attribute): Bool

    /*
     * 对比入参对象和当前对象是否相等
     *
     * @参数 o 入参对象
     * @返回值 相等为true，不相等为false
     */
    public operator func ==(that: Attribute): Bool
}
```

#### class Attributes

```cangjie
/*
 * 元素的属性。
 */
public class Attributes <: Iterable<Attribute> & Hashable & Equatable<Attributes> & ToString {
    /*
     * 此集合中的属性数
     *
     * @返回值 集合中的属性数
     */
    public prop size: Int64

    /*
     * 此集合中的前缀为"data-"的属性数
     *
     * @返回值 集合中的前缀为"data-"的属性数
     */
    public prop dataSize: Int64

    /*
     * 通过属性键获取属性键值
     *
     * @参数 key （区分大小写）属性键
     * @返回值 属性值；如果未设置，则为空字符串。
     */
    public func get(key: String): String

    /*
     * 通过不区分大小写的属性键获取属性值
     *
     * @参数 key （不区分大小写）属性键
     * @返回值 属性值；如果未设置，则为空字符串。
     */
    public func getIgnoreCase(key: String): String

    /*
     * 获得"data-"开头的值
     *
     * @参数 key 要搜索的key（不包含"data-"前缀）
     * @返回值 对应的值（可能为None）
     */
    public func getData(key: String): ?String

    /*
     * 添加新属性。如果属性键已经存在，将产生重复项。
     *
     * @参数 key 区分大小写的属性键（不为None）
     * @参数 value 属性值（可以为None）
     * @返回值 当前属性
     * @throws ValidationException 当key为空
     */
    public func add(key: String, value: ?String): Attributes

    /*
     * 添加新属性。如果属性键已经存在，将会替换属性值。
     *
     * @参数 key 区分大小写的属性键（不为None）
     * @参数 value 属性值（可以为None）
     * @返回值 当前属性
     * @throws ValidationException 当key为空
     */
    public func put(key: String, value: ?String): Attributes
    
    /*
     * 如果value为false，删除这条属性。如果value为true，并且没有这条属性，添加这条属性，这条属性的值为None，否则覆盖这条属性，值为None。
     *
     * @参数 key 区分大小写的属性键（不为None）
     * @参数 value 布尔值
     * @返回值 当前属性
     * @throws ValidationException 当key为空
     */
    public func put(key: String, value: Bool): Attributes

    /*
     * 添加新属性。如果属性键已经存在，将会替换属性值。
     *
     * @参数 attribute 单个属性
     * @返回值 当前属性
     * @throws ValidationException 当Attribute.value为空
     */
    public func put(attribute: Attribute): Attributes
    
    /*
     * 将传入集合中的所有属性添加到此集合中
     *
     * @参数 incoming 传入集合
     * @throws ValidationException 当Attribute.value为空
     */
    public func addAll(incoming: Attributes): Unit

    /*
     * 插入"data-"开头的值
     *
     * @参数 key 要插入的key（不包含"data-"前缀）
     * @参数 value 要插入的value（可能为None）
     * @返回值 如果之前有对应的key则返回的是之前key对应的value值，否则为None
     * @throws ValidationException 当key为空
     */
    public func putData(key: String, value: ?String): ?String

    /*
     * 按属性键移除属性。
     *
     * @参数 要删除的属性键
     * @throws ValidationException 当key为空
     */
    public func remove(key: String): Unit
    
    /*
     * 按属性键移除属性。(不区分大小写)
     *
     * @参数 要删除的属性键
     * @throws ValidationException 当key为空
     */
    public func removeIgnoreCase(key: String): Unit

    /*
     * 删除"data-"开头的值
     *
     * @参数 key 要删除的key（不包含"data-"前缀）
     * @throws ValidationException 当key为空
     */
    public func removeData(key: String): Unit

    /*
     * 检查属性键是否存在（区分大小写）
     *
     * @参数 key 要检查属性键（区分大小写）
     * @返回值 如果属性键存在，则为true，否则为false
     */
    public func hasKey(key: String): Bool

    /*
     * 检查属性键是否存在（不区分大小写）
     *
     * @参数 key 要检查属性键（不区分大小写）
     * @返回值 如果属性键存在，则为true，否则为false
     */
    public func hasKeyIgnoreCase(key: String): Bool

    /*
     * 检查属性键是否存在（区分大小写），并且属性值不能为None
     *
     * @参数 key 要检查的密钥
     * @返回值 如果密钥存在，则为true，否则为false
     */
    public func hasDeclaredValueForKey(key: String): Bool

    /*
     * 检查属性键是否存在（不区分大小写），并且属性值不能为None
     *
     * @参数 key 要检查的密钥
     * @返回值 如果密钥存在，则为true，否则为false
     */
    public func hasDeclaredValueForKeyIgnoreCase(key: String): Bool

    /*
     * 判断当前对象是否为空
     *
     * @返回值 是否为空
     */
    public func isEmpty(): Bool
    
    /*
     * 返回当前对象的迭代器
     *
     * @返回值 前对象的迭代器
     */
    public func iterator(): Iterator<Attribute> 

    /*
     * 将属性作为列表获取，以便进行迭代。
     *
     * @返回值 属性列表
     */
    public func asList(): ArrayList<Attribute>

    /*
     * 检索作为HTML5自定义数据属性的属性的筛选视图
     *
     * @返回值 自定义数据属性的映射。
     */
    public func dataset(): Iterator<(String, ?String)>

    /*
     * 获取这些属性的HTML表示形式。
     *
     * @返回值 HTML
     */
    public func html(): String

    /*
     * toString方法，和html()方法相同
     *
     * @返回值 HTML
     */
    public func toString(): String

    /*
     * 克隆当前对象，返回新的对象
     *
     * @返回值 新的对象
     */
    public func clone(): Attributes

    /*
     * 在键上加一个反斜杠
     *
     * @参数 key 要添加的密钥
     * @返回值 添加后返回值
     */
    public static func internalKey(key: String): String

    /*
     * hash值
     *
     * @返回值 对象的hash值
     */
    @OverflowWrapping
    public func hashCode(): Int64

    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 o 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: Attributes): Bool

    /*
     * 对比入参对象和当前对象是否相等
     *
     * @参数 o 入参对象
     * @返回值 相等为true，不相等为false
     */
    public operator func ==(that: Attributes): Bool
}
```

### 示例

#### class Attribute

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var attr: Attribute = Attribute("key", "value &")
    if (attr.html() == "key=\"value &amp;\"") {
        println("pass1")
    }
    if (attr.toString() == attr.html()) {
        println("pass2")
    }
    if (attr.getKey() == "key") {
        println("pass3")
    }
    if (attr.getValue() == "value &") {
        println("pass4")
    }
    if (attr.hasDeclaredValue()) {
        println("pass5")
    }
    var attr1: Attribute = attr.clone()
    if (attr == attr1) {
        println("pass6")
    }
    if (attr.hashCode() == attr1.hashCode()) {
        println("pass7")
    }
    var attr2: Attribute = Attribute("key", "value1", Attributes())
    if (attr != attr2) {
        println("pass8")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
```

#### class Attributes

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var attributes1: Attributes = Attributes()
    attributes1.put("Tot", "a&p")
    attributes1.put("Hello", "There")
    attributes1.put("data-name", "Jsoup")
    if (attributes1.size == 3) {
        println("pass1")
    }
    if (attributes1.get("Tot") == "a&p") {
        println("pass2")
    }
    attributes1.remove("Tot")
    if (attributes1.get("Tot") == "") {
        println("pass3")
    }
    if (attributes1.size == 2) {
        println("pass4")
    }
    if (attributes1.get("HELLO") == "") {
        println("pass5")
    }
    if (attributes1.getIgnoreCase("HELLO") == "There") {
        println("pass6")
    }
    if (!attributes1.hasKey("HELLO")) {
        println("pass7")
    }
    if (attributes1.hasKeyIgnoreCase("HELLO")) {
        println("pass8")
    }
    if (attributes1.dataSize == 1) {
        println("pass9")
    }
    if (attributes1.getData("name").getOrThrow() == "Jsoup") {
        println("pass10")
    }
    var attr: Attribute = Attribute("key", "value &")
    attributes1.put(attr)
    if (attributes1.size == 3) {
        println("pass11")
    }
    if (!attributes1.isEmpty()) {
        println("pass12")
    }
    if (attributes1.toString() == attributes1.html()) {
        println("pass13")
    }
    if (attributes1.hasDeclaredValueForKeyIgnoreCase("key")) {
        println("pass14")
    }
    var attributes2: Attributes = attributes1.clone()
    if (attributes1 == attributes2) {
        println("pass15")
    }
    var attributes3: Attributes = Attributes()
    if (attributes1 != attributes3) {
        println("pass16")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
pass9
pass10
pass11
pass12
pass13
pass14
pass15
pass16
```

## HTML文档结构节点 - 基本抽象节点模型Node

### 介绍

### 主要接口

#### abstract class Node

```cangjie
/*
 * 基本的抽象节点模型。元素、文档、注释等都是Node实例。
 */
public abstract class Node <: Hashable & Equatable<Node> & ToString {
    /*
     * 抽象方法，获取此节点的节点名称
     *
     * @返回值 此节点的节点名称
     */
    public func nodeName(): String

    /*
     * 获取此节点的节点名称
     *
     * @返回值 此节点的节点名称
     */
    public open func normalName(): String

    /*
     * 检查此节点是否有父节点。
     *
     * @返回值 如果时true代表有父节点，否则没有
     */
    public func hasParent(): Bool

    /*
     * 通过属性的键获取属性的值。
     *
     * @参数 attributeKey 属性键
     * @返回值 属性值
     */
    public open func attr(attributeKey: String): String

    /*
     * 抽象方法，获取元素的所有属性。
     *
     * @返回值 属性
     */
    public func attributes(): Attributes

    /*
     * 获取节点属性数量
     *
     * @返回值 属性数量
     */
    public func attributesSize(): Int64

    /*
     * 设置一个属性（键=值）。如果该属性已经存在，则会将其替换。
     *
     * @参数 attributeKey 属性key
     * @参数 attributeValue 属性value
     * @返回值 当前节点
     */
    public open func attr(attributeKey: String, attributeValue: String): Node

    /*
     * 测试此节点是否具有属性。(不区分大小写)
     *
     * @参数 attributeKey 属性key
     * @返回值 返回true表示有属性，返回false表示没有属性
     */
    public open func hasAttr(attributeKey: String): Bool

    /*
     * 从该节点中删除一个属性。
     *
     * @参数 attributeKey 要删除的属性。
     * @返回值 当前节点
     */
    public open func removeAttr(attributeKey: String): Node

    /*
     * 清除此节点中的所有属性。
     *
     * @返回值 当前节点
     */
    public open func clearAttributes(): Node

    /*
     * 抽象方法，获取应用于此节点的基本URI。
     *
     * @返回值 基本URI
     */
    public func baseUri(): String

    /*
     * 更新此节点及其所有子节点的基本URI。
     *
     * @参数 baseUri 基本URI
     */
    public open func setBaseUri(baseUri: String): Unit

    /*
     * 从可能是相对的URL属性中获取绝对URL
     *
     * @参数 baseUri 属性键
     * @返回值 如果可以生成，则为绝对URL；如果属性丢失或无法成功生成URL，则为空字符串
     * @throws ValidationException 当attributeKey为空
     */
    public open func absUrl(attributeKey: String): String

    /*
     * 通过索引获取子节点
     *
     * @参数 index 子节点的索引
     * @返回值 返回此索引处的子节点。
     */
    public func childNode(index: Int64): Node

    /*
     * 获取此节点的子节点
     *
     * @返回值 子节点列表
     */
    public func childNodes(): ArrayList<Node>

    /*
     * 复制此节点的子节点
     *
     * @返回值 子节点列表
     */
    public func childNodesCopy(): ArrayList<Node>

    /*
     * 抽象方法，获取此节点包含的子节点数。
     *
     * @返回值 此节点包含的子节点数。
     */
    public func childNodeSize(): Int64

    /*
     * 抽象方法，删除此节点的所有子节点。
     *
     * @返回值 当前节点。
     */
    public func empty(): Node

    /*
     * 获取此节点的父节点。
     *
     * @返回值 此节点的父节点。
     */
    public open func parent(): ?Node

    /*
     * 获取此节点的父节点。
     *
     * @返回值 此节点的父节点。
     */
    public func parentNode(): ?Node

    /*
     * 获取此节点的根节点
     *
     * @返回值 此节点的根节点。
     */
    public open func root(): Node

    /*
     * 获取与此节点关联的文档。
     *
     * @返回值 与该节点关联的Document，如果没有这样的Document，则为None。
     */
    public func ownerDocument(): ?Document

    /*
     * 从DOM树中移除（删除）此节点。如果此节点具有子节点，则它们也将被删除。
     */
    public func remove(): Unit

    /*
     * 在此节点之前将指定的HTML插入到DOM中（作为前面的同级）。
     *
     * @参数 html 要在此节点之前添加的html
     * @返回值 当前节点
     */
    public open func before(html: String): Node

    /*
     * 在此节点之前将指定的节点插入DOM（作为前面的同级节点）。
     *
     * @参数 node 要添加的节点
     * @返回值 当前节点
     */
    public open func before(node: Node): Node

    /*
     * 在此节点之后将指定的HTML插入到DOM中（作为后面的同级）。
     *
     * @参数 html 要在此节点之前添加的html
     * @返回值 当前节点
     */
    public open func after(html: String): Node

    /*
     * 在此节点之后将指定的HTML插入到DOM中（作为后面的同级）。
     *
     * @参数 node 要添加的节点
     * @返回值 当前节点
     */
    public open func after(node: Node): Node

    /*
     * 将提供的HTML包裹此节点。
     *
     * @参数 node 要添加的节点
     * @返回值 当前节点
     * @throws ValidationException 当html为空
     */
    public open func wrap(html: String): Node

    /*
     * 从DOM中删除此节点，并将其子节点上移到节点的父节点中。这样做的效果是删除节点，但保留其子节点。
     *
     * @返回值 该节点的第一个子节点，如果没有子节点就为None
     */
    public func unwrap(): ?Node

    /*
     * 将DOM中的此节点替换为提供的节点。
     *
     * @参数 nodeIn 节点
     */
    public func replaceWith(nodeIn: Node): Unit

    /*
     * 检索此节点的同级节点。
     *
     * @返回值 此节点的同级节点列表。
     */
    public func siblingNodes(): ArrayList<Node>

    /*
     * 获取此节点的下一个同级节点。
     *
     * @返回值 返回下一个同级，如果这是最后一个同级则返回None
     */
    public func nextSibling(): ?Node

    /*
     * 获取此节点的上一个同级节点。
     *
     * @返回值 返回上一个同级，如果这是第一个同级则返回None
     */
    public func previousSibling(): ?Node

    /*
     * 获取此节点在其节点同级列表中的列表索引。例如，如果这是第一个节点，返回0。
     *
     * @返回值 在节点同级列表中的位置
     */
    public func siblingIndex(): Int64

    /*
     * 获取此节点的第一个子节点，如果没有，则获取None。
     *
     * @返回值 此节点的第一个子节点
     */
    public func firstChild(): ?Node

    /*
     * 获取此节点的最后一个子节点，如果没有，则获取None。
     *
     * @返回值 此节点的最后一个子节点
     */
    public func lastChild(): ?Node

    /*
     * 对该节点及其子节点执行深度优先遍历。
     *
     * @参数 nodeVisitor 在每个节点上执行的访问者回调
     * @返回值 此节点
     */
    public open func traverse(nodeVisitor: NodeVisitor): Node

    /*
     * 通过此节点及其子节点执行深度优先筛选。
     *
     * @参数 nodeFilter 在每个节点上执行的筛选器回调
     * @返回值 此节点
     */
    public open func filter(nodeFilter: NodeFilter): Node

    /*
     * 获取此节点的外部HTML。例如，在p元素上，可以返回p＞Para</p＞。
     *
     * @返回值 返回外部HTML
     */
    public open func outerHtml(): String

    /*
     * 将此节点及其子节点写入给定的StringBuilder。
     *
     * @参数 appendable 要写入的StringBuilder
     * @返回值 返回StringBuilder
     */
    public open func html(appendable: StringBuilder): StringBuilder

    /*
     * 获取解析此节点的原始输入源中的源范围（起始位置和结束位置）。位置在解析内容之前必须启用跟踪。对于一个元素，这将是开始标记的位置。
     *
     * @返回值 返回节点起点的范围
     */
    public func sourceRange(): SrcRange

    /*
     * 获取此节点的外部HTML。
     *
     * @返回值 外部HTML和outerHtml()相同
     */
    public open func toString(): String
    
    /*
     * hash值
     *
     * @返回值 对象的hash值
     */
    @OverflowWrapping
    public func hashCode(): Int64
    
    /*
     * 检查此节点是否与另一个节点具有相同的内容。如果节点的名称、属性和内容与其他节点；特别是其在树中的位置不会影响其相似性。
     *
     * @参数 o 要比较的其他对象
     * @返回值 如果此节点的内容与其他节点的内容相同返回true
     */
    public func hasSameValue(o: ?Object): Bool
    
    /*
     * 创建此节点及其所有子节点的独立深度副本。克隆的节点将没有兄弟节点或父节点。作为一个独立对象，对克隆或其任何子对象所做的任何更改都不会影响原始节点。
     *
     * @返回值 一个独立的克隆节点，包括任何子节点的克隆
     */
    public open func clone(): Node
    
    /*
     * 创建此节点的独立浅层副本。它的任何子节点（如果有）都不会被克隆，也不会有父节点或同级节点。
     *
     * @返回值 返回此节点的单个独立副本
     */
    public open func shallowClone(): Node
    
    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 that 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: Node): Bool

    /*
     * 对比入参对象和当前对象是否相等
     *
     * @参数 that 入参对象
     * @返回值 相等为true，不相等为false
     */
    public operator func ==(that: Node): Bool
}
```

### 示例

#### abstract class Node

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var doc: Document = Html4cj.parse("<a href=/foo>Hello</a>", "https://jsoup.org/")
    var a: Element = doc.select("a").first().getOrThrow()
    if (a.attr("href") == "/foo") {
        println("pass1")
    }
    if (a.attr("abs:href") == "https://jsoup.org/foo") {
        println("pass2")
    }
    if (a.hasAttr("abs:href")) {
        println("pass3")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
```

## HTML文档结构节点 - HTML元素Element

### 介绍

### 主要接口

#### class SrcRange

```cangjie
/*
 * 跟踪原始输入源中节点开始或结束的角色位置
 */
public class SrcRange <: Hashable & Equatable<SrcRange> & ToString {
    /*
     * 创建一个具有起始位置和结束位置的新范围。
     *
     * @参数 start 起始位置。
     * @参数 end 结束位置。
     */
    public init(start: SrcPosition, end: SrcPosition)

    /*
     * 获取此节点的起始位置。
     *
     * @返回值 起始位置。
     */
    public func start(): SrcPosition

    /*
     * 获取此节点的结束位置。
     *
     * @返回值 结束位置。
     */
    public func end(): SrcPosition

    /*
     * 测试在分析过程中是否跟踪了此源范围。
     *
     * @返回值 如果在解析过程中跟踪了这一点，则返回true，否则返回false
     */
    public func isTracked(): Bool

    /*
     * 跟踪节点的范围。
     *
     * @参数 node 要将此位置关联到的节点
     * @参数 start 如果这是起始范围。元素结束标记为false。
     */
    public func track(node: Node, start: Bool): Unit

    /*
     * hash值
     *
     * @返回值 对象的hash值
     */
    @OverflowWrapping
    public func hashCode(): Int64

    /*
     * 获取此SrcRange的String表示形式
     *
     * @返回值 字符串
     */
    public func toString(): String
   
    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 that 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: SrcRange): Bool
  
    /*
     * 对比入参对象和当前对象是否相等
     *
     * @参数 that 入参对象
     * @返回值 相等为true，不相等为false
     */
    public operator func ==(that: SrcRange): Bool
}
```

#### class SrcPosition

```cangjie
/*
 * 跟踪原始输入源中节点开始或结束的角色位置
 */
public class SrcPosition <: Hashable & Equatable<SrcPosition> & ToString {    
    /*
     * 创建一个新的SrcPositionn对象。
     *
     * @参数 pos 位置索引
     * @参数 lineNumber 行号
     * @参数 columnNumber 列编号
     */
    public init(pos: Int64, lineNumber: Int64, columnNumber: Int64)
    
    /*
     * 获取读取此位置的原始输入源的位置索引
     *
     * @返回值 位置索引
     */
    public func pos(): Int64
    
    /*
     * 获取读取此位置的原始输入源的行号
     *
     * @返回值 行号
     */
    public func lineNumber(): Int64
    
    /*
     * 获取读取此位置的原始输入源的列
     *
     * @返回值 列
     */
    public func columnNumber(): Int64
    
    /*
     * 测试在分析过程中是否跟踪了此位置。
     *
     * @返回值 如果在解析过程中跟踪了这一点，则返回true，否则返回false
     */
    public func isTracked(): Bool
    
    /*
     * 获取此位置的字符串表示形式，格式为{line,column:pos}
     *
     * @返回值 返回字符串
     */
    public func toString(): String
    
    /*
     * hash值
     *
     * @返回值 对象的hash值
     */
    @OverflowWrapping
    public func hashCode(): Int64
   
    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 that 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: SrcPosition): Bool
  
    /*
     * 对比入参对象和当前对象是否相等。
     *
     * @参数 that 入参对象。
     * @返回值 相等为true，不相等为false。
     */
    public operator func ==(that: SrcPosition): Bool
}
```

#### open class Element

```cangjie
/*
 * HTML元素由标记名、属性和子节点（包括文本节点和其他元素）组成。
 * 从元素中，您可以提取数据、遍历节点图和操作HTML。
 */
public open class Element <: Node & Equatable<Element> {
    /*
     * 构造方法
     *
     * @参数 tag 标签名称
     * @throws ValidationException 当tag为空
     */
    public init(tag: String)

    /*
     * 构造方法
     *
     * @参数 tag 标签名称
     * @参数 baseUri 基本URI
     * @参数 attributesValue 初始属性
     */
    public init(tag: Tag, baseUri: ?String, attributesValue: ?Attributes)

    /*
     * 构造方法
     *
     * @参数 tag 标签名称
     * @参数 baseUri 基本URI
     */
    public init(tag: Tag, baseUri: ?String)

    /*
     * 获取当前节点元素的所有属性。
     *
     * @返回值 属性
     */
    public override func attributes(): Attributes

    /*
     * 获取应用于当前节点的基本URI。
     *
     * @返回值 基本URI
     */
    public override func baseUri(): String

    /*
     * 获取当前节点包含的子节点数。
     *
     * @返回值 子节点数。
     */
    public override func childNodeSize(): Int64

    /*
     * 获取当前节点的节点名称。
     *
     * @返回值 节点名称。
     */
    public open override func nodeName(): String

    /*
     * 获取当前节点的标记名称。
     *
     * @返回值 标记名称。
     */
    public func tagName(): String

    /*
     * 获取当前节点的规范化名称。
     *
     * @返回值 规范化名称。
     */
    public override func normalName(): String

    /*
     * 更改（重命名）当前节点的标记。
     *
     * @参数 tagName 标记名称
     * @返回值 当前节点
     */
    public func tagName(tagName: String): Element

    /*
     * 获取当前节点的标记。
     *
     * @返回值 当前节点的标记。
     */
    public func tag(): Tag

    /*
     * 判断当前节点是否为块级结构
     *
     * @返回值 否为块级结构，true为块级结构，false不是块级结构
     */
    public func isBlock(): Bool

    /*
     * 获取当前节点的id属性。
     *
     * @返回值 id属性，如果不存在为""
     */
    public func id(): String

    /*
     * 设置当前节点的id属性。
     *
     * @参数 id id值
     * @返回值 当前节点
     */
    public func id(id: String): Element

    /*
     * 设置当前节点的属性值。如果当前节点已经有一个带有键的属性，则更新其值；否则，将添加一个新属性。
     *
     * @参数 attributeKey 属性键
     * @参数 attributeValue 属性值
     * @返回值 当前节点
     */
    public func attr(attributeKey: String, attributeValue: String): Element

    /*
     * 如果attributeValue为false，删除这条属性，如果attributeValue为true，添加这条属性，这条属性的值为None
     *
     * @参数 key 区分大小写的属性键（不为None）
     * @参数 value 布尔值
     * @返回值 当前节点
     */
    public func attr(attributeKey: String, attributeValue: Bool): Element

    /*
     * 获取当前节点的HTML5自定义数据属性。当前节点中每个具有以“data-”开头的键的属性都包含在数据集中。
     *
     * @返回值 “data-”开头迭代器
     */
    public func dataset(): Iterator<(String, ?String)>

    /*
     * 获取当前节点的父节点
     *
     * @返回值 当前节点的父节点
     */
    public func parentElement(): ?Element

    /*
     * 获取当前节点的父节点一直到根节点
     *
     * @返回值 当前节点的父节点列表
     */
    public func parents(): Elements

    /*
     * 获取当前节点在index位置的子节点
     *
     * @参数 index 位置
     * @返回值 当前节点在index位置的子节点
     */
    public func child(index: Int64): Element

    /*
     * 获取当前节点子节点的数量
     *
     * @返回值 当前节点子节点的数量
     */
    public func childrenSize(): Int64

    /*
     * 获取当前节点的子节点。
     *
     * @返回值 当前节点的子节点。
     */
    public func children(): Elements

    /*
     * 获取当前节点的子文本节点。
     *
     * @返回值 当前节点的子文本节点。
     */
    public func textNodes(): ArrayList<TextNode>

    /*
     * 获取当前节点的子数据节点。
     *
     * @返回值 当前节点的子数据节点。
     */
    public func dataNodes(): ArrayList<DataNode>

    /*
     * 查找与Selector CSS查询匹配的节点，并将此节点作为起始上下文。匹配的节点可以包括该节点或其任何子节点。
     *
     * @参数 cssQuery 类似CSS的Selector查询
     * @返回值 所有匹配到的节点列表
     * @throws ValidationException 当cssQuery为空
     */
    public func select(cssQuery: String): Elements

    /*
     * 查找与提供的Evaluator匹配的元素。
     * 这与select（String）具有相同的功能，但如果您多次（在许多文档上）运行相同的查询，并且希望节省重复解析CSS查询的开销，那么这可能会很有用。
     *
     * @参数 evaluator 查询器
     * @返回值 所有匹配到的节点列表
     */
    public func select(evaluator: Evaluator): Elements

    /*
     * 查找与Selector CSS查询匹配的第一个节点，并将该节点作为起始上下文。
     *
     * @参数 cssQuery cssQuery类似CSS的选择器查询
     * @返回值 匹配的第一个节点，没有则为None
     * @throws ValidationException 当cssQuery为空
     */
    public func selectFirst(cssQuery: String): ?Element

    /*
     * 查找与提供的Evaluator匹配的第一个节点，并将该节点作为起始上下文。
     *
     * @参数 evaluator 查询器
     * @返回值 匹配的第一个节点，没有则为None
     */
    public func selectFirst(evaluator: Evaluator): ?Element

    /*
     * 和selectFirst方法相同，匹配第一个节点，没有抛异常
     *
     * @参数 cssQuery cssQuery类似CSS的选择器查询
     * @返回值 匹配的第一个节点，没有则抛异常
     * @throws ValidationException 当cssQuery为空/匹配结果为空
     * @throws SelectorParseException 当选择器初始化失败
     */
    public func expectFirst(cssQuery: String): Element

    /*
     * 当前节点是否与给定的Selector CSS查询匹配
     *
     * @参数 cssQuery cssQuery类似CSS的选择器查询
     * @返回值 是否匹配
     * @throws SelectorParseException 当选择器初始化失败
     */
    public func check(cssQuery: String): Bool

    /*
     * 当前节点是否与给定的Evaluator查询匹配
     *
     * @参数 evaluator 查询器
     * @返回值 是否匹配
     */
    public func check(evaluator: Evaluator): Bool

    /*
     * 在当前节点的父级节点中查找最近的匹配节点，如果没有返回None
     *
     * @参数 cssQuery 选择器CSS查询
     * @返回值 返回匹配的父节点
     * @throws SelectorParseException 当选择器初始化失败
     */
    public func closest(cssQuery: String): ?Element

    /*
     * 在当前节点的父级节点中查找最近的匹配节点，如果没有返回None
     *
     * @参数 evaluator 查询器
     * @返回值 返回匹配的父节点
     */
    public func closest(evaluator: Evaluator): ?Element

    /*
     * 在当前节点的子节点的末尾插入一个节点。传入节点将被重新设置为父节点。
     *
     * @参数 child 子节点
     * @返回值 当前节点
     */
    public func appendChild(child: Node): Element

    /*
     * 在当前节点的子节点的末尾插入节点列表。
     *
     * @参数 child 子节点列表
     * @返回值 当前节点
     */
    public func appendChildren(children: Collection<Node>): Element

    /*
     * 将当前节点添加到提供的父节点中，作为其下一个子节点。
     *
     * @参数 parent 提供的父节点
     * @返回值 当前节点
     */
    public func appendTo(parent: Element): Element

    /*
     * 将传入的节点添加到当前节点的子节点开头
     *
     * @参数 child 子节点
     * @返回值 当前节点
     */
    public func prependChild(child: Node): Element

    /*
     * 将传入的节点列表添加到当前节点的子节点开头
     *
     * @参数 children 子节点列表
     * @返回值 当前节点
     */
    public func prependChildren(children: Collection<Node>): Element

    /*
     * 将传入的子节点插入到当前节点指定索引处的子结点中。
     *
     * @参数 index 插入索引
     * @参数 children 子节点列表
     * @返回值 当前节点
     */
    public func insertChildren(index: Int64, children: Collection<Node>): Element

    /*
     * 将传入的子节点插入到当前节点指定索引处的子结点中。
     *
     * @参数 index 插入索引
     * @参数 children 子节点列表
     * @返回值 当前节点
     */
    public func insertChildren(index: Int64, children: Array<Node>): Element

    /*
     * 通过标记名称创建一个新节点，并将其作为最后一个子节点添加到当前节点
     *
     * @参数 tagName 标记名称
     * @返回值 当前节点
     * @throws ValidationException 当tagName为空
     */
    public func appendElement(tagName: String): Element

    /*
     * 通过标记名称创建一个新节点，并将其作为第一个子节点添加到当前节点
     *
     * @参数 tagName 标记名称
     * @返回值 当前节点
     * @throws ValidationException 当tagName为空
     */
    public func prependElement(tagName: String): Element

    /*
     * 创建一个新的TextNode，并将其作为最后一个子节点添加到当前节点
     *
     * @参数 text 标记名称
     * @返回值 当前节点
     */
    public func appendText(text: String): Element

    /*
     * 创建一个新的TextNode，并将其作为第一个子节点添加到当前节点
     *
     * @参数 text 标记名称
     * @返回值 当前节点
     */
    public func prependText(text: String): Element

    /*
     * 将内部HTML添加到当前节点。将解析提供的HTML，并将每个节点附加到子节点的末尾。
     *
     * @参数 html HTML
     * @返回值 当前节点
     */
    public func append(html: String): Element

    /*
     * 将内部HTML添加到当前节点。将解析提供的HTML，并将每个节点附加到子节点的开头。
     *
     * @参数 html HTML
     * @返回值 当前节点
     */
    public func prepend(html: String): Element

    /*
     * 在当前节点之前将指定的HTML插入到DOM中。
     *
     * @参数 html HTML
     * @返回值 当前节点
     */
    public override func before(html: String): Element

    /*
     * 在当前节点之前将指定的节点插入到DOM中。
     *
     * @参数 node 节点
     * @返回值 当前节点
     */
    public override func before(node: Node): Element

    /*
     * 在当前节点之后将指定的HTML插入到DOM中。
     *
     * @参数 html HTML
     * @返回值 当前节点
     */
    public override func after(html: String): Element

    /*
     * 在当前节点之后将指定的节点插入到DOM中。
     *
     * @参数 node 节点
     * @返回值 当前节点
     */
    public override func after(node: Node): Element

    /*
     * 删除元素的所有子节点。
     *
     * @返回值 当前节点
     */
    public override func empty(): Element

    /*
     * 将提供的HTML包裹此当前节点
     *
     * @参数 html HTML
     * @返回值 当前节点
     * @throws ValidationException 当html为空
     */
    public override func wrap(html: String): Element

    /*
     * 获取一个CSS选择器，该选择器将唯一地选择此元素。
     *
     * @返回值 可用于检索选择器中的元素的CSS路径。
     */
    public func cssSelector(): String

    /*
     * 获取同级节点。如果当前节点没有同级节点，则返回一个空列表。当前节点本身不是同级节点，因此不会包含在返回的列表中。
     *
     * @返回值 同级节点列表
     */
    public func siblingElements(): Elements

    /*
     * 获取当前节点的下一个同级节点。
     *
     * @返回值 下一个同级节点，如果没有返回None。
     */
    public func nextElementSibling(): ?Element

    /*
     * 获取当前节点之后的每个同级节点。
     *
     * @返回值 当前节点之后的每个同级节点，或者如果没有下一个同级节点，则为空列表
     */
    public func nextElementSiblings(): Elements

    /*
     * 获取当前节点的上一个同级节点。
     *
     * @返回值 上一个同级节点，如果没有返回None。
     */
    public func previousElementSibling(): ?Element

    /*
     * 获取当前节点之前的每个同级节点。
     *
     * @返回值 当前节点之前的每个同级节点，或者如果没有上一个同级节点，则为空列表
     */
    public func previousElementSiblings(): Elements

    /*
     * 获取当前节点的第一个Element同级。这可能就是当前节点。
     *
     * @返回值 返回当前节点的第一个同级（也就是当前节点父节点的第一个子节点）
     */
    public func firstElementSibling(): Element

    /*
     * 获取当前节点在其节点同级列表中的列表索引。
     *
     * @返回值 在节点同级列表中的位置
     */
    public func elementSiblingIndex(): Int64

    /*
     * 获取当前节点的最后一个Element同级。这可能就是当前节点。
     *
     * @返回值 返回当前节点的最后一个同级（也就是当前节点父节点的最后一个子节点）
     */
    public func lastElementSibling(): Element

    /*
     * 获取当前节点的第一个子节点，如果没有子节点，返回None
     *
     * @返回值 第一个Element子节点，或者为None。
     */
    public func firstElementChild(): ?Element

    /*
     * 获取当前节点的最后一个子节点，如果没有子节点，返回None
     *
     * @返回值 最后一个Element子节点，或者为None。
     */
    public func lastElementChild(): ?Element

    /*
     * 查找具有指定标记名称的节点，包括当前节点下的节点和递归节点。
     *
     * @参数 tagName 要搜索的标记名称（不区分大小写）。
     * @返回值 节点列表
     * @throws ValidationException 当tagName为空
     */
    public func getElementsByTag(tagName: String): Elements

    /*
     * 按id查找的节点，包括当前节点下的节点和递归节点。
     *
     * @参数 id 要搜索的id。
     * @返回值 id匹配的第一个节点
     * @throws ValidationException 当id为空
     */
    public func getElementById(id: String): ?Element

    /*
     * 查找具有class的节点，包括当前节点下的节点和递归节点。不区分大小写。
     *
     * @参数 className class名称。
     * @返回值 具有所提供类名的节点，没有则为空。
     * @throws ValidationException 当className为空
     */
    public func getElementsByClass(className: String): Elements

    /*
     * 查找具有命名属性集的节点。不区分大小写。
     *
     * @参数 key 属性key
     * @返回值 具有此属性的节点，没有则为空。
     * @throws ValidationException 当key为空
     */
    public func getElementsByAttribute(key: String): Elements

    /*
     * 查找属性名称以提供的前缀开头的节点。
     *
     * @参数 key 属性key前缀
     * @返回值 具有此属性前缀的节点，没有则为空。
     * @throws ValidationException 当keyPrefix为空
     */
    public func getElementsByAttributeStarting(keyPrefix: String): Elements

    /*
     * 查找具有具有特定值的属性的节点。不区分大小写。
     *
     * @参数 key 属性key
     * @参数 value 属性value
     * @返回值 具有此属性key和属性value的节点，没有则为空。
     * @throws ValidationException 当key/value为空
     */
    public func getElementsByAttributeValue(key: String, value: String): Elements

    /*
     * 查找不具有具有特定值的属性的节点。不区分大小写。
     *
     * @参数 key 属性key
     * @参数 value 属性value
     * @返回值 不具有此属性key和属性value的节点，没有则为空。
     * @throws ValidationException 当key/value为空
     */
    public func getElementsByAttributeValueNot(key: String, value: String): Elements

    /*
     * 查找具有以值前缀开头的属性的节点。不区分大小写。
     *
     * @参数 key 属性key
     * @参数 valuePrefix 属性value前缀
     * @返回值 具有此属性key和属性value前缀的节点，没有则为空。
     * @throws ValidationException 当key/valuePrefix为空
     */
    public func getElementsByAttributeValueStarting(key: String, valuePrefix: String): Elements

    /*
     * 查找具有以值后缀结尾的属性的节点。不区分大小写。
     *
     * @参数 key 属性key
     * @参数 valueSuffix 属性value后缀
     * @返回值 具有此属性key和属性value后缀的节点，没有则为空。
     * @throws ValidationException 当key/valueSuffix为空
     */
    public func getElementsByAttributeValueEnding(key: String, valueSuffix: String): Elements

    /*
     * 查找具有其值包含匹配字符串的属性的节点。不区分大小写。
     *
     * @参数 key 属性key
     * @参数 matchValue 匹配的属性value字符串
     * @返回值 具有此属性key和匹配的属性value字符串的节点，没有则为空。
     * @throws ValidationException 当key/matchValue为空
     */
    public func getElementsByAttributeValueContaining(key: String, matchValue: String): Elements

    /*
     * 查找具有值与提供的正则表达式匹配的属性的节点。
     *
     * @参数 key 属性key
     * @参数 pattern 正则
     * @返回值 具有与此正则表达式匹配的属性的节点
     */
    public func getElementsByAttributeValueMatching(key: String, pattern: Regex): Elements

    /*
     * 查找具有值与提供的正则表达式匹配的属性的节点。
     *
     * @参数 key 属性key
     * @参数 regex 正则文本
     * @返回值 具有与此正则表达式匹配的属性的节点
     * @throws IllegalArgumentException 当正则初始化失败
     */
    public func getElementsByAttributeValueMatching(key: String, regex: String): Elements

    /*
     * 查找其同级索引小于所提供索引的节点。
     *
     * @参数 index 索引
     * @返回值 小于索引的节点
     */
    public func getElementsByIndexLessThan(index: Int64): Elements

    /*
     * 查找其同级索引大于所提供索引的节点。
     *
     * @参数 index 索引
     * @返回值 大于索引的节点
     */
    public func getElementsByIndexGreaterThan(index: Int64): Elements

    /*
     * 查找其同级索引等于所提供索引的节点。
     *
     * @参数 index 索引
     * @返回值 等于索引的节点
     */
    public func getElementsByIndexEquals(index: Int64): Elements

    /*
     * 查找包含指定字符串的节点。搜索不区分大小写。文本可以直接出现在节点中，也可以出现在其任何子节点中。
     *
     * @参数 searchText 查找字符串
     * @返回值 包含字符串的节点，不区分大小写。
     */
    public func getElementsContainingText(searchText: String): Elements

    /*
     * 查找直接包含指定字符串的节点。搜索不区分大小写。文本必须直接出现在节点中，而不能出现在其任何子节点中。
     *
     * @参数 searchText 查找字符串
     * @返回值 包含字符串的节点，不区分大小写。
     */
    public func getElementsContainingOwnText(searchText: String): Elements

    /*
     * 查找文本与提供的正则表达式匹配的节点。
     *
     * @参数 pattern 正则
     * @返回值 正则匹配的节点
     */
    public func getElementsMatchingText(pattern: Regex): Elements

    /*
     * 查找文本与提供的正则表达式匹配的节点。
     *
     * @参数 regex 正则字符串
     * @返回值 正则匹配的节点
     * @throws IllegalArgumentException 当正则初始化失败
     */
    public func getElementsMatchingText(regex: String): Elements

    /*
     * 查找其自身文本与提供的正则表达式匹配的节点。
     *
     * @参数 pattern 正则字符串
     * @返回值 正则匹配的节点
     */
    public func getElementsMatchingOwnText(pattern: Regex): Elements

    /*
     * 查找其自身文本与提供的正则表达式匹配的节点。
     *
     * @参数 regex 正则字符串
     * @返回值 正则匹配的节点
     * @throws IllegalArgumentException 当正则初始化失败
     */
    public func getElementsMatchingOwnText(regex: String): Elements

    /*
     * 查找当前节点下的所有节点
     *
     * @返回值 所有节点
     */
    public func getAllElements(): Elements

    /*
     * 获取此元素及其所有子元素的标准化组合文本。将对空白进行规范化和修剪。
     *
     * @返回值 解码的、标准化的文本或空字符串。
     */
    public func text(): String

    /*
     * 获取此元素及其子元素的非规范化解码文本，仅包括原始源中存在的任何换行符和空格。
     *
     * @返回值 解码的非标准化文本
     */
    public func wholeText(): String

    /*
     * 获取此元素的非规范化解码文本，不包括任何子元素，只包括原始源中存在的任何换行符和空格。
     *
     * @返回值 已解码的非规范化文本，它是此元素的直接子级
     */
    public func wholeOwnText(): String

    /*
     * 仅获取此元素所拥有的（规范化的）文本；无法获得所有子项的组合文本。
     *
     * @返回值 解码文本，或者如果没有则为空字符串。
     */
    public func ownText(): String

    /*
     * 设置当前节点的文本。任何现有内容（文本或元素）都将被清除。
     *
     * @参数 text 文本
     * @返回值 当前节点
     */
    public open func text(text: String): Element

    /*
     * 检查当前节点或其任何子节点是否包含非空白文本。
     *
     * @返回值 如果节点具有非空白文本内容，则返回true，否则为false。
     */
    public func hasText(): Bool

    /*
     * 获取当前节点的组合数据。
     *
     * @返回值 组合数据，如果没有返回空字符串
     */
    public func data(): String

    /*
     * 获取此元素的“class”属性的文字值，该属性可能包括多个用空格分隔的类名。
     *
     * @返回值 文字类属性，或者如果没有设置类属性，则为空字符串。
     */
    public func className(): String

    /*
     * 获取每个元素的类名。
     *
     * @返回值 类名集，如果没有类属性则为空
     */
    public func classNames(): Set<String>

    /*
     * 将当前节点的class属性设置为提供的类名。
     *
     * @参数 classNames 集合
     * @返回值 当前节点
     */
    public func classNames(classNames: Set<String>): Element

    /*
     * 测试当前节点是否具有类。不区分大小写。
     *
     * @参数 className 要检查的类的名称
     * @返回值 如果有，则返回true，如果没有，则返回false
     */
    public func hasClass(className: String): Bool

    /*
     * 将类名添加到当前节点的class属性中。
     *
     * @参数 className 要添加的类的名称
     * @返回值 当前节点
     */
    public func addClass(className: String): Element

    /*
     * 从当前节点的class属性中删除类名。
     *
     * @参数 className 要删除的类的名称
     * @返回值 当前节点
     */
    public func removeClass(className: String): Element

    /*
     * 在当前节点的class属性上切换类名：如果存在，则将其移除；否则添加它。
     *
     * @参数 className 要切换的类的名称
     * @返回值 当前节点
     */
    public func toggleClass(className: String): Element

    /*
     * 获取表单元素（input、textarea等）的值。
     *
     * @返回值 返回表单元素的值，如果未设置，则返回空字符串。
     */
    public func val(): String

    /*
     * 设置表单元素（输入、文本区域等）的值。
     *
     * @参数 value 要设置的值
     * @返回值 当前节点
     */
    public func val(value: String): Element

    /*
     * 获取此元素的结束（结束）标记的源范围（起始位置和结束位置）。
     *
     * @返回值 返回这个元素的结束标记的范围
     */
    public func endSourceRange(): SrcRange

    /*
     * 检索当前节点的内部HTML。
     *
     * @返回值 HTML字符串。
     */
    public func html(): String

    /*
     * 将当前节点及其子节点写入给定的StringBuilder。
     *
     * @参数 appendable StringBuilder。
     * @返回值 StringBuilder。
     */
    public override func html(appendable: StringBuilder): StringBuilder

    /*
     * 设置当前节点的内部HTML。首先清除现有的HTML。
     *
     * @参数 html HTML字符串。
     * @返回值 当前节点。
     */
    public func html(html: String): Element

    /*
     * 创建此节点及其所有子节点的独立深度副本。克隆的节点将没有兄弟节点或父节点。作为一个独立对象，对克隆或其任何子对象所做的任何更改都不会影响原始节点。
     *
     * @返回值 一个独立的克隆节点，包括任何子节点的克隆
     */
    public open override func clone(): Element
    
    /*
     * 创建此节点的独立浅层副本。它的任何子节点（如果有）都不会被克隆，也不会有父节点或同级节点。
     *
     * @返回值 返回此节点的单个独立副本
     */
    public open override func shallowClone(): Element

    /*
     * 清除此节点中的所有属性。
     *
     * @返回值 当前节点
     */
    public override func clearAttributes(): Element

    /*
     * 从该节点中删除一个属性。
     *
     * @参数 attributeKey 要删除的属性。
     * @返回值 当前节点
     */
    public override func removeAttr(attributeKey: String): Element

    /*
     * 获取此节点的根节点
     *
     * @返回值 此节点的根节点。
     */
    public override func root(): Element

    /*
     * 对该节点及其子节点执行深度优先遍历。
     *
     * @参数 nodeVisitor 在每个节点上执行的访问者回调
     * @返回值 此节点
     */
    public override func traverse(nodeVisitor: NodeVisitor): Element

    /*
     * 通过此节点及其子节点执行深度优先筛选。
     *
     * @参数 nodeFilter 在每个节点上执行的筛选器回调
     * @返回值 此节点
     */
    public override func filter(nodeFilter: NodeFilter): Element
    
    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 that 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: Element): Bool

    /*
     * 对比入参对象和当前对象是否相等
     *
     * @参数 that 入参对象
     * @返回值 相等为true，不相等为false
     */
    public operator func ==(that: Element): Bool
}
```

### 示例

#### class SrcRange

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
    var srcPosition1: SrcPosition = SrcPosition(20, 2, 2)
    var srcRange: SrcRange = SrcRange(srcPosition, srcPosition1)
    if (srcRange.start() == srcPosition) {
        println("pass1")
    }    
    if (srcRange.end() == srcPosition1) {
        println("pass2")
    }   
    if (srcRange.isTracked()) {
        println("pass3")
    }
    if (srcRange == srcRange) {
        println("pass4")
    }
    if (srcRange.toString() == "1,1:10-2,2:20") {
        println("pass5")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
```

#### class SrcPosition

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
    var srcPosition1: SrcPosition = SrcPosition(20, 2, 2)
    if (srcPosition != srcPosition1) {
        println("pass1")
    }  
    if (srcPosition.pos() == 10) {
        println("pass2")
    } 
    if (srcPosition.lineNumber() == 1) {
        println("pass3")
    } 
    if (srcPosition.columnNumber() == 1) {
        println("pass4")
    } 
    if (srcPosition.isTracked()) {
        println("pass5")
    } 

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
```

#### class Element

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    let p1: Tag = Tag.valueOf("P")
    var element1: Element = Element(p1, "")
    if (element1.baseUri() == "") {
        println("pass1")
    }
    if (element1.childNodeSize() == 0) {
        println("pass2")
    }
    if (element1.nodeName() == "P") {
        println("pass3")
    }
    if (element1.tag() == p1) {
        println("pass4")
    }
    if (element1.tagName() == "P") {
        println("pass5")
    }
    if (element1.isBlock()) {
        println("pass6")
    }
    var attributes2: Attributes = Attributes()
    attributes2.put("id", "1")
    attributes2.put("class", "html")
    let p2: Tag = Tag.valueOf("P")
    var element2: Element = Element(p2, "", attributes2)
    if (element2.id() == "1") {
        println("pass7")
    }
    element2.id("2")
    if (element2.id() == "2") {
        println("pass8")
    }
    var element3: Element = Element("body")
    var element4: Element = Element("p0")
    var element5: Element = Element("p1")
    var element6: Element = Element("p2")
    var element7: Element = Element("p3")
    var element8: Element = Element("p4")
    element3.appendChild(element4)
    element3.appendChild(element5)
    element3.prependChild(element6)
    if (element3.childrenSize() == 3) {
        println("pass9")
    }
    element4.before(element7)
    element4.after(element8)
    if (element3.childrenSize() == 5) {
        println("pass10")
    }
    element3.empty()
    if (element3.childrenSize() == 0) {
        println("pass11")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
pass9
pass10
pass11
```

## HTML文档结构节点 - HTML 文档Document

### 介绍

### 主要接口

#### class Document

```cangjie
/*
 * HTML文档。
 */
public class Document <: Element & Equatable<Document> {
    /*
     * 创建一个新的空文档。
     *
     * @参数 baseUri 文档的基本URI
     */
    public init(baseUri: String)

    /*
     * 创建一个有效的、空的文档外壳，适合向其中添加更多元素。
     *
     * @参数 baseUri 文档的基本URI
     * @返回值 文档，包含html、head和body元素。
     */
    public static func createShell(baseUri: String): Document

    /*
     * 获取分析此文档的URL。如果起始URL是重定向，这将返回提供文档的最终URL。
     *
     * @返回值 返回位置
     */
    public func location(): String

    /*
     * 返回此文档的doctype。
     *
     * @返回值 文档类型，如果未设置则为None
     */
    public func documentType(): ?DocumentType

    /*
     * 获取此文档的head元素。
     *
     * @返回值 head元素。
     */
    public func head(): Element

    /*
     * 获取此文档的body元素。
     *
     * @返回值 body元素。
     */
    public func body(): Element

    /*
     * 获取此文档中包含的每个表单元素。
     *
     * @返回值 返回一个FormElement对象列表，如果没有，则该列表将为空。
     */
    public func forms(): ArrayList<FormElement>

    /*
     * 选择此文档中与查询匹配的第一个FormElement。
     *
     * @参数 cssQuery 选择器CSS查询
     * @返回值 返回第一个匹配的表单元素。
     * @throws ValidationException 当cssQuery为空
     */
    public func expectForm(cssQuery: String): ?FormElement

    /*
     * 获取文档的title元素的字符串内容。
     *
     * @返回值 标题，如果未设置，则为空字符串。
     */
    public func title(): String

    /*
     * 设置文档的title元素。更新现有元素，如果标题不存在则添加标题。
     *
     * @参数 title 要设置为title的字符串。
     */
    public func title(title: String): Unit

    /*
     * 使用此文档的基本uri创建一个新的Element。
     *
     * @参数 tagName 节点标签名称
     * @返回值 新节点
     */
    public func createElement(tagName: String): Element

    /*
     * 获取此节点的外部HTML。例如，在p元素上，可以返回p＞Para</p＞。
     *
     * @返回值 返回外部HTML
     */
    public override func outerHtml(): String

    /*
     * 设置当前节点的文本。任何现有内容（文本或元素）都将被清除。
     *
     * @参数 text 文本
     * @返回值 当前节点
     */
    public override func text(text: String): Element

    /*
     * 获取当前节点的节点名称。
     *
     * @返回值 节点名称。
     */
    public override func nodeName(): String

    /*
     * 设置此文档中使用的字符集。
     *
     * @参数 charset charset字符集
     */
    public func charset(charset: String): Unit

    /*
     * 返回此文档中使用的字符集。
     *
     * @返回值 当前字符集。
     */
    public func charset(): String

    /*
     * 设置此文档中具有字符集信息的元素是否在通过进行更改时更新。
     *
     * @参数 update 如果为true，则根据字符集更新的元素会更改，如果不是，则为false
     */
    public func updateMetaCharsetElement(update: Bool): Unit

    /*
     * 返回此文档中具有字符集信息的元素是否在通过进行更改时更新。
     *
     * @返回值 如果节点在字符集更改时更新，则返回true，否则返回false
     */
    public func updateMetaCharsetElement(): Bool

    /*
     * 创建此节点及其所有子节点的独立深度副本。克隆的节点将没有兄弟节点或父节点。作为一个独立对象，对克隆或其任何子对象所做的任何更改都不会影响原始节点。
     *
     * @返回值 一个独立的克隆节点，包括任何子节点的克隆
     */
    public override func clone(): Document
    
    /*
     * 创建此节点的独立浅层副本。它的任何子节点（如果有）都不会被克隆，也不会有父节点或同级节点。
     *
     * @返回值 返回此节点的单个独立副本
     */
    public override func shallowClone(): Document
    
    /*
     * 获取文档的当前输出设置。
     *
     * @返回值 当前输出设置。
     */
    public func outputSettings(): DocumentOutputSettings
    
    /*
     * 设置文档的输出设置。
     *
     * @参数 documentOutputSettings 设置新的输出设置。
     * @返回值 当前文档
     */
    public func outputSettings(documentOutputSettings: DocumentOutputSettings): Document
    
    /*
     * 获取QuirksMode枚举
     *
     * @参数 QuirksMode枚举
     */
    public func quirksMode(): QuirksMode
    
    /*
     * 设置QuirksMode枚举
     *
     * @参数 quirksModeValue 设置新的QuirksMode枚举
     * @返回值 当前文档
     */
    public func quirksMode(quirksModeValue: QuirksMode): Document
    
    /*
     * 获取用于解析此文档的解析器。
     *
     * @返回值 解析器
     */
    public func parser(): Parser

    /*
     * 设置用于创建此文档的解析器。当需要在此文档中进行进一步解析时，将使用此解析器。
     *
     * @参数 parserValue 配置的解析器
     * @返回值 当前文档
     */
    public func parser(parserValue: Parser): Document
    
    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 that 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: Document): Bool

    /*
     * 对比入参对象和当前对象是否相等
     *
     * @参数 that 入参对象
     * @返回值 相等为true，不相等为false
     */
    public operator func ==(that: Document): Bool
}
```

#### enum QuirksMode

```cangjie
public enum QuirksMode <: Equatable<QuirksMode> & ToString {
    | noQuirks
    | quirks
    | limitedQuirks
  
    /*
     * 对比入参对象和当前对象是否相等
     *
     * @参数 that 入参对象
     * @返回值 相等为true，不相等为false
     */
    public operator func ==(that: QuirksMode): Bool
   
    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 that 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: QuirksMode): Bool

    /*
     * 获取此枚举的值。
     *
     * @返回值 枚举的值
     */
    public func toString(): String
}
```

#### enum Syntax

```cangjie
public enum Syntax <: Equatable<Syntax> & ToString {
    | htmlSyntax
    | xmlSyntax
  
    /*
     * 对比入参对象和当前对象是否相等
     *
     * @参数 that 入参对象
     * @返回值 相等为true，不相等为false
     */
    public operator func ==(that: Syntax): Bool
   
    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 that 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: Syntax): Bool

    /*
     * 获取此枚举的值。
     *
     * @返回值 枚举的值
     */
    public func toString(): String
}
```

#### enum EscapeMode

```cangjie
public enum EscapeMode <: Equatable<EscapeMode> & ToString {
    | xhtml
    | base
    | extended
   
    /*
     * 对比入参对象和当前对象是否不相等
     *
     * @参数 that 入参对象
     * @返回值 不相等为true，相等为false
     */
    public operator func !=(that: EscapeMode): Bool
  
    /*
     * 对比入参对象和当前对象是否相等
     *
     * @参数 that 入参对象
     * @返回值 相等为true，不相等为false
     */
    public operator func ==(that: EscapeMode): Bool

    /*
     * 获取此枚举的值。
     *
     * @返回值 枚举的值
     */
    public func toString(): String
}
```

#### class DocumentOutputSettings

```cangjie
public class DocumentOutputSettings {
    /*
     * 构造方法。
     */
    public init()

    /*
     * 获取文档的当前HTML转义模式。
     *
     * @返回值 文档的当前转义模式。
     */
    public func escapeMode(): EscapeMode

    /*
     * 设置文档的当前HTML转义模式。
     *
     * @参数 escapeModeValue HTML转义模式。
     * @返回值 文档的输出设置。
     */
    public func escapeMode(escapeModeValue: EscapeMode): DocumentOutputSettings

    /*
     * 获取文档的当前输出字符集。
     *
     * @返回值 文档的当前字符集。
     */
    public func charset(): String

    /*
     * 设置文档的当前输出字符集。
     *
     * @参数 coreCharset 字符集。
     * @返回值 文档的输出设置。
     */
    public func charset(coreCharset: String): DocumentOutputSettings

    /*
     * 获取文档的当前输出语法。
     *
     * @返回值 当前输出语法。
     */
    public func syntax(): Syntax

    /*
     * 设置文档的当前输出语法。
     *
     * @参数 syntaxValue 输出语法。
     * @返回值 文档的输出设置。
     */
    public func syntax(syntaxValue: Syntax): DocumentOutputSettings

    /*
     * 是否启用了漂亮打印。默认值为true。如果禁用，HTML输出方法将不会重新格式化输出，并且输出通常看起来像输入。
     *
     * @返回值 启用了漂亮打印为true，否则为false。
     */
    public func prettyPrint(): Bool

    /*
     * 设置是否启用了漂亮打印。
     *
     * @参数 prettyPrintValue 是否启用了漂亮打印。
     * @返回值 文档的输出设置。
     */
    public func prettyPrint(prettyPrintValue: Bool): DocumentOutputSettings

    /*
     * 是否启用了大纲模式。默认值为false。如果启用，HTML输出方法将所有标记视为块。
     *
     * @返回值 启用了大纲模式为true，否则为false。
     */
    public func outline(): Bool

    /*
     * 设置是否启用大纲模式。
     *
     * @参数 outlineMode 是否启用大纲模式。
     * @返回值 文档的输出设置。
     */
    public func outline(outlineMode: Bool): DocumentOutputSettings

    /*
     * 获取当前标记缩进量，在漂亮打印时使用。
     *
     * @返回值 当前标记缩进量。
     */
    public func indentAmount(): Int64

    /*
     * 设置当前标记缩进量。
     *
     * @参数 indentAmount 标记缩进量。
     * @返回值 文档的输出设置。
     * @throws ValidationException 当indentAmount<0
     */
    public func indentAmount(indentAmount: Int64): DocumentOutputSettings

    /*
     * 获取当前的最大填充量，在漂亮的打印时使用，这样嵌套非常深的节点就不会得到疯狂的填充量。
     *
     * @返回值 当前的最大填充量。
     */
    public func maxPaddingWidth(): Int64

    /*
     * 设置最大填充量。
     *
     * @参数 maxPaddingWidthValue 最大填充量。
     * @返回值 文档的输出设置
     * @throws ValidationException 当maxPaddingWidthValue<-1
     */
    public func maxPaddingWidth(maxPaddingWidthValue: Int64): DocumentOutputSettings

    /*
     * 克隆当前对象，返回新的对象
     *
     * @返回值 新的对象
     */
    public func clone(): DocumentOutputSettings
}
```

### 示例

#### class Document

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var doc: Document = Html4cj.parse("<p>Hello</p>")
    doc.text("Replaced")
    if (doc.text() == "Replaced") {
        println("pass1")
    }
    if (doc.body().text() == "Replaced") {
        println("pass2")
    }
    if (doc.select("head").size == 1) {
        println("pass3")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
```

#### enum QuirksMode

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var quirksMode1: QuirksMode = QuirksMode.noQuirks
    var quirksMode2: QuirksMode = QuirksMode.quirks
    var quirksMode3: QuirksMode = QuirksMode.limitedQuirks
    if ("noQuirks" == quirksMode1.toString()) {
        println("pass1")
    }
    if ("quirks" == quirksMode2.toString()) {
        println("pass2")
    }
    if ("limitedQuirks" == quirksMode3.toString()) {
        println("pass3")
    }
    if (quirksMode1 != quirksMode2) {
        println("pass4")
    }
    if (quirksMode3 == quirksMode3) {
        println("pass5")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
```

#### enum Syntax

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var syntax1: Syntax = Syntax.htmlSyntax
    var syntax2: Syntax = Syntax.xmlSyntax
    if ("htmlSyntax" == syntax1.toString()) {
        println("pass1")
    }
    if ("xmlSyntax" == syntax2.toString()) {
        println("pass2")
    }
    if (syntax1 != syntax2) {
        println("pass3")
    }
    if (syntax2 == syntax2) {
        println("pass4")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
```

#### enum EscapeMode

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var escapeMode1: EscapeMode = EscapeMode.xhtml
    var escapeMode2: EscapeMode = EscapeMode.base
    var escapeMode3: EscapeMode = EscapeMode.extended
    if ("xhtml" == escapeMode1.toString()) {
        println("pass1")
    }
    if ("base" == escapeMode2.toString()) {
        println("pass2")
    }
    if ("extended" == escapeMode3.toString()) {
        println("pass3")
    }
    if (escapeMode1 != escapeMode2) {
        println("pass4")
    }
    if (escapeMode3 == escapeMode3) {
        println("pass5")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
```

#### class DocumentOutputSettings

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var documentOutputSettings: DocumentOutputSettings = DocumentOutputSettings()
    if (EscapeMode.base == documentOutputSettings.escapeMode()) {
        println("pass1")
    }
    documentOutputSettings.escapeMode(EscapeMode.xhtml)
    if (EscapeMode.xhtml == documentOutputSettings.escapeMode()) {
        println("pass2")
    }
    if ("UTF-8" == documentOutputSettings.charset()) {
        println("pass3")
    }
    documentOutputSettings.charset("ASCII")
    if ("ASCII" == documentOutputSettings.charset()) {
        println("pass4")
    }
    if (Syntax.htmlSyntax == documentOutputSettings.syntax()) {
        println("pass5")
    }
    documentOutputSettings.syntax(Syntax.xmlSyntax)
    if (Syntax.xmlSyntax == documentOutputSettings.syntax()) {
        println("pass6")
    }
    if (documentOutputSettings.prettyPrint()) {
        println("pass7")
    }
    documentOutputSettings.prettyPrint(false)
    if (!documentOutputSettings.prettyPrint()) {
        println("pass8")
    }
    if (!documentOutputSettings.outline()) {
        println("pass9")
    }
    documentOutputSettings.outline(true)
    if (documentOutputSettings.outline()) {
        println("pass10")
    }
    if (1 == documentOutputSettings.indentAmount()) {
        println("pass11")
    }
    documentOutputSettings.indentAmount(10)
    if (10 == documentOutputSettings.indentAmount()) {
        println("pass12")
    }
    if (30 == documentOutputSettings.maxPaddingWidth()) {
        println("pass13")
    }
    documentOutputSettings.maxPaddingWidth(10)
    if (10 == documentOutputSettings.maxPaddingWidth()) {
        println("pass14")
    }

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
pass9
pass10
pass11
pass12
pass13
pass14
```

## HTML文档结构节点 - 其他节点数据结构

### 介绍

### 主要接口

#### abstract open class LeafNode

```cangjie
public abstract open class LeafNode <: Node {
    /*
     * 获取元素的所有属性。
     *
     * @返回值 属性
     */
    public override func attributes(): Attributes

    /*
     * 通过属性的键获取属性的值。
     *
     * @参数 key 属性键
     * @返回值 如果时true代表有父节点，否则没有
     */
    public override func attr(key: String): String

    /*
     * 设置属性键值对
     *
     * @参数 key 属性键
     * @参数 value 属性值
     * @返回值 当前节点
     */
    public override func attr(key: String, value: String): Node

    /*
     * 检查是否有任何匹配的元素定义了此属性.
     * @param attributeKey 属性key
     * @return Bool
     */
    public override func hasAttr(key: String): Bool

    /*
     * 从该节点中删除一个属性。
     *
     * @参数 attributeKey 要删除的属性。
     * @返回值 当前节点
     */
    public override func removeAttr(key: String): Node

    /*
     * 从可能是相对的URL属性中获取绝对URL
     *
     * @参数 baseUri 属性键
     * @返回值 如果可以生成，则为绝对URL；如果属性丢失或无法成功生成URL，则为空字符串
     */
    public override func absUrl(key: String): String

    /*
     * 获取应用于此节点的基本URI。
     *
     * @返回值 基本URI
     */
    public override func baseUri(): String

    /*
     * 获取此节点包含的子节点数。
     *
     * @返回值 此节点包含的子节点数。
     */
    public override func childNodeSize(): Int64

    /*
     * 删除此节点的所有子节点。
     *
     * @返回值 当前节点。
     */
    public override func empty(): Node
}
```

#### class FormElement

```cangjie
/*
 * HTML表单元素提供了对与其相关联的表单字段/控件的现成访问。
 */
public class FormElement <: Element {
    /*
     * 创建一个新的独立表单节点。
     *
     * @参数 tag 标记。
     * @参数 baseUri 基本URI。
     * @参数 attributes 初始属性。
     */
    public init(tag: Tag, baseUri: ?String, attributes: ?Attributes)

    /*
     * 获取与此表单节点关联的表单节点的列表。
     *
     * @返回值 与此表单关联的表单控件节点的列表。
     */
    public func elements(): Elements

    /*
     * 添加节点到当前节点
     *
     * @参数 element 表单节点控件
     * @返回值 当前表单节点
     */
    public func addElement(element: Element): FormElement

    /*
     * 克隆复制一个新的独立表单节点。
     *
     * @返回值 新的对象
     */
    public override func clone(): FormElement 
}
```

#### class PseudoTextElement

```cangjie
/*
 * 将TextNode表示为Element,
 */
public class PseudoTextElement <: Element {
    /*
     * 创建一个新的节点。
     *
     * @参数 tag 标记。
     * @参数 baseUri 基本URI。
     * @参数 attributes 初始属性。
     */
    public init(tag: Tag, baseUri: String, attributes: Attributes)
}
```

#### open class TextNode

```cangjie
/*
 * 一个文本节点。
 */
public open class TextNode <: LeafNode {
    /*
     * 创建一个新的TextNode，表示提供的（未编码的）文本）。
     *
     * @参数 text 原始文本。
     */
    public init(text: String)

    /*
     * 获取当前节点的节点名称。
     *
     * @返回值 节点名称。
     */
    public open func nodeName(): String

    /*
     * 获取此文本节点的文本内容。
     *
     * @返回值 文本内容。
     */
    public open func text(): String

    /*
     * 设置此文本节点的文本内容。
     *
     * @参数 text 文本内容。
     * @返回值 当前节点
     */
    public func text(text: String): TextNode

    /*
     * 获取此文本节点的（未编码的）文本，包括原始文本中的任何换行符和空格。
     *
     * @返回值 文本内容。
     */
    public func getWholeText(): String

    /*
     * 测试这个文本节点是空白的——也就是说，是空的还是只有空白（包括换行符）。
     *
     * @返回值 如果此文档为空或仅为空白，则返回true；如果包含任何文本内容，则返回false。
     */
    public func isBlank(): Bool

    /*
     * 按指定的字符串偏移量将此文本节点拆分为两个节点。
     *
     * @参数 offset 字符串偏移量。
     * @返回值 新创建的文本节点
     */
    public func splitText(offset: Int64): TextNode

    /*
     * 获取此节点的HTML。
     *
     * @返回值 字符串
     */
    public func toString(): String

    /*
     * 克隆复制一个新的独立文本节点。
     *
     * @返回值 新的对象
     */
    public open override func clone(): TextNode

    /*
     * 从HTML编码（又称转义）的数据创建一个新的TextNode。
     *
     * @参数 encodedText 编码HTML的文本
     * @返回值 新的对象
     */
    public static func createFromEncoded(encodedText: String): TextNode
}
```

#### class CDataNode

```cangjie
/*
 * 字符数据节点，支持CDATA部分。
 */
public class CDataNode <: TextNode {
    /*
     * 创建一个新的CDataNode。
     *
     * @参数 text 文本。
     */
    public init(text: String)

    /*
     * 获取当前节点的节点名称。
     *
     * @返回值 节点名称。
     */
    public override func nodeName(): String

    /*
     * 获取此CDataNode的未编码、非规范化的文本内容。
     *
     * @返回值 未编码、未规范化的文本。
     */
    public override func text(): String

    /*
     * 克隆复制一个新的节点。
     *
     * @返回值 新的对象
     */
    public override func clone(): CDataNode
}
```

#### class Comment

```cangjie
/*
 * 注释节点。
 */
public class Comment <: LeafNode {
    /*
     * 创建一个新的注释节点。
     *
     * @参数 text 注释的内容。
     */
    public init(text: String)

    /*
     * 获取当前节点的节点名称。
     *
     * @返回值 节点名称。
     */
    public override func nodeName(): String

    /*
     * 获取当前节点的注释内容。
     *
     * @返回值 注释内容。
     */
    public func getData(): String

    /*
     * 设置当前节点的注释内容。
     *
     * @参数 data 注释内容。
     * @返回值 当前节点。
     */
    public func setData(data: String): Comment

    /*
     * 获取此当前节点的文本内容。
     *
     * @返回值 文本。
     */
    public func toString(): String

    /*
     * 克隆复制一个新的节点。
     *
     * @返回值 新的对象
     */
    public override func clone(): Comment

    /*
     * 检查此注释是否看起来像XML声明。
     *
     * @返回值 如果它看起来像是一个XML声明，为true，否则为false。
     */
    public func isXmlDeclaration(): Bool

    /*
     * 尝试将此注释强制转换为XML Declaration节点。
     *
     * @返回值 如果可以解析为XML声明，则返回一个XML声明，否则为None。
     */
    public func asXmlDeclaration(): ?XmlDeclaration
}
```

#### class DataNode

```cangjie
/*
 * 一个数据节点，用于样式、脚本标记等的内容
 */
public class DataNode <: LeafNode {
    /*
     * 创建一个新的DataNode。
     *
     * @参数 text 内容。
     */
    public init(data: String)

    /*
     * 获取当前节点的节点名称。
     *
     * @返回值 节点名称。
     */
    public override func nodeName(): String

    /*
     * 获取此节点的数据内容。
     *
     * @返回值 数据内容。
     */
    public func getWholeData(): String

    /*
     * 设置此节点的数据内容。
     *
     * @参数 data 数据内容
     * @返回值 当前节点
     */
    public func setWholeData(data: String): DataNode

    /*
     * 获取此当前节点的文本内容。
     *
     * @返回值 文本。
     */
    public func toString(): String

    /*
     * 克隆复制一个新的节点。
     *
     * @返回值 新的对象
     */
    public override func clone(): DataNode
}
```

#### class DocumentType

```cangjie
/*
 * DOCTYPE节点。
 */
public class DocumentType <: LeafNode { 
    /*
     * public常量字符串。
     */
    public static let PUBLIC_KEY: String = "PUBLIC"

    /*
     * system常量字符串。
     */
    public static let SYSTEM_KEY: String = "SYSTEM"

    /*
     * 创建一个新的doctype节点。
     *
     * @参数 name 名称。
     * @参数 publicId 公共ID。
     * @参数 systemId 系统ID。
     */
    public init(name: String, publicId: String, systemId: String)

    /*
     * 设置发布系统密钥。
     *
     * @参数 value 发布系统密钥。
     */
    public func setPubSysKey(value: ?String): Unit

    /*
     * 获取此doctype的名称
     *
     * @返回值 doctype的名称
     */
    public func name(): String

    /*
     * 获取此doctype的公共ID
     *
     * @返回值 公共ID
     */
    public func publicId(): String

    /*
     * 获取此doctype的系统ID
     *
     * @返回值 系统ID
     */
    public func systemId(): String

    /*
     * 获取当前节点的节点名称。
     *
     * @返回值 节点名称。
     */
    public override func nodeName(): String
}
```

#### class XmlDeclaration

```cangjie
/*
 * XML声明。
 */
public class XmlDeclaration <: LeafNode {
    /*
     * 创建新的XML声明。
     *
     * @参数 name 名称。
     * @参数 isProcessingInstruction 是否正在处理指令。
     */
    public init(name: String, isProcessingInstruction: Bool)

    /*
     * 获取当前节点的节点名称。
     *
     * @返回值 节点名称。
     */
    public override func nodeName(): String

    /*
     * 获取当前节点的名称。
     *
     * @返回值 当前节点的名称。
     */
    public func name(): String

    /*
     * 获取未编码的XML声明。
     *
     * @返回值 XML声明。
     */
    public func getWholeDeclaration(): String

    /*
     * 获取此当前节点的文本内容。
     *
     * @返回值 文本。
     */
    public func toString(): String 

    /*
     * 克隆复制一个新的节点。
     *
     * @返回值 新的对象
     */
    public override func clone(): XmlDeclaration
}
```

### 示例

#### class FormElement

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var formElement: FormElement = FormElement(Tag.valueOf("from"), "", None)
    var formElement1: FormElement = FormElement(Tag.valueOf("from1"), "", None)
    var formElement2: FormElement = FormElement(Tag.valueOf("from2"), "", None)
    var elements: Elements = formElement.elements()
    if (elements.size == 0) {
        println("pass1")
    }
    formElement.addElement(formElement1)
    formElement.addElement(formElement2)
    if (elements.size == 2) {
        println("pass2")
    }
    var formElement3: FormElement = formElement.clone()
    var elements3: Elements = formElement3.elements()
    if (elements3.size == 2) {
        println("pass3")
    }

    return 0
}
```

执行结果如下：

```cangjie

```

#### open class TextNode

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var textNode1: TextNode = TextNode("这是一个文本")
    if (textNode1.nodeName() == "#text") {
        println("pass1")
    }
    if (textNode1.text() == "这是一个文本") {
        println("pass2")
    }
    textNode1.text("新文本")
    if (textNode1.text() == "新文本") {
        println("pass3")
    }
    if (!textNode1.isBlank()) {
        println("pass4")
    }
    if (textNode1.getWholeText() == "新文本") {
        println("pass5")
    }
    if (textNode1.toString() == "新文本") {
        println("pass6")
    }
    textNode1.text("")
    if (textNode1.isBlank()) {
        println("pass7")
    }
    textNode1.text("this is text")
    var textNode2: TextNode = textNode1.splitText(4)
    if (textNode1.text() == "this") {
        println("pass8")
    }
    if (textNode2.text() == " is text") {
        println("pass9")
    }
    var textNode3: TextNode = textNode1.clone()
    if (textNode1 != textNode3) {
        println("pass10")
    }
    if (!refEq(textNode1, textNode3)) {
        println("pass11")
    }
    var textNode4: TextNode = TextNode.createFromEncoded("textNode")
    if (textNode4.text() == "textNode") {
        println("pass12")
    }

    return 0
}
```

执行结果如下：

```cangjie
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
pass9
pass10
pass11
pass12
```

#### class CDataNode

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var cDataNode1: CDataNode = CDataNode("CDataNode")
    if (cDataNode1.nodeName() == "#cdata") {
        println("pass1")
    }
    if (cDataNode1.text() == "CDataNode") {
        println("pass2")
    }
    var cDataNode2: CDataNode = cDataNode1.clone()
    if (cDataNode1 != cDataNode2) {
        println("pass3")
    }
    if (!refEq(cDataNode1, cDataNode2)) {
        println("pass4")
    }

    return 0
}
```

执行结果如下：

```cangjie
pass1
pass2
pass3
pass4
```

#### class Comment

```cangjie
import cangjie_tpc::html4cj
import cangjie_tpc::html4cj.*

main(): Int64 {
    var commentNode: Comment = html4cj.Comment("public override func clone(): Comment")
    if (commentNode.nodeName() == "#comment") {
        println("pass1")
    }
    if (commentNode.getData() == "public override func clone(): Comment") {
        println("pass2")
    }
    commentNode.setData("注释")
    if (commentNode.getData() == "注释") {
        println("pass3")
    }
    if (commentNode.toString() == "<!--注释-->") {
        println("pass4")
    }
    if (!commentNode.isXmlDeclaration()) {
        println("pass5")
    }
    var commentNode1: Comment = html4cj.Comment("?xml encoding='ISO-8859-1'?")
    if (commentNode1.nodeName() == "#comment") {
        println("pass6")
    }
    if (commentNode1.getData() == "?xml encoding='ISO-8859-1'?") {
        println("pass6")
    }
    if (commentNode1.toString() == "<!--?xml encoding='ISO-8859-1'?-->") {
        println("pass7")
    }
    if (commentNode1.isXmlDeclaration()) {
        println("pass8")
    }
    var xmlDeclarat1: XmlDeclaration = commentNode1.asXmlDeclaration().getOrThrow()
    if (xmlDeclarat1.toString() == "<?xml encoding=\"ISO-8859-1\"?>") {
        println("pass9")
    }

    return 0
}
```

执行结果如下：

```cangjie
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
pass9
```

#### class DataNode

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var dataNode1: DataNode = DataNode("DataNode")
    if (dataNode1.nodeName() == "#data") {
        println("pass1")
    }
    if (dataNode1.getWholeData() == "DataNode") {
        println("pass2")
    }
    if (dataNode1.toString() == "DataNode") {
        println("pass3")
    }
    dataNode1.setWholeData("new DataNode")
    if (dataNode1.getWholeData() == "new DataNode") {
        println("pass4")
    }
    if (dataNode1.toString() == "new DataNode") {
        println("pass5")
    }
    var dataNode2: DataNode = dataNode1.clone()
    if (dataNode1 != dataNode2) {
        println("pass6")
    }
    if (!refEq(dataNode1, dataNode2)) {
        println("pass7")
    }

    return 0
}
```

执行结果如下：

```cangjie
pass1
pass2
pass3
pass4
pass5
pass6
pass7
```

#### class DocumentType

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var documentType: DocumentType = DocumentType("html", "", "")
    if (documentType.nodeName() == "#doctype") {
        println("pass1")
    }
    if (documentType.name() == "html") {
        println("pass2")
    }
    if (documentType.publicId() == "") {
        println("pass3")
    }
    if (documentType.systemId() == "") {
        println("pass4")
    }
    documentType.setPubSysKey("key")
    if (documentType.toString() == "<!doctype html key>") {
        println("pass5")
    }
    var documentType1: DocumentType = DocumentType("notHtml", "--public", "--system")
    if (documentType1.nodeName() == "#doctype") {
        println("pass6")
    }
    if (documentType1.name() == "html") {
        println("pass7")
    }
    if (documentType1.publicId() == "--public") {
        println("pass8")
    }
    if (documentType1.systemId() == "--system") {
        println("pass9")
    }
    if (documentType.toString() == "<!DOCTYPE notHtml PUBLIC \"--public\" \"--system\">") {
        println("pass10")
    }

    return 0
}
```

执行结果如下：

```cangjie
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
pass9
pass10
```

#### class XmlDeclaration

```cangjie
import cangjie_tpc::html4cj.*

main(): Int64 {
    var xmlDeclaration: XmlDeclaration = XmlDeclaration("xml", false)
    if (xmlDeclaration.nodeName() == "#declaration") {
        println("pass1")
    }
    if (xmlDeclaration.name() == "xml") {
        println("pass2")
    }
    xmlDeclaration.attr("version", "1.0")
    xmlDeclaration.attr("encoding", "UTF-8")
    if (xmlDeclaration.getWholeDeclaration() == "version=\"1.0\" encoding=\"UTF-8\"") {
        println("pass3")
    }
    if (xmlDeclaration.toString() == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>") {
        println("pass4")
    }
    var xmlDeclaration1: XmlDeclaration = XmlDeclaration("xml", true)
    if (xmlDeclaration1.nodeName() == "#declaration") {
        println("pass5")
    }
    if (xmlDeclaration1.name() == "xml") {
        println("pass6")
    }
    xmlDeclaration1.attr("version", "1.0")
    xmlDeclaration1.attr("encoding", "UTF-8")
    if (xmlDeclaration1.getWholeDeclaration() == "version=\"1.0\" encoding=\"UTF-8\"") {
        println("pass7")
    }
    if (xmlDeclaration1.toString() == "<!xml version=\"1.0\" encoding=\"UTF-8\"!>") {
        println("pass8")
    }
    var xmlDeclaration2: XmlDeclaration = xmlDeclaration1.clone()
    if (xmlDeclaration1 != xmlDeclaration2) {
        println("pass9")
    }
    if (!refEq(xmlDeclaration1, xmlDeclaration2)) {
        println("pass10")
    }

    return 0
}
```

执行结果如下：

```cangjie
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
pass9
pass10
```
