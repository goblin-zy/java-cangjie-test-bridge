package study.translation;
public final class InsufficientFundsException extends RuntimeException {
    // 创建余额不足异常，保存错误说明；它与非法金额的参数异常不同。
    public InsufficientFundsException(String message) {
        super(message);
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
