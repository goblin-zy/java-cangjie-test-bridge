<div align="center">
<h1>cjmustache</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.1.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.1.3-brightgreen" style="display: inline-block;" />
<!-- <img alt="" src="https://img.shields.io/badge/cjcov-0.0%25-brightgreen" style="display: inline-block;" /> -->
<!-- <img alt="" src="https://img.shields.io/badge/state-孵化/毕业-brightgreen" style="display: inline-block;" /> -->
<!-- <img alt="" src="https://img.shields.io/badge/domain-HOS/Cloud-brightgreen" style="display: inline-block;" /> -->
</p>

## <img alt="" src="./doc/readme-image/readme-icon-introduction.png" style="display: inline-block;" width=3%/> 1 介绍

一个迁移自 [jmustache](https://github.com/samskivert/jmustache) 的模版引擎项目。

您只需要在项目的cjpm.toml下的加入：

```cangjie
  cjmustache = { git = "https://gitcode.com/Cangjie-SIG/cjmustache.git", output-type = "static", branch = "Public-version-branch" }
```

继续在控制台输入`cjpm update`即可引入本项目。

### 1.1 项目特性

  * 不依赖反射，完全基于DataModel的渲染机制.
  * 不依赖其他项目，实现零依赖.
  * 渲染机制基于键值匹配.

### 1.2 约束与限制
  * 可渲染的数据类型必须是DataModel支持的数据，即`实现Serializable<T>接口的类`, `HashMap<K, T> where K, T <: Serializable<T>`, `ArrayLsit<T> where T <: Serializable<T>`, `Array`, `Bool`, `Float`, `Int64`, `String`.
  * 不支持函数渲染.
  * `{{= =}}` 只支持一个或两个字符分隔符.

## <img alt="" src="./doc/readme-image/readme-icon-framework.png" style="display: inline-block;" width=3%/> 2 架构

### 2.1 项目结构

```shell
.
├── README.md
├── cjpm.lock
├── cjpm.toml
├── CHANGELOG.md
├── LICENSE
├── doc
│   └── readme-image
│       ├── readme-icon-compile.png
│       ├── readme-icon-contribute.png
│       ├── readme-icon-framework.png
│       └── readme-icon-introduction.png
└── src
    ├── basic_collector.cj
    ├── default_collector.cj
    ├── escapers.cj
    ├── helpers.cj
    ├── mustache.cj
    ├── my_exception.cj
    ├── template.cj
    └── test
        ├── templates
        │   └── main.html
        ├── compile_test.cj
        ├── escapers_test.cj
        ├── helpers_test.cj
        ├── shared_test.cj
        └── thread_safety_test.cj
```

### 2.2 接口与方法说明

#### Mustache
  * `compile(tmpl: String): Template`: 将输入的字符串编译成`Template`模版。

#### Template
  * `execute(context: DataModel): String`: 使用`context`来渲染编译成的`Template`模版。
  * `execute(out: OutputStream, context: DataModel): Unit`: 使用`context`来渲染编译成的`Template`模版，并加载到传入的`OutputStream`。

#### compile
  * `compile.escapeHTML(escapeHTML: Bool): Compile`: 返回一个默认情况下可转义HTML的编译器。
  * `compile.standardsMode(_standardsMode: Bool): Compiler`: 返回一个使用或不使用标准模式的编译器。标准模式禁用非标准cjmustache扩展。
  * `compile.strictSections(_strictSections: Bool): Compiler`: 返回一个编译器，当节引用缺少的值（｛@code true｝）或将缺少的值视为｛@code false｝,（默认值为｛@code false｝）时，该编译器会抛出异常。
  * `compile.defaultValue(_defaultValue: String): Compiler`: 返回一个编译器，该编译器将使用给定的值来处理任何缺失的变量。
  * `compile.nullValue(_nullValue: String): Compiler`: 返回一个编译器，该编译器将对解析为DataModelNull的任何变量使用给定值。
  * `compile.emptyStringIsFalse(_emptyStringIsFalse: Bool): Compiler`: 返回一个编译器，如果参数为true，则将空字符串视为false值。
  * `compile.zeroIsFalse(_zeroIsFalse: Bool):  Compiler`: 返回一个编译器，如果参数为真，则将零视为假值。
  * `compile.withFormatter(_formatter: Formatter): Compiler`: 配置用于将对象转换为字符串的格式化器。
  * `compile.withEscaper(_escaper: Escaper): Compiler`: 配置用于转义替换文本的转义器。
  * `compile.withLoader(_loader: TemplateLoader): Compiler`: 返回一个编译器，该编译器使用配置的的模板加载器来加载模版。
  * `compile.withCollector(_collector: Collector): Compiler`: 返回一个编译器，该编译器使用配置的收集器来收集渲染数据。
  * `compile.withDelims(_delims: String): Compiler`: 返回一个编译器，该编译器使用提供的delims作为默认分隔符。
  * `compile.computerNullValue(name: String): DataModel`: 返回在模板中用于空值属性的值。
  * `compile.isFalsey(value: DataModel): Bool`: 如果提供的值为“false”，则返回true。如果{@link emptyStringIsFalse}为true，则空字符串被视为false。如果{@link zeroIsFalse}为真，则零值被视为假。
  * `compile.loadTemplate(name: String): Template `: 使用此编译器配置的模板加载器加载和编译模板。

#### Formatter
```cangjie
public interface Formatter { 
    // 将 @Param value 转换为 String 以包含在模板中
    func format(value: DataModel): String
}
```

#### VariableFetcher
```cangjie
public interface VariableFetcher {
    // 从提供的上下文对象中读取名为 @Param name 的变量 
    func get(ctx: DataModel, name: String): DataModel
}
```

#### Escaper
```cangjie
public interface Escaper {
    /* 用转义序列替换 @Param raw 的字符 */
    func escape(raw: String): String
}
```

#### TemplateLoader
```cangjie
public interface TemplateLoader {
    /** 返回具有提供名称的模板的输入流对象*/
    func getTemplate(name: String): InputStream
}
```

#### Collector
```cangjie
public interface Collector {
    /** 在提供的上下文对象中为名为 @Param name 的变量创建一个提取器，该提取器永远不会为None。
      * 其中 fetcher 将被缓存，并在未来的上下文中重用，
      */
    func createFetcher(ctx: DataModel, name: String): ?VariableFetcher

    /** 创建用于缓存 VariableFetcher实例的映射。*/
    func createFetcherCache(): HashMap<String, VariableFetcher>
}
```

## <img alt="" src="./doc/readme-image/readme-icon-compile.png" style="display: inline-block;" width=3%/> 3 使用说明

### 3.1 编译构建（Win/Linux/Mac）

```
cjpm update
cjpm build
cjpm test
```

### 3.2 功能示例

**Usage**

使用cjmustache非常简单。以`String`或`InputStream`的形式提供`Template`，并获取可以在任何上下文上执行的模板：

```cangjie
let text = "One, two, {{three}}. Three sir!"
let tmpl: Template = Mustache.compiler().compile(text)
let data = HashMap<String, String>([("three", "five")]).serialize()
println(tmpl.execute(data))
// result: "One, two, five. Three sir!"
```

```cangjie
let text = "{{foo.0}}"
let tmpl = Mustache.compiler().compile(text)
let data = HashMap<String, ArrayList<Int64>>([("foo", ArrayList<Int64>([1, 2, 3, 4]))]).serialize()
println(tmpl.execute(data))
// result: "1"
```

执行上下文可以是`DataModel`支持和实现`Serializable<T>`接口的对象。变量将通过以下机制解决：

  * 如果上下文是`HashMap`, 则将使用`HashMap.get`。
  * 如果上下文是`ArrayList`和`Array`，则将使用下标访问或迭代遍历。
  * 如果上下文的`类对象`，则通过访问`字段名`获取变量

例子:

具体示例请参见
[shared_test.cangjie](https://gitcode.com/naxida/cjmustache/blob/main/src/test/shared_test.cj)
中的代码,另请参阅
[Mustache documentation](http://mustache.github.io/mustache.5.html) 了解有关模板语法的详细信息

**基本语义**

 * {{key}}: 在{{ }}中放键值，渲染时将会使用键值为key的value来渲染该位置.
 * {{key.inner}}: 嵌套调用，渲染过程为，先拿到键值为key的value，再获取value中键值为inner的innerValue.
 * {{this}}：可以不提供键值，使用`this`将直接使用渲染数据对象本身进行渲染.
 * {{#key}}inner{{/key}}: 表示使用键值为key的对象，{{#key}}inner{{/key}}实际上等价于{{key.inner}}，但是当键值为key的对象是一个数组时，则可以循环渲染.

**loop**

如果需要遍历数组来渲染模版：

```cangjie
let text = "{{#things}}({{this}}){{/things}}"
let tmpl: Template = Mustache.compiler().compile(text)
println(tmpl.execute(HashMap<String, Array<String>>([("things", ["foo", "bar", "woo"])]).serialize()))
// result: (foo)(bar)(woo)

let text = "{{#things}}({{things.0}}){{/things}}"
let tmpl: Template = Mustache.compiler().compile(text)
println(tmpl.execute(HashMap<String, Array<String>>([("things", ["foo", "bar", "woo"])]).serialize()))
// result: (foo)(foo)(foo)
```

**Serializable<T>**

如果你需要使用类渲染或渲染的数据类型不一致，则需要使用实现`Serializable<T>`接口的类:

```cangjie
public class DiffTypeRenderClass <: Serializable<DiffTypeRenderClass> {
    var name = "foo"
    var things = ArrayList<HashMap<String, String>>([
            HashMap<String, String>([("thing_name", "bar")]), 
            HashMap<String, String>([("thing_name", "baz")])])

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("name", name))
            .add(field<ArrayList<HashMap<String, String>>>("things", things))
    }

    public func getTemplate(_: String): InputStream {
        let byteArrayStream = ByteArrayStream()
        byteArrayStream.write(str.toArray())
        return BufferedInputStream(byteArrayStream)
    }
}

let text = "{{name}}({{#things}}({{name}}{{thing_name}}){{/things}})"
let tmpl: Template = Mustache.compiler().compile(text)
println(tmpl.execute(DiffTypeRenderClass().serialize()))
// result: "foo((foobar)(foobaz))"
```

**TemplateLoader**

如果你想使用自定义的`TemplateLoader`来加载模版，则需实现`interface TemplateLoader`，并调用`compile.withLoader`:

```cangjie
public class DualStrNestedTemplateLoader <: TemplateLoader {
    public DualStrNestedTemplateLoader(let str1: String, let str2: String) {}

    public func getTemplate(name: String): InputStream {
        if (name.equalsIgnoreAsciiCase("nested")) {
            return BufferedInputStream(ByteBuffer(str1.toArray()))
        }
        return BufferedInputStream(ByteBuffer(str2.toArray()))
    }
}

public class DiffTypeRenderClass <: Serializable<DiffTypeRenderClass> {
    var name = "foo"
    var things = ArrayList<HashMap<String, String>>([
            HashMap<String, String>([("thing_name", "bar")]), 
            HashMap<String, String>([("thing_name", "baz")])])

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("name", name))
            .add(field<ArrayList<HashMap<String, String>>>("things", things))
    }

    public static func deserialize(dm: DataModel): DiffTypeRenderClass {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = DiffTypeRenderClass()
        result.name = String.deserialize(dms.get("name"))
        result.things = ArrayList<HashMap<String, String>>.deserialize(dms.get("things"))
        return result
    }
}

let text = "{{name}}({{#things}}({{>nested}}){{/things}})"
let tmpl: Template = Mustache.compiler().withLoader(
    DualStrNestedTemplateLoader("{{name}}{{thing_name}}", "nonfoo")).compile(text)
println(tmpl.execute(DiffTypeRenderClass().serialize()))
// result: "foo((foobar)(foobaz))"
```

**Default Values**

默认情况下，当变量无法解析或解析为None时，将抛出异常（节除外，见下文）。您可以通过两种方式更改此行为。如果你想提供一个在所有这些情况下使用的值，请使用 `defaultValue()`:

```cangjie
let text = "{{foo.4}}"
let tmpl: Template = Mustache.compiler().defaultValue("?").compile(text)
let data = HashMap<String, ArrayList<Int>>([("foo", ArrayList<Int64>([1, 2, 3, 4]))]).serialize()
println(tmpl.execute(data))
// result: "?"
```

**Null Values**

如果你只希望为解析为null的变量提供一个默认值，并希望在变量无法解析的情况下保留异常，请使用`nullValue()`:

```cangjie
let text = "{{nullvar}}{{nonnullvar}}"
let tmpl = Mustache.compiler().nullValue("foo").compile(text)
let data = HashMap<String, ?String>([("nonnullvar", "bar"), ("nullvar", None)]).serialize()
println(tmpl.execute(data))
// result: "foobar"
```

当使用`HashMap`作为上下文时，`nullValue()`仅在`HashMap`包含到`None`的映射时使用。如果映射缺少给定变量的映射，那么它被认为是不可解析的，并引发异常。

```cangjie
// no mapping exists for "doesNotExist"
let text = "{{exists}} {{nullValued}} {{doesNotExist}}?"
let tmpl = Mustache.compiler().nullValue("what").compile(text)
let data = HashMap<String, ?String>([("exists", "Say"), ("nullValued", None)]).serialize()
println(tmpl.execute(data))
// throws MustacheException when executing the template because doesNotExist cannot be resolved
```

**不要**在编译器配置中同时使用`defaultValue`和`nullValue`。每一个都覆盖另一个，所以你最后调用的那个就是你将得到的行为。但是即使你不小心做了正确的事情，你也有令人困惑的代码，所以不要同时调用两个，使用一个或另一个。

**Sections**

节(Sections)不受`nullValue()`或`defaultValue()`设置的影响。它们的行为由一个单独的配置控制：`strictSections()`.

默认情况下，不可解析或解析为`None`的部分将被忽略（相反，不可解析或解析为`None`的反向部分将被包括在内）。如果使用`strictSections(true)`，则引用不可解析值的节将始终引发异常。引用可解析但为`None`的节永远不会抛出异常，无论`strictSections()`如何设置

**Extensions**

cjmustache扩展了基本的Mustache模板语言，增加了一些额外的功能。这些附加功能列举如下:

**默认情况下不转义HTML**

您可以在获取编译器时更改默认的HTML转义行为:

```cangjie
println(Mustache.compiler()
    .escapeHTML(false).compile("{{foo}}")
        .execute(HashMap<String, String>([("foo", "<bar>")]).serialize()))
// result: "<bar>"
// not: "&lt;bar&gt;"
```

**用户定义的对象格式**


默认情况下，cjmustache在呈现模板时将对象转换为字符串。您可以通过实现`interface Formatter`来自定义此格式：

```cangjie
public class CustomFormatter <: Formatter {
    public func format(value: DataModel): String {
        if (let Some(dataModelString) <- (value as DataModelString)) {
            return dataModelString.getValue() + "Customer"
        }
        return "unknown"
    }
}

public class DiffTypeRenderClass <: Serializable<DiffTypeRenderClass> {
    var msg = 1
    var today = "My"

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<Int64>("msg", msg))
            .add(field<String>("today", today))
    }

    public static func deserialize(dm: DataModel): DiffTypeRenderClass {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = DiffTypeRenderClass()
        result.msg= Int64.deserialize(dms.get("msg"))
        result.today = String.deserialize(dms.get("today"))
        return result
    }
}

let text = "{{msg}}: {{today}}"
let tmpl = Mustache.compiler().withFormatter(CustomFormatter()).compile(text)
let data = DiffTypeRenderClass().serialize()
println(tmpl.execute(data))
// result: "unknown: MyCustomer"
```

**Escaper**

您可以在获取编译器时更改转义行为，以支持HTML和纯文本以外的文件格式.

如果你只需要替换文本中的固定字符串，你可以使用 `Escapers.simple`:

```cangjie
let escapes = [[ "[", "[[" ], [ "]", "]]" ]]
let text = "{{foo}}"
let tmpl = Mustache.compiler().withEscaper(Escapers.simple(escapes)).compile(text)
let data = HashMap<String, String>([("foo", "[bar]")]).serialize()
println(tmpl.execute(data))
// result: "[[bar]]"
```

也可以直接实现`interface Escaper`接口，以便对转义过程进行更多控制

**Special variables**

**this**

可以使用特殊变量`this`和`.`来引用上下文对象本身，而不是其成员之一。这在遍历列表时特别有用

```cangjie
println(Mustache.compiler().compile("{{this}}").execute("bar".serialize()))
println(Mustache.compiler().compile("{{.}}").execute("bar".serialize()))
// result: "bar"
```

`.` 显然，其他Mustache实现也支持它，尽管它没有出现在官方文档中

**-first and -last**

可以使用特殊变量 `-first` 和 `-last` 对列表元素执行特殊处理。 `-first` 在处理元素列表的第一个元素的节中解析为 `true` .它在所有其他时间都解析为 `false` . `-last` 在处理元素列表中最后一个元素的节中解析为 `true` .它在所有其他时间都解析为 `false` 

人们经常会在倒排部分中使用这些特殊变量，如下所示:

```cangjie
let text = "{{#things}}{{^-first}}, {{/-first}}{{this}}{{/things}}"
let tmpl = Mustache.compiler().compile(text)
let data = HashMap<String, Array<String>>([("things", ["one", "two", "three"])]).serialize()
println(tmpl.execute(data))
// result: "one, two, three"
```

请注意， `-first` 和 `-last` 的值仅引用最内部的封闭部分。如果您正在处理一个节中的一个节，则无法确定您是处于外部节的第一个迭代还是最后一个迭代中。

**-index**

`-index` 特殊变量包含1表示第一次迭代通过一个部分，2表示第二次，3表示第三次，依此类推。它在所有其他时间都包含0。请注意，对于由单例值而不是列表填充的部分，它也包含0。

```cangjie
let text = "My favorite things:\n{{#things}}{{-index}}. {{this}}\n{{/things}}"
let tmpl = Mustache.compiler().compile(text)
let data = HashMap<String, Array<String>>(
        [("things", ["Peanut butter", "Pen spinning", "Handstands"])]).serialize()
println(tmpl.execute(data))
// result:
// "My favorite things:"
// "1. Peanut butter"
// "2. Pen spinning"
// "3. Handstands"
```

**Compound variables**

除了使用上下文解析简单变量外，还可以使用复合变量从当前上下文的子对象中提取数据。举例来说:

```cangjie
public class InnerCompound <: Serializable<InnerCompound> {
    var who = "world" 

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("who", who))
    }

    public static func deserialize(dm: DataModel): InnerCompound {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = InnerCompound()
        result.who = String.deserialize(dms.get("who"))
        return result
    }
}

public class OuterCompound <: Serializable<OuterCompound> {
    var compound = InnerCompound()

    public func serialize(): DataModel {
        return DataModelStruct()
        .add(field<InnerCompound>("compound", compound))
    }

    public static func deserialize(dm: DataModel): OuterCompound {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = OuterCompound()
        result.compound = InnerCompound.deserialize(dms.get("compound"))
        return result
    }
}

let text = "Hello {{compound.who}}!"    
let tmpl = Mustache.compiler().compile(text)
println(tmpl.execute(OuterCompound().serialize()))
// result: "Hello world!"
```

请注意，复合变量本质上是使用单例节的简写。上述示例也可以表示为:
    Hello {{#compound}}{{who}}{{/compound}}!
    Hello {{#class}}{{name}}{{/class}}!

还请注意，嵌套的单例节和复合变量之间存在一个语义差异：在为复合变量的第一个组件解析对象之后，在解析子组件时将不会搜索父上下文

**Newline trimming**

如果开始或结束部分标记是一行中唯一的内容，则会修剪标记后面的所有空白和行结束符。这允许文明的模板，如:

```html
Favorite foods:
<ul>
  {{#people}}
  <li>{{first_name}} {{last_name}} likes {{favorite_food}}.</li>
  {{/people}}
</ul>
```

它产生的输出如下:

```html
Favorite foods:
<ul>
  <li>Elvis Presley likes peanut butter.</li>
  <li>Mahatma Gandhi likes aloo dum.</li>
</ul>
```

而不是:

```html
Favorite foods:
<ul>

  <li>Elvis Presley likes peanut butter.</li>

  <li>Mahatma Gandhi likes aloo dum.</li>

</ul>
```

其将在没有换行修剪的情况下产生.

**Nested Contexts**

如果在嵌套上下文中找不到变量，则在下一个外部上下文中解析该变量。这允许如下使用:

```cangjie
public class DiffTypeRenderClass <: Serializable<DiffTypeRenderClass> {
    var outer = "foo"
    var inner = ArrayList<String>(["bar", "baz", "bif"])

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("outer", outer))
            .add(field<ArrayList<String>>("inner", inner))
    }

    public static func deserialize(dm: DataModel): DiffTypeRenderClass {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = DiffTypeRenderClass()
        result.outer = String.deserialize(dms.get("outer"))
        result.inner = ArrayList<String>.deserialize(dms.get("inner"))
        return result
    }
}

let text = "{{outer}}:\n{{#inner}}{{outer}}.{{this}}\n{{/inner}}"
let tmpl = Mustache.compiler().compile(text)
let data = DiffTypeRenderClass().serialize()
println(tmpl.execute(data))
// results:
// "foo:"
// "foo.bar"
// "foo.baz"
// "foo.bif"
```

请注意，如果一个变量是在内部上下文中定义的，它会隐藏外部上下文中的相同名称。目前还没有办法从外部上下文访问变量.

**Standards Mode**

这些扩展中更具侵入性的扩展，特别是父上下文的搜索和复合变量的使用，可以在创建编译器时禁用，如下所示:

```cangjie
let text = "{{foo.bar}}"
let tmpl = Mustache.compiler().standardsMode(true).compile(text)
let data = HashMap<String, String>([("foo.bar", "baz")]).serialize()
println(tmpl.execute(data))
// result: "baz"
```

**Thread Safety**

cjmustache是内部线程安全的，但有以下警告:

  * 编译：编译模板调用了各种帮助类：`Formatter`, `Escaper`, `TemplateLoader`, `Collector`.这些类的默认实现是线程安全的，但是如果您提供自定义实例，则必须确保自定义实例是线程安全的。

  * 执行：执行模板可以调用一些帮助类：`VariableFetcher`。这些类的默认实现是线程安全的，但是如果您提供自定义实例，则必须确保自定义实例是线程安全的

因此，执行摘要是：只要您提供的所有帮助器类都是线程安全的（或者您使用默认值），那么在线程之间共享`Compiler`实例来编译模板是安全的。如果在执行时将不可变数据传递给模板，那么让多个线程同时执行单个`Template`实例是安全的.


## <img alt="" src="./doc/readme-image/readme-icon-contribute.png" style="display: inline-block;" width=3%/> 4 参与贡献

本项目由 [SIGCANGJIE / 仓颉兴趣组](https://gitcode.com/SIGCANGJIE) 实现并维护。技术支持和意见反馈请提Issue。

本项目采用Apache License 2.0，同时本项目迁移的原始项目 [jmustache](https://github.com/samskivert/jmustache)采用Eclipse Distribution License (EDL) v1.0协议。欢迎给我们提交PR，欢迎参与任何形式的贡献。

本项目committer：[@naxida](https://gitcode.com/naxida/cjmustache.git)

This project is supervised by [@zhangyin_gitcode](https://gitcode.com/zhangyin_gitcode) (HUAWEI Developer Advocate).

![](https://raw.gitcode.com/SIGCANGJIE/homepage/attachment/uploads/9b648c07-efc2-4eb3-b02f-eab18c77beea/devadvocate.png)