package smartlibrary.Part3_Testing.Unit.model;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import smartlibrary.model.MembershipType;

import static org.junit.jupiter.api.Assertions.*;

public class MembershipTypeUnitTest {

    @ParameterizedTest
    @CsvSource({
        "STUDENT, 3, 14",
        "STAFF, 5, 30",
        "GUEST, 1, 7"
    })
    void membershipType_hasExpectedMaxLoansAndDays(String type, int expectedMaxLoans, int expectedMaxDays){
        MembershipType membershipType = MembershipType.valueOf(type);
        
        assertEquals(expectedMaxLoans, membershipType.getMaxLoans());
        assertEquals(expectedMaxDays, membershipType.getMaxLoanDays());
    }
}