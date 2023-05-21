import SwiftUI

struct MenuView: View {
    @Environment(\.openWindow) private var openWindow

    private func toggleExecutable() {
        if isEnabled$.value {
            ExecutableService.shared.stop()
        } else {
            if activeServer != nil {
                ExecutableService.shared.start(getArguments())
            }
        }
    }

    private func getArguments() -> [String] {
        ArgumentsBuilderService.shared.create(port: "4441", url: activeServer!.url, verbose: true)
    }

    private func activeChange(_ newValue: Server?) {
        if !isEnabled$.value {
            return
        }
        if newValue == nil {
            ExecutableService.shared.stop()
            return
        }
        ExecutableService.shared.restart(getArguments())
    }

    private func openSettings() {
        openWindow(id: "settings")
    }

    private func quit() {
        NSApplication.shared.terminate(self)
    }

    private var activeServer: Server? {
        servers$.value.first(where: { $0.id == active$.value })
    }

    @ObservedObject private var isEnabled$ = ExecutableService.shared.isEnabled$
    @ObservedObject private var servers$ = UserSettingsService.shared.servers$
    @ObservedObject private var active$ = UserSettingsService.shared.active$

    var body: some View {
        Button(action: toggleExecutable, label: {
            Text(isEnabled$.value ? "Disable" : "Enable")
        })
                .disabled(active$.value == nil)
                .keyboardShortcut("s")
                .onChange(of: activeServer, perform: activeChange)

        let activeBinding = Binding<UUID>(
                get: { active$.value ?? UUID() },
                set: { UserSettingsService.shared.active = $0 }
        )

        Picker("Server", selection: activeBinding) {
            ForEach(servers$.value, id: \.id) { server in
                Text(server.name)
            }
        }
                .disabled(servers$.value.count == 0)
                .pickerStyle(MenuPickerStyle())

        Button(action: openSettings, label: { Text("Settings") })

        Divider()

        Button(action: quit, label: { Text("Quit") }).keyboardShortcut("q")
    }
}
