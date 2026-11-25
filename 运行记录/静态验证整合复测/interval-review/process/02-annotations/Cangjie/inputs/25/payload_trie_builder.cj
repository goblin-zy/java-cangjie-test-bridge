/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
package ahoCorasick4cj

/*
 * The class is PayloadTrieBuilder
 * @since 0.38.2
 */
public class PayloadTrieBuilder<T> {
    
    private let trieConfig: TrieConfig = TrieConfig()
    private let trie: PayloadTrie<T> = PayloadTrie<T>(trieConfig)

    /**
    * Configure the Trie to ignore case when searching for keywords in the text.
    * This must be called before calling addKeyword because the algorithm converts
    * keywords to lowercase as they are added, depending on this case sensitivity
    * setting.
    *
    * @return This builder.
    */
    public func ignoreCase(): PayloadTrieBuilder<T> {
        this.trieConfig.setCaseInsensitive(true)
        return this
    }

    /**
    * Configure the Trie to ignore overlapping keywords.
    *
    * @return This builder.
    */
    public func ignoreOverlaps(): PayloadTrieBuilder<T> {
        this.trieConfig.setAllowOverlaps(false)
        return this
    }

    @Frozen
    public func build(): PayloadTrie<T> {
        this.trie.constructFailureStates()
        return this.trie
    }

    /**
     * Adds a keyword to the {@link Trie}'s list of text search keywords.
     * No {@link Payload} is supplied.
     *
     * @param keyword The keyword to add to the list.
     * @return This builder.
     * @throws NullPointerException if the keyword is null.
     */
    @Frozen
    public func addKeyword(keyword: String): PayloadTrieBuilder<T> {
        this.trie.addKeyword(keyword)
        return this
    }

    /**
     * Adds a keyword and a payload to the {@link Trie}'s list of text
     * search keywords.
     *
     * @param keyword The keyword to add to the list.
     * @param payload the payload to add
     * @return This builder.
     * @throws NullPointerException if the keyword is null.
     */
    @Frozen
    public func addKeyword(keyword: String, payload: ?T): PayloadTrieBuilder<T> {
        this.trie.addKeyword(keyword, payload)
        return this
    }

    /**
    * Adds a list of keywords and payloads to the {@link Trie}'s list of
    * text search keywords.
    *
    * @param keywords The keywords to add to the list.
    * @return This builder.
    */
    @Frozen
    public func addKeywords(keywords: ArrayList<Payload<T>>): PayloadTrieBuilder<T> {
        for (payload in keywords) {
            this.trie.addKeyword(payload.keyword, payload.data)
        }
        return this
    }

    /**
    * Configure the Trie to match whole keywords in the text.
    *
    * @return This builder.
    */
    public func onlyWholeWords(): PayloadTrieBuilder<T> {
        this.trieConfig.setOnlyWholeWords(true)
        return this
    }

    /**
    * Configure the Trie to match whole keywords that are separated by whitespace
    * in the text. For example, "this keyword thatkeyword" would only match the
    * first occurrence of "keyword".
    *
    * @return This builder.
    */
    public func onlyWholeWordsWhiteSpaceSeparated(): PayloadTrieBuilder<T> {
        this.trieConfig.setOnlyWholeWordsWhiteSpaceSeparated(true)
        return this
    }

    /**
    * Configure the Trie to stop after the first keyword is found in the text.
    *
    * @return This builder.
    */
    public func stopOnHit(): PayloadTrieBuilder<T> {
        trie.trieConfig.setStopOnHit(true)
        return this
    }

    /**
    * @return This builder.
    */
    public func caseInsensitive(): PayloadTrieBuilder<T> {
        return ignoreCase()
    }

    /**
    * @return This builder.
    */
    public func removeOverlaps(): PayloadTrieBuilder<T> {
        return ignoreOverlaps()
    }
}
