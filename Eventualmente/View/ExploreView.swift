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

enum SortOption: String, CaseIterable {
    case date = "Fecha"
    case categoryAZ = "Categoría (A-Z)"
    case categoryZA = "Categoría (Z-A)"
}

struct ExploreView: View {
    @FirestoreQuery(collectionPath: "events", predicates: [.orderBy("date", false)]) var events: [Event]
    @State private var selectedViewMode: ViewMode = .list
    @State private var searchText: String = ""
    @State private var selectedSortOption: SortOption = .date

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
                EventListToolbar(title: "Explorar", sortMenuPicker: { picker }, filterButtonAction: {})
            }
            .onChange(of: selectedSortOption) {
                switch selectedSortOption {
                case .date:
                    $events.predicates = [.orderBy("date", false)]
                case .categoryAZ:
                    $events.predicates = [.orderBy("categoryName", false)]
                case .categoryZA:
                    $events.predicates = [.orderBy("categoryName", true)]
                }
            }
        }
    }
}

extension ExploreView {
    var picker: some View {
        Picker("SortMenu", selection: $selectedSortOption) {
            ForEach(SortOption.allCases, id: \.rawValue) {
                Text($0.rawValue).tag($0)
            }
        }
    }

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
