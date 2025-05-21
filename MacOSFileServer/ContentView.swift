import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    @State private var sidebarWidth: CGFloat = 200
    
    var body: some View {
        NavigationView {
            sidebar
            mainContent
        }
        .sheet(isPresented: $appState.showNewShareSheet) {
            NewShareView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $appState.showNewUserSheet) {
            NewUserView()
                .environmentObject(appState)
        }
    }
    
    var sidebar: some View {
        List(selection: $appState.selectedSidebarItem) {
            Section(header: Text("Main")) {
                ForEach(SidebarItem.allCases) { item in
                    NavigationLink(destination: destinationView(for: item)) {
                        Label(item.rawValue, systemImage: item.icon)
                    }
                    .tag(item)
                }
            }
            
            Section(header: Text("Active Shares")) {
                ForEach(appState.shares.filter { $0.isActive }) { share in
                    NavigationLink(destination: ShareDetailView(share: share)) {
                        Label(share.name, systemImage: "folder")
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 200, idealWidth: sidebarWidth)
    }
    
    var mainContent: some View {
        destinationView(for: appState.selectedSidebarItem)
    }
    
    @ViewBuilder
    func destinationView(for item: SidebarItem) -> some View {
        switch item {
        case .dashboard:
            DashboardView()
                .environmentObject(appState)
        case .shares:
            SharesView()
                .environmentObject(appState)
        case .users:
            UsersView()
                .environmentObject(appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}