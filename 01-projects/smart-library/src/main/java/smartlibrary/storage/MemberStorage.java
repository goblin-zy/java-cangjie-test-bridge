package smartlibrary.storage;

import smartlibrary.model.Member;

public interface MemberStorage {
    Member find(int memberId);
    void save(Member member);
}