import SwiftUI
import FirebaseCore
import FirebaseFirestore
import CalendarView

struct ExploreView: View {
    @Environment(AppModel.self) private var appModel
    @State private var vm = ExploreViewModel()
    @FirestoreQuery(
        collectionPath: "events",
        predicates: [
            .orderBy("date", false),
            .where("date", isGreaterThan: Timestamp(date: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!))
        ]
    ) var events: [Event]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $vm.selectedViewMode) {
                    ForEach(ViewMode.allCases, id: \.rawValue) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .pickerStyle(.segmented)
                .background(.toolbarBackground)
                Divider()
                Group {
                    switch vm.selectedViewMode {
                    case .list:
                        listModeView
                    case .calendar:
                        calendarModeView
                    }
                }
                .searchable(text: $vm.searchText, placement: .automatic, prompt: "Buscar")
                .toolbar {
                    ExploreNavigationBar(sortMenuPicker: { picker }, filterButtonAction: {})
                    ExploreBottomToolbar(vm: vm, userId: appModel.state.userId)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .bottomBar)
                .onChange(of: events) { _, newValue in
                    vm.eventsShown = newValue
                    vm.addCalendarDecorations(events: events)
                }
                .onChange(of: vm.selectedSortOption) {
                    vm.sortEvents()
                    $events.predicates = vm.allPredicates
                }
                .onChange(of: vm.selectedViewMode) { _, newValue in
                    vm.updateViewMode(viewMode: newValue)
                    $events.predicates = vm.allPredicates
                }
                .onChange(of: vm.selectedSubsection) { _, _ in
                    $events.predicates = vm.allPredicates
                }
                .onChange(of: vm.visibleMonth) { _, _ in
                    vm.updateDatePredicates(selectedDate: nil)
                    $events.predicates = vm.allPredicates
                    vm.selectedDate = nil
                }
                .onChange(of: vm.selectedDate) { _, newDate in
                    vm.updateDatePredicates(selectedDate: newDate)
                    $events.predicates = vm.allPredicates
                }
                .onChange(of: vm.searchText) { _, newValue in
                    vm.eventsShown = newValue.isEmpty ? events : events.filter({ $0.title.localizedCaseInsensitiveContains(newValue) })
                }
                .sheet(isPresented: $vm.isCreatingEvent) {
                    NavigationStack {
                        CreateEventView(userId: appModel.state.userId, groupId: "")
                    }
                }
            }
        }
    }
}

// Subviews
extension ExploreView {
    var picker: some View {
        Picker("SortMenu", selection: $vm.selectedSortOption) {
            ForEach(SortOption.allCases, id: \.rawValue) {
                Text($0.rawValue).tag($0)
            }
        }
    }

    var listModeView: some View {
        var sectionTitle: String {
            switch vm.selectedSubsection {
            case .allEvents: "Todos los eventos"
            case .favorites: "Favoritos"
            case .myEvents: "Mis eventos"
            }
        }

        return List {
            Section(sectionTitle) {
                eventsList
            }
            .opacity(vm.eventsShown.isEmpty ? 0 : 1)
        }
        .overlay(alignment: .center) {
            NoResults(message: "No se ha encontrado ningún evento, prueba a crear uno.")
                .opacity(vm.eventsShown.isEmpty ? 1 : 0)
        }
    }

    var calendarModeView: some View {
        let eventListSectionTitle =
            vm.selectedDate == nil ?
                "Eventos de \(vm.visibleMonth.date!.monthName)" :
                "Eventos del \(vm.selectedDate!.day!) de \(vm.selectedDate!.date!.monthName)"

        return List {
            Section {
                CalendarView(visibleDateComponents: $vm.visibleMonth, selection: $vm.selectedDate)
                    .selectable { date in
                        if let date = Calendar.current.date(from: date) {
                            return date >= .now.startOfTheDay
                        } else {
                            return false
                        }
                    }
                    .deselectable()
                    .decorating(vm.decoratedDates, color: .accent)
            }
            Section(eventListSectionTitle) {
                if vm.eventsShown.isEmpty {
                    Text("No se ha encontrado ningún evento.")
                } else {
                    eventsList
                }
            }
        }
    }

    var eventsList: some View {
        ForEach(vm.eventsShown, id: \.id) { event in
            NavigationLink {
                EventDetailView(event: event)
            } label: {
                EventListItem(event: event)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExploreView()
            .environment(AppModel())
    }
    .tint(.accent)
}
