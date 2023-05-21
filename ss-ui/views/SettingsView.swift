import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView().padding().tabItem {
                        Text("General")
                    }
                    .tag(1)
            ServersSettingsView().padding().tabItem {
                        Text("Servers")
                    }
                    .tag(2)
            ProxySettingsView().padding().tabItem {
                        Text("Proxy")
                    }
                    .tag(2)
        }
                .padding()
    }
}
