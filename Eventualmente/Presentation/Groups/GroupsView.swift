import SwiftUI
import FirebaseFirestore

struct GroupsView: View {
    @Environment(AppModel.self) private var appModel
    @State private var vm = GroupsViewModel()
    @FirestoreQuery(collectionPath: "groups") var groups: [PrivateGroup]

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
                    // TODO
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
                        // TODO
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    GroupsView()
        .environment(AppModel())
        .tint(.accent)
}
