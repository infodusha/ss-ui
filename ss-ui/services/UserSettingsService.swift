import Foundation

class UserSettingsService {
    static let shared = UserSettingsService()

    let servers$ = ExternalState<[Server]>([])
    let active$ = ExternalState<UUID?>(nil)

    init() {
        servers$.value = servers
        active$.value = active
    }

    var servers: [Server] {
        get {
            if let data = UserDefaults.standard.data(forKey: "servers") {
                if let servers = try? JSONDecoder().decode([Server].self, from: data) {
                    return servers
                }
            }
            return []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "servers")
                doTry {
                    try newValue.forEach { server in
                        try server.savePassword()
                    }
                }
                servers$.value = newValue
            }
        }
    }

    var active: UUID? {
        get {
            if let data = UserDefaults.standard.data(forKey: "active") {
                if let active = try? JSONDecoder().decode(UUID.self, from: data) {
                    return active
                }
            }
            return nil
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: "active")
            } else if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "active")
            }
            active$.value = newValue
        }
    }
}

