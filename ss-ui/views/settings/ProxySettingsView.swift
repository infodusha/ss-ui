import SwiftUI

struct ProxySettingsView: View {
    var body: some View {
        Form {
            LabeledContent("Proxy exceptions list") {
                TextEditor(text: .constant("Placeholder"))
            }
        }
                .disabled(true)
    }
}

