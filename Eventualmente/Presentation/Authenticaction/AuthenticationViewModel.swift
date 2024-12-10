//
//  AuthenticationViewModel.swift
//  Eventualmente
//
//  Created by Inés Carrión on 24/11/24.
//

import Foundation
import OSLog
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

    var email: String = ""
    var password: String = ""
    var passwordConfirmation: String = ""

    var authFlow: AuthFlow = .createAccount
    var areFieldsEmpty: Bool {
        if authFlow == .createAccount {
            email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty
        } else {
            email.isEmpty || password.isEmpty
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
                    errorMessage = "No existe ningún usuario con el correo electrónico introducido"
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

    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}
