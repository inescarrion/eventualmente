import Foundation
import FirebaseFirestore
import OSLog

@MainActor
@Observable
class EventDetailViewModel {
    private(set) var event: Event
    var isFavourite: Bool {
        event.usersFavourite.contains(AppModel.userId)
    }
    var isAuthor: Bool {
        event.userId == AppModel.userId
    }

    init(event: Event) {
        self.event = event
    }

    func updateFavourite() {
        do {
            if let id = event.id {
                var usersFavourite = event.usersFavourite
                if isFavourite {
                    usersFavourite.removeAll(where: { $0 == AppModel.userId })
                } else {
                    usersFavourite.append(AppModel.userId)
                }
                let updatedEvent = Event(
                    userId: event.userId,
                    groupId: event.groupId,
                    usersFavourite: usersFavourite,
                    title: event.title,
                    categoryName: event.categoryName,
                    categorySymbol: event.categorySymbol,
                    subcategoryName: event.subcategoryName,
                    location: event.location,
                    date: event.date,
                    link: event.link,
                    moreInfo: event.moreInfo)
                try Firestore.firestore().collection("events").document(id).setData(from: updatedEvent, merge: true)
                fetchUpdatedEvent(id: id)
            }
        } catch {
            Logger.global.error("Error creating event: \(error.localizedDescription)")
        }
    }

    func fetchUpdatedEvent(id: String) {
        Task {
            self.event = try await Firestore.firestore().collection("events").document(id).getDocument(as: Event.self)
        }
    }

    func deleteEvent() {
        Firestore.firestore().collection("events").document(event.id!).delete()
    }
}
