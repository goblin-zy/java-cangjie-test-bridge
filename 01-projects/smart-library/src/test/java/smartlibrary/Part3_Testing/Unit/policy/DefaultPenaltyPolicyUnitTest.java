package smartlibrary.Part3_Testing.Unit.policy;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import smartlibrary.policy.impl.DefaultPenaltyPolicy;

import static org.junit.jupiter.api.Assertions.*;

public class DefaultPenaltyPolicyUnitTest {

    @ParameterizedTest
    @CsvSource({
        "0, 0.0",
        "-1, 0.0",
        "1, 1.0",
        "3, 3.0",
        "5, 5.0",
        "6, 12.0",
        "10, 20.0",
        "50, 100.0",
        "100, 100.0"
    })
    void calculatePenalty_returnsExpectedAmount(int overdueDays, double expectedPenalty){
        DefaultPenaltyPolicy policy = new DefaultPenaltyPolicy();
        
        assertEquals(expectedPenalty, policy.calculatePenalty(overdueDays), 0.001);
    }
}