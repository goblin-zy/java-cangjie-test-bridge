package smartlibrary.policy.impl;

import smartlibrary.policy.PenaltyPolicy;

public class DefaultPenaltyPolicy implements PenaltyPolicy {

    private static final int GRACE_PERIOD_DAYS = 5;
    private static final double STANDARD_RATE = 1.0;
    private static final double ELEVATED_RATE = 2.0;
    private static final double MAX_PENALTY = 100.0;

    @Override
    public double calculatePenalty(int overdueDays) {
        if (overdueDays <= 0) {
            return 0;
        }

        double penalty;
        if (overdueDays <= GRACE_PERIOD_DAYS) {
            penalty = overdueDays * STANDARD_RATE;
        } else {
            penalty = overdueDays * ELEVATED_RATE;
        }

        return Math.min(penalty, MAX_PENALTY);
    }
}