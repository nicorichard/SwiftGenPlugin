import PackagePlugin
import Foundation

@main
struct SwiftGenPlugin: BuildToolPlugin {
    private let swiftGenConfigFilename = "swiftgen.yml"

    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let fileManager = FileManager.default

        // This example configures `swiftgen` to write to this plugin's work directory.
        // Note: This writes to DerivedData and not to the project's source directories.
        let swiftGenOutputsDir = context.pluginWorkDirectory

        // If a `swiftgen.yml` file is located in the package directory it will be used, and the resulting generated files will be recreated for each target.
        //
        // In addition, if a `swiftgen.yml` is present in the root directory of any target's source files it will be used to generate sources for that target only.
        let paths: [Path] = [
            context.package.directory.appending(swiftGenConfigFilename),
            target.directory.appending(swiftGenConfigFilename)
        ]
            .filter {
                fileManager.fileExists(atPath: $0.string)
            }

        Diagnostics.remark("No SwiftGen configurations found for target \(target.name). If you would like to generate sources for this target include a `swiftgen.yml` in the target's source directory, or include a shared `swiftgen.yml` at the package's root.")

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
