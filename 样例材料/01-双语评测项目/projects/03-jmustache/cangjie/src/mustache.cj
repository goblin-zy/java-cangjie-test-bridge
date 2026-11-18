package cjmustache

import stdx.serialization.serialization.*
import std.collection.concurrent.*
import std.collection.*
import stdx.encoding.json.ToJson
import std.unicode.*
import std.sync.*
import std.io.*

public class Mustache {
    protected static let NO_CHAR: Rune = r'\u{0000}'

    /** FAILING_LOADER 是一种默认配置。如果用户或系统没有正确设置模板加载器，
    * 就会使用这个默认的 "失败" 加载器，从而在执行时提醒用户模板加载未配置。
    */
    protected static let FAILING_LOADER: TemplateLoader
                            = DefenseTemplateLoader()

    protected static let DEFAULT_FORMATTER: Formatter
                            = DefaultFormatter()

    public static func compiler() {
        Compiler(false /*standardsMode=*/,
                 false /*strictSections=*/, 
                 None  /*nullValue=*/,
                 false /*missingIsNull=*/, 
                 false/*emptyStringIsFalse=*/,
                 false/*zeroIsFalse=*/, 
                 DEFAULT_FORMATTER, 
                 Escapers.HTML, 
                 FAILING_LOADER,
                 DefaultCollector(), 
                 Delims())
    }

    /**
    * 将提供的模板编译为可重复执行的中间形式。
    */
    protected static func compile(
        source: InputStream, compiler: Compiler): Template {
        let accum = Parser(compiler).parse(source)
        return Template(trim(accum.finish(), true), compiler)
    }

    private Mustache() {}

    /* 用于修剪 Mustache 模板解析过程中不同片段的空白字符，确保某些标签（如部分、块、注释）如果单独占一行时，
     * 可以正确移除前后多余的空白。这种空白修剪通常在模板中改善代码的可读性或生成更干净的输出。 */
    /* @top: 表示当前模板片段是否是顶级片段。如果为 true，表示当前片段集在最外层的模板中，允许进行特殊的空白处理 */
    protected static func trim(
        segs: Array<Segment>, top: Bool): Array<Segment> {
        let ll = segs.size
        for (ii in 0..ll) {
            let seg: Segment = segs[ii]
            var pseg: ?Segment  /* 表示当前片段的前一个片段（如果有） */
            var nseg: ?Segment  /* 表示当前片段的下一个片段（如果有） */
            if (ii > 0) { pseg = segs[ii-1] }
            else { pseg = None }
            if (ii < ll - 1) { nseg = segs[ii+1] }
            else { nseg = None }

            var prev: ?StringSegment = None
            var next: ?StringSegment = None
            if (pseg.isSome() &&
                pseg.getOrThrow() is StringSegment) {
                prev = (pseg.getOrThrow() as StringSegment)
            } else { prev = None }
            if (nseg.isSome() && 
                nseg.getOrThrow() is StringSegment) {
                next = (nseg.getOrThrow() as StringSegment)
            } else { next = None }

            let prevBlank: Bool = ((pseg.isNone() && top) ||
                (!prev.isNone() &&
                  prev.getOrThrow().trailsBlank()))
            let nextBlank: Bool = ((nseg.isNone() && top) || 
                (!next.isNone() && 
                  next.getOrThrow().leadsBlank()))

            if (seg is StandaloneSection) {  /* 处理独立的 Section 段 */
                let sect = (seg as StandaloneSection).
                getOrThrow()
                var indent: String = ""
                if (prevBlank && sect.firstLeadsBlank()) {
                    if (let Some(rprev) <- prev) {
                        indent = rprev.indent()
                        segs[ii-1] = rprev.trimTrailBlank()
                    }
                    sect.trimFirstBlank()
                    sect.standaloneStart(true)
                } 
                if (nextBlank && sect.lastTrailsBlank()) {
                    sect.trimLastBlank()
                    if (let Some(rnext) <- next) {
                        segs[ii+1] = rnext.trimLeadBlank()
                    }
                    sect.standaloneEnd(true)
                }
                if (sect is ParentTemplateSegment && 
                    !indent.equalsIgnoreAsciiCase("")) {
                    segs[ii] = 
                        (sect as ParentTemplateSegment).getOrThrow().
                        indent(indent, pseg.isNone(), nseg.isNone())
                }
            } 
            /* 对于部分模板片段 IncludedTemplateSegment，如果前后是空白，且片段独立存在一行，
             * 则将其设置为独立片段，并根据前一个片段的缩进进行缩进调整 */
            else if (seg is IncludedTemplateSegment) {
                var include = 
                (seg as IncludedTemplateSegment).getOrThrow()
                if (!prev.isNone() && prevBlank && nextBlank) {
                    let indent: String = prev.getOrThrow().indent()
                    include._standalone = true
                    if (!indent.equalsIgnoreAsciiCase("")) {
                        include = include.indent(
                            indent, pseg.isNone(), nseg.isNone())
                        segs[ii] = include 
                    }
                    if (next.isSome()) {
                        segs[ii+1] = 
                        (next.getOrThrow().trimLeadBlank())
                    }
                }
            }
            /* 对于注释或非输出片段（FauxSegment），如果前后片段都是空白字符，则将前后的空白字符修剪掉 */
            else if (seg is FauxSegment) { /* 处理注释或其他非打印片段 */
                if (prevBlank && nextBlank) {
                    if (pseg.isSome()) { 
                        segs[ii-1] = prev.
                        getOrThrow().trimTrailBlank() 
                    }
                    if (nseg.isSome()) { 
                        segs[ii+1] = next.
                        getOrThrow().trimLeadBlank() 
                    }
                }
            }
        }

        return segs
    }

    /** 按缩进方式缩进段
      * @param _segs : 如果需要缩进，则要克隆段
      * @param indent : 用于缩进的空间
      * @param _first : 是否在第一段上附加缩进
      * @param _last ： 是否在最后一段最后一个空换行符（后面没有字符）上附加缩进
      * @return ：克隆片段（如果更改）
      */
    protected static func indentSegs(
        _segs: Array<Segment>, indent: String, 
        _first: Bool, _last: Bool): Array<Segment> {
        /* 与trim不同，此方法在段发生更改时克隆段，因此必须处理返回值；
         * 可以使用对返回的简单身份检查来确定是否存在change_last:Bool */
        if (indent.equalsIgnoreAsciiCase("")) {
            return _segs
        }

        let length = _segs.size
        let copySegs = ArrayList<Segment>()
        var changed = false

        for (i in 0.._segs.size) {
            let seg: Segment = _segs[i]

            let pseg: ?Segment = if (i > 0) { 
                                    _segs[i-1]
                                } else { 
                                    None
                                }

            let nseg: ?Segment = if (i < length - 1) {
                                    _segs[i+1]
                                } else {
                                    None 
                                }

            var copy: Segment
            if (seg is AbstractSectionSegment) {
                let abseg = (seg as AbstractSectionSegment).getOrThrow()
                var first: Bool
                var last: Bool

                if (pseg.isNone()) {
                    first = _first
                } else if (abseg.isStandaloneStart()) {
                    first = true
                } else {
                    first = false
                }

                if (abseg.isStandalone()) {
                    last = false
                } else if (nseg.isNone()) {
                    last = _last
                } else {
                    last = true
                }
                copy = abseg.indent(indent, first, last)

            } else if (seg is StringSegment) {
                var first: Bool
                var last: Bool

                if (pseg.isNone()) {
                    first = _first
                } else if (pseg.getOrThrow().isStandalone()) {
                    first = true
                } else {
                    first = false
                }

                if (nseg.isNone()) {
                    last = _last
                } else if (nseg.getOrThrow() is
                    AbstractSectionSegment) {
                    let abseg = (
                        nseg.getOrThrow() as 
                            AbstractSectionSegment).getOrThrow()
                    last = !abseg.isStandaloneStart()
                } else if (nseg.getOrThrow().isStandalone()) {
                    last = false
                } else {
                    last = true
                }

                copy = seg.indent(indent, first, last)

            } else if (seg is IncludedTemplateSegment) {
                if (seg.isStandalone()) {
                    var last: Bool
                    if (nseg.isNone()) {
                        last = _last
                    } else if (nseg.getOrThrow().isStandalone()) {
                        last = false
                    } else {
                        last = true
                    }

                    copy = seg.indent(indent, false, last)
                } else {
                    copy = seg
                }
            } else {
                copy = seg.indent(indent, _first, _last)
            }

            if (!refEq(seg, copy)) {
                changed = true
            }
            copySegs.add(copy)
        }

        if (changed) {
            return copySegs.toArray()
        }

        return _segs
    }

    protected static func replaceBlockSegs(_segs: Array<Segment>, 
        blocks: HashMap<String, BlockSegment>): Array<Segment> {
        if (blocks.isEmpty()) {
            return _segs
        }

        let copySegs = ArrayList<Segment>()
        var changed: Bool = false

        for (i in 0.._segs.size) {
            let seg: Segment = _segs[i]
            var copy: Segment

            if (seg is BlockReplaceable) {
                copy = (seg as BlockReplaceable).
                    getOrThrow().replaceBlocks(blocks)
            } else {
                copy = seg
            }

            if (!refEq(seg, copy)) {
                changed = true
            }
            copySegs.add(copy)
        }
        if (changed) {
            return copySegs.toArray()
        }
        return _segs
    }

    protected static func restoreStartTag(
        text: StringBuilder, starts: Delims): Unit {
        text.insert(0, starts.start1)
        if (starts.start2 != NO_CHAR) {
            text.insert(1, starts.start2)
        }
    }
    
    //this method was never called, what was my intention here?
    protected static func allowsWhitespace(typeRune: Rune): Bool {
        return ((typeRune == r'=' /* change delimiters */) ||
               (typeRune == r'!' /* comment */))
    }

    protected static let TEXT: Int64 = 0
    protected static let MATCHING_START: Int64 = 1
    protected static let MATCHING_END: Int64 = 2
    protected static let TAG: Int64 = 3
}

public class DefenseTemplateLoader <: TemplateLoader {
    public func getTemplate(_: String): InputStream {
        throw UnsupportedException("Template loading not configured")
    }
}

public class DefaultFormatter <: Formatter {
    public func format(data: DataModel): String {
        return data.toString()
    }
}

/** 将模板编译为可执行形式。请参阅｛@link Mustache｝
 */
public class Compiler {
    /** 是否启用标准模式 */
    public let _standardsMode: Bool

    /** 当节解析为缺少值时是否抛出异常。如果为false，
      * 则简单地省略该部分（或在反向部分的情况下包含该部分）。
      * 如果为true，则抛出{@code MustacheException}
      */
    public let _strictSections: Bool

    /** 当变量解析为null时使用的值。如果此值为null（这是默认的null值），
      * 则将引发异常。如果{@link#missingIsNull}也为true，则当无法解析
      * 变量时将使用此值。
      *
      * <p>如果nullValue包含子字符串{@code{{name}}}，
      * 则该子字符串将被变量的名称替换。例如，如果null值为{@code？{{name}}？}
      * 缺少的变量是{@code foo}，那么将使用字符串{@code？foo？}</p>
      */
    public let _nullValue: ?String

    /** 如果此值为true，则缺失的变量将被视为返回null的变量。
      * 假设将｛@link#nullValue｝配置为非空值，则将使用
      *｛@link#nullValue｝代替它们
      */
    public let _missingIsNull: Bool

    /** 如果此值为true，则空字符串将被视为false值，
      * 就像在JavaScript mustache实现中一样。默认值为false
      */
    public let _emptyStringIsFalse: Bool

    /** 如果此值为true，则零将被视为false值，
      * 就像JavaScript mustache实现中一样。默认值为false
      */
    public let _zeroIsFalse: Bool

    /** 处理渲染模板时将对象转换为字符串。
      * 默认格式化程序使用{@link String#valueOf}
      */
    public let _formatter: Formatter

    /** 处理替换文本中的转义字符 */
    public let _escaper: Escaper

    /** 此编译过程中使用的模板加载器 */
    public let _loader: TemplateLoader

    /** 使用此编译器编译的模板所使用的收集器 */
    public let _collector: Collector

    /** 使用此编译器编译的模板中默认使用的定界符 */
    public let _delims: Delims

    protected init(_standardsMode: Bool, _strictSections: Bool, _nullValue: ?String,
                   _missingIsNull: Bool, _emptyStringIsFalse: Bool, _zeroIsFalse: Bool, 
                   _formatter: Formatter, _escaper: Escaper, _loader: TemplateLoader,
                   _collector: Collector, _delims: Delims) {
        this._standardsMode = _standardsMode;
        this._strictSections = _strictSections;
        this._nullValue = _nullValue;
        this._missingIsNull = _missingIsNull;
        this._emptyStringIsFalse = _emptyStringIsFalse;
        this._zeroIsFalse = _zeroIsFalse;
        this._formatter = _formatter;
        this._escaper = _escaper;
        this._loader = _loader;
        this._collector = _collector;
        this._delims = _delims;
    }

    /** 将提供的模板编译为可重复执行的中间形式 */ 
    public func compile(source: InputStream): Template {
        return Mustache.compile(source, this)
    }

    // /** 将提供的模板编译为可重复执行的中间形式 */
    public func compile(template: String): Template {
        let byteArrayStream = ByteBuffer()
        byteArrayStream.write(template.toArray())
        let temp = BufferedInputStream(byteArrayStream)
        return compile(temp)
    }

    /** 返回一个编译器，默认情况下该编译器可以转义HTML，也可以不转义HTML。
      * 注意：这是通过{@link#withEscaper}设置的任何擒纵器 */
    public func escapeHTML(escapeHTML: Bool): Compiler {
        if (escapeHTML) {
            return withEscaper(Escapers.HTML)
        }
        return withEscaper(Escapers.NONE)
    }

    /** 返回一个使用或不使用标准模式的编译器。标准模式禁用非标准cjmustache扩展，
      * 如在父上下文中查找缺失的名称 */
    public func standardsMode(_standardsMode: Bool): Compiler {
        return Compiler(_standardsMode, this._strictSections, this._nullValue,
                        this._missingIsNull, this._emptyStringIsFalse, this._zeroIsFalse,
                        this._formatter, this._escaper, this._loader, this._collector,
                        this._delims)
    }


    /** 返回一个编译器，当节引用缺少的值（｛@code true｝）或将缺少的值视为｛@code false｝
      *（默认值为｛@codefalse｝）时，该编译器会抛出异常 */
    public func strictSections(_strictSections: Bool): Compiler {
        return Compiler(this._standardsMode, _strictSections, this._nullValue,
                        this._missingIsNull, this._emptyStringIsFalse, this._zeroIsFalse,
                        this._formatter, this._escaper, this._loader, this._collector,
                        this._delims)
    }

    /** 返回一个编译器，该编译器将使用给定的值来处理任何缺失的变量，
      * 或者解析为null。这类似于{@link#nullValue}，
      * 不同的是它为丢失的键和返回null值的现有键返回提供的默认值 */
    public func defaultValue(_defaultValue: String): Compiler {
        return Compiler(this._standardsMode, this._strictSections, _defaultValue, true,
                        this._emptyStringIsFalse, this._zeroIsFalse, this._formatter,
                        this._escaper, this._loader, this._collector, this._delims)
    }
    

    /** 返回一个编译器，该编译器将对解析为null的任何变量使用给定值，
      * 但仍将对找不到访问器的变量引发异常。这类似于{@link#defaultValue}，]
      * 只是它区分了缺失的访问器和存在但返回null的访问器
      * <ul>
      * <li>在将cj对象用作上下文的情况下，如果没有字段或方法可以作为变量，则会引发异常</li>
      * <li>在将{@link Map}用作上下文的情况下，如果映射不包含变量的映射，
      * 将引发异常。如果映射包含映射到｛@code null｝的映射，则使用
      *｛@code nullValue｝</li></ul>
      */
    public func nullValue(_nullValue: String): Compiler {
        return Compiler(this._standardsMode, this._strictSections, _nullValue, false,
                        this._emptyStringIsFalse, this._zeroIsFalse, this._formatter,
                        this._escaper, this._loader, this._collector, this._delims)
    }

    /** 返回一个编译器，如果参数为true，则将空字符串视为false值 */
    public func emptyStringIsFalse(_emptyStringIsFalse: Bool): Compiler {
        return Compiler(this._standardsMode, this._strictSections, this._nullValue,
                        this._missingIsNull, _emptyStringIsFalse, this._zeroIsFalse,
                        this._formatter, this._escaper, this._loader, this._collector,
                        this._delims)
    }

    /** 返回一个编译器，如果参数为真，则将零视为假值 */
    public func zeroIsFalse(_zeroIsFalse: Bool):  Compiler {
        return Compiler(this._standardsMode, this._strictSections, this._nullValue,
                        this._missingIsNull, this._emptyStringIsFalse, _zeroIsFalse,
                        this._formatter, this._escaper, this._loader, this._collector,
                        this._delims)
    }

    /** 配置用于将对象转换为字符串｛@link格式化程序｝ */
    public func withFormatter(_formatter: Formatter): Compiler {
        return Compiler(this._standardsMode, this._strictSections, this._nullValue,
                        this._missingIsNull, this._emptyStringIsFalse, this._zeroIsFalse,
                        _formatter, this._escaper, this._loader, this._collector, this._delims)
    }

    /** 配置用于转义替换文本的｛@link Escaper｝*/
    public func withEscaper(_escaper: Escaper): Compiler {
        return Compiler(this._standardsMode, this._strictSections, this._nullValue,
                        this._missingIsNull, this._emptyStringIsFalse, this._zeroIsFalse,
                        this._formatter, _escaper, this._loader, this._collector, this._delims)
    }

    /** 返回一个编译器，该编译器被配置为使用提供的模板加载器来处理部分 */
    public func withLoader(_loader: TemplateLoader): Compiler {
        return Compiler(this._standardsMode, this._strictSections, this._nullValue,
                        this._missingIsNull, this._emptyStringIsFalse, this._zeroIsFalse,
                        this._formatter, this._escaper, _loader, this._collector, this._delims)
    }

    /** 返回配置为使用提供的收集器的编译器 */
    public func withCollector(_collector: Collector): Compiler {
        return Compiler(this._standardsMode, this._strictSections, this._nullValue,
                        this._missingIsNull, this._emptyStringIsFalse, this._zeroIsFalse,
                        this._formatter, this._escaper, this._loader, _collector, this._delims)
    }

    /** 返回一个编译器，该编译器被配置为使用提供的delims作为
      * 默认分隔符@param delims是一个形式为{@code AB CD}或{@code a D}的字符串，
      * 其中a和B是打开的delims，C和D是关闭的delims */
    public func withDelims(_delims: String): Compiler {
        return Compiler(this._standardsMode, this._strictSections, this._nullValue,
                                this._missingIsNull, this._emptyStringIsFalse, this._zeroIsFalse,
                                this._formatter, this._escaper, this._loader, this._collector,
                                Delims().updateDelims(_delims))
    }

    /** 返回在模板中用于空值属性{@code-name}的值。有关更多详细信息，请参阅｛@link#nullValue｝ */
    public func computerNullValue(name: String): DataModel {
        if (_nullValue.isNone()) { return DataModelNull() }
        return _nullValue.getOrThrow().replace("{{name}}", name).serialize()
    }

    /** 如果提供的值为“false”，则返回true。如果{@link#emptyStringIsFalse}为true，
      * 则空字符串被视为false。如果{@link#zeroIsFalse}为真，则零值被视为假 */
    public func isFalsey(value: DataModel): Bool {
        if (value is DataModelStruct) {
            return false
        }

        return ((_emptyStringIsFalse && isEmptyCharSequence(_formatter.format(value).serialize())) || 
                (_zeroIsFalse && (value is DataModelInt) && (value as DataModelInt).getOrThrow().getValue() == 0) || 
                (_zeroIsFalse && (value is DataModelFloat) && (value as DataModelFloat).getOrThrow().getValue() == 0.0f64))
    }

    /** 替换“.equals（value）”。例如，长度为0的值不能为空 */
    public func isEmptyCharSequence(value: DataModel): Bool {
        
        if (let Some(strValue) <- (value as DataModelString)) {
            return strValue.getValue().size == 0
        }

        return false
    }

    /** 使用此编译器配置的模板加载器加载和编译模板{@code-name}。
     * 请注意，这没有缓存：如果调用者希望多次使用加载的模板，则应缓存该模板。
     * @return : 编译模版 
     * @throws : MustacheException 如果模板无法加载（由于I/O异常）或编译（由于语法错误等）。
     */
    public func loadTemplate(name: String): Template {
        var tin: ?InputStream = None
        try {
            tin = _loader.getTemplate(name)
            return compile(tin.getOrThrow())
        } catch (e: Exception) {
                throw MustacheException(
                    "Unable to load template: " + name, e)
        } 
    }
}

/** 手卷解析器；呼！ */
protected class Parser {
    protected let delims: Delims
    protected let text = StringBuilder()

    protected var sourceRunes: ?Array<Rune> = None
    protected var index = 0
    protected var accum: Accumlator

    protected var state: Int64 = Mustache.TEXT
    protected var line: Int64 = 1
    protected var column: Int64 = 0
    protected var tagStartColumn: Int64 = -1

    public init(compiler: Compiler) {
        this.accum = Accumlator(compiler, true)
        this.delims = compiler._delims.copy()
    }

    public func parse(source: InputStream): Accumlator {
        getRunesFromInputStream(source)

        while (let Some(r) <- nextRune()) {
            column++
            parseRune(r)
            if (r == r'\n') {
                column = 0
                line++
            }
        }

        if (state == Mustache.TAG) {
            Mustache.restoreStartTag(text, delims)
        } else if (state == Mustache.MATCHING_END) {
            Mustache.restoreStartTag(text, delims)
            text.append(delims.end1)
        } else if (state == Mustache.MATCHING_START) {
            text.append(delims.start1)
        } else if (state == Mustache.TEXT) {
            // do nothing
        }
        accum.addTextSegment(text)
        return accum
    }

    protected func parseRune(c: Rune): Unit {
        if (state == Mustache.TEXT) {
            if (c == delims.start1) {
                state = Mustache.MATCHING_START
                tagStartColumn = column
                if (delims.start2 == Mustache.NO_CHAR) {
                    parseRune(Mustache.NO_CHAR)
                }
            } else {
                text.append(c)
            }
        }
        else if (state == Mustache.MATCHING_START) {
            if (c == delims.start2) {
                accum.addTextSegment(text)
                state = Mustache.TAG
            } else {
                text.append(delims.start1)
                state = Mustache.TEXT
                parseRune(c)
            }
        }
        else if (state == Mustache.TAG) {
            if (c == delims.end1) {
                state = Mustache.MATCHING_END
                if (delims.end2 == Mustache.NO_CHAR) {
                    parseRune(Mustache.NO_CHAR)
                }
            } else if (c == delims.start1 && text.size > 0 &&
                        text.toString().toRuneArray()[0] != r'!') {
                Mustache.restoreStartTag(text, delims)
                accum.addTextSegment(text)
                tagStartColumn = column

                if (delims.start2 == Mustache.NO_CHAR) {
                    accum.addTextSegment(text)
                    state = Mustache.TAG
                } else {
                    state = Mustache.MATCHING_START
                }

            } else {
                text.append(c)
            }
        }
        else if (state == Mustache.MATCHING_END) {
            if (c == delims.end2) {
                if (text.toString().toRuneArray()[0] == r'=') {
                    delims.updateDelims(text.toString().slice(begin: 1, end: text.size - 1))
                    text.reset(capacity: Some(1))
                    accum.addFauxSegment()
                } else {
                    if (delims.isStaches() && 
                        text.toString().toRuneArray()[0] == delims.start1) {

                        if (let Some(end3) <- nextRune()) {
                            if (end3 != r'}') {
                                throw MustacheParseException(
                                    "Invalid triple-mustache tag: {{" +
                                    text.toString() + "}}" + String(end3), line)
                            }
                        } else {
                            throw MustacheParseException(
                                "Invalid triple-mustache tag: {{" +
                                text.toString() + "}}", line)
                        }

                        text.replace(0, 1, "&")
                    }
                    accum = accum.addTagSegment(text, line)
                }
                state = Mustache.TEXT
            } else {
                text.append(delims.end1)
                state = Mustache.TAG
                parseRune(c)
            }
        }
    }

    protected func nextRune(): ?Rune {
        let next = sourceRunes.getOrThrow().get(index)
        index++
        return next
    }

    private func getRunesFromInputStream(sourse: InputStream): Unit {
        let bufferedInputStream = BufferedInputStream(sourse)
        let byteList = ArrayList<Byte>()
        let byteArr = Array<Byte>(1024, repeat: 0)
        var readLen = bufferedInputStream.read(byteArr)
        while (readLen > 0) {
            byteList.add(all: byteArr[0..readLen])
            readLen = bufferedInputStream.read(byteArr)
        }
        sourceRunes = String.fromUtf8(byteList.toArray()).toRuneArray()
    }
}

/* 负责累积模板的片段并在解析过程中管理不同的标签
 * 该类用于解析 Mustache 模板中的标签（例如 {{#section}}、{{> partial}} 等），
 * 并将这些标签转换为对应的模板片段（Segment）
 * 它通过处理模板中的文本和标签来构建最终模板的片段集合，这些片段将在模板渲染时使用 */
open protected class Accumlator {
    protected let _comp: Compiler
    protected let _topLevel: Bool
    protected let _segs = ArrayList<Segment>() 

    public init(compiler: Compiler, topLevel: Bool) {
        _comp = compiler      /* 传入的 Compiler 对象，用于编译模板时的上下文 */
        _topLevel = topLevel  /* 表示当前累积器是否处于顶级状态。如果是顶级累积器，则在某些情况下对文本片段的处理会有所不同 */
    }

    /* 将普通文本添加为模板片段。这个方法会将 StringBuilder 中的内容转化为 StringSegment 对象，存储在 _segs 列表中 */
    public func addTextSegment(text: StringBuilder): Unit {
        if (text.size > 0) {
            _segs.add(StringSegment(text.toString(),
                        _segs.isEmpty() && _topLevel))
            text.reset(capacity: Some(1))
        }
    }

    /* 解析 Mustache 模板中的标签（例如 {{#section}} 或 {{/section}}），并将标签处理为相应的模板片段 */
    public func addTagSegment(
        accum: StringBuilder, tagLine: Int64): Accumlator {
        let outer: Accumlator = this
        let tag: String = accum.toString().trim()
        let nextTagRunes = tag.toRuneArray()[1..]
        let nextTagsBuilder = StringBuilder() 
        for (r in nextTagRunes) {
            nextTagsBuilder.append(r)
        }
        let nextTags = nextTagsBuilder.toString().trim()
        accum.reset(capacity: Some(1))

        match (tag.toRuneArray()[0]) {
            case r'#' => requireNoNewlines(tag, tagLine)
                    return SectionSegmentAccumlator(
                        _comp, false, outer, nextTags, tagLine)
            
            case r'>' => _segs.add(
                    IncludedTemplateSegment(_comp, nextTags, tagLine))
                    return this

            case r'<' => requireNoNewlines(tag, tagLine)
                    return ParentTemplateSegmentAccumlator(
                        _comp, false, outer, nextTags, tagLine)

            case r'$' => requireNoNewlines(tag, tagLine)
                    return BlockSegmentAccumlator(
                        _comp, false, outer, nextTags, tagLine)

            case r'^' => requireNoNewlines(tag, tagLine)
                    return InvertedSegmentAccumlator(
                        _comp, false, outer, nextTags, tagLine)

            case r'/' => requireNoNewlines(tag, tagLine)
                    return addCloseSectionSegment(nextTags, tagLine)

            case r'!' => _segs.add(FauxSegment())
                    return this

            case r'&' => requireNoNewlines(tag, tagLine)
                    _segs.add(VariableSegment(
                        nextTags, tagLine, _comp._formatter, Escapers.NONE))
                    return this

            case _ => requireNoNewlines(tag, tagLine)
                    _segs.add(VariableSegment(
                        tag, tagLine, _comp._formatter, _comp._escaper))
                    return this
        }
    }

    public func addFauxSegment(): Unit {
        _segs.add(FauxSegment())
    }

    open public func finish(): Array<Segment> {
        _segs.toArray()
    }

    open protected func addCloseSectionSegment(
        tag: String, line: Int64): Accumlator {
        throw  MustacheParseException(
                "Section close tag with no open tag '" +
                tag + "'", line)
    }

    protected static func requireNoNewlines(
        tag: String, line: Int64): Unit {
        if (tag.indexOf(b'\n') != None || tag.indexOf(b'\r') != None) {
            throw MustacheParseException(
                "Invalid tag name: contains newline '" +
                tag + "'", line)
        }
    }

    protected static func requireSameName(
        name1: String, name2: String, line: Int64): Unit {
        if (!name1.equalsIgnoreAsciiCase(name2)) {
            MustacheParseException(
                "Section close tag with mismatched open tag '" +
                    name2 + "' != '" + name1 + "'", line)
        }
    }
}

protected class SectionSegmentAccumlator <: Accumlator {
    public SectionSegmentAccumlator(compiler: Compiler, topLevel: Bool,
            let outer: Accumlator,  let tag1: String, 
            let tagLine: Int64) {
        super(compiler, topLevel)
    }

    public override func finish(): Array<Segment> {
        throw MustacheParseException(
            "Section missing close tag '" + tag1 + "'", tagLine)
    }

    protected override func addCloseSectionSegment(itag: String,
        line: Int64): Accumlator {
        Accumlator.requireSameName(tag1, itag, line)
        outer._segs.add(SectionSegment(_comp, itag, super.finish(), tagLine))
        return outer
    }
}

protected class ParentTemplateSegmentAccumlator <: Accumlator {
    public ParentTemplateSegmentAccumlator(compiler: Compiler, topLevel: Bool,
            let outer: Accumlator,  let tag1: String, let tagLine: Int64) {
        super(compiler, topLevel)
    }

    public override func finish(): Array<Segment> {
        throw MustacheParseException("Parent missing close tag '" +
                tag1 + "'", tagLine)
    }

    protected override func addCloseSectionSegment(itag: String,
        line: Int64): Accumlator {
        Accumlator.requireSameName(tag1, itag, line)
        outer._segs.add(ParentTemplateSegment(
            _comp, itag, super.finish(), tagLine))
        return outer
    }
}

protected class BlockSegmentAccumlator <: Accumlator {
    public BlockSegmentAccumlator(compiler: Compiler, topLevel: Bool,
            let outer: Accumlator,  let tag1: String, let tagLine: Int64) {
        super(compiler, topLevel)
    }

    public override func finish(): Array<Segment> {
        throw MustacheParseException("Block missing close tag '" +
            tag1 + "'", tagLine)
    } 

    protected override func addCloseSectionSegment(itag: String, 
        line: Int64): Accumlator {
        Accumlator.requireSameName(tag1, itag, line)
        outer._segs.add(BlockSegment(_comp, itag, super.finish(), tagLine))
        return outer
    }
}

protected class InvertedSegmentAccumlator <: Accumlator {
    public InvertedSegmentAccumlator(compiler: Compiler, topLevel: Bool, 
            let outer: Accumlator,  let tag1: String, let tagLine: Int64) {
        super(compiler, topLevel)
    }

    public override func finish(): Array<Segment> {
        throw MustacheParseException(
            "Inverted section missing close tag '" +
            tag1 + "'", tagLine)
    }

    protected override func addCloseSectionSegment(itag: String,
         line: Int64): Accumlator {
        Accumlator.requireSameName(tag1, itag, line)
        outer._segs.add(
            InvertedSegment(_comp, itag, 
            super.finish(), tagLine))
        return outer
    }
}

public class Delims {
    public var start1 = r'{'  
    public var end1   = r'}'
    public var start2 = r'{'
    public var end2   = r'}'

    public func isStaches(): Bool {
        start1 == r'{' && start2 == r'{' && end1 == r'}' && end2 == r'}'
    }

    public func updateDelims(dtext: String): Delims {
        var delims: Array<String> = dtext.split(" ")
        if (delims.size != 2) {
            throw MustacheException(errmsg(dtext)) 
        }

        let delimsStr1 = delims[0]
        let delimsStr2 = delims[1]
        let tempDelims1 = delimsStr1.toRuneArray()
        let tempDelims2 = delimsStr2.toRuneArray()
        
        match (delims[0].size) {
            case 1 => start1 = tempDelims1[0]
                      start2 = Mustache.NO_CHAR
            case 2 => start1 = tempDelims1[0]
                      start2 = tempDelims1[1]
            case _ => throw MustacheException(errmsg(dtext))
        }

        match (delims[1].size) {
            case 1 => end1 = tempDelims2[0]
                      end2 = Mustache.NO_CHAR
            case 2 => end1 = tempDelims2[0]
                      end2 = tempDelims2[1]
            case _ => throw MustacheException(errmsg(dtext))
        }

        return this
    }

    public func addTag(
        prefix: Rune, name: String, 
        into: StringBuilder): Unit {
        into.append(start1)
        into.append(start2)
        if (prefix != r' ') {
            into.append(prefix)
        }
        into.append(name)
        into.append(end1)
        into.append(end2)
    }

    public func copy(): Delims {
        let d = Delims()
        d.start1 = start1
        d.start2 = start2
        d.end1 = end1
        d.end2 = end2
        return d
    }

    private static func errmsg(dtext: String): String {
        "Invalid delimiter configuration '" + dtext + "'. Must be of the " +
        "form {{=1 2=}} or {{=12 34=}} where 1, 2, 3 and 4 are delimiter chars."
    }
}

/** 处理渲染模板时将对象转换为字符串 
 */
public interface Formatter { 
    /** 将 @Param value 转换为 String 以包含在模板中
      */
    func format(value: DataModel): String
}

public interface VariableFetcher {
    /** 从提供的上下文对象中读取名为 @Param name 的变量 
      */
    func get(ctx: DataModel, name: String): DataModel
}

/* 处理替换文本中的转义字符 */
public interface Escaper {
    /* 用转义序列替换相应的字符 */
    func escape(raw: String): String

    /**
      * 如果需要，使用转义序列转义原始字符，并将其附加到可追加/可写字符序列中
      * @param stringBuilder  : 可追加/可写的字符串构造器
      * @param out            ：可追加/可写的流对象
      * @param raw            ：输入字符串
      */
    func escape(
        stringBuilder: ?StringBuilder, out: ?OutputStream, 
        raw: String): Unit {
        appendOrWrite(stringBuilder, out, raw)
    }

    // 由子对象选择实现，不实现就使用的话将抛出异常 @throws UnInplementException
    func toString(): String {
        throw UnInplementException()
    }
}



/** 处理加载部分(partial)模板 
 */
public interface TemplateLoader {
    /** 返回具有提供名称的模板的输入流对象*/
    func getTemplate(name: String): InputStream
}


/**用于在不执行模板的情况下访问模板中的标签*/
public interface Visitor {
    /** 访问文本段。这些文本块通常在执行模板时按原样再现 
      * @param text :文本块。可能包含换行符 
      */
    func visitText(text: String): Unit

    /** 访问变量标签。
      * @param name : 变量的名称。
      */
    func visitVariable(name: String): Unit

    /** 问包含（partial）标签。
      * @param name : 标记指定的部分模板的名称。
      * @return : 如果模板应该被解析和访问，则返回true，跳过则返回false。
      */
    func visitInclude(name: String): Bool


    /** 访问父部分标签。默认情况下为向后兼容性
      * 返回<code>false</code>。
      * @param name标记指定的父部分模板的名称。
      * @return : 如果模板应该被解析和访问，则返回true，跳过则返回false。
      */
    func visitParent(_: String): Bool {
        return false
    }

    /** 访问块标签(block tag)。默认情况下跳过向后兼容性。
      * @param name块的名称。
      * @return : 如果应该访问块的内容，则返回true，跳过则返回false。
      */
    func visitBlock(_: String): Bool {
        return false
    }
    
    /** 访问分区标签(section tag)。
      * @param name节(section)的名称。
      * @return : 如果应该访问该部分的内容，则返回true，跳过则返回false。
      */
    func visitSection(name: String): Bool

    /** 访问倒置的分区标签(section tag)。
      * @param name反转部分的名称。
      * @return : 如果应该访问该部分的内容，则返回true，跳过则返回false。
      */
    func visitInvertedSection(name: String): Bool
}

public interface Collector {
    /** 在提供的上下文对象中为名为 @Param name 的变量创建一个提取器，该提取器永远不会为None。
      * 其中 fetcher 将被缓存，并在未来的上下文中重用，
      */
    func createFetcher(ctx: DataModel, name: String): ?VariableFetcher

    /** 创建用于缓存 VariableFetcher实例的映射。*/
    func createFetcherCache(): ConcurrentHashMap<String, VariableFetcher>
}


/** 命名段的辅助类 */
protected abstract class NamedSegment <: Segment {
    protected NamedSegment(
        protected let _name: String, 
        protected let _line: Int64) {}

    public override func serialize(): DataModel {
        return DataModelStruct().add(field<String>("_name", _name)).
            add(field<Int64>("_line", _line))
    }

    open public func toString(): String {
        return serialize().toJson().toJsonString()
    }
}

/* 用于处理 Mustache 模板中的变量。VariableSegment 代表模板中的一个变量插值部分，
 * 例如 {{name}}，它负责从上下文中查找相应的值并格式化输出 */
protected class VariableSegment <: NamedSegment {
    protected let _formatter: Formatter
    protected let _escaper: Escaper

    public init(name: String, line: Int64, 
        formatter: Formatter, escaper: Escaper) {
        super(name, line)
        _formatter = formatter
        _escaper = escaper
    }

    public override func execute(tmpl: Template, ctx: Context, 
        out: OutputStream): Unit {
        let value = tmpl.getValueOrDefault(ctx, _name, _line)   
        if (value is DataModelNull) {
            let msg: String = if (Template.isThisName(_name)) {
                "Resolved '.' to null (which is disallowed), on line " +
                    _line.toString()
            } else {
                "No key, method or field with name '" +
                    _name + "' on line " + _line.toString()
            }
            throw MustacheException(msg)
        }
        escape(out, _formatter.format(value), _escaper)
    } 

    public override func decompile(delims: Delims, 
        into: StringBuilder): Unit {
        delims.addTag(r' ', _name, into)
    }

    public override func visit(visitor: Visitor): Unit {
        visitor.visitVariable(_name)
    }

    public override func indent(_: String, _: Bool, 
        _: Bool): VariableSegment {
        return this
    }

    public override func isStandalone() {
        return false
    }

    public func toString(): String {
        return "Var(" + _name + ":" + _line.toString() + ")"
    }
}

protected interface StandaloneSection <: BlockReplaceable {
    func firstLeadsBlank(): Bool {
        let _segs = segs()
        if (_segs.size == 0 || !(_segs[0] is StringSegment)) { 
            return false 
        }
        return (_segs[0] as StringSegment).getOrThrow().leadsBlank()
    }

    func trimFirstBlank(): Unit {
        let _segs = segs()
        _segs[0] = (_segs[0] as StringSegment).getOrThrow().trimLeadBlank()
    }

    func lastTrailsBlank(): Bool {
        let _segs = segs()
        let lastIdx = _segs.size - 1

        if (_segs.size == 0 || !(_segs[lastIdx] is StringSegment)) { 
            return false 
        }

        return (_segs[lastIdx] as StringSegment).getOrThrow().trailsBlank()
    }

    func trimLastBlank(): Unit {
        let _segs = segs()
        let lastIdx = _segs.size - 1
        _segs[lastIdx] = (_segs[lastIdx] as StringSegment).
        getOrThrow().trimTrailBlank()
    }

    func isStandaloneEnd(): Bool
    func isStandaloneStart(): Bool
    func standaloneStart(standaloneStart: Bool): Unit
    func standaloneEnd(standaloneEnd: Bool): Unit

    func segs(): Array<Segment>
}

protected interface BlockReplaceable {
    func replaceBlocks(blocks: HashMap<String, BlockSegment>): Segment
}

protected abstract class AbstractSectionSegment <: NamedSegment & StandaloneSection {
    protected init(compiler: Compiler, name: String, 
        segs: Array<Segment>, line: Int64) {
        super(name, line)
        _comp = compiler
        _segs = Mustache.trim(segs, false)
    }

    protected init(original: AbstractSectionSegment, 
        segs: Array<Segment>) {
        super(original._name, original._line)
        _comp = original._comp
        _segs = segs
    }

    protected func executeSegs(tmpl: Template, 
        ctx: Context, out: OutputStream): Unit {
        for (seg in _segs) {
            seg.execute(tmpl, ctx, out)
        }
    }

    protected func indent(indent: String, first: Bool, 
        last: Bool): AbstractSectionSegment

    public override func isStandalone(): Bool 
    { return _standaloneEnd }
    public override func isStandaloneStart(): Bool 
    { return _standaloneStart }
    public override func isStandaloneEnd(): Bool 
    { return _standaloneEnd }
    public override func standaloneStart(
        standaloneStart: Bool): Unit 
    { this._standaloneStart = standaloneStart }
    public override func standaloneEnd(
        standaloneEnd: Bool): Unit 
    { this._standaloneEnd = standaloneEnd }

    public override func segs(): Array<Segment> 
    { return _segs }

    protected let _comp: Compiler
    protected let _segs: Array<Segment>
    protected var _standaloneStart: Bool = false
    protected var _standaloneEnd: Bool = false
}

// 如果可迭代，则迭代执行
protected class SectionSegment <: AbstractSectionSegment {
    public init(compiler: Compiler, name: String, 
        segs: Array<Segment>, line: Int64) {
        super(compiler, name, segs, line)
    }

    public init(
        original: SectionSegment, segs: Array<Segment>) {
        super(original, segs)
    }
    
    public override func execute(tmpl: Template, 
        ctx: Context, out: OutputStream): Unit {
        let value = tmpl.getSectionValue(ctx, _name, _line)
        
        if (let Some(iterValue) <- (value as DataModelSeq)) {
            let iter = iterValue.getItems().iterator()

            var index = 0
            let list = ArrayList<DataModel>()
            while (let Some(elem) <- iter.next()) {
                list.add(elem)
            }

            var count = list.size
            for (elem in list) {
                count--
                let onFirst: Bool = (index == 0)
                let onLast: Bool = !(count != 0)
                index++
                executeSegs(tmpl, 
                ctx.next(elem, index, onFirst, onLast), out)
            }
        } else if (let Some(boolValue) <- (value as DataModelBool)) {
            if (boolValue.getValue()) {
                executeSegs(tmpl, ctx, out)
            }
        } else if (_comp.isFalsey(value)) {
            // omit the section
        } else {
            executeSegs(tmpl, ctx.next(value), out)
        }
    }

    public override func decompile(
        delims: Delims, into: StringBuilder): Unit {
        delims.addTag(r'#', _name, into)
        for (seg in _segs) { seg.decompile(delims, into) }
        delims.addTag(r'/', _name, into)
    }

    public override func visit(visitor: Visitor): Unit {
        if (visitor.visitSection(_name)) {
            for (seg in _segs) {
                seg.visit(visitor)
            }
        }
    }
    public override func indent(indent: String, 
        first: Bool, last: Bool): SectionSegment {
        let segs: Array<Segment> = Mustache.indentSegs(
            _segs, indent, first, last)
        if (segs.equal(_segs)) {
            return this
        }
        return SectionSegment(this, segs)

    }
    public override func replaceBlocks(
        blocks: HashMap<String, BlockSegment>): SectionSegment {
        let segs = Mustache.replaceBlockSegs(_segs, blocks)
        if (segs.equal(_segs)) {
            return this
        }
        return SectionSegment(this, segs)
    }
    public func toString(): String {
        return "Section(" + _name + ":" +
        _line.toString() + "): " + 
        _segs._toString()
    }
}

/** 使用$作为符号的父部分参数 */
protected class BlockSegment <: AbstractSectionSegment {
    public init(compiler: Compiler, name: String,
        segs: Array<Segment>, line: Int64) {
        super(compiler, name, segs, line)
    }

    public init(
        original: BlockSegment, segs: Array<Segment>) {
        super(original, segs)
    }

    public override func execute(tmpl: Template, 
        ctx: Context, out: OutputStream): Unit {
        executeSegs(tmpl, ctx, out)
    }

    public override func decompile(delims: Delims, 
        into: StringBuilder): Unit {
        delims.addTag(r'$', _name, into)
        for (seg in _segs) { 
            seg.decompile(delims, into)
        }
        delims.addTag(r'/', _name, into)
    }

    public override func visit(visitor: Visitor): Unit {
        if (visitor.visitBlock(_name)) {
            for (seg in _segs) {
                seg.visit(visitor)
            }
        }
    }

    protected override func indent(indent: String, first: Bool,
        last: Bool): BlockSegment {
        let segs: Array<Segment> = Mustache.indentSegs(
            _segs, indent, first, last)
        if (segs.equal(_segs)) {
            return this
        }
        return BlockSegment(this, segs)
    }

    public override func replaceBlocks(
        blocks: HashMap<String, BlockSegment>): BlockSegment {
        if (let Some(extracedBlocks) <- blocks.get(_name)) {
            return BlockSegment(this, extracedBlocks._segs)
        } else {
            let segs: Array<Segment> = Mustache.
            replaceBlockSegs(_segs, blocks)
            if (segs.equal(_segs)) {
                return this
            }
            return BlockSegment(this, segs)
        }
    }

    public func toString() {
        return "Block(" + _name + ":" + _line.toString() +
        "): " + _segs._toString()
    }
}

protected abstract class AbstractPartialSegment <: NamedSegment {
    protected let _comp: Compiler
    protected let _indent: String
    private let lock = Mutex()
    private var _template: ?Template = None 

    protected init(compiler: Compiler, name: String, line: Int64,
        indent: String) {
        super(name, line)
        _comp = compiler
        _indent = indent
    }

    public override func execute(_: Template, ctx: Context, 
        out: OutputStream): Unit {
        /** 我们必须注意保留我们的上下文，而不是创建一个新的上下文，
          * 如果我们只是用ctx.data调用execute（），就会发生这种情况 */
        getTemplate().executeSegs(ctx, out)
    }

    protected func getTemplate(): Template {
        var currentTemplate = _template

        if (currentTemplate.isNone()) {
            lock.lock()
            try {
                currentTemplate = _template
                if (currentTemplate.isNone()) {
                    currentTemplate = _loadTemplate()
                    _template = currentTemplate
                }
            } finally {
                lock.unlock()
            }
        }

        return currentTemplate.getOrThrow()
    }

    open protected func _loadTemplate(): Template {
        return _comp.loadTemplate(_name).indent(_indent)
    }

    public func isStandalone(): Bool
}

/** 一个按规范加载和执行子模板的段，称为段(Segment) */
protected class IncludedTemplateSegment <: AbstractPartialSegment {
    public init(compiler: Compiler, name: String, line: Int64) {
        super(compiler, name, line, "")
    }

    private init(compiler: Compiler, name: String, 
        line: Int64, indent: String) {
        super(compiler, name, line, indent)
    }

    public override func decompile(deilms: Delims, 
        into: StringBuilder): Unit {
        deilms.addTag(r'<', _name, into)
    }

    public override func visit(visitor: Visitor): Unit {
        if (visitor.visitInclude(_name)) {
            getTemplate().visit(visitor)
        }
    }

    protected override func indent(indent: String, 
        _: Bool, _: Bool): IncludedTemplateSegment {
        if (_standalone.isNone()) {
            throw NoneValueException()
        }

        let r_standalone = _standalone.getOrThrow()
        if (indent.equalsIgnoreAsciiCase("") ||
            !r_standalone) {
            return this
        }
        
        let s = IncludedTemplateSegment(_comp, _name, _line, 
            indent + this._indent)
        s._standalone = r_standalone
        return s
    }

    public func toString(): String {
        return "Include(name=" + _name + ", indent=" + _indent +
            ", standalone=" + _standalone.getOrThrow().toString() + ")"
    }
    public override func isStandalone(): Bool {
        return _standalone.getOrThrow()
    } 
    protected var _standalone: ?Bool = None
}

/** 通过称为继承的规范加载和执行父模板的段 */
protected class ParentTemplateSegment<: AbstractPartialSegment & StandaloneSection {
    public init(compiler: Compiler, name: String, 
        segs: Array<Segment>, line: Int64) {
        this(compiler, name, segs, line, "")
    }

    private init(compiler: Compiler, name: String, 
        segs: Array<Segment>, line: Int64, indent: String) {
        super(compiler, name, line, indent)
        this._segs = Mustache.trim(removeNonBlocks(segs), true)
        this._blocks = HashMap<String, BlockSegment>()
    }

    private init(original: ParentTemplateSegment, segs: Array<Segment>,
        indent: String, blocks: HashMap<String, BlockSegment>) {
        super(original._comp, original._name, original._line, 
        indent + original._indent)
        this._segs = segs
        this._standaloneStart = original._standaloneStart
        this._standaloneEnd = original._standaloneEnd
        let newBlocks = HashMap<String, BlockSegment>()
        newBlocks.add(all: original._blocks)
        newBlocks.add(all: blocks)
        this._blocks = newBlocks 
    }

    private static func removeNonBlocks(
        segs: Array<Segment>): Array<Segment> {
        let copy = ArrayList<Segment>()
        for (seg in segs) {
            if (seg is BlockSegment) {
                copy.add(seg)
            } 
        }

        return copy.toArray()
    }

    public override func decompile(delims: Delims,
        into: StringBuilder) {
        delims.addTag(r'<', _name, into)
    }

    public override func visit(visitor: Visitor): Unit {
        if (visitor.visitParent(_name)) {
            getTemplate().visit(visitor)
        }
    }

    public override func indent(indent: String, 
        _: Bool, _: Bool): ParentTemplateSegment {
        if (indent.equalsIgnoreAsciiCase("") ||
            !_standaloneStart) {
            return this
        }
        return ParentTemplateSegment(this, this._segs, 
                indent, HashMap<String, BlockSegment>())
    }

    protected override func _loadTemplate(): Template {
        let blocks = HashMap<String, BlockSegment>()
        for (seg in _segs) {
            if (seg is BlockSegment) {
                let bs = (seg as BlockSegment).getOrThrow()
                blocks.add(bs._name, bs)
            }
        }
        blocks.add(all: _blocks)
        return super._loadTemplate().replaceBlocks(blocks)
    }

    public override func lastTrailsBlank(): Bool {
        let _segs: Array<Segment> = segs()
        let lastIdx: Int64 = _segs.size - 1 

        if (lastIdx < 0) { 
            return true 
        }

        if (!(_segs[lastIdx] is StringSegment)) { 
                return false 
            }
        return (_segs[lastIdx] as StringSegment).getOrThrow().trailsBlank()
    }

    public override func trimLastBlank(): Unit {
        let _segs: Array<Segment> = segs()
        let idx: Int64 = _segs.size - 1
        
        if (idx < 0) { 
            return 
        }

        _segs[idx] = (_segs[idx] as StringSegment).getOrThrow().trimTrailBlank()
    }

    public override func replaceBlocks(
        blocks: HashMap<String, BlockSegment>): ParentTemplateSegment {
        return ParentTemplateSegment(this, _segs, "", blocks)
    }

    public func segs(): Array<Segment> 
    { return _segs }
    public override func isStandalone(): Bool 
    { return _standaloneEnd }
    public override func isStandaloneStart(): Bool 
    { return _standaloneStart }
    public override func isStandaloneEnd(): Bool 
    { return _standaloneEnd }
    public override func standaloneStart(standaloneStart: Bool): Unit 
    { this._standaloneStart = standaloneStart }
    public override func standaloneEnd(standaloneEnd: Bool): Unit 
    { this._standaloneEnd = standaloneEnd }

    public func toString(): String {
        return "Parent(name=" + _name + ", indent=" + _indent + 
        ", standaloneStart=" + _standaloneStart.toString() + ")"
    }

    protected let _segs: Array<Segment>
    protected var _standaloneStart: Bool = false
    protected var _standaloneEnd: Bool = false
    protected let _blocks: HashMap<String, BlockSegment>
} 

/** 表示倒置截面的线段(inverted section) */
protected class InvertedSegment <: AbstractSectionSegment {
    protected let __comp: Compiler
    public init(compiler: Compiler, name: String, 
        segs: Array<Segment>, line: Int64) {
        super(compiler, name, segs, line)
        __comp = compiler
    }
    public init(original: InvertedSegment, segs: Array<Segment>) {
        super(original, segs)
        __comp = original._comp
    }

    public override func execute(tmpl: Template, 
        ctx: Context, out: OutputStream): Unit {
        let value = tmpl.getSectionValue(ctx, _name, _line)
        if (let Some(iterValue) <- (value as DataModelSeq)) {
            let iter = iterValue.getItems().iterator()
            if (iter.next().isNone()) {
                executeSegs(tmpl, ctx, out)
            }
        } else if (let Some(boolValue) <- (value as DataModelBool)) {
            if (!boolValue.getValue()) {
                executeSegs(tmpl, ctx, out)
            }
        } else if (_comp.isFalsey(value)) {
            executeSegs(tmpl, ctx, out)
        }
    }

    public override func decompile(delims: Delims,
        into: StringBuilder): Unit {
        delims.addTag(r'$', _name, into)
        for (seg in _segs) { seg.decompile(delims, into) }
        delims.addTag(r'/', _name, into)
    }

    public override func visit(visitor: Visitor): Unit {
        if (visitor.visitInvertedSection(_name)) {
            for (seg in _segs) {
                seg.visit(visitor)
            }
        }
    }

    protected override func indent(indent: String, 
        first: Bool, last: Bool): InvertedSegment {
        let segs: Array<Segment> = Mustache.indentSegs(
            _segs, indent, first, last)
        if (segs.equal(_segs)) {
            return this
        }
        return InvertedSegment(this, segs)
    }

    public override func replaceBlocks(
        blocks: HashMap<String, BlockSegment>): InvertedSegment {
        let segs: Array<Segment> = Mustache.
            replaceBlockSegs(_segs, blocks)
        if (segs.equal(_segs)) {
            return this
        }
        return InvertedSegment(this, segs)
    }
    
    public func toString() {
        return "Inverted(" + _name + ":" + 
        _line.toString() + "): " + _segs._toString();
    }
}

/** 再现字符串的简单片段 */
protected class FauxSegment <: Segment {
    public override func execute(_: Template, 
        _: Context, _: OutputStream): Unit {}

    public override func decompile(_: Delims, 
        _: StringBuilder): Unit {} 

    public override func visit(_: Visitor): Unit {}

    public override func indent(_: String, 
        _: Bool, _: Bool): FauxSegment { return this }

    public override func isStandalone(): Bool { true }

    public func ToString() { "Faux" }
}

protected class StringSegment <: Segment {
    public StringSegment(let _text: String, let _leadBlank: Int64, 
        let _trailBlank: Int64, let _first: Bool) {
            if (!(_leadBlank >= -1) || !(_trailBlank >= -1)) {
                throw Exception("_leadBlank or _trailBlank < -1")
            }
        }

    public init(text: String, first: Bool) {
        this(text, blankPos(text, true, first),
            blankPos(text, false, first), first)
    }


    /* 判断当前字符串片段是否有前导空白或尾随空白。
     * 返回 _leadBlank 和 _trailBlank 是否等于 -1 来确定是否有空白 */
    public func leadsBlank(): Bool { return _leadBlank != -1 }
    public func trailsBlank(): Bool { return _trailBlank != -1 }
    
    /* 这两个方法分别用于修剪字符串片段的前导和尾随空白字符，返回新的 StringSegment 实例 */
    public func trimLeadBlank(): StringSegment {
        if (_leadBlank == -1) { 
            return this 
        }

        let lpos = _leadBlank + 1
        let newTrail = if (_trailBlank == -1) {
                            -1 
                        } else { 
                            _trailBlank - lpos 
                        }

        StringSegment(_text.slice(begin: lpos), -1, newTrail, _first)
    } 
    
    public func trimTrailBlank(): StringSegment {
        return if (_trailBlank == -1) { 
            this 
        } else { 
            StringSegment(_text.slice(end: _trailBlank), _leadBlank, -1, _first)
        }
    }

    /** 计算部分标识的缩进,如果字符串尾部没有空白或者尾随空白超出了字符串长度，
      * 则返回空字符串。否则返回 _trailBlank 之后的部分
      * @reutrn : 缩进空格或空字符串
      */
    func indent(): String {
        if (_trailBlank == -1 || _trailBlank >= _text.size) {
            return ""
        }
        return _text.slice(begin: _trailBlank)
    }

    public func indent(indent: String, 
        first: Bool, last: Bool): StringSegment {

        if (indent.equalsIgnoreAsciiCase("")) { 
            return this
        }

        let reindent = reindent(_text, indent, first, last)
        return StringSegment(reindent, _first)
    }

    public override func isStandalone(): Bool {
        return false
    }

    public override func execute(_: Template, 
        _: Context, out: OutputStream): Unit {
        write(out, _text)
    }

    public override func decompile(_: Delims, 
        into: StringBuilder): Unit {
        into.append(_text)
    }

    public override func visit(visitor: Visitor): Unit {
        visitor.visitText(_text)
    }

    public func toString() {
        "Text(" + _text.replace("\r", "\\r").replace("\n", "\\n") + ")" + 
            _leadBlank.toString() + "/" + _trailBlank.toString()
    }

    /* 这个方法用于重新缩进字符串。如果 first 为真，在字符串开头添加缩进；
     * 如果在字符串中遇到换行符，则在换行符后添加缩进 */
    private static func reindent(input: String, indent: String,
        first: Bool, last: Bool): String {
        let inputRunes = input.toRuneArray()
        let length = inputRunes.size
        let stringBuild = StringBuilder(indent.size + length)

        if (first == true) {
            stringBuild.append(indent)
        }

        for (ii in 0..length) {
            let c: Rune = inputRunes[ii]
            stringBuild.append(c)
            if (c == r'\n' && (last || ii != length - 1)) {
                stringBuild.append(indent)
            }
        }

        return stringBuild.toString()
    }

    /* 这个静态方法用于确定字符串中的空白字符位置。它会根据 leading 标志来决定查找前导还是尾随空白。
     * 如果是查找前导空白，从字符串的开头开始遍历；如果查找尾随空白，从字符串末尾开始向前遍历
     * 如果在字符串中找到了换行符（\n），就返回该位置；如果没有找到空白字符，则返回 -1*/
    private static func blankPos(text: String, 
        leading: Bool, first: Bool): Int64 {
        let textRunes = text.toRuneArray()
        let len = textRunes.size

        var ii: Int64 = if (leading) { 0 }
                        else { len - 1 }
        let ll: Int64 = if (leading) { len }
                        else { -1 }
        let dd: Int64 = if (leading) { 1 }
                        else { -1 }

        while (ii != ll) {
            var c = textRunes[ii]
            if (c == r'\n') { 
                return if (leading) { ii }
                        else { ii + 1 }
            }
            if (!c.isWhiteSpace()) { return -1 }
            ii += dd
        }
        /* 如果这是第一个字符串段，我们正在寻找尾随空格，
         * 那么一个完全空白的段（但缺少换行符）就是所有尾随空格 */
        return if (leading || !first) { -1 } else { 0 }
    }
}

extend<T> Array<T> where T <: Segment {
    public func equal(segs: Array<T>): Bool {
        let size1 = this.size
        let size2 = segs.size

        if (size1 != size2) { return false }
        for (i in 0..size1) {
            if (!refEq(this[i], segs[i])) {
                return false
            }
        }
        
        return true
    }

    public func _toString(): String {
        let stringBuilder = StringBuilder()
        stringBuilder.append("[")

        for (i in 0..this.size) {
            stringBuilder.append(this[i].toString())
            if (i != this.size - 1) {
                stringBuilder.append(", ")
            }
        }

        stringBuilder.append("]")
        return stringBuilder.toString()
    }
}

extend StringBuilder {
    public func insert(index: Int64, r: Rune) {
        let str = this.toString()
        this.reset(capacity: Some(1))
        this.append(str.slice(end: index) + r.toString() + str.slice(begin: index))
    }

    public func replace(l: Int64, r: Int64, s: String) {
        let str = this.toString()
        this.reset(capacity: Some(1))
        this.append(str.slice(end: l) + s + str.slice(begin: r))
    }
}

extend DataModel {
    public func toString(): String {
        return match (this) {
            case str: DataModelString => str.getValue()
            case i64: DataModelInt => i64.getValue().toString()
            case f64: DataModelFloat => f64.getValue().toString()
            case bool: DataModelBool => bool.getValue().toString()
            case seq: DataModelSeq => String.join(seq.getItems() |> 
                                        map {item: DataModel => item.toString() } |>
                                            collectArray<String>, delimiter: ", ")
            case none: DataModelNull => ""
            case _ => throw MustacheException("Unsupported type")
        }
    }
}

extend String {
    public func slice(begin!: Int64 = -1, end!: Int64 = -1): String {
        let thisRunes = this.toRuneArray()
        let runes = if (begin == -1 && end == -1) {
            thisRunes
        } else if (begin == -1 && end != -1) {
            thisRunes[..end]
        } else if (begin != -1 && end == -1) {
            thisRunes[begin..]
        } else {
            thisRunes[begin..end]
        }
        let stringBuilder = StringBuilder()
        for (r in runes) {
            stringBuilder.append(r)
        }
        return stringBuilder.toString()
    }
}