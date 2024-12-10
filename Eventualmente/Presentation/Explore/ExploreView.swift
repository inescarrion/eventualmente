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
    @State private var eventsShown: [Event] = []

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

                ToolbarItem(placement: .bottomBar) {
                    toolbarButtons
                }
            }
            .toolbarBackground(.visible, for: .bottomBar)
            .onChange(of: selectedSortOption) {
                switch selectedSortOption {
                case .date:
                    $events.predicates = [.orderBy("date", false)]
                case .categoryAZ:
                    $events.predicates = [.orderBy("categoryName", false)]
                case .categoryZA:
                    $events.predicates = [.orderBy("categoryName", true)]
                }
                eventsShown = events
            }
            .onChange(of: events.count) { oldValue, newValue in
                // Initialize events list with all the events
                if oldValue == 0 && newValue > 0 {
                    eventsShown = events
                }
            }
            .onChange(of: searchText) { _, newValue in
                if newValue.isEmpty {
                    eventsShown = events
                } else {
                    eventsShown = events.filter( { $0.title.localizedCaseInsensitiveContains(newValue) })
                }
            }
        }
    }
}

extension ExploreView {
    var toolbarButtons: some View {
            HStack {
                Button("Todos") {}
                    .bold()
                Button("Favoritos") {}
                    .foregroundStyle(.gray)
                Button("Mis eventos") {}
                    .foregroundStyle(.gray)
                Button("Crear", systemImage: "plus") {}
                    .buttonStyle(.borderedProminent)
                    .padding(.leading)
            }
    }

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
            .opacity(eventsShown.isEmpty ? 0 : 1)
        }
        .overlay(alignment: .center) {
            NoResults(message: "No se ha encontrado ningún evento")
                .opacity(eventsShown.isEmpty ? 1 : 0)
        }
    }

    var eventsList: some View {
        ForEach(eventsShown, id: \.id) { event in
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
            if eventsShown.isEmpty {
                Text("No se ha encontrado ningún evento.")
            } else {
                eventsList
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
    .tint(.accent)
}
