// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "SwiftGenPlugin",
    defaultLocalization: "en",
    products: [
        .plugin(name: "SwiftGenPlugin", targets: ["SwiftGenPlugin"])
    ],
    dependencies: [],
    targets: [
        .plugin(
            name: "SwiftGenPlugin",
            capability: .buildTool(),
            dependencies: [
                "SwiftGenBinary"
            ]
        ),
        .executableTarget(
            name: "Example",
            plugins: ["SwiftGenPlugin"]
        ),
        .binaryTarget(
            name: "SwiftGenBinary",
            url: "https://github.com/nicorichard/SwiftGenPlugin/releases/download/6.5.1/SwiftGenBinary.artifactbundle.zip",
            checksum: "5f2948f251baac0e2ae70094c597e8a4eb5633ac1a04b0a73da8e3ac50d9c9c8"
        ),
    ]
)
