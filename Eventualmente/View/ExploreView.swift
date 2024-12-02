//
//  ExploreView.swift
//  Eventualmente
//
//  Created by Inés Carrión on 2/12/24.
//

import SwiftUI
import FirebaseFirestore

struct ExploreView: View {
    @FirestoreQuery(collectionPath: "events") var events: [Event]

    var body: some View {
        List {
            Section("Todos los eventos") {
                ForEach(events, id: \.id) { event in
                    NavigationLink {
                        EventDetailView(event: event)
                    } label: {
                        EventListItem(event: event)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
