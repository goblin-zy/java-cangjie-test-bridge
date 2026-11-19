package smartlibrary.api;

public interface LibraryFacade {
    void borrowFlow(int memberId, String itemCode);
    void returnFlow(String itemCode);
}