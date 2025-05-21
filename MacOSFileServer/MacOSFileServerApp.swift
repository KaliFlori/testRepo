import SwiftUI

@main
struct MacOSFileServerApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            SidebarCommands()
            
            CommandGroup(replacing: .newItem) {
                Button("New Share") {
                    appState.showNewShareSheet = true
                }
                .keyboardShortcut("n", modifiers: [.command])
            }
        }
    }
}