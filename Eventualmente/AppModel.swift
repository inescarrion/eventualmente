import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum AppState: Equatable {
    case loading
    case unauthenticated
    case authenticated(user: User)

    var userId: String {
        switch self {
        case .loading: return ""
        case .unauthenticated: return ""
        case .authenticated(user: let user): return user.uid
        }
    }
}

enum Tab: Equatable {
    case explore
    case groups
    case myAccount
}

@MainActor
@Observable
class AppModel {
    var state: AppState = .loading
    var selectedTab: Tab = .explore
    let database = Firestore.firestore()

    init() {
        registerAuthStateHandler()

        // Disable database persistence
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        database.settings = settings
    }

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { _, user in
                self.state = user == nil ? .unauthenticated : .authenticated(user: user!)
            }
        }
    }
}
