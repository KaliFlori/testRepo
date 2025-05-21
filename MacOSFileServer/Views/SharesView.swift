import SwiftUI

struct SharesView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedShare: SharePoint? = nil
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Manage Shares")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: { appState.showNewShareSheet = true }) {
                    Label("Add Share", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding([.horizontal, .top])
            
            if appState.shares.isEmpty {
                VStack {
                    Spacer()
                    Text("No shares configured")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Click 'Add Share' to create a new share point")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                sharesTable
            }
        }
        .navigationTitle("Shares")
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Share"),
                message: Text("Are you sure you want to delete this share? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let selectedShare = selectedShare,
                       let index = appState.shares.firstIndex(where: { $0.id == selectedShare.id }) {
                        appState.shares.remove(at: index)
                        self.selectedShare = nil
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    var sharesTable: some View {
        Table(appState.shares, selection: $selectedShare) {
            TableColumn("Name", value: \.name)
            
            TableColumn("Path") { share in
                Text(share.path)
                    .foregroundColor(.secondary)
            }
            
            TableColumn("Status") { share in
                HStack {
                    Circle()
                        .fill(share.isActive ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                    Text(share.isActive ? "Active" : "Inactive")
                }
            }
            
            TableColumn("Access Level") { share in
                Text(share.accessLevel.rawValue)
            }
            
            TableColumn("Actions") { share in
                HStack {
                    Button(action: {
                        if let index = appState.shares.firstIndex(where: { $0.id == share.id }) {
                            appState.shares[index].isActive.toggle()
                        }
                    }) {
                        Image(systemName: share.isActive ? "pause.fill" : "play.fill")
                    }
                    .buttonStyle(.borderless)
                    .help(share.isActive ? "Deactivate" : "Activate")
                    
                    Button(action: {
                        selectedShare = share
                        showDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.borderless)
                    .help("Delete")
                }
            }
        }
        .padding()
    }
}

struct ShareDetailView: View {
    var share: SharePoint
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text(share.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(share.path)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Circle()
                            .fill(share.isActive ? Color.green : Color.red)
                            .frame(width: 10, height: 10)
                        Text(share.isActive ? "Active" : "Inactive")
                    }
                    
                    Text(share.accessLevel.rawValue)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Share Settings")
                    .font(.headline)
                
                HStack {
                    Text("Path:")
                        .frame(width: 100, alignment: .leading)
                    Text(share.path)
                    Spacer()
                    Button("Browse...") {}
                        .disabled(true) // Would be implemented in a real app
                }
                
                HStack {
                    Text("Access:")
                        .frame(width: 100, alignment: .leading)
                    Picker("", selection: .constant(share.accessLevel)) {
                        ForEach(ShareAccessLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .disabled(true) // Would be editable in a real app
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("User Access")
                    .font(.headline)
                
                if share.allowedUsers.isEmpty {
                    Text("All users can access this share")
                        .foregroundColor(.secondary)
                } else {
                    Text("\(share.allowedUsers.count) users can access this share")
                        .foregroundColor(.secondary)
                }
                
                Button("Manage User Access") {}
                    .disabled(true) // Would be implemented in a real app
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Share Details")
    }
}

struct NewShareView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var path = "/Users/Shared"
    @State private var accessLevel = ShareAccessLevel.readOnly
    @State private var isActive = true
    
    var body: some View {
        VStack {
            HStack {
                Text("New Share")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
            
            Form {
                Section(header: Text("Share Information")) {
                    TextField("Share Name", text: $name)
                    
                    HStack {
                        TextField("Path", text: $path)
                        Button("Browse...") {}
                            .disabled(true) // Would be implemented in a real app
                    }
                    
                    Picker("Access Level", selection: $accessLevel) {
                        ForEach(ShareAccessLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    
                    Toggle("Active", isOn: $isActive)
                }
            }
            .padding()
            
            HStack {
                Spacer()
                
                Button("Create Share") {
                    let newShare = SharePoint(
                        id: UUID(),
                        name: name,
                        path: path,
                        isActive: isActive,
                        accessLevel: accessLevel
                    )
                    
                    appState.shares.append(newShare)
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || path.isEmpty)
                .padding()
            }
        }
        .frame(width: 500, height: 400)
    }
}

struct SharesView_Previews: PreviewProvider {
    static var previews: some View {
        SharesView()
            .environmentObject(AppState())
    }
}