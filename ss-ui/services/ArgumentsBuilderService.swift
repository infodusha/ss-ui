import Foundation

class ArgumentsBuilderService {
    static let shared = ArgumentsBuilderService()

    func create(port: String, url: String, verbose: Bool) -> [String] {
        var arguments: [String] = []
        arguments.append("-c")
        arguments.append(url)
        if verbose {
            arguments.append("-verbose")
        }
        arguments.append("-socks")
        arguments.append(":\(port)")
        arguments.append("-u")
        return arguments
    }
}