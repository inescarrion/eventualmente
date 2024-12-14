import Foundation
import FirebaseFirestore
import OSLog

@Observable
class CreateEventViewModel {
    let userId: String
    let groupId: String
    var title: String = ""
    var selectedCategory: Category = .init(name: "", subcategories: [])
    var selectedSubcategory: String = ""
    var location: String = ""
    var selectedDate: Date = .now
    var link: String = ""
    var moreInfo: String = ""

    var isFormValid: Bool {
        if !userId.isEmpty {
            return !title.isEmptyOrWhitespace && !selectedCategory.name.isEmptyOrWhitespace && !location.isEmptyOrWhitespace && selectedDate > .now
                && (!link.isEmptyOrWhitespace || !moreInfo.isEmptyOrWhitespace)
        } else if !groupId.isEmpty {
            return !title.isEmptyOrWhitespace && selectedDate > .now
        } else {
            Logger.global.error("UserId and groupId are empty")
            return false
        }
    }

    init(userId: String, groupId: String) {
        self.userId = userId
        self.groupId = groupId
    }

    func createEvent() {
        let event = Event(
            userId: userId, groupId: groupId, usersFavourite: [],
            title: title, categoryName: selectedCategory.name, subcategoryName: selectedSubcategory,
            location: location, date: Timestamp(date: selectedDate), link: link, moreInfo: moreInfo)
        do {
            try Firestore.firestore().collection("events").document().setData(from: event, merge: false)
        } catch {
            Logger.global.error("Error creating event: \(error)")
        }
    }
}
