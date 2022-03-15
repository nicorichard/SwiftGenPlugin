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
            url: "https://github.com/nicorichard/SwiftGenPlugin/releases/download/0.0.1/SwiftGenBinary.artifactbundle.zip",
            checksum: "1bfd5e100412f41c3d5502c51569922cbb7d302c17562d574b821d0550b1df2c"
        ),
    ]
)
