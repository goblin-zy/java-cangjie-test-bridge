/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

package diffUtils4cj

public class DiffRow <: ToString {
    private var tag: Tag
    private var oldLine: String
    private var newLine: String

    /**
     * Creates a DiffRow
     * 
     * @param The Tag
     * @param The oldLine
     * @param The newLine
     * 
     * @since 0.39.3
     */
    public init(tag: Tag, oldLine: String, newLine: String) {
        this.tag = tag
        this.oldLine = oldLine
        this.newLine = newLine
    }

    /**
     * Returns the Tag
     *
     * @return the Tag
     *
     * @since 0.39.3
     */
    public func getTag(): Tag {
        return tag
    }

    /**
     * Set the Tag
     *
     * @param the Tag
     *
     * @since 0.39.3
     */
    public func setTag(tag: Tag): Unit {
        this.tag = tag
    }

    /**
     * Returns the OldLine
     *
     * @return the OldLine
     *
     * @since 0.39.3
     */
    public func getOldLine():String {
        return oldLine
    }

    /**
     * Set the OldLine
     *
     * @param the OldLine
     *
     * @since 0.39.3
     */
    public func setOldLine(oldLine: String): Unit {
        this.oldLine = oldLine
    }

    /**
     * Returns the NewLine
     *
     * @return the NewLine
     *
     * @since 0.39.3
     */
    public func getNewLine(): String {
        return newLine
    }

    /**
     * Set the NewLine
     *
     * @param the NewLine
     *
     * @since 0.39.3
     */
    public func setNewLine(newLine: String): Unit {
        this.newLine = newLine
    }

    /**
     * Returns the String
     *
     * @return the String
     *
     * @since 0.39.3
     */
    public func toString(): String {
        return "[${this.tag.toString()}" + ",${this.oldLine}" + ",${this.newLine}" + "]";
    }
}

public enum Tag <: ToString {
    | INSERT
    | DELETE
    | CHANGE
    | EQUAL

    /**
     * Returns the String
     *
     * @return the String
     *
     * @since 0.39.3
     */
    public func toString(): String {
        return match(this) {
            case INSERT => "INSERT"
            case DELETE => "DELETE"
            case CHANGE => "CHANGE"
            case EQUAL => "EQUAL"
        }
    }
}