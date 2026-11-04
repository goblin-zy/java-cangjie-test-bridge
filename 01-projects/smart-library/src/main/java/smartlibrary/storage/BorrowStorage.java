package smartlibrary.storage;

import smartlibrary.model.BorrowRecord;
import java.time.LocalDate;
import java.util.List;

public interface BorrowStorage {
    void save(BorrowRecord record);
    BorrowRecord findActiveBorrow(String itemCode);
    int countActiveBorrows(int memberId);
    boolean hasOverdueBorrows(int memberId, LocalDate today);
    List<BorrowRecord> findAll();
    List<BorrowRecord> findByMember(int memberId);
}