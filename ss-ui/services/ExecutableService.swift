import Foundation
import SwiftUI

class ExecutableService {
    static let shared = ExecutableService()

    let isEnabled$ = ExternalState(false)

    private var task: Process?
    private var executableURL: URL?

    private init() {
        executableURL = getExecutableURL()
    }

    func start(_ arguments: [String]) {
        logger.debug("Starting executable...")
        task = getTask(arguments)
        doTry {
            try task!.run()
        }
        isEnabled$.value = task!.isRunning
        logger.debug("Executable started")
    }

    func stop() {
        logger.debug("Stopping executable...")
        if task == nil {
            isEnabled$.value = false
            logger.debug("Task was not started but being stopped")
        } else {
            task!.interrupt()
            task!.interrupt()
            task!.terminate()
            task = nil
        }
        logger.debug("Executable stopped")
    }

    func restart(_ arguments: [String]) {
        logger.debug("Restating executable...")
        let task = task
        stop()
        task!.waitUntilExit()
        start(arguments)
        logger.debug("Executable restarted")
    }

    private func getTask(_ arguments: [String]) -> Process {
        let output = getOutput()
        let task = Process()
        task.standardOutput = output
        task.standardError = output
        task.executableURL = executableURL
        task.standardInput = nil
        task.arguments = arguments
        task.terminationHandler = { process in
            logger.debug("Executable terminated")
            DispatchQueue.main.async {
                self.isEnabled$.value = false
            }
        }
        return task
    }

    private func getOutput() -> Pipe {
        let output = Pipe()
        output.fileHandleForReading.readabilityHandler = { pipe in
            if let output = String(data: pipe.availableData, encoding: .utf8) {
                if !output.isEmpty {
                    logger.info(" \(output)")
                }
            } else {
                logger.critical("Error decoding data: \(pipe.availableData)")
            }
        }
        return output
    }

    private func getExecutableURL() -> URL? {
        doTry {
            let arch = try getArch()
            let resource = "shadowsocks2-macos-\(arch)"
            if let url = Bundle.main.url(forResource: resource, withExtension: nil) {
                return url
            } else {
                throw AppError.runtime("Can't find executable")
            }
        }
    }
}
