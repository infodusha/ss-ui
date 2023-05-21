import Foundation
import os

let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ss-ui")

enum AppError: Error {
    case runtime(String)
}

func doTry<T>(_ content: () throws -> T) -> T? {
    do {
        return try content()
    } catch {
        logger.fault("TRY_FAILED - \(error)")
        return nil
    }
}

class ExternalState<T>: ObservableObject {
    @Published var value: T

    init(_ value: T) {
        self.value = value
    }
}
