package cjmustache

 /* 捕获在 Mustache 模板处理过程中可能发生的各种错误,可以用于标识解析或执行模板时发生的任何问题。 */
open public class MustacheException <: Exception {
    private let cause: Exception

    public init(message: String) {
        super(message)
        cause = Exception()
    }

    public init(cause: Exception) {
        super(cause.message)
        this.cause = cause
    }

    public init(message: String, cause: Exception) {
        super(message)
        this.cause = cause
    }
}

/* 用于捕获和传达与模板上下文相关的错误信息 */
public class ExceptionContext <: MustacheException {
    /** @Param key: The key that caused the problem.
    *   @Param lineNo: The line number of the template on which the problem occurred.
    */
    public let key: String
    public let lineNo: Int64

    public init(message: String, key: String, lineNo: Int64) {
        super(message)
        this.key = key
        this.lineNo = lineNo
    }

    public init(
        message: String, key: String, lineNo: Int64, cause: Exception) {
        super(message, cause)
        this.key = key
        this.lineNo = lineNo
    }
}


public class MustacheParseException <: MustacheException {
    public init(message: String) {
        super(message)
    }

    public init(message: String, lineNo: Int64) {
        super(message + " @ line " + lineNo.toString())
    }
}

public class UncheckedIOException <: Exception {
    public init() {
        super("This is UncheckedIOException.")
    }
    public override func getClassName(): String {
        "UncheckedIOException"
    } 
}

public class UnInplementException <: Exception {
    public init() {
        super("No ImplementException.")
    }
    public override func getClassName(): String {
        "UnImplementException"
    }    
}

public class ShouldNotReachHereException <: Exception {
    public init() {
        super("ShouldNotReachHereException")
    }
    public override func getClassName(): String {
        "ShouldNotReachHereException"
    }
}

public class RuntimeException <: Exception {
    let e: Exception

    public init(e: Exception) {
        super("RuntimeException")
        this.e = e
    }
    public override func getClassName(): String {
        "RuntimeException"
    }
}
