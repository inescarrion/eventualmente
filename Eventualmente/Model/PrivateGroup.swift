import Foundation
@preconcurrency import FirebaseFirestore

struct PrivateGroup: Codable, Hashable, Sendable {
    @DocumentID var id: String?

    let name: String
    let membersIds: [String]
}
