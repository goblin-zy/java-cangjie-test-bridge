package smartlibrary.policy.impl;

import smartlibrary.model.Member;
import smartlibrary.policy.BorrowPolicy;

public class DefaultBorrowPolicy implements BorrowPolicy {

    @Override
    public boolean canBorrow(Member member, int activeBorrows, boolean hasOverdue) {
        return member != null
                && member.isActive()
                && activeBorrows < member.getMembershipType().getMaxLoans()
                && !hasOverdue;
    }
}
