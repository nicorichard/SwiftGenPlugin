import PackagePlugin
import Foundation

@main
struct SwiftGenBuildPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let fileManager = FileManager.default

        // Configures `swiftgen` to write to this plugin's work directory.
        // Note: Writes to DerivedData and not to the project's source directories.
        let swiftGenOutputsDir = context.pluginWorkDirectory

        // If a `swiftgen.yml` file is located in the package directory it will be used, and the resulting generated files will be recreated for each target.
        //
        // In addition, if a `swiftgen.yml` is present in the root directory of any target's source files it will be used to generate sources for that target only.
        let paths: [Path] = Helper().paths(context: context, targets: [target])
        
        // Clear the SwiftGen plugin's directory
        // Since we are always generating the output from scratch this prevents storing
        // garbage when a generated file is deleted.
        try? fileManager.removeItem(atPath: swiftGenOutputsDir.string)
        try? fileManager.createDirectory(atPath: swiftGenOutputsDir.string, withIntermediateDirectories: false)

        // Return a command to run `swiftgen` as a prebuild command. It will be run before
        // every build and generates source files into an output directory provided by the
        // build context.
        return try paths.map { path in
            Command.prebuildCommand(
                displayName: "Running SwiftGen",
                executable: try context.tool(named: "swiftgen").path,
                arguments: [
                    "config",
                    "run",
                    "--verbose",
                    "--config", "\(path)"
                ],
                environment: [
                    "PROJECT_DIR": "\(context.package.directory)",
                    "TARGET_NAME": "\(target.name)",
                    "DERIVED_SOURCES_DIR": "\(swiftGenOutputsDir)",
                ],
                outputFilesDirectory: swiftGenOutputsDir
            )
        }
    }
}

struct Helper {
    let fileManager = FileManager.default
    let configFilenames = ["swiftgen.yml", ".swiftgen.yml"]

    /// Automatically discovers SwiftGen config file paths for the given package and selected targets
    /// If a `swiftgen.yml` file is located in the package directory it will be used, and the resulting generated files will be recreated for each target.
    ///
    /// In addition, if a `swiftgen.yml` is present in the root directory of any target's source files it will be used to generate sources for that target only.///
    func paths(context: PluginContext, targets: [Target]) -> [Path] {
        let packagePathConfig = configFilenames.map {
            context.package.directory.appending($0)
        }.first {
            fileManager.fileExists(atPath: $0.string)
        }

        let targetPathConfigs = targets.map { target in
            configFilenames.map { filename in
                target.directory.appending(filename)
            }.first { path in
                fileManager.fileExists(atPath: path.string)
            }
        }

        let paths = [
            [packagePathConfig],
            targetPathConfigs
        ]
            .flatMap { $0 }
            .compactMap { $0 }
            .filter {
                fileManager.fileExists(atPath: $0.string)
            }

        if paths.isEmpty {
            Diagnostics.remark("No SwiftGen configurations found. If you would like to generate sources include a `swiftgen.yml` in a target's source directory, or in the package's root.")
        }

        return paths
    }
}
