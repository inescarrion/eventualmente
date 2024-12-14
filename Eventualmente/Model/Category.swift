import Foundation
import FirebaseFirestore

struct Category: Codable, Hashable {
    @DocumentID var id: String?

    let name: String
    let subcategories: [String]
}
