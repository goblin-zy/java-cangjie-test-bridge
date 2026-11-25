/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is TrieBuilder
 * @since 0.38.2
 */
public class TrieConfig {

    var allowOverlaps: Bool = true
    var onlyWholeWords: Bool = false
    var onlyWholeWordsWhiteSpaceSeparated: Bool = false
    var caseInsensitive: Bool = false
    var stopOnHit: Bool = false

    public func isStopOnHit(): Bool {
        return stopOnHit
    }

    public func setStopOnHit(stopOnHit: Bool): Unit {
        this.stopOnHit = stopOnHit
    }

    public func isAllowOverlaps(): Bool {
        return allowOverlaps
    }

    public func setAllowOverlaps(allowOverlaps: Bool): Unit {
        this.allowOverlaps = allowOverlaps
    }

    public func isOnlyWholeWords(): Bool {
        return onlyWholeWords
    }

    public func setOnlyWholeWords(onlyWholeWords: Bool): Unit {
        this.onlyWholeWords = onlyWholeWords
    }

    public func isOnlyWholeWordsWhiteSpaceSeparated(): Bool {
        return onlyWholeWordsWhiteSpaceSeparated
    }

    public func setOnlyWholeWordsWhiteSpaceSeparated(onlyWholeWordsWhiteSpaceSeparated: Bool): Unit {
        this.onlyWholeWordsWhiteSpaceSeparated = onlyWholeWordsWhiteSpaceSeparated
    }

    public func isCaseInsensitive(): Bool {
        return caseInsensitive
    }

    public func setCaseInsensitive(caseInsensitive: Bool): Unit {
        this.caseInsensitive = caseInsensitive
    }
}
