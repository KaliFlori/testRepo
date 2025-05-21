import Foundation

class FileSystemUtility {
    static let shared = FileSystemUtility()
    
    private init() {}
    
    // Check if a path exists
    func pathExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    // Check if a path is a directory
    func isDirectory(at path: String) -> Bool {
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return exists && isDir.boolValue
    }
    
    // Get directory contents
    func contentsOfDirectory(at path: String) -> [URL]? {
        do {
            return try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: path), includingPropertiesForKeys: nil)
        } catch {
            print("Error getting directory contents: \(error)")
            return nil
        }
    }
    
    // Create directory if it doesn't exist
    func createDirectoryIfNeeded(at path: String) -> Bool {
        if pathExists(at: path) {
            return isDirectory(at: path)
        }
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
            return true
        } catch {
            print("Error creating directory: \(error)")
            return false
        }
    }
    
    // Get file attributes
    func attributesOfItem(at path: String) -> [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch {
            print("Error getting file attributes: \(error)")
            return nil
        }
    }
    
    // Check if the app has permission to access a path
    func canAccessPath(_ path: String) -> Bool {
        // Check read permission
        let readAccess = FileManager.default.isReadableFile(atPath: path)
        
        // Check write permission
        let writeAccess = FileManager.default.isWritableFile(atPath: path)
        
        return readAccess && writeAccess
    }
    
    // Get directory size
    func sizeOfDirectory(at path: String) -> Int64 {
        guard let urls = contentsOfDirectory(at: path) else { return 0 }
        
        var size: Int64 = 0
        
        for url in urls {
            let path = url.path
            
            if isDirectory(at: path) {
                size += sizeOfDirectory(at: path)
            } else if let attributes = attributesOfItem(at: path),
                      let fileSize = attributes[.size] as? Int64 {
                size += fileSize
            }
        }
        
        return size
    }
    
    // Format size for display
    func formattedSize(bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}