import SwiftUI
import FirebaseFirestore

struct Event: Codable, Equatable {
    @DocumentID var id: String?

    let userId: String?
    var isPublic: Bool {
        userId == nil
    }

    let title: String
    let categoryName: String?
    let subcategoryName: String?
    let location: String?
    let date: Date
    let link: String?
    let moreInfo: String?
}
