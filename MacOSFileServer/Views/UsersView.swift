import SwiftUI

struct UsersView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedUser: User? = nil
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Manage Users")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: { appState.showNewUserSheet = true }) {
                    Label("Add User", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding([.horizontal, .top])
            
            if appState.users.isEmpty {
                VStack {
                    Spacer()
                    Text("No users configured")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Click 'Add User' to create a new user")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                usersTable
            }
        }
        .navigationTitle("Users")
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete User"),
                message: Text("Are you sure you want to delete this user? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let selectedUser = selectedUser,
                       let index = appState.users.firstIndex(where: { $0.id == selectedUser.id }) {
                        appState.users.remove(at: index)
                        self.selectedUser = nil
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    var usersTable: some View {
        Table(appState.users, selection: $selectedUser) {
            TableColumn("Username", value: \.username)
            
            TableColumn("Full Name", value: \.fullName)
            
            TableColumn("Role") { user in
                Text(user.isAdmin ? "Administrator" : "Regular User")
            }
            
            TableColumn("Actions") { user in
                HStack {
                    Button(action: {
                        if let index = appState.users.firstIndex(where: { $0.id == user.id }) {
                            appState.users[index].isAdmin.toggle()
                        }
                    }) {
                        Image(systemName: "person.fill.badge.plus")
                    }
                    .buttonStyle(.borderless)
                    .help(user.isAdmin ? "Remove Admin" : "Make Admin")
                    
                    Button(action: {
                        selectedUser = user
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

struct NewUserView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var username = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isAdmin = false
    
    var passwordsMatch: Bool {
        password == confirmPassword
    }
    
    var formIsValid: Bool {
        !username.isEmpty && !fullName.isEmpty && !password.isEmpty && passwordsMatch
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("New User")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
            
            Form {
                Section(header: Text("User Information")) {
                    TextField("Username", text: $username)
                    TextField("Full Name", text: $fullName)
                    
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty && !passwordsMatch {
                        Text("Passwords do not match")
                            .foregroundColor(.red)
                    }
                    
                    Toggle("Administrator", isOn: $isAdmin)
                }
            }
            .padding()
            
            HStack {
                Spacer()
                
                Button("Create User") {
                    let newUser = User(
                        id: UUID(),
                        username: username,
                        fullName: fullName,
                        isAdmin: isAdmin,
                        password: password
                    )
                    
                    appState.users.append(newUser)
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!formIsValid)
                .padding()
            }
        }
        .frame(width: 500, height: 400)
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
            .environmentObject(AppState())
    }
}