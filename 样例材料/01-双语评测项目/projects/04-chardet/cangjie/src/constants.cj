/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package chardet4cj

public class Constants {


    public static let CHARSET_ISO_2022_CN: String = "ISO-2022-CN"
    public static let CHARSET_UTF_8: String = "UTF-8"
    public static let CHARSET_UTF_16BE: String = "UTF-16BE"
    public static let CHARSET_UTF_16LE: String = "UTF-16LE"

    public static let CHARSET_HZ_GB_2312: String = "HZ-GB-2312"
    public static let CHARSET_US_ASCCI: String = "US-ASCII"
}
public class ChardetException <: Exception {
    private var messages: String = ""
    public init() {
        super()
    }

    public init(messages: String) {
        super(messages)
        this.messages = messages
    }

    public func getMessage(): String {
        return messages
    }
    public override func toString(): String {
        return "ChardetException: ${messages}"
    }
}
