package smartlibrary.storage.memory;

import smartlibrary.model.Member;
import smartlibrary.storage.MemberStorage;

import java.util.HashMap;
import java.util.Map;

public class MemoryMemberStorage implements MemberStorage {

    private final Map<Integer, Member> members = new HashMap<>();

    @Override
    public Member find(int memberId) {
        return members.get(memberId);
    }

    public void save(Member member) {
        members.put(member.getId(), member);
    }
}
