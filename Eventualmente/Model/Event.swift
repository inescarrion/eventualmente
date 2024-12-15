import SwiftUI
@preconcurrency import FirebaseFirestore

struct Event: Codable, Equatable, Sendable {
    @DocumentID var id: String?

    let userId: String
    let groupId: String
    var isPublic: Bool {
        groupId.isEmpty
    }

    // IDs of users that marked the event as favourite
    let usersFavourite: [String]

    let title: String
    let categoryName: String
    let categorySymbol: String
    let subcategoryName: String
    let location: String
    let date: Timestamp
    let link: String
    let moreInfo: String
}
