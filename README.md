# SwiftGenPlugin

A remote built tool plugin [SE-0325](https://github.com/apple/swift-evolution/blob/main/proposals/0325-swiftpm-additional-plugin-apis.md) as demonstrated by both [apple/swift-package-manager](https://github.com/apple/swift-package-manager/tree/main/Fixtures/Miscellaneous/Plugins/MyBinaryToolPlugin) and [abertelrud/swiftpm-buildtool-plugin-examples](https://github.com/abertelrud/swiftpm-buildtool-plugin-examples) but can be used in any project by adding this remote repository.

## Warning

This project is intended for demonstration and research purposes only.

## Questions

If anyone can help answer these questions please open an issue or [use my contact information](https://github.com/nicorichard).

- It's unclear to me how to properly package a command line tool such as SwiftGen as a `.artifactbundle`
  - I've copied over the bundle from [abertelrud/swiftpm-buildtool-plugin-examples](https://github.com/abertelrud/swiftpm-buildtool-plugin-examples) and zipped it
- What is the best way to store and distribute swift pre-built artifacts?
  - For the purposes of this repository I've included a `.zip` with the Github release artifacts
    - This is tricky because the tagged code must reference the version from the release before it is created
- How is cleanup supposed to be handled for build tools?
  - e.g. If I change the name of my expected generated SwiftGen file, both the old file and the new will be in the generated outputs
  - I've tried running deletions from `createBuildCommands` but they tend to not run out of sync and unpredictably

## Usage

Include the following in your `Package.swift`

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

and add a `swiftgen.yml` ([Example](swiftgen.yml)) to the root of your package (same folder as `Package.swift`).
