import Foundation
import SwiftUI
import FirebaseFirestore
import OSLog

@MainActor
@Observable
class GroupsViewModel {
    var joinGroupId: String = ""
    var newGroupName: String = ""

    func joinGroup() {
        Task {
            do {
                let group = try await Firestore.firestore().collection("groups").document(joinGroupId).getDocument(as: PrivateGroup.self)
                var members: Set<String> = Set(group.membersIds)
                members.insert(AppModel.userId)
                let updatedGroup = PrivateGroup(name: group.name, membersIds: Array(members))
                try Firestore.firestore().collection("groups").document(joinGroupId).setData(from: updatedGroup, merge: true)
            } catch {
                Logger.global.error("Group joining failed: \(error.localizedDescription)")
            }
        }
    }

    func createGroup() {
        Task {
            do {
                let group = PrivateGroup(name: newGroupName, membersIds: [AppModel.userId])
                try Firestore.firestore().collection("groups").document().setData(from: group)
            } catch {
                Logger.global.error("Group creation failed: \(error.localizedDescription)")
            }
        }
    }
}
