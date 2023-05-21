import Foundation

func getArch() throws -> Arch {
    var systemInfo = utsname()
    let retVal = uname(&systemInfo)

    if retVal != EXIT_SUCCESS {
        throw AppError.runtime("Can't call uname")
    }

    let arch = withUnsafeBytes(of: &systemInfo.machine) { bufPtr -> String? in
        let data = Data(bufPtr)
        if let lastIndex = data.lastIndex(where: { $0 != 0 }) {
            return String(data: data[0...lastIndex], encoding: .isoLatin1)
        } else {
            return String(data: data, encoding: .isoLatin1)
        }
    }

    if arch == nil {
        throw AppError.runtime("Can't decode uname")
    }

    return arch == "arm64" ? .arm64 : .x86_64
}

