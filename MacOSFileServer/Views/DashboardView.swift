import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                
                HStack(spacing: 20) {
                    statsCard(title: "Active Shares", value: String(appState.shares.filter { $0.isActive }.count), icon: "folder.fill")
                    statsCard(title: "Users", value: String(appState.users.count), icon: "person.fill")
                    statsCard(title: "Active Connections", value: String(appState.activeConnections.count), icon: "network")
                }
                
                Text("Active Connections")
                    .font(.headline)
                
                activeConnectionsSection
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: { appState.showSettingsSheet = true }) {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
    }
    
    var headerSection: some View {
        VStack(alignment: .leading) {
            Text("macOS File Server")
                .font(.largeTitle)
                .bold()
            
            Text("Server Status: Active")
                .foregroundColor(.green)
        }
    }
    
    func statsCard(title: String, value: String, icon: String) -> some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 40, weight: .bold))
            }
            .padding(.bottom, 5)
            
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
    
    var activeConnectionsSection: some View {
        VStack {
            if appState.activeConnections.isEmpty {
                Text("No active connections")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                VStack(spacing: 0) {
                    HStack {
                        Text("User")
                            .fontWeight(.bold)
                            .frame(width: 120, alignment: .leading)
                        Text("IP Address")
                            .fontWeight(.bold)
                            .frame(width: 120, alignment: .leading)
                        Text("Share")
                            .fontWeight(.bold)
                            .frame(width: 120, alignment: .leading)
                        Text("Connected Since")
                            .fontWeight(.bold)
                            .frame(width: 200, alignment: .leading)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color(NSColor.controlBackgroundColor))
                    
                    Divider()
                    
                    ForEach(appState.activeConnections) { connection in
                        HStack {
                            Text(connection.username)
                                .frame(width: 120, alignment: .leading)
                            Text(connection.ipAddress)
                                .frame(width: 120, alignment: .leading)
                            Text(connection.connectedShare)
                                .frame(width: 120, alignment: .leading)
                            Text(timeFormatter.string(from: connection.connectionTime))
                                .frame(width: 200, alignment: .leading)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Label("Disconnect", systemImage: "xmark.circle")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        
                        Divider()
                    }
                }
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
            }
        }
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(AppState())
    }
}