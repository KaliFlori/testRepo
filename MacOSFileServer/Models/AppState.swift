import SwiftUI

class AppState: ObservableObject {
    // Navigation
    @Published var selectedSidebarItem: SidebarItem = .dashboard
    
    // UI State
    @Published var showNewShareSheet = false
    @Published var showNewUserSheet = false
    @Published var showSettingsSheet = false
    
    // Data
    @Published var shares: [SharePoint] = []
    @Published var users: [User] = []
    @Published var activeConnections: [Connection] = []
    
    init() {
        // Load initial data
        loadSampleData()
    }
    
    private func loadSampleData() {
        // Sample shares for UI development
        shares = [
            SharePoint(id: UUID(), name: "Documents", path: "/Users/Shared/Documents", isActive: true, accessLevel: .readWrite),
            SharePoint(id: UUID(), name: "Media", path: "/Users/Shared/Media", isActive: true, accessLevel: .readOnly),
            SharePoint(id: UUID(), name: "Projects", path: "/Users/Shared/Projects", isActive: false, accessLevel: .readWrite)
        ]
        
        // Sample users
        users = [
            User(id: UUID(), username: "admin", fullName: "Administrator", isAdmin: true),
            User(id: UUID(), username: "user1", fullName: "Regular User", isAdmin: false),
            User(id: UUID(), username: "guest", fullName: "Guest User", isAdmin: false)
        ]
        
        // Sample connections
        activeConnections = [
            Connection(id: UUID(), username: "user1", ipAddress: "192.168.1.5", connectedShare: "Documents", connectionTime: Date().addingTimeInterval(-3600)),
            Connection(id: UUID(), username: "guest", ipAddress: "192.168.1.10", connectedShare: "Media", connectionTime: Date().addingTimeInterval(-1800))
        ]
    }
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case shares = "Shares"
    case users = "Users"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .dashboard: return "gauge"
        case .shares: return "folder"
        case .users: return "person.2"
        }
    }
}

enum ShareAccessLevel: String, CaseIterable, Identifiable {
    case readOnly = "Read Only"
    case readWrite = "Read & Write"
    
    var id: String { self.rawValue }
}

struct SharePoint: Identifiable {
    var id: UUID
    var name: String
    var path: String
    var isActive: Bool
    var accessLevel: ShareAccessLevel
    var allowedUsers: [UUID] = [] // Empty means all users
}

struct User: Identifiable {
    var id: UUID
    var username: String
    var fullName: String
    var isAdmin: Bool
    var password: String = "password" // In a real app, this would be securely hashed
}

struct Connection: Identifiable {
    var id: UUID
    var username: String
    var ipAddress: String
    var connectedShare: String
    var connectionTime: Date
}