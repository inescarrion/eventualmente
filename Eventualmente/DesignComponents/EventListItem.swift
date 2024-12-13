import SwiftUI
import FirebaseFirestore

struct EventListItem: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.title)
                .fontWeight(.semibold)
            if !event.categoryName.isEmpty {
                HStack(spacing: 0) {
                    Text(event.categoryName)
                    Group {
                        Text(" | ")
                        Text(event.subcategoryName)
                    }
                    .opacity(event.subcategoryName.isEmpty ? 0 : 1)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            HStack(spacing: 4) {
                if !event.location.isEmpty {
                    Image(systemName: "mappin.and.ellipse")
                    Text(event.location)
                    Text(" | ")
                }
                Image(systemName: "calendar")
                Text(event.date.dateValue().formatted(date: .numeric, time: .omitted))
            }
            .font(.footnote)
        }
    }
}

#Preview {
    List {
        EventListItem(event: .init(
            userId: "", groupId: "", usersFavourite: [], title: "Event title",
            categoryName: "Category", subcategoryName: "Subcategory",
            location: "Location", date: Timestamp(), link: "", moreInfo: ""
        ))
        EventListItem(event: .init(
            userId: "", groupId: "", usersFavourite: [],
            title: "Private event with less information", categoryName: "",
            subcategoryName: "", location: "", date: Timestamp(), link: "", moreInfo: ""
        ))
    }
}
