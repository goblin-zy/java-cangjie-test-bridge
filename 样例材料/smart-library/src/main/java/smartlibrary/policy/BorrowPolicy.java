package smartlibrary.policy;

import smartlibrary.model.Member;

public interface BorrowPolicy {

    boolean canBorrow(Member member, int activeBorrows, boolean hasOverdue);
}
