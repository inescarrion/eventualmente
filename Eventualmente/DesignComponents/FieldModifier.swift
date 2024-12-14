import SwiftUI

struct FieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
    }
}

extension View {
    func customField() -> some View {
        modifier(FieldModifier())
    }
}
