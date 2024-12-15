import Foundation
import FirebaseFirestore

struct PrivateGroup: Codable {
    @DocumentID var id: String?

    let name: String
    let membersIds: [String]
}
