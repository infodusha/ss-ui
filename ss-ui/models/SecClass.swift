import Foundation

enum SecClass {
    case genericPassword
    case internetPassword
    case certificate
    case key
    case identity

    var rawValue: CFString {
        switch self {
        case .genericPassword:
            return kSecClassGenericPassword
        case .internetPassword:
            return kSecClassInternetPassword
        case .certificate:
            return kSecClassCertificate
        case .key:
            return kSecClassKey
        case .identity:
            return kSecClassIdentity
        }
    }
}
