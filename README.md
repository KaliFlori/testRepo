# macOS File Server App

A Swift-based file server application for macOS that supports SMB sharing with user management.

## Features

- **File & Folder Sharing**: Share local files and folders via SMB protocol
- **User Management**: Create and manage users with different permission levels
- **Modern UI**: Built with SwiftUI for a native macOS experience
- **Dashboard**: Monitor active shares and connections
- **Access Control**: Granular permissions for shared resources

## Requirements

- macOS 12.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later

## Installation

1. Clone this repository
2. Open the project in Xcode
3. Build and run the application

```bash
git clone https://github.com/KaliFlori/testRepo.git
cd testRepo
swift build
```

## Usage

1. Launch the application
2. Use the sidebar to navigate between Dashboard, Shares, and Users
3. Add new shares by clicking the "Add Share" button
4. Add new users by clicking the "Add User" button
5. Monitor active connections from the Dashboard

## Architecture

The application is built using the following components:

- **SwiftUI**: For the user interface
- **SMB Service**: Interfaces with macOS native SMB functionality
- **File System Utility**: Handles file operations and permissions
- **User Management**: Manages user accounts and authentication

## License

This project is licensed under the MIT License - see the LICENSE file for details.
