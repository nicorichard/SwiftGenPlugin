// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "SwiftGenPlugin",
    defaultLocalization: "en",
    products: [
        .plugin(name: "SwiftGenBuildPlugin", targets: ["BuildTool"]),
        .plugin(name: "SwiftGenCommandPlugin", targets: ["Run SwiftGen"])
    ],
    dependencies: [],
    targets: [
        .plugin(
            name: "BuildTool",
            capability: .buildTool(),
            dependencies: [
                "swiftgen"
            ]
        ),
        .plugin(
            name: "Run SwiftGen",
            capability: .command(
                intent: .custom(
                    verb: "swiftgen",
                    description: "Generate Swift code for this package's resources."
                ),
                permissions: [
                  .writeToPackageDirectory(reason: "To generate Swift code for this package's resources.")
                ]
            ),
            dependencies: ["swiftgen"]
        ),
        .executableTarget(
            name: "BuildToolExample",
            exclude: ["Resources/swiftgen.yml"],
            plugins: ["BuildTool"]
        ),
        .executableTarget(
            name: "CommandExample",
            exclude: ["Resources/swiftgen.yml"],
            plugins: ["Run SwiftGen"]
        ),
        .binaryTarget(
            name: "swiftgen",
            url: "https://github.com/nicorichard/SwiftGen/releases/download/6.5.1/swiftgen.artifactbundle.zip",
            checksum: "a8e445b41ac0fd81459e07657ee19445ff6cbeef64eb0b3df51637b85f925da8"
        ),
    ]
)
