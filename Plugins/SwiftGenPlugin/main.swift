import PackagePlugin
import Foundation

@main
struct SwiftGenPlugin: BuildToolPlugin {
    private let swiftGenConfigFilename = "swiftgen.yml"

    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let fileManager = FileManager.default

        // This example configures `swiftgen` to write to a "SwiftGenOutputs" directory.
        // Note: This writes to DerivedData and not to the project's source directories.
        let swiftGenOutputsDir = context.pluginWorkDirectory.appending("SwiftGenOutputs")

        // Create the directory to store our generated files (if it doesn't exist already)
        try fileManager.createDirectory(atPath: swiftGenOutputsDir.string, withIntermediateDirectories: true)

        // Configures `swiftgen` to take inputs from a main `swiftgen.yml` file located in
        // the package directory if it exists. Which will be copied to each target.
        //
        // Otherwise `swiftgen` will take inputs from files named `swiftgen.yml` in the root
        // directory of each target's source files.
        func fullPackageConfig(_ context: PluginContext) -> Path? {
            let fullPackageConfigPath = context.package.directory.appending(swiftGenConfigFilename)
            if fileManager.fileExists(atPath: fullPackageConfigPath.string) {
                return fullPackageConfigPath
            }
            return nil
        }
        let path: Path = fullPackageConfig(context) ?? target.directory.appending(swiftGenConfigFilename)

        // Return a command to run `swiftgen` as a prebuild command. It will be run before
        // every build and generates source files into an output directory provided by the
        // build context.
        return [
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
        ]
    }
}
