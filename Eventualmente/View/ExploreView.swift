//
//  ExploreView.swift
//  Eventualmente
//
//  Created by Inés Carrión on 2/12/24.
//

import SwiftUI
import FirebaseFirestore

enum ViewMode: String, CaseIterable {
    case list = "Lista"
    case calendar = "Calendario"
}

struct ExploreView: View {
    @FirestoreQuery(collectionPath: "events") var events: [Event]
    @State private var selectedViewMode: ViewMode = .list
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            Picker("", selection: $selectedViewMode) {
                ForEach(ViewMode.allCases, id: \.rawValue) {
                    Text($0.rawValue).tag($0)
                }
            }
            .padding(.horizontal)
            .pickerStyle(.segmented)
            Group {
                switch selectedViewMode {
                case .list:
                    listModeView()
                case .calendar:
                    calendarModeView()
                }
            }
            .searchable(text: $searchText, placement: .automatic, prompt: "Buscar")
            .toolbar {
                EventListToolbar(title: "Explorar", sortButtonAction: {}, filterButtonAction: {})
            }
        }
    }
}

extension ExploreView {
    func listModeView() -> some View {
        List {
            Section("Todos los eventos") {
                eventsList
            }
        }
    }

    var eventsList: some View {
        ForEach(events, id: \.id) { event in
            NavigationLink {
                EventDetailView(event: event)
            } label: {
                EventListItem(event: event)
            }
        }
    }

    func calendarModeView() -> some View {
        List {
            Section {
                Text("[CALENDARIO]")
            }
            eventsList
        }
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
    .tint(.accent)
}
