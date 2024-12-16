import SwiftUI
import FirebaseFirestore

enum Path: Hashable {
    case groupEvents(group: PrivateGroup)
    case groupDetails(group: Binding<PrivateGroup>)

    static func == (lhs: Path, rhs: Path) -> Bool {
        switch (lhs, rhs) {
        case (.groupEvents(let lhsType), .groupEvents(let rhsType)):
            return lhsType == rhsType
        case (.groupDetails(let lhsType), .groupDetails(let rhsType)):
            return lhsType.wrappedValue == rhsType.wrappedValue
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .groupEvents(let group):
            return hasher.combine(group)
        case .groupDetails(let group):
            return hasher.combine(group.wrappedValue)
        }
    }
}

struct GroupsView: View {
    @Environment(AppModel.self) private var appModel
    @Bindable private var vm = GroupsViewModel()
    @FirestoreQuery(collectionPath: "groups", predicates: [.where(field: "membersIds", arrayContains: AppModel.userId)]) var groups: [PrivateGroup]
    @State private var isJoinGroupAlertPresented: Bool = false
    @State private var isCreatingGroup: Bool = false
    @State private var path: [Path] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(groups, id: \.id) { group in
                    NavigationLink(group.name, value: Path.groupEvents(group: group))
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
                GroupFormView(type: .create)
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
            .navigationDestination(for: Path.self) { path in
                switch path {
                case .groupEvents(let group):
                    GroupEventsView(group: group)
                case .groupDetails(let group):
                    GroupDetailsView(group: group, path: $path)
                }
            }
        }
    }
}

#Preview {
    GroupsView()
        .environment(AppModel())
        .tint(.accent)
}
