import SwiftUI

struct ServersSettingsView: View {
    @Environment(\.controlActiveState) private var controlActiveState

    private func handleControlActiveStateChange(_ newValue: ControlActiveState) {
        switch newValue {
        case .inactive:
            if (serversLoaded) {
                save()
            }
            break
        case .key, .active:
            break
        @unknown default:
            break
        }
    }

    private func save() {
        UserSettingsService.shared.servers = servers
    }

    private func add() {
        let server = Server(id: UUID())
        servers.append(server)
        selection = server.id
    }

    private func remove(id: UUID) {
        if selection == id {
            selection = nil
        }
        if UserSettingsService.shared.active == id {
            UserSettingsService.shared.active = nil
        }
        let index = servers.firstIndex {
            $0.id == id
        }
        if index == nil {
            return
        }
        doTry {
            try servers[index!].deletePassword()
        }
        servers.remove(at: index!)
        save()
    }

    @State private var servers: [Server] = []

    @State private var selection: UUID?

    @State private var serversLoaded = false

    var body: some View {
        HSplitView {
            List(servers, id: \.id, selection: $selection) { server in
                Text(server.name).frame(alignment: .leading).contextMenu(ContextMenu {
                    Button(action: { remove(id: server.id) }, label: { Text("Remove") })
                })
            }
                    .contextMenu(ContextMenu {
                        Button(action: add, label: { Text("Add") })
                    })
                    .frame(minWidth: 100, maxWidth: 300, alignment: .leading)

            ZStack {
                if selection != nil {
                    if let selected = servers.first(where: { $0.id == selection }) {
                        let selectedBinding = Binding<Server>(
                                get: { selected },
                                set: {
                                    selected.name = $0.name
                                    selected.address = $0.address
                                    selected.port = $0.port
                                    selected.password = $0.password
                                    selected.cipher = $0.cipher
                                }
                        )

                        Form {
                            TextField("Name", text: selectedBinding.name)
                            TextField("Address", text: selectedBinding.address)
                            TextField("Port", text: selectedBinding.port)
                            SecureField("Password", text: selectedBinding.password)
                            Picker(selection: selectedBinding.cipher, label: Text("Cipher")) {
                                Text("AEAD_AES_128_GCM").tag(Cipher.AEAD_AES_128_GCM)
                                Text("AEAD_AES_256_GCM").tag(Cipher.AEAD_AES_256_GCM)
                                Text("AEAD_CHACHA20_POLY1305").tag(Cipher.AEAD_CHACHA20_POLY1305)
                            }
                        }
                                .frame(alignment: .leading)
                                .onSubmit(save)
                                .onDisappear(perform: save)
                    }
                } else {
                    if servers.count == 0 {
                        Text("Add a new server")
                    } else {
                        Text("Select server to edit")
                    }
                }
            }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).padding()
        }
                .onAppear {
                    servers = UserSettingsService.shared.servers
                    serversLoaded = true
                }
                .onChange(of: selection, perform: { newValue in save() })
                .onChange(of: controlActiveState, perform: handleControlActiveStateChange)
    }
}
