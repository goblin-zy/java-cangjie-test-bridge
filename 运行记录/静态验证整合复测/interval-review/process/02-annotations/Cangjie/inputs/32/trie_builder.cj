/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is TrieBuilder
 * @since 0.38.2
 */
public class TrieBuilder {
    
    private let delegate: PayloadTrieBuilder<String> = PayloadTrie.builder()
    
    /**
     * Default (empty) constructor.
     */
    protected init() {}

    /**
     * Configure the Trie to ignore case when searching for keywords in the text.
    * This must be called before calling addKeyword because the algorithm converts
    * keywords to lowercase as they are added, depending on this case sensitivity
    * setting.
    *
    * @return This builder.
    */
    public func ignoreCase(): TrieBuilder {
        delegate.ignoreCase()
        return this
    }

    /**
    * Configure the Trie to ignore overlapping keywords.
    *
    * @return This builder.
    */
    public func ignoreOverlaps(): TrieBuilder {
        delegate.ignoreOverlaps()
        return this
    }

    /**
     * Adds a keyword to the Trie's list of text search keywords.
     *
     * @param keyword The keyword to add to the list.
     * @return This builder.
     * @throws NullPointerException if the keyword is null.
     */
    public func addKeyword(keyword: String): TrieBuilder {
        delegate.addKeyword(keyword, None)
        return this
    }

    /**
    * Adds a list of keywords to the Trie's list of text search keywords.
    *
    * @param keywords The keywords to add to the list.
    * @return This builder.
    */
    public func addKeywords(keywords: Array<String>): TrieBuilder {
        for (i in 0..keywords.size) {
            delegate.addKeyword(keywords[i], None)
        }
        return this
    }

    /**
    * Adds a list of keywords to the Trie's list of text search keywords.
    *
    * @param keywords The keywords to add to the list.
    * @return This builder.
    */
    public func addKeywords(keywords: ArrayList<String>): TrieBuilder {
        for (keyword in keywords) {
            this.delegate.addKeyword(keyword, None)
        }
        return this
    }

    /**
    * Configure the Trie to match whole keywords in the text.
    *
    * @return This builder.
    */
    public func onlyWholeWords(): TrieBuilder {
        this.delegate.onlyWholeWords()
        return this
    }

    /**
    * Configure the Trie to match whole keywords that are separated by whitespace
    * in the text. For example, "this keyword thatkeyword" would only match the
    * first occurrence of "keyword".
    *
    * @return This builder.
    */
    public func onlyWholeWordsWhiteSpaceSeparated(): TrieBuilder {
        this.delegate.onlyWholeWordsWhiteSpaceSeparated()
        return this
    }

    /**
    * Configure the Trie to stop after the first keyword is found in the text.
    *
    * @return This builder.
    */
    public func stopOnHit(): TrieBuilder {
        this.delegate.stopOnHit()
        return this
    }

    /**
     * Configure the Trie based on the builder settings.
     *
     * @return The configured Trie.
     */
    public func build(): Trie {
        var payloadTrie: PayloadTrie<String> = this.delegate.build()
        return Trie(payloadTrie)
    }

    /**
    * @return This builder.
    */
    public func caseInsensitive(): TrieBuilder {
        return ignoreCase()
    }

    /**
    * @return This builder.
    */
    public func removeOverlaps(): TrieBuilder {
        return ignoreOverlaps()
    }
}
