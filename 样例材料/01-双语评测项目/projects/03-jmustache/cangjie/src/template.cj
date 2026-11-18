package cjmustache

import stdx.serialization.serialization.*
import std.collection.concurrent.*
import std.io.*
import std.collection.*
import std.convert.*

public class Template {
    protected static let DOT_NAME: String   = "."
    protected static let THIS_NAME: String  = "this"
    protected static let FIRST_NAME: String = "-first"
    protected static let LAST_NAME: String  = "-last"
    protected static let INDEX_NAME: String = "-index"

    protected let _fcache: ConcurrentHashMap<String, VariableFetcher>

    protected Template(
        let _segs: Array<Segment>, 
        let _compiler: Compiler) {
        _fcache = _compiler._collector.createFetcherCache()
    } 
    
    // 用来表示没有对应的 fetcher 
    public static let NO_FETCHER_FOUND = "<no fetcher found>"


    public func execute(out: OutputStream, context: DataModel): Unit {
        execute(context, out)
    }

    public func execute(context: DataModel): String {
        let byteArrayStream = ByteBuffer()
        let out = BufferedOutputStream(byteArrayStream)
        execute(context, out)
        out.flush()
        return String.fromUtf8(readToEnd(byteArrayStream))
    }

    public func execute(context: DataModel, out: OutputStream): Unit {
        executeSegs(Context(context, None, 0, false, false), out)
    }

    /**
     * 使用提供的上下文和父上下文执行此模板，并将结果写入提供的写入器
     * 将在父上下文中搜索在主上下文中找不到的变量，就像输入块时主上下文成为父上下文一样
     * @throws MustacheException : 如果在执行或写入模板时发生错误
     */
    public func execute(
        context: DataModel, parentContext: DataModel, out: OutputStream) {
        let ctx = Context(parentContext, None, 0, false, false)
        executeSegs(Context(context, ctx, 0, false, false), out)
    }

    protected func executeSegs(
        ctx: Context, out: OutputStream): Unit {
        for (seg in _segs) {
            seg.execute(this, ctx, out)
        }
    }

    /** 
      * 我们在这里要做的是重建这个部分模板，但要缩进
      * 如果标识没有改变任何东西，我们将返回原始模板
      */
    protected func indent(indent: String): Template {
        if (indent.equalsIgnoreAsciiCase("")) {
            return this
        }

        let copySegs: Array<Segment> = 
        Mustache.indentSegs(_segs, indent, false, false)
        if (copySegs.equal(_segs)) {
            return this
        }

        return Template(copySegs, _compiler)
    }

    protected func replaceBlocks(
        blocks: HashMap<String, BlockSegment>): Template {
        if (blocks.isEmpty()) {
            return this
        }

        let copySegs: Array<Segment> = 
        Mustache.replaceBlockSegs(_segs, blocks)
        if (copySegs.equal(_segs)) {
            return this
        }

        return Template(copySegs, _compiler)
    } 


    protected func createFragment(
        segs: Array<Segment>, currentCtx: Context): Fragment {
            TemplateFragment(segs, currentCtx, this, _compiler)
    }

    /** 访问此模板中的标签（通过{@code visitor}），而不执行它。
      * @param visitor : 在模板中的每个标签上调用访问者
      */
    public func visit(visitor: Visitor): Unit {
        for (seg in _segs) {
            seg.visit(visitor)
        }
    }

/*==========================getValue============================*/

    /** 由执行段调用，以获取所提供上下文中指定变量的值 
      * @param ctx  : 查找变量的上下文 
      * @param-name : 要解析的变量的名称
      * @param missingIsNull : 如果变量无法解析，是否失败，或者在这种情况下返回null 
      *
      * @return : 返回与提供的名称关联的值，如果无法解析任何值，则返回null。
      */
    protected func getValue(
        ctx: Context, name: String, line: Int64,
            missingIsNull: Bool): DataModel {
        /* 处理我们的特殊变量 */
        if (name.equalsIgnoreAsciiCase(FIRST_NAME)) {
            return ctx.onFirst.serialize()
        } else if (name.equalsIgnoreAsciiCase(LAST_NAME)) {
            return ctx.onLast.serialize()
        } else if (name.equalsIgnoreAsciiCase(INDEX_NAME)) {
            return ctx.index.serialize()
        }

        /* 如果我们处于标准模式，请将自己限制为简单的直接解析
         *（没有复合键，在父上下文中没有解析值） */
        if (_compiler._standardsMode) {
            let dm = getValueIn(ctx.data, name, line)
            if (!(dm is DataModelNull)) {
                return checkForMissing(name, line, missingIsNull, dm)
            }
            return Template.NO_FETCHER_FOUND.serialize()
        }

        /* 首先在父上下文中搜索键（即使键是复合键，我们也会首先尝试找到它的“整体”
         * ，只有当失败时，我们才会分部分解析它） */
        var curCtx: ?Context = ctx
        while (let Some(extCtx) <- curCtx) {
            let value = getValueIn(extCtx.data, name, line)
            if (!(value is DataModelNull)) {
                if (isNO_FETCHER_FOUND(value)) {
                    curCtx = extCtx.parent
                    continue
                }

                return value
            } else {
                return DataModelNull()
            }

            curCtx = extCtx.parent
        }

        /* 如果我们到达这里，我们在这个或我们的父环境中什么也没发现...... */

        /* 如果我们有一个复合键，分解该值并逐步解析 */
        if (!name.equalsIgnoreAsciiCase(DOT_NAME) && 
            name.indexOf(DOT_NAME) != None) {
                return getCompoundValue(
                    ctx, name, line, missingIsNull)
        } else {
            return checkForMissing(
                name, line, missingIsNull, NO_FETCHER_FOUND.serialize())
        }
    }

    /*
     * 将复合键{@code name}分解为组件，并解析它们引用的值。
     */
    protected func getCompoundValue(
            ctx: Context, name: String, 
            line: Int64, missingIsNull: Bool): DataModel {
        let comps: Array<String> = name.split(".")
        let size = comps.size

        /* 我们希望允许复合键的第一个组件位于父上下文中，
         * 但一旦我们选择了子组件，它们只能在表示该组件的对象中解析 */
        var value = getValue(ctx, comps[0], line, missingIsNull)

        for (ii in 1..size) {
            if (isNO_FETCHER_FOUND(value)) {
                if (!missingIsNull) {
                    throw ExceptionContext(
                        "Missing context for compound variable '" + 
                        name +"' on line " + line.toString() + ". '" +
                        comps[ii - 1] + "' was not found.", name, line)
                }
                return DataModelNull()
            } else if (value is DataModelNull) {
                return value
            }

            value = getValueIn(value, comps[ii], line)
        }
        
        return checkForMissing(
            name, line, missingIsNull, value)
    }

    /**
      * 返回指定变量的值，注意它将用作节的内容。
      */
    protected func getSectionValue(
        ctx: Context, name: String, line: Int64): DataModel {
            let value = getValue(ctx, name, line, !_compiler._strictSections)
            return if (value is DataModelNull) {
                ArrayList<String>().serialize()
            } else {
                value
            }
    }


    /**
      * 返回指定变量的值，如果变量解析为null，则返回配置的默认值。请参阅{@link#getValue}。
      */
    protected func getValueOrDefault(
        ctx: Context, name: String, line: Int64): DataModel {
            let value = getValue(ctx, name, line, _compiler._missingIsNull)

            return if (value is DataModelNull) {
                _compiler.computerNullValue(name)
            } else {
                value
            }
    }

    protected func getValueIn(
        data: DataModel, name: String, line: Int64): DataModel {
        /*如果我们得到或者“this”返回整个上下文；我们在null检查之前这样做，
        因为上下文为null可能是有效的（例如，如果我们迭代一个包含null的列表  */

        if (isThisName(name)) { 
            return data 
        }

        if (data is DataModelNull) {
            throw NoneValueException(
                "Null context for variable '" + 
                name + "' on line " + line.toString())
        }

        let key = Key(data, name)
        var fetcher = _fcache.get(key.toString())

        if (let Some(extractedFetcher) <- fetcher) {
            try {
                return extractedFetcher.get(data, name)
            } catch (e: Exception) {
                fetcher = _compiler._collector.
                    createFetcher(data, name)
            }
        } else {
            fetcher = _compiler._collector.
                createFetcher(data, name)
        }

        /* 如果我们无法创建一个fetcher，请使用NOT_FOUND_fetcher，
        它将返回NO_fetcher_FOUND， 让调用者知道他们可以尝试父上下文或做le怪胎；
        我们仍然缓存此fetcher，以避免在同一上下文中重复查找和找不到fetcher（这可能很昂贵）*/
        if (fetcher.isNone()) {
            fetcher = NOT_FOUND_FETCHER
        }

        let value = (fetcher.getOrThrow()).get(data, name)
        _fcache.add(key.toString(), fetcher.getOrThrow())

        return value
    }


    protected func checkForMissing(
        name: String, line: Int64, missingIsNull: Bool,
            value: DataModel): DataModel {
        if (isNO_FETCHER_FOUND(value)) {
            if (missingIsNull) { 
                return DataModelNull()
            }
            throw ExceptionContext(
                "No method or field with name '" + 
                name + "' on line " + line.toString(),
                name, line
            )
        } else {
            return value
        }
    }

    protected static func isThisName(name: String): Bool {
        DOT_NAME.equalsIgnoreAsciiCase(name) || 
        THIS_NAME.equalsIgnoreAsciiCase(name)
    }

    protected static let NOT_FOUND_FETCHER =
        NoneVariableFetcher()

/*==========================getValue============================*/
}

public class NoneVariableFetcher <: VariableFetcher {
    public func get(_: DataModel, _: String): DataModel {
        return Template.NO_FETCHER_FOUND.serialize()
    }
}


protected class Context {
    public Context(
        public let data: DataModel,
        public let parent: ?Context,
        public let index: Int64,
        public let onFirst: Bool,
        public let onLast: Bool) {}

    /* 创建一个新的 Context 对象，并初始化其属性 */
    public func next(data: DataModel): Context {
        return Context(data, this, index, onFirst, onLast)
    }

    public func next(
        data: DataModel, index: Int64, 
        onFirst: Bool, onLast: Bool): Context {
        return Context(data, this, index, onFirst, onLast)
    }
}

/** 一个template模版会被解析为多个Segment段对象 */
protected abstract class Segment <: Serializable<Segment> {
    protected open func execute(
        tpml: Template, ctx: Context, out: OutputStream): Unit

    protected open func decompile(
        delims: Delims, into: StringBuilder): Unit

    protected open func visit(Visitor: Visitor): Unit

    /**
     * 通过参数 indent 递归缩进
     * @param indent : 参数缩进应为非 {@code\n} 的空格字符
     * @param first  : 在第一行附加缩进（不管它是否有 {@code\n} ）
     * @param last   : 在后面没有文本的最后一个 {@code\n} 上附加缩进
     * @return       : 新创建的段(segment)或相同的段（如果没有变化）
     */
    protected open func indent(
        indent: String, first: Bool, last: Bool): Segment

    /**
     * 判断模板片段是否是独立的。根据 Mustache 规范，独立的片段
     * 可以在其前后有独立的空白字符，通常是空行或单独的标签行。
     * 一旦调用了{@code trim}，就会确定独立标签，以便在不重新
     * 分析模板的情况下进行适当的（重新）缩进
     * @return true : 如果该模版片段是独立的
     */
    protected open func isStandalone(): Bool

    /** 将数据写入 Writer 中。这是一个实用方法，用于处理模板渲染时的输出 
     */
    protected open func write(
        out: OutputStream, data: String): Unit {
        try {
            out.write(data.toArray())
        } catch (ioe: IOException) {
            throw MustacheException(ioe)
        }
    }

    /* 对输出内容进行转义操作，并将其写入到 out 对象中。这个方法用于处理诸如 HTML、XML 等格式中的字符转义。
     */
    protected static func escape(
        out: OutputStream, data: String, escape: Escaper): Unit {
        try {
            escape.escape(None, out, data)
        } catch (ioe: IOException) {
            throw MustacheException(ioe)
        }
    } 

    /*
     * 由子对象去选择实现，如果不实现就使用则抛出异常 @throws UnInplementException 
     */ 
    open public func toString(): String {
        throw UnInplementException()
    }
    open public func serialize(): DataModel {
        throw UnInplementException()
    }
    public static func deserialize(_: DataModel): Segment {
        throw UnInplementException()
    }
}

protected class Key {
    public Key(
        let dm: DataModel, let name: String) {  }
    
    public func hashCode(): Int64 {
        return getDataModelType().hashCode() + name.hashCode()
    }

    public func equals(other: Key): Bool {
        return getDataModelType()
            .equalsIgnoreAsciiCase(other.getDataModelType()) && 
                name.equalsIgnoreAsciiCase(other.name)
    }

    public func toString(): String {
        getDataModelType() + ":" + name
    }

    public func getDataModelType(): String {
        return match (dm) {
            case dm: DataModelStruct => "DataModelStruct"
            case dm: DataModelSeq    => "DataModelSeq"
            case dm: DataModelInt    => "DataModelInt"
            case dm: DataModelFloat  => "DataModelFloat"
            case dm: DataModelString => "DataModelString"  
            case dm: DataModelBool   => "DataModelBool"
            case dm: DataModelNull   => "DataModelNull"
            case _ => throw Exception("Irregular data types or data structures")
        }
    }
}

public class TemplateFragment <: Fragment {
    protected TemplateFragment(
        let segs: Array<Segment>,
        let currentCtx: Context,
        let tmpl: Template, 
        let compiler: Compiler) {}

    public override func execute(
            out: OutputStream): Unit {
        execute(currentCtx, out)
    }

    public override func execute(
            context: DataModel, out: OutputStream): Unit {
        execute(currentCtx.next(context), out)
    }

    public override func executeTemplate(
            tmpl: Template, out: OutputStream): Unit {
        tmpl.executeSegs(currentCtx, out)
    }

    public override func context(): DataModel {
        return currentCtx.data
    }

    public override func context(n: Int64): DataModel {
        return context(currentCtx, n)
    } 

    public override func decomplie(
            into: StringBuilder): StringBuilder {
        for (seg in segs) {
            seg.decompile(compiler._delims, into)
        }
        return into
    }

    private func context(ctx: ?Context, n: Int64): DataModel {
        var rctx = ctx.getOrThrow()
        return if (n == 0) {
            rctx.data
        } else {
            context(rctx.parent, n-1)
        }
    }

    private func execute(
            ctx: Context, out: OutputStream): Unit {
        for (seg in segs) {
            seg.execute(tmpl, ctx, out)
        }
    }
}

/**
* 封装传递给lambda的模板片段。该片段绑定到
* 调用lambda时生效的变量上下文。
*/
public abstract class Fragment {

    /**执行此片段；将其结果写入{@code out}*/
    public func execute(out: OutputStream): Unit

    /**使用提供的上下文执行此片段；将其结果写入{@code out}。这个
    * 提供的上下文将嵌套在片段的绑定上下文中*/
    public func execute(context: DataModel, out: OutputStream): Unit

    /**使用此片段的绑定上下文执行{@code tmpl}。这允许lambda
    * 将其片段解析为动态加载的模板，然后使用以下命令运行该模板
    * 与λ相同的上下文，允许λ充当“后期界限”
    * 模板，即您可以根据中的信息决定包含哪个模板背景*/
    public func executeTemplate(
        tmpl: Template, out: OutputStream): Unit

    /**执行此片段并将其结果作为字符串返回*/
    public func execute(): String {
        let byteArrayStream = ByteBuffer()
        let bufferedOutputStream = 
        BufferedOutputStream(byteArrayStream)
        execute(bufferedOutputStream)
        bufferedOutputStream.flush()
        return String.fromUtf8(readToEnd(byteArrayStream))
    }

    /**使用提供的上下文执行此片段；以字符串形式返回其结果
    * 提供的上下文将嵌套在片段的绑定上下文中*/
    public func execute(context: DataModel): String {
        let byteArrayStream = ByteBuffer()
        let bufferedOutputStream = BufferedOutputStream(byteArrayStream)
        execute(context, bufferedOutputStream)
        bufferedOutputStream.flush()
        return String.fromUtf8(readToEnd(byteArrayStream))
    }

    /**返回对此片段有效的上下文对象。对象的实际类型
    * 取决于传递给顶级模板的数据的结构。你知道在哪里
    * 您的lambdas已被执行，因此您知道按顺序将上下文转换为哪种类型
    * 检查它（无论是{@code Map}还是POJO或其他东西）*/
    public func context(): DataModel

    /**像{@link#contexts（）}一样，btu返回第{@coden}个父上下文对象
    * 返回与{@link#context（）}相同的值，{@code 1}返回父上下文，
    * {@code 2}返回父对象，依此类推。请注意，如果你要求父对象
    * 不存在，将抛出异常。您应该只在以下情况下使用此方法
    * 知道你的lambda是在具有特定沿袭的上下文中一致运行的*/
    public func context(n: Int64): DataModel


    /**分解此模板，并返回<em>近似值</em>
    * 解析它的原始模板。这不是的确切字符
    * 字符表示，因为原始文本不会被保留，因为这会
    * 当绝大多数用户使用库时，会对库的所有用户造成巨大的内存损失
    * 他们不称之为反编译。
    *
    * <p>限制：
    * ul><li>标签内的空白未被保留：即{@code{foo.bar}}变为
    * {@code{{foo.bar}}}。
    * <li>如果模板更改了分隔符，则不会保留这些分隔符。 
    * 在{@link Mustache.Compiler}上配置的分隔符用于所有反编译。
    * </ul>
    *
    * <p>此功能旨在启用i18n的lambdas，以便您可以恢复
    * lambda的内容（只要它们简单）用作
    * 翻译字符串。例如：{@code{#i18n}}你好{user.name}}！{/i18n}}可以是
    * 发送到可以使用{@code反编译}恢复文本的{@code i18n}lambda
    * {@code你好{{user.name}}！}在翻译词典中查找。这个
    * 翻译后的片段可以被编译和缓存，然后执行以代替
    * 原始片段使用{@link Template.Ffragment#context}。
    */
    public func decomplie(): String {
        decomplie(StringBuilder()).toString()
    }

    /**将此片段分解为{@code into}。请参阅{@link#decompile（）}。
    * @return{@code into}用于调用链*/
    public func decomplie(into: StringBuilder): StringBuilder
}

