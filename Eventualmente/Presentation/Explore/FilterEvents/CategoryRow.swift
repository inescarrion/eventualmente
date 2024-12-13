import Foundation

struct CategoryRow: Hashable {
    var isSelected: Bool
    var isExpanded: Bool = false
    let name: String
    let isSubcategory: Bool
    let subcategories: [String]
}
