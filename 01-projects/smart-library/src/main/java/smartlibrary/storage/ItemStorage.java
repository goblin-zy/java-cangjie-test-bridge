package smartlibrary.storage;

import smartlibrary.model.LibraryItem;

public interface ItemStorage {
    LibraryItem find(String code);
    void updateAvailability(String code, boolean available);
    void save(LibraryItem item);
}