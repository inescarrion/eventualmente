import SwiftUI
import FirebaseFirestore

struct GroupsView: View {
    @Environment(AppModel.self) private var appModel
    @Bindable private var vm = GroupsViewModel()
    @FirestoreQuery(collectionPath: "groups", predicates: [.where(field: "membersIds", arrayContains: AppModel.userId)]) var groups: [PrivateGroup]
    @State private var isJoinGroupAlertPresented: Bool = false
    @State private var isCreatingGroup: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(groups, id: \.id) { group in
                    NavigationLink(group.name) {
                        GroupEventsView(group: group)
                            .environment(appModel)
                    }
                }
                Button("+ Crear nuevo grupo") {
                    isCreatingGroup = true
                }
            }
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Grupos".coloredFirstLetter)
                        .font(.customTitle1)
                        .padding(.leading, 4)
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("Unirse a grupo existente") {
                        isJoinGroupAlertPresented = true
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $isCreatingGroup) {
                CreateGroupView()
                    .environment(vm)
            }
            .alert("Introduce el código de invitación", isPresented: $isJoinGroupAlertPresented) {
                TextField("Pega aquí el código", text: $vm.joinGroupId)
                Button("Validar") {
                    vm.joinGroup()
                }
                .keyboardShortcut(.defaultAction)
                Button("Cancelar", role: .cancel) {
                    isJoinGroupAlertPresented = false
                }
            } message: {
                Text("Pide el código al creador del grupo (Grupo > Detalles > Añadir miembro)")
            }
        }
    }
}

#Preview {
    GroupsView()
        .environment(AppModel())
        .tint(.accent)
}
