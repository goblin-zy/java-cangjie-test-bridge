package smartlibrary.model;

public class LibraryItem {

    private final String code;
    private boolean available;

    public LibraryItem(String code, boolean available) {
        this.code = code;
        this.available = available;
    }

    public String getCode() {
        return code;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }
}
