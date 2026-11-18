package cjmustache

import stdx.serialization.serialization.*
import std.collection.concurrent.*

/**
  *  cjnustache使用的默认收集器。
  */
open public class DefaultCollector <: BasicCollector {
    public DefaultCollector(
        let _allowAccessCoercion!: Bool = true) { } 

    public override func createFetcher(
        ctx: DataModel, name: String): ?VariableFetcher {
        let fetcher: ?VariableFetcher = super.createFetcher(ctx, name)

        if (fetcher.isSome()) { return fetcher }

        return None
    }

    public override func createFetcherCache(): 
        ConcurrentHashMap<String, VariableFetcher> {
        return ConcurrentHashMap<String, VariableFetcher>()
    }
}
