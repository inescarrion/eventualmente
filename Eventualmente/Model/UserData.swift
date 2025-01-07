import Foundation
@preconcurrency import FirebaseFirestore

struct UserData: Codable, Equatable, Sendable {
    @DocumentID var id: String?

    let name: String
}
