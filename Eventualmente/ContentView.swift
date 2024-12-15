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
            Group {
                ExploreView()
                    .tabItem {
                        Label("Explorar", systemImage: "magnifyingglass")
                    }
                    .tag(Tab.explore)
                    .environment(appModel)
                GroupsView()
                    .tabItem {
                        Label("Grupos", systemImage: "person.3")
                    }
                    .tag(Tab.groups)
                    .environment(appModel)
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
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
        .environment(AppModel())
        .tint(.accent)
}
