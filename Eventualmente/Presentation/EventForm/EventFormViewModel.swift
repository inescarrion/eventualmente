import Foundation
import FirebaseFirestore
import OSLog

enum EventFormType {
    case create(userId: String, groupId: String)
    case update(event: Event)
}

@MainActor
@Observable
class EventFormViewModel {
    let userId: String
    let groupId: String
    let usersFavourite: [String]
    var title: String = ""
    var selectedCategory: Category = .init(name: "", symbolName: "", subcategories: [])
    var selectedSubcategory: String = ""
    var location: String = ""
    var selectedDate: Date = .now
    var link: String = ""
    var moreInfo: String = ""

    let type: EventFormType
    var formTitle: String {
        switch type {
        case .create:
            "Crear nuevo evento"
        case .update:
            "Editar evento"
        }
    }
    var confirmButtonLabel: String {
        switch type {
        case .create:
            "Crear"
        case .update:
            "Guardar"
        }
    }

    var isFormValid: Bool {
        guard !userId.isEmpty else { fatalError("userId must not be empty")}

        if !groupId.isEmpty {
            // Private event
            return !title.isEmptyOrWhitespace && selectedDate > .now
        } else {
            // Public event
            return !title.isEmptyOrWhitespace && !selectedCategory.name.isEmptyOrWhitespace && !location.isEmptyOrWhitespace && selectedDate > .now
            && (!link.isEmptyOrWhitespace || !moreInfo.isEmptyOrWhitespace)
        }
    }

    init(type: EventFormType) {
        switch type {
        case .create(let userId, let groupId):
            self.userId = userId
            self.groupId = groupId
            self.usersFavourite = []
        case .update(let event):
            self.userId = event.userId
            self.groupId = event.groupId
            self.usersFavourite = event.usersFavourite
            self.title = event.title
            self.selectedCategory = .init(name: "", symbolName: "", subcategories: [])
            self.selectedSubcategory = event.subcategoryName
            self.location = event.location
            self.selectedDate = event.date.dateValue()
            self.link = event.link
            self.moreInfo = event.moreInfo
        }
        self.type = type
    }

    func createOrUpdateEvent() {
        switch type {
        case .create(let userId, let groupId):
            let event = Event(
                userId: userId, groupId: groupId, usersFavourite: usersFavourite,
                title: title, categoryName: selectedCategory.name, categorySymbol: selectedCategory.symbolName, subcategoryName: selectedSubcategory,
                location: location, date: Timestamp(date: selectedDate), link: link, moreInfo: moreInfo)
            do {
                try Firestore.firestore().collection("events").document().setData(from: event, merge: false)
            } catch {
                Logger.global.error("Error creating event: \(error.localizedDescription)")
            }
        case .update(let event):
            guard let id = event.id else { return }
            let updatedEvent = Event(
                userId: userId,
                groupId: groupId,
                usersFavourite: usersFavourite,
                title: title,
                categoryName: selectedCategory.name,
                categorySymbol: selectedCategory.symbolName,
                subcategoryName: selectedSubcategory,
                location: location,
                date: Timestamp(date: selectedDate),
                link: link,
                moreInfo: moreInfo)
            do {
                try Firestore.firestore().collection("events").document(id).setData(from: updatedEvent, merge: true)
            } catch {
                Logger.global.error("Error updating event: \(error.localizedDescription)")
            }
        }
    }
}
