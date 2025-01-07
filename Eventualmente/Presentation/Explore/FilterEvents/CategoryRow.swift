import Foundation

struct CategoryRow: Hashable {
    var isSelected: Bool
    var isExpanded: Bool = false
    let name: String
    let parentName: String?
    var isSubcategory: Bool {
        parentName != nil
    }
    let subcategories: [String]
}
