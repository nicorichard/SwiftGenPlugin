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
            path: "https://github.com/nicorichard/SwiftGenPlugin/releases/download/0.0.1/SwiftGenBinary.artifactbundle.zip"
        ),
    ]
)
