//
//  EventList.swift
//  Eventualmente
//
//  Created by Inés Carrión on 30/11/24.
//

import SwiftUI

struct EventListItem: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.title)
                .fontWeight(.semibold)
            if let categoryName = event.categoryName {
                HStack(spacing: 0) {
                    Text(categoryName)
                    Group {
                        Text(" | ")
                        Text(event.subcategoryName ?? "")
                    }
                    .opacity(event.categoryName == nil ? 0 : 1)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            HStack(spacing: 4) {
                if let location = event.location {
                    Image(systemName: "mappin.and.ellipse")
                    Text(location)
                    Text(" | ")
                }
                Image(systemName: "calendar")
                Text(event.date.formatted(date: .numeric, time: .omitted))
            }
            .font(.footnote)
        }
    }
}

#Preview {
    List {
        EventListItem(event: .init(userId: nil, title: "Event title", categoryName: "Category", subcategoryName: "Subcategory", location: "Location", date: .now, link: "https://example.com", moreInfo: "More info"))
        EventListItem(event: .init(userId: nil, title: "Private event with less information", categoryName: nil, subcategoryName: nil, location: nil, date: .now, link: nil, moreInfo: nil))
    }
}
