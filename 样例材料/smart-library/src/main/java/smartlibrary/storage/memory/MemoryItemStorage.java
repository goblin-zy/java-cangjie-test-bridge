package smartlibrary.storage.memory;

import smartlibrary.model.LibraryItem;
import smartlibrary.storage.ItemStorage;

import java.util.HashMap;
import java.util.Map;

public class MemoryItemStorage implements ItemStorage {

    private final Map<String, LibraryItem> items = new HashMap<>();

    @Override
    public LibraryItem find(String code) {
        return items.get(code);
    }

    @Override
    public void updateAvailability(String code, boolean available) {
        LibraryItem item = items.get(code);
        if (item != null) {
            item.setAvailable(available);
        }
    }

    public void save(LibraryItem item) {
        items.put(item.getCode(), item);
    }
}
