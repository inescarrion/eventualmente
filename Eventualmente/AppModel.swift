//
//  AppState.swift
//  Eventualmente
//
//  Created by Inés Carrión on 24/11/24.
//

import SwiftUI
import FirebaseAuth

enum AppState: Equatable {
    case loading
    case unauthenticated
    case authenticated(user: User)
}

@MainActor
@Observable
class AppModel {
    var state: AppState = .loading

    init() {
        registerAuthStateHandler()
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
