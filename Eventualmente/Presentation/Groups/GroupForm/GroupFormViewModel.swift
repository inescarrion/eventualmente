import Foundation
import SwiftUI
import FirebaseFirestore
import OSLog

enum GroupFormType {
    case create
    case update(group: Binding<PrivateGroup>)
}

@MainActor
@Observable
class GroupFormViewModel {
    var newGroupName: String = ""
    var type: GroupFormType
    var navigationTitle: String {
        switch type {
        case .create:
            "Crear nuevo grupo"
        case .update:
            "Editar grupo"
        }
    }
    var confirmButtonText: String {
        switch type {
        case .create:
            "Crear"
        case .update:
            "Guardar"
        }
    }

    var groupCollection: CollectionReference {
        Firestore.firestore().collection("groups")
    }

    init(type: GroupFormType) {
        self.type = type
        if case .update(let group) = type {
            newGroupName = group.wrappedValue.name
        }
    }

    func createOrUpdateGroup() async {
        switch type {
        case .create:
            do {
                let group = PrivateGroup(name: newGroupName, membersIds: [AppModel.userId])
                try groupCollection.document().setData(from: group)
            } catch {
                Logger.global.error("Group creation failed: \(error.localizedDescription)")
            }
        case .update(let group):
            do {
                let updatedGroup = PrivateGroup(name: newGroupName, membersIds: group.wrappedValue.membersIds)
                try groupCollection.document(group.wrappedValue.id!).setData(from: updatedGroup, merge: true)
                group.wrappedValue = try await groupCollection.document(group.wrappedValue.id!).getDocument(as: PrivateGroup.self)
            } catch {
                Logger.global.error("Group update failed: \(error.localizedDescription)")
            }
        }
    }
}
