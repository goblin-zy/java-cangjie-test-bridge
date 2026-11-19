package smartlibrary.model;

public class Member {

    private final int id;
    private final boolean active;
    private final MembershipType membershipType;

    public Member(int id, boolean active, MembershipType membershipType) {
        this.id = id;
        this.active = active;
        this.membershipType = membershipType;
    }

    public int getId() {
        return id;
    }

    public boolean isActive() {
        return active;
    }

    public MembershipType getMembershipType() {
        return membershipType;
    }
}
