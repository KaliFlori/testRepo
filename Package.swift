// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MacOSFileServer",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "MacOSFileServer", targets: ["MacOSFileServer"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MacOSFileServer",
            dependencies: [],
            path: "MacOSFileServer",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "MacOSFileServerTests",
            dependencies: ["MacOSFileServer"],
            path: "Tests"
        )
    ]
)