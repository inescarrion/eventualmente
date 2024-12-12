import SwiftUI

struct AuthenticationView: View {
    @Environment(AppModel.self) var appModel
    @Environment(AuthenticationViewModel.self) var authVM

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Image("logo")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 100)
                    .padding(.vertical, 10)
                form()
            }
            .padding(.horizontal)

            Spacer()

            VStack(alignment: .center) {
                Text(authVM.authFlow == .createAccount ? "Ya tengo una cuenta" : "No tengo una cuenta")
                CustomSecondaryButton(authVM.authFlow == .createAccount ? "Iniciar sesión" : "Crear cuenta") {
                    switch authVM.authFlow {
                    case .createAccount:
                        withAnimation {
                            authVM.authFlow = .logIn
                            authVM.errorMessage = ""
                            authVM.passwordConfirmation = ""
                        }
                    case .logIn:
                        withAnimation {
                            authVM.authFlow = .createAccount
                            authVM.errorMessage = ""
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

private extension AuthenticationView {
    func form() -> some View {
        VStack(alignment: .leading) {
            @Bindable var authVM = authVM
            VStack(alignment: .leading, spacing: 30) {
                Text(authVM.authFlow == .createAccount ? "Crear \ncuenta".coloredFirstLetter : "Iniciar \nsesión".coloredFirstLetter)
                    .font(.customLargeTitle)
                    .fixedSize()
                TextField("Correo electrónico", text: $authVM.email)
                    .customField()
                SecureField("Contraseña", text: $authVM.password)
                    .customField()
                if authVM.authFlow == .createAccount {
                    SecureField("Repetir contraseña", text: $authVM.passwordConfirmation)
                        .customField()
                }
            }
            ErrorMessage(text: authVM.errorMessage, isVisible: !authVM.errorMessage.isEmpty)
            CustomPrimaryButton(authVM.authFlow == .createAccount ? "Crear cuenta" : "Iniciar sesión") {
                switch authVM.authFlow {
                case .createAccount:
                    Task {
                        _ = await authVM.createAccount()
                    }
                case .logIn:
                    Task {
                        _ = await authVM.logIn()
                    }
                }
            }
            .disabled(authVM.areFieldsEmpty)
        }
    }
}

#Preview {
    AuthenticationView()
        .environment(AppModel())
        .environment(AuthenticationViewModel())
}
