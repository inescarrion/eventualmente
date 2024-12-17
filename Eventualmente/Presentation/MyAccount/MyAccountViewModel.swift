import Foundation
import FirebaseFirestore
import FirebaseAuth
import OSLog

@MainActor
@Observable
class MyAccountViewModel {
    var currentUser = Auth.auth().currentUser
    var user: UserData?

    init() {
        guard !AppModel.userId.isEmpty else { user = nil ; return }
        Task {
            self.user = try await Firestore.firestore().collection("users").document(AppModel.userId).getDocument(as: UserData.self)
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            Logger.global.error("\(error.localizedDescription)")
        }
    }
}
