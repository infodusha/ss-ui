import Foundation

struct KeychainDictionary {
    var secClass: SecClass?
    var service: String?
    var account: String?
    var data: Data?
    var returnData: Bool?

    var query: CFDictionary {
        var query: [CFString: Any] = [:]
        if secClass != nil {
            query[kSecClass] = secClass!.rawValue
        }
        if service != nil {
            query[kSecAttrService] = service
        }
        if account != nil {
            query[kSecAttrAccount] = account
        }
        if data != nil {
            query[kSecValueData] = data
        }
        if returnData != nil && returnData != false {
            query[kSecReturnData] = true
        }
        return query as CFDictionary
    }

    init(secClass: SecClass? = nil, service: String? = nil, account: String? = nil, data: Data? = nil, returnData: Bool? = nil) {
        self.secClass = secClass
        self.service = service
        self.account = account
        self.data = data
        self.returnData = returnData
    }
}
