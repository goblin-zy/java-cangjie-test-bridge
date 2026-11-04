package smartlibrary.api.impl;

import smartlibrary.api.LibraryFacade;
import smartlibrary.service.CirculationService;

public class DefaultLibraryFacade implements LibraryFacade {

    private final CirculationService circulationService;

    public DefaultLibraryFacade(CirculationService circulationService) {
        if (circulationService == null) {
            throw new IllegalArgumentException("CirculationService cannot be null");
        }
        this.circulationService = circulationService;
    }

    @Override
    public void borrowFlow(int memberId, String itemCode) {
        try {
            circulationService.requestBorrow(memberId, itemCode);
        } catch (IllegalStateException | IllegalArgumentException e) {
            throw new RuntimeException("Failed to complete borrow flow: " + e.getMessage(), e);
        }
    }

    @Override
    public void returnFlow(String itemCode) {
        try {
            circulationService.returnItem(itemCode);
        } catch (IllegalStateException | IllegalArgumentException e) {
            throw new RuntimeException("Failed to complete return flow: " + e.getMessage(), e);
        }
    }
}