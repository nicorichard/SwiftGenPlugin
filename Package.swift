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
            exclude: ["swiftgen.yml"],
            plugins: ["BuildTool"]
        ),
        .executableTarget(
            name: "CommandExample",
            exclude: ["swiftgen.yml"],
            plugins: ["Run SwiftGen"]
        ),
        .binaryTarget(
            name: "swiftgen",
            path: "bin/swiftgen.artifactbundle"
        ),
    ]
)
