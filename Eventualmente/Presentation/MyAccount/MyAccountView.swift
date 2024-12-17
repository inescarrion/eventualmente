import SwiftUI
@preconcurrency import FirebaseAuth
import OSLog

struct MyAccountView: View {
    @State private var isShowingUpdateSheet: Bool = false
    @State private var selectedField: SelectedField?
    @State private var currentUserName = Auth.auth().currentUser?.displayName
    @State private var currentUserEmail = Auth.auth().currentUser?.email

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ListRowWithButton(text: currentUserName) {
                        selectedField = .name
                    }
                } header: {
                    Text("Nombre")
                } footer: {
                    Text("Este nombre es el que se mostrará en los grupos.")
                }

                Section("Correo electrónico") {
                    ListRowWithButton(text: currentUserEmail) {
                        selectedField = .email
                    }
                }

                Section("Contraseña") {
                    Button("Cambiar contraseña") {
                        selectedField = .password
                    }
                }

                Section("Créditos") {
                    Text("Ilustración de la página \"No se ha encontrado ningún evento, prueba a crear uno.\" diseñada por [storyset](https://www.freepik.com/free-vector/curious-concept-illustration_10840797.htm#fromView=search&page=1&position=19&uuid=d493423b-688b-495d-8714-850c2e38622b)")
                    Text("Vista de calendario: [CalendarView](https://github.com/AllanJuenemann/CalendarView) de Allan Juenemann")
                    Text("Autenticación y base de datos: [Google Firebase](https://firebase.google.com/)")
                }

                Button("Cerrar sesión") {
                    logOut()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Mi cuenta".coloredFirstLetter)
                        .font(.customTitle1)
                        .padding(.leading, 4)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(item: $selectedField) {
                fetchUpdatedUserName()
            } content: { selectedField in
                UserDataFormView(selectedField: selectedField)
                    .presentationDetents([.medium])
            }
        }
    }
}

private extension MyAccountView {
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            Logger.global.error("\(error.localizedDescription)")
        }
    }

    func fetchUpdatedUserName() {
        Task {
            try? await Auth.auth().currentUser?.reload()
            self.currentUserName = Auth.auth().currentUser?.displayName
        }
    }
}

#Preview {
    NavigationStack {
        MyAccountView()
    }
    .tint(.accent)
}
