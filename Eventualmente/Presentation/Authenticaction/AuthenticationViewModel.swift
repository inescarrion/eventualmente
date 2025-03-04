import Foundation
import OSLog
import FirebaseFirestore
@preconcurrency import FirebaseAuth

enum AuthFlow {
    case createAccount
    case logIn
}

@MainActor
@Observable
class AuthenticationViewModel {
    private let logger = Logger(
        subsystem: Logger.subsystem,
        category: String(describing: AuthenticationViewModel.self)
    )

    var name: String = ""
    var email: String = ""
    var password: String = ""
    var passwordConfirmation: String = ""

    var authFlow: AuthFlow = .logIn
    var areFieldsEmpty: Bool {
        if authFlow == .createAccount {
            name.isEmptyOrWhitespace || email.isEmptyOrWhitespace || password.isEmptyOrWhitespace || passwordConfirmation.isEmptyOrWhitespace
        } else {
            email.isEmptyOrWhitespace || password.isEmptyOrWhitespace
        }
    }
    var errorMessage: String = ""

    func validateFields() -> Bool {
        if password.count < 8 || password.count > 20 {
            errorMessage = "La contraseña debe tener entre 8 y 20 caracteres"
            return false
        } else if password != passwordConfirmation {
            errorMessage = "Las contraseñas no coinciden"
            return false
        } else {
            errorMessage = ""
            return true
        }
    }
}

extension AuthenticationViewModel {
    func createAccount() async -> Bool {
        guard validateFields() else { return false }
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            logger.info("User \(authResult.user.uid) created successfully")
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges { error in
                if let error {
                    self.logger.error("Error setting user name: \(error.localizedDescription)")
                } else {
                    Task {
                        try await Auth.auth().currentUser?.reload()
                        if let user = Auth.auth().currentUser {
                            let userData = UserData(name: user.displayName!)
                            try Firestore.firestore().collection("users").document(authResult.user.uid).setData(from: userData, merge: false)
                        }
                    }
                }
            }
            return true
        } catch {
            if let error = error as NSError? {
                let code = AuthErrorCode(rawValue: error.code)
                switch code {
                case .invalidEmail:
                    errorMessage = "La dirección de correo no es válida"
                case .emailAlreadyInUse:
                    errorMessage = "Ya existe una cuenta con el correo electrónico especificado"
                case .networkError:
                    errorMessage = "Error de red. Inténtalo de nuevo más tarde"
                default:
                    errorMessage = "Se ha producido un error\(code == nil ? "" : " (código: \(code!.rawValue))")"
                }
            } else {
                errorMessage = "Se ha producido un error"
            }
            logger.error("\(error.localizedDescription)")
            return false
        }
    }

    func logIn() async -> Bool {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            logger.info("User \(authResult.user.uid) signed in successfully")
            errorMessage = ""
            return true
        } catch {
            if let error = error as NSError? {
                let code = AuthErrorCode(rawValue: error.code)
                switch code {
                case .invalidEmail:
                    errorMessage = "La dirección de correo no es válida"
                case .userNotFound:
                    // swiftlint:disable:next line_length
                    errorMessage = "No existe ningún usuario con el correo electrónico introducido. Si lo has cambiado recientemente, te llegará un correo a la nueva dirección para verificarla"
                case .wrongPassword:
                    errorMessage = "La contraseña no es correcta"
                case .networkError:
                    errorMessage = "Error de red. Inténtalo de nuevo más tarde"
                default:
                    errorMessage = "Se ha producido un error\(code == nil ? "" : " (código: \(code!.rawValue))")"
                }
            } else {
                errorMessage = "Se ha producido un error"
            }
            logger.error("\(error.localizedDescription)")
            return false
        }
    }
}
