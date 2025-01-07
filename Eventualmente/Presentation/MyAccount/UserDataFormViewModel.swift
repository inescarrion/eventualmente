import Foundation
import FirebaseFirestore
import FirebaseAuth
import OSLog

@MainActor
@Observable
class UserDataFormViewModel {
    let currentUser = Auth.auth().currentUser

    func updateName(name: String) {
        let changeRequest = currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
            if let error {
                Logger.global.error("Error updating user name: \(error.localizedDescription)")
            } else {
                let updatedUser = UserData(name: name)
                do {
                    guard let id = self.currentUser?.uid else { return }
                    try Firestore.firestore().collection("users").document(id).setData(from: updatedUser, merge: true)
                } catch {
                    Logger.global.error("Error updating user data: \(error.localizedDescription)")
                }
            }
        }
    }

    func updateEmail(password: String, email: String) {
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: currentUser?.email ?? "", password: password)

        currentUser?.reauthenticate(with: credential) { _, error in
            if let error {
                Logger.global.error("Error reauthenticating user: \(error.localizedDescription)")
            } else {
                self.currentUser?.sendEmailVerification(beforeUpdatingEmail: email) { error in
                    guard let error else { return }
                    Logger.global.error("Error updating user email: \(error.localizedDescription)")
                }
                // Log out
                do {
                    try Auth.auth().signOut()
                } catch {
                    Logger.global.error("\(error.localizedDescription)")
                }
            }
        }
    }

    func updatePassword(oldPassword: String, newPassword: String) {
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: currentUser?.email ?? "", password: oldPassword)

        currentUser?.reauthenticate(with: credential) { _, error in
            if let error {
                Logger.global.error("Error reauthenticating user: \(error.localizedDescription)")
            } else {
                self.currentUser?.updatePassword(to: newPassword) { error in
                    guard let error else { return }
                    Logger.global.error("Error updating user password: \(error.localizedDescription)")
                }
            }
        }
    }
}
