package smartlibrary.storage.memory;

import smartlibrary.model.BorrowRecord;
import smartlibrary.storage.BorrowStorage;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class MemoryBorrowStorage implements BorrowStorage {

    private final List<BorrowRecord> records = new ArrayList<>();

    @Override
    public void save(BorrowRecord record) {
        records.add(record);
    }

    @Override
    public BorrowRecord findActiveBorrow(String itemCode) {
        return records.stream()
                .filter(r -> r.getItemCode().equals(itemCode) && !r.isReturned())
                .findFirst()
                .orElse(null);
    }

    @Override
    public int countActiveBorrows(int memberId) {
        return (int) records.stream()
                .filter(r -> r.getMemberId() == memberId && !r.isReturned())
                .count();
    }

    @Override
    public boolean hasOverdueBorrows(int memberId, LocalDate today) {
        return records.stream()
                .anyMatch(r -> r.getMemberId() == memberId
                        && !r.isReturned()
                        && r.isOverdue(today));
    }

    @Override
    public List<BorrowRecord> findAll() {
        return new ArrayList<>(records);
    }

    @Override
    public List<BorrowRecord> findByMember(int memberId) {
        return records.stream()
                .filter(r -> r.getMemberId() == memberId)
                .collect(Collectors.toList());
    }
}