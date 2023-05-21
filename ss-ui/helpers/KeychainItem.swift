import Foundation
import AuthenticationServices

class KeychainItem {
    private let secClass: SecClass
    private let service: String
    private let account: String

    private let dictionary: KeychainDictionary

    init(secClass: SecClass, service: String, account: String) {
        self.secClass = secClass
        self.service = service
        self.account = account
        dictionary = KeychainDictionary(secClass: secClass, service: service, account: account)
    }

    func delete() throws {
        let status = SecItemDelete(dictionary.query)
        if status != errSecSuccess {
            throw AppError.runtime("\(status)")
        }
    }

    func read() throws -> Data? {
        var dict = dictionary
        dict.returnData = true
        var result: AnyObject?
        let status = SecItemCopyMatching(dict.query, &result)
        if status != errSecSuccess {
            throw AppError.runtime("\(status)")
        }
        return result as? Data
    }

    func save(_ data: Data) throws {
        var dict = dictionary
        dict.data = data
        let status = SecItemAdd(dict.query, nil)

        if status == errSecDuplicateItem {
            try update(data)
        } else if status != errSecSuccess {
            throw AppError.runtime("\(status)")
        }
    }

    private func update(_ data: Data) throws {
        let dict = KeychainDictionary(data: data)
        let status = SecItemUpdate(dictionary.query, dict.query)
        if status != errSecSuccess {
            throw AppError.runtime("\(status)")
        }
    }
}

