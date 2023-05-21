import Foundation

class Server: Codable, Equatable {
    let id: UUID
    var name = ""
    var cipher = Cipher.AEAD_CHACHA20_POLY1305
    var password = ""
    var address = ""
    var port = ""

    private var keychainItem: KeychainItem!

    var url: String {
        "ss://\(cipher):\(password)@\(address):\(port)"
    }

    init(id: UUID) {
        self.id = id
        setKeychain()
        loadPassword();
    }

    func savePassword() throws {
        let data = Data(password.utf8)
        try keychainItem.save(data)
    }

    func deletePassword() throws {
        try keychainItem.delete()
    }

    private func setKeychain() {
        keychainItem = KeychainItem(secClass: .genericPassword, service: "ss-ui", account: id.uuidString)
    }

    private func loadPassword() {
        let savedPassword = doTry {
            try keychainItem.read()
        }
        if savedPassword != nil {
            // FIXME no idea why I need two !!
            password = String(decoding: savedPassword!!, as: UTF8.self)
        }
    }

    static func ==(lhs: Server, rhs: Server) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.url == rhs.url
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case cipher
        case address
        case port
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(cipher, forKey: .cipher)
        try container.encode(address, forKey: .address)
        try container.encode(port, forKey: .port)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        cipher = try container.decode(Cipher.self, forKey: .cipher)
        address = try container.decode(String.self, forKey: .address)
        port = try container.decode(String.self, forKey: .port)
        setKeychain()
        loadPassword();
    }
}
