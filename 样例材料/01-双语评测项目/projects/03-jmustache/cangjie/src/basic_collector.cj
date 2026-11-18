package cjmustache

import stdx.serialization.serialization.*
import std.collection.concurrent.*
import std.collection.*
import std.convert.*

/* 负责在不使用 cangjie 反射的情况下收集和解析数据。
 * 该类主要用于将模板中的变量（例如迭代器、数组等）转换为可迭代的对象或用于模板渲染的数据片段 */
public abstract class BasicCollector <: Collector {
    public open func createFetcher(
        ctx: DataModel, name: String): ?VariableFetcher {
        if (ctx is DataModelStruct) {
            return MAP_FETCHER
        }

        /* 如果名称看起来像一个数字，可以使用我们的“索引”获取器之一 */
        let c = name.toRuneArray()[0]
        if (c >= r'0' && c <= r'9') {
            if (ctx is DataModelSeq) {
                return LIST_FETCHER
            }
            return ITER_FETCHER
        }

        return None
    }

    /** 这应该返回一个线程安全的映射，要么在标准的{@link map}实现上调用
      * {@link Collections#synchronizedMap}，要么类似于{@code ConcurrentHashMap}
      */
    public func createFetcherCache(): ConcurrentHashMap<String, VariableFetcher>

    /* 于 Map 类型的上下文，调用 Map.get() 获取变量值，或者允许迭代 entrySet。 */
    protected static let MAP_FETCHER = MapVariableFetcher()

    /* 用于 List 类型的上下文，根据索引获取列表中的元素 */
    protected static let LIST_FETCHER = ListVariableFetcher()

    /* 用于 Iterator，通过索引获取迭代器中的下一个元素 */
    protected static let ITER_FETCHER = IterVariableFetcher()

}


protected class MapVariableFetcher <: VariableFetcher {
    public func get(ctx: DataModel, name: String): DataModel {
        let mp = match (ctx) {
            case mpCtx: DataModelStruct => mpCtx
                        let dmMp = HashMap<String, DataModel>()
                        mpCtx.getFields() |> forEach<Field>{ field: Field => 
                            dmMp.add(field.getName(), field.getData())
                        }
                        dmMp
            case _ => return Template.NO_FETCHER_FOUND.serialize()
        }

        if (let Some(value) <- mp.get(name)) {
            return value
        }

        return Template.NO_FETCHER_FOUND.serialize()
    }

    public func toString(): String {
        return "MAP_FETCHER"
    }
}

protected class ListVariableFetcher <: VariableFetcher {
    public func get(ctx: DataModel, name: String): DataModel {
        try {
            let arr = match (ctx) {
                case arrCtx: DataModelSeq => arrCtx.getItems()
                case _ => return Template.NO_FETCHER_FOUND.serialize()
            }
            if (let Some(value) <- arr.get(Int64.parse(name))) {
                return value
            }
        } catch (e: Exception) {
            // fall
        }

        return Template.NO_FETCHER_FOUND.serialize()
    }

    public func toString(): String {
        return "LIST_FETCHER"
    }
}

protected class IterVariableFetcher <: VariableFetcher {
    public func get(ctx: DataModel, name: String): DataModel {
        try {
            let iter = match (ctx) {
                case arrCtx: DataModelSeq => arrCtx.getItems().iterator()
                case _ => return Template.NO_FETCHER_FOUND.serialize()
            }

            for (_ in 0..Int64.parse(name)) { 
                iter.next() 
            }
            
            if (let Some(value) <- iter.next()) {
                return value
            }
        } catch (e: Exception) {
            // fall
        }

        return Template.NO_FETCHER_FOUND.serialize()
    }

    public func toString(): String {
        return "ITER_FETCHER"
    }
}

