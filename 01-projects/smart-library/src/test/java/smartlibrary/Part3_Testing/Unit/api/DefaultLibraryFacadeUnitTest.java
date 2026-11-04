package smartlibrary.Part3_Testing.Unit.api;

import org.junit.jupiter.api.Test;
import smartlibrary.api.impl.DefaultLibraryFacade;
import smartlibrary.service.CirculationService;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class DefaultLibraryFacadeUnitTest {

    @Test 
    void constructor_throws_whenCirculationServiceNull(){
        IllegalArgumentException exception = assertThrows(
            IllegalArgumentException.class,
            () -> new DefaultLibraryFacade(null)
        );
        
        assertEquals("CirculationService cannot be null", exception.getMessage());
    }
    
    @Test 
    void borrowFlow_callsRequestBorrow_onCirculationService(){
        CirculationService mockService = mock(CirculationService.class);
        DefaultLibraryFacade facade = new DefaultLibraryFacade(mockService);
        
        facade.borrowFlow(1, "BOOK001");
        
        verify(mockService, times(1)).requestBorrow(1, "BOOK001");
    }
    
    @Test 
    void borrowFlow_throwsRuntimeException_whenCirculationServiceThrowsIllegalState(){
        CirculationService mockService = mock(CirculationService.class);
        doThrow(new IllegalStateException("Test error")).when(mockService).requestBorrow(anyInt(), anyString());
        DefaultLibraryFacade facade = new DefaultLibraryFacade(mockService);
        
        RuntimeException exception = assertThrows(
            RuntimeException.class,
            () -> facade.borrowFlow(1, "BOOK001")
        );
        
        assertTrue(exception.getMessage().contains("Failed to complete borrow flow"));
    }
    
    @Test 
    void borrowFlow_throwsRuntimeException_whenCirculationServiceThrowsIllegalArgument(){
        CirculationService mockService = mock(CirculationService.class);
        doThrow(new IllegalArgumentException("Test error")).when(mockService).requestBorrow(anyInt(), anyString());
        DefaultLibraryFacade facade = new DefaultLibraryFacade(mockService);
        
        RuntimeException exception = assertThrows(
            RuntimeException.class,
            () -> facade.borrowFlow(1, "BOOK001")
        );
        
        assertTrue(exception.getMessage().contains("Failed to complete borrow flow"));
    }
    
    @Test 
    void returnFlow_callsReturnItem_onCirculationService(){
        CirculationService mockService = mock(CirculationService.class);
        DefaultLibraryFacade facade = new DefaultLibraryFacade(mockService);
        
        facade.returnFlow("BOOK001");
        
        verify(mockService, times(1)).returnItem("BOOK001");
    }
    
    @Test 
    void returnFlow_throwsRuntimeException_whenCirculationServiceThrowsIllegalState(){
        CirculationService mockService = mock(CirculationService.class);
        doThrow(new IllegalStateException("Test error")).when(mockService).returnItem(anyString());
        DefaultLibraryFacade facade = new DefaultLibraryFacade(mockService);
        
        RuntimeException exception = assertThrows(
            RuntimeException.class,
            () -> facade.returnFlow("BOOK001")
        );
        
        assertTrue(exception.getMessage().contains("Failed to complete return flow"));
    }
}