import Foundation
import SwiftUI
import FirebaseFirestore
import OSLog

@MainActor
@Observable
class GroupDetailsViewModel {
    var group: Binding<PrivateGroup>
    var membersData: [UserData]

    func groupDocument(id: String) -> DocumentReference {
        Firestore.firestore().collection("groups").document(id)
    }

    init(group: Binding<PrivateGroup>) {
        _group = group
        self.membersData = []
    }

    func fetchGroupMembers(group: PrivateGroup) {
        guard membersData.isEmpty else { return }
        Task {
            do {
                for memberId in group.membersIds {
                    let memberData = try await Firestore.firestore().collection("users").document(memberId).getDocument(as: UserData.self)
                    membersData.append(memberData)
                }
            } catch {
                Logger.global.error("Error fetching group members: \(error.localizedDescription)")
            }
        }
    }

    func deleteGroup(group: PrivateGroup) {
        Task {
            do {
                try await groupDocument(id: group.id!).delete()
            } catch {
                Logger.global.error("Error deleting group: \(error.localizedDescription)")
            }
        }
    }

    func deleteMember(member: UserData, group: Binding<PrivateGroup>) {
        if membersData.count == 1 {
            deleteGroup(group: group.wrappedValue)
        } else {
            let updatedGroup = PrivateGroup(name: group.wrappedValue.name, membersIds: group.wrappedValue.membersIds.filter({ $0 != member.id }))
            Task {
                do {
                    try groupDocument(id: group.wrappedValue.id!).setData(from: updatedGroup, merge: true)
                    membersData.removeAll(where: { $0 == member })
                    group.wrappedValue = try await groupDocument(id: group.wrappedValue.id!).getDocument(as: PrivateGroup.self)
                } catch {
                    Logger.global.error("Error deleting group member: \(error.localizedDescription)")
                }
            }
        }
    }
}
