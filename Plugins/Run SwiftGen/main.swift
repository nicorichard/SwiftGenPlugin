import PackagePlugin
import Foundation

@main
struct SwiftGenCommandPlugin: CommandPlugin {
    /// Automatically discovers SwiftGen config file paths for the given package and selected targets
    private func paths(context: PluginContext, targets: [Target], configFile: String) -> [Path] {
        let fileManager = FileManager.default

        return ([
            context.package.directory.appending(configFile)
        ] + targets.map { target in
            target.directory.appending("Resources").appending(configFile)
        }).filter {
            fileManager.fileExists(atPath: $0.string)
        }
    }

    /// Determines the targets in which we'll search for SwiftGen config files to be run
    private func targets(context: PluginContext, arguments: [String]) -> [Target] {
        let targetArgs = parseArgs(key: "target", arguments: arguments)

        if !targetArgs.isEmpty {
            return context.package.targets
        } else {
            return context.package.targets.filter {
                targetArgs.contains($0.name)
            }
        }
    }

    func performCommand(context: PluginContext, arguments: [String]) async throws {
        // Determines the config file name to search for, this can be customized by including `--filename FILENAME`
        let configFile = parseArgs(key: "filename", arguments: arguments).last ?? "swiftgen.yml"

        // Determines which targets the command plugin will search for swiftgen config files in
        // This can be specified manually in the console by passing n `--target TARGET_NAME` arguments or will be passed in from Xcode 14's swift command plugin GUI
        let targets = targets(context: context, arguments: arguments)

        // If a config file is located in the package's root directory it will be run.
        // In addition, if a config file is present in a selected target's source directory it will be run.
        let paths = paths(context: context, targets: targets, configFile: configFile)

        if paths.isEmpty {
            Diagnostics.remark("No SwiftGen configurations found. If you would like to generate sources include a `swiftgen.yml` in a target's source directory, or in the package's root.")
        }

        let tool = try context.tool(named: "swiftgen")

        let exec = URL(fileURLWithPath: tool.path.string)

        for path in paths {

            print("Generating with the SwiftGen configuraton at `\(path)`")

            let args = [
                "config",
                "run",
                "--verbose",
                "--config", "\(path)"
            ]

            let process = try Process.run(exec, arguments: args)

            process.waitUntilExit()

            if process.terminationReason == .exit && process.terminationStatus == 0 {
                print("SwiftGen execution completed for the configuraton at `\(path)`")
            }
            else {
                let problem = "\(process.terminationReason):\(process.terminationStatus)"
                Diagnostics.error("There was a problem generating Swift code for the SwiftGen configuration at `\(path)`: \(problem)")
            }
        }
    }
}

private func parseArgs(key: String, arguments: [String]) -> [String] {
    var values = [String]()

    var valueIsNext = false
    for arg in arguments {
        if valueIsNext && !arg.starts(with: "--") {
            values.append(arg)
        }

        if arg == "--\(key)" {
            valueIsNext = true
        } else {
            valueIsNext = false
        }
    }

    return values
}
