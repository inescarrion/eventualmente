//
//  ContentView.swift
//  Eventualmente
//
//  Created by Inés Carrión on 8/10/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @Environment(AppModel.self) var appModel
    @State private var authenticationViewModel = AuthenticationViewModel()

    var body: some View {
        Group {
            switch appModel.state {
            case .loading:
                ProgressView()
            case .unauthenticated:
                AuthenticationView()
                    .environment(authenticationViewModel)
            case .authenticated(let user):
                tabView(user: user)
            }
        }
        .animation(.easeInOut, value: appModel.state)
    }
}

extension ContentView {
    func tabView(user: User) -> some View {
        @Bindable var appModel = appModel
        return TabView(selection: $appModel.selectedTab) {
            ExploreView()
                .tabItem {
                    Label("Explorar", systemImage: "magnifyingglass")
                }
                .tag(Tab.explore)
            Text("Favoritos")
                .tabItem {
                    Label("Favoritos", systemImage: "heart")
                }
                .tag(Tab.favourites)
            Text("Mis eventos")
                .tabItem {
                    Label("Mis eventos", systemImage: "calendar.badge.plus")
                }
                .tag(Tab.myEvents)
            Text("Grupos")
                .tabItem {
                    Label("Grupos", systemImage: "person.3")
                }
                .tag(Tab.groups)
                List {
                    Section("Correo electrónico") {
                        Text(user.email!)
                    }
                    Button("Cerrar sesión") {
                        authenticationViewModel.logOut()
                    }
                }
                .tabItem {
                    Label("Mi cuenta", systemImage: "person.crop.circle")
                }
                .tag(Tab.myAccount)
        }
    }
}

#Preview {
    ContentView()
        .environment(AppModel())
        .tint(.accent)
}
