# SwiftGenPlugin

A remote built tool plugin [SE-0325](https://github.com/apple/swift-evolution/blob/main/proposals/0325-swiftpm-additional-plugin-apis.md) as demonstrated by both [apple/swift-package-manager](https://github.com/apple/swift-package-manager/tree/main/Fixtures/Miscellaneous/Plugins/MyBinaryToolPlugin) and [abertelrud/swiftpm-buildtool-plugin-examples](https://github.com/abertelrud/swiftpm-buildtool-plugin-examples) but can be used in any project by adding this remote repository.

## Warning

This project is intended for demonstration and research purposes only.
Check out the accompanying [PR to SwiftGen](https://github.com/SwiftGen/SwiftGen/pull/926).

## Usage

### Adding the plugin

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
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        )
    ]
```

### Swiftgen.yml

The plugin offers two options for the `swiftgen.yml` file to support multiple-target packages. If you are only concerned with one target there is no difference between the two options.

1. Add a `swiftgen.yml` ([Example](swiftgen.yml)) to the root of your package (same folder as `Package.swift`), and swiftgen will be run **for all targets which support the plugin**
2. Add a `swiftgen.yml` ([Example](swiftgen.yml)) to your target's sources, swiftgen will be run for only this target

Both 1 & 2 can be combined if desired. However, if there is any duplicate files between the two methods the more specific target files will be used (method #2).

## Issues

At the moment the plugin is quite good at the typical use case. The correct files are generated, and new versions of the files are overwritten.
However, the plugin is not good at cleaning up files in the event that you decide to change a generated file's name or stop to generate it. In these cases you may need to manually remove the previously generated files from DerivedData or run `File -> Packages -> Clear Package Caches`.

**Question:**

- How is cleanup supposed to be handled for build tools?
  - e.g. If I change the name of my expected generated SwiftGen file, both the old file and the new will be in the generated outputs
  - I've tried running deletions from `createBuildCommands` but they tend to not run out of sync and unpredictably

If anyone can help answer these questions please open an issue or [use my contact information](https://github.com/nicorichard).
