import XCTest
@testable import MacOSFileServer

final class MacOSFileServerTests: XCTestCase {
    func testAppStateInitialization() {
        let appState = AppState()
        
        // Verify initial state
        XCTAssertEqual(appState.selectedSidebarItem, .dashboard)
        XCTAssertFalse(appState.showNewShareSheet)
        XCTAssertFalse(appState.showNewUserSheet)
        XCTAssertFalse(appState.showSettingsSheet)
        
        // Verify sample data was loaded
        XCTAssertFalse(appState.shares.isEmpty)
        XCTAssertFalse(appState.users.isEmpty)
        XCTAssertFalse(appState.activeConnections.isEmpty)
    }
    
    func testFileSystemUtility() {
        let utility = FileSystemUtility.shared
        
        // Test path exists
        XCTAssertTrue(utility.pathExists(at: "/"))
        
        // Test is directory
        XCTAssertTrue(utility.isDirectory(at: "/"))
        
        // Test formatted size
        let size = utility.formattedSize(bytes: 1024 * 1024)
        XCTAssertEqual(size, "1 MB")
    }
}