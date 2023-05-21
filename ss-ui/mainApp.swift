import SwiftUI

@main
struct mainApp: App {
    @ObservedObject private var isEnabled$ = ExecutableService.shared.isEnabled$;

    var body: some Scene {
        MenuBarExtra("UtilityApp", systemImage: isEnabled$.value ? "key.fill" : "key") {
            MenuView()
        }

        Window("Settings", id: "settings") {
            SettingsView()
                    .frame(width: 600, height: 400)
                    .fixedSize()
        }
                .windowResizability(.contentSize)
    }
}
