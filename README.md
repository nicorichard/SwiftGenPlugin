# SwiftGenPlugin

A remote built tool plugin [SE-0325](https://github.com/apple/swift-evolution/blob/main/proposals/0325-swiftpm-additional-plugin-apis.md) as demonstrated by both [apple/swift-package-manager](https://github.com/apple/swift-package-manager/tree/main/Fixtures/Miscellaneous/Plugins/MyBinaryToolPlugin) and [abertelrud/swiftpm-buildtool-plugin-examples](https://github.com/abertelrud/swiftpm-buildtool-plugin-examples) but can be used in any project by adding this remote repository.

## Questions

- It's still unclear to me how to properly package a command line tool such as SwiftGen as a `.artifactbundle`
- I'm interested to know the best way to store and distribute swift pre-built artifacts
  - For the purposes of this repository I've included a `.zip` with the Github release artifacts
    - This is tricky because the tagged code must reference the version from the release before it is created

## Usage

Include the following in your `Package.swift`

```swift
dependencies: [
        .package(url: "https://github.com/nicorichard/SwiftGenPlugin", exact: "6.4.0")
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