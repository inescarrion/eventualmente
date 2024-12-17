import SwiftUI

enum SelectedField: Identifiable {
    var id: Self { self }

    case name
    case email
    case password
}

struct UserDataFormView: View {
    @Environment(\.dismiss) var dismiss
    @State private var vm = UserDataFormViewModel()
    let selectedField: SelectedField
    var navigationTitle: String {
        switch selectedField {
        case .name:
            "Editar nombre"
        case .email:
            "Editar correo electrónico"
        case .password:
            "Editar contraseña"
        }
    }
    var sectionTitle: String {
        switch selectedField {
        case .name:
            "Nuevo nombre"
        case .email:
            "Nuevo correo electrónico"
        case .password:
            "Nueva contraseña"
        }
    }
    var hint: String {
        switch selectedField {
        case .name:
            "Introduce un nuevo nombre"
        case .email:
            "Introduce una nueva dirección"
        case .password:
            "Introduce una nueva contraseña"
        }
    }
    @State private var currentPassword: String = ""
    @State private var text: String = ""

    var body: some View {
        NavigationStack {
            List {
                if selectedField != .name {
                    Section("Contraseña actual") {
                        SecureField("Introduce tu contraseña actual", text: $currentPassword)
                    }
                }
                Section {
                    if selectedField == .password {
                        SecureField(hint, text: $text)
                    } else {
                        TextField(hint, text: $text)
                            .textInputAutocapitalization(selectedField == .name ? .words : .never)
                            .autocorrectionDisabled(true)
                    }
                } header: {
                    Text(sectionTitle)
                } footer: {
                    if selectedField == .email {
                        Text("Se enviará un correo electrónico de verificación a la nueva dirección y tendrás que volver a iniciar sesión.")
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        switch selectedField {
                        case .name:
                            vm.updateName(name: text)
                        case .email:
                            vm.updateEmail(password: currentPassword, email: text)
                        case .password:
                            vm.updatePassword(oldPassword: currentPassword, newPassword: text)
                        }
                        dismiss()
                    }
                    .disabled(text.isEmptyOrWhitespace)
                }
            }
        }
    }
}

#Preview {
    Group {
        UserDataFormView(selectedField: .name)
        UserDataFormView(selectedField: .email)
        UserDataFormView(selectedField: .password)
    }
    .tint(.accent)
}
