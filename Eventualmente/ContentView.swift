//
//  ContentView.swift
//  Eventualmente
//
//  Created by Inés Carrión on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppModel.self) var appModel
    @State private var authenticationViewModel = AuthenticationViewModel()

    var body: some View {
        NavigationStack {
            switch appModel.state {
            case .loading:
                ProgressView()
            case .unauthenticated:
                AuthenticationView()
                    .environment(authenticationViewModel)
            case .authenticated(let user):
                List {
                    Section("Correo electrónico") {
                        Text(user.email!)
                    }
                    Button("Cerrar sesión") {
                        authenticationViewModel.logOut()
                    }
                }
            }
        }
        .animation(.easeInOut, value: appModel.state)
    }
}

#Preview {
    ContentView()
}
