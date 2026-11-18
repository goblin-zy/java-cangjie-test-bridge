/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

package diffUtils4cj

/**
 * Delta Comparator.
 */
public class DeltaComparator<T> where T <: Equal<T> & ToString {

    public init() {
    }

    /**
     * Returns the Ordering of delta
     *
     * @return the Ordering
     *
     * @since 0.38.2
     */
    public static func deltaComparator(a:Delta<T>,b:Delta<T>): Ordering  {
        let posA = a.getOriginal().getPosition();
        let posB = b.getOriginal().getPosition();
        if (posA > posB) {
            return Ordering.GT
        } else if (posA < posB) {
            return Ordering.LT
        }
        return Ordering.EQ
    }
}