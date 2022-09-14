# SwiftGenPlugin

SwiftGen code generation for Swift packages that works on any machine. No installation required.

Uses the remote build tool plugin [SE-0325](https://github.com/apple/swift-evolution/blob/main/proposals/0325-swiftpm-additional-plugin-apis.md) as demonstrated by [apple/swift-package-manager](https://github.com/apple/swift-package-manager/tree/main/Fixtures/Miscellaneous/Plugins/MyBinaryToolPlugin) and [abertelrud/swiftpm-buildtool-plugin-examples](https://github.com/abertelrud/swiftpm-buildtool-plugin-examples).

## Attention

Until issues are resolved which pin Xcode at 100% CPU this repository includes a vendored SwiftGen binary. Please verify the checksum and use at your own risk.

## Usage

### Adding The Build Plugin

Add the dependency to your `Package.swift` and include the plugin on any targets for which you would like it to run

```swift
    dependencies: [
        .package(url: "https://github.com/nicorichard/SwiftGenPlugin", exact: "6.5.1")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftGenBuildPlugin", package: "SwiftGenPlugin")
            ]
        )
    ]
```

### Add a SwiftGen config

Add a `swiftgen.yml` file to your project following the [configuration file format](https://github.com/SwiftGen/SwiftGen/blob/stable/Documentation/ConfigFile.md) and prefixing your output paths with `${DERIVED_SOURCES_DIR}/`

Take a look at this repository's [swiftgen.yml](./swiftgen.yml) for an example.

### Supporting Multiple Targets

The plugin offers two options for the `swiftgen.yml` file to support multiple-target packages. If you are only concerned with one target there is no difference between the two options.

1. Add a `swiftgen.yml` ([Example](swiftgen.yml)) to the root of your package (same folder as `Package.swift`), and swiftgen will be run **for all targets which support the plugin**
2. Add a `swiftgen.yml` ([Example](swiftgen.yml)) to your target's sources, swiftgen will be run for only this target

Both 1 & 2 can be combined if desired. However, if there is any duplicate files between the two methods the more specific target files will be used (method #2).