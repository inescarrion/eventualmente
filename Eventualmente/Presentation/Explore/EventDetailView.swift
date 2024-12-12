import SwiftUI

struct EventDetailView: View {
    @State private var event: Event

    init(event: Event) {
        self.event = event
    }

    var body: some View {
        Text(event.title)
    }
}

#Preview {
    EventDetailView(event: .init(userId: "", title: "Event title", categoryName: "", subcategoryName: "", location: "", date: .init(), link: "", moreInfo: ""))
}
