import Foundation
@preconcurrency import FirebaseFirestore

struct PrivateGroup: Codable, Equatable, Sendable {
    @DocumentID var id: String?

    let name: String
    let membersIds: [String]
}
