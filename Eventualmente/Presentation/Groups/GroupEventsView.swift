import SwiftUI
import FirebaseFirestore

struct GroupEventsView: View {
    @Environment(AppModel.self) private var appModel
    @FirestoreQuery(collectionPath: "events") var groupEvents: [Event]
    let group: PrivateGroup
    @State private var isCreatingEvent: Bool = false

    var body: some View {
        List {
            Section("Eventos del grupo") {
                ForEach(groupEvents, id: \.id) { event in
                    NavigationLink {
                        EventDetailView(event: event)
                    } label: {
                        EventListItem(event: event)
                    }
                }
                Button("+ Crear nuevo evento") {
                    isCreatingEvent = true
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // TODO
                } label: {
                    NavigationButtonLabel(icon: "info.circle", text: "Detalles")
                }
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            $groupEvents.predicates = [.where("groupId", isEqualTo: group.id!)]
        }
        .sheet(isPresented: $isCreatingEvent) {
            EventFormView(type: .create(userId: AppModel.userId, groupId: group.id!), isPublic: false)
        }
    }
}

#Preview {
    NavigationStack {
        GroupEventsView(group: .init(name: "Nombre del grupo", membersIds: [""]))
            .environment(AppModel())
    }
    .tint(.accent)
}
