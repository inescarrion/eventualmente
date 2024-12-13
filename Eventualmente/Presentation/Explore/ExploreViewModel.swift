import Foundation
import FirebaseCore
import FirebaseFirestore
import SwiftUI

@Observable
class ExploreViewModel {
    var basePredicates: [QueryPredicate] = [
        .orderBy("date", false),
        .where("date", isGreaterThan: Timestamp(date: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!))
    ]
    var datePredicates: [QueryPredicate] = []
    var subsectionPredicates: [QueryPredicate] = []
    var filterPredicates: [QueryPredicate] = []
    var allPredicates: [QueryPredicate] {
        return basePredicates + subsectionPredicates + filterPredicates + datePredicates
    }

    var selectedViewMode: ViewMode = .list
    var selectedSubsection: ToolbarSubsections = .allEvents
    var isCreatingEvent: Bool = false
    var isFilterSheetPresented: Bool = false
    var searchText: String = ""
    var selectedSortOption: SortOption = .date

    // Calendar
    var visibleMonth: DateComponents = Calendar.current.dateComponents([.year, .month], from: .now)
    var selectedDate: DateComponents?
    var decoratedDates: Set<DateComponents> = []

    // Filters
    var areFiltersApplied: Bool = false
    var activeFilters: Int {
        guard areFiltersApplied else { return 0 }
        var count: Int = 0
        count += selectedCategoriesNames.count
        count += selectedSubcategories.count
        count += startDate.startOfTheDay == .now.startOfTheDay ? 0 : 1
        count += endDate.startOfTheDay == .now.startOfTheDay ? 0 : 1
        count += location.isEmpty ? 0 : 1
        return count
    }
    var categoriesListRows: [CategoryRow] = []
    var selectedCategoriesNames: Set<String> = []
    var selectedSubcategories: Set<String> = []
    var startDate: Date = .now
    var endDate: Date = .now
    var isEndDateSelected: Bool = false
    var location: String = ""

    var eventsShown: [Event] = []

    func sortEvents() {
        switch selectedSortOption {
        case .date:
            basePredicates[0] = .orderBy("date", false)
        case .categoryAZ:
            basePredicates[0] = .orderBy("categoryName", false)
        case .categoryZA:
            basePredicates[0] = .orderBy("categoryName", true)
        }
    }

    func updateViewMode(viewMode: ViewMode) {
        switch viewMode {
        case .list:
            datePredicates = []
            selectedDate = nil
        case .calendar:
            visibleMonth = Calendar.current.dateComponents([.year, .month], from: .now)
            datePredicates = [.isLessThan("date", Timestamp(date: Date().firstDayOfMonth(advancedBy: 1)))]
        }
    }

    func updateDatePredicates(selectedDate: DateComponents?) {
        if let selectedDate {
            // Show events of selected day
            datePredicates = [
                .where("date", isGreaterThanOrEqualTo: Timestamp(date: Calendar.current.date(from: selectedDate)!.startOfTheDay)),
                .where("date", isLessThanOrEqualTo: Timestamp(date: Calendar.current.date(from: selectedDate)!.endOfTheDay))]
        } else {
            // Show events of visible month if view mode is calendar
            guard selectedViewMode == .calendar else { return }
            datePredicates = [
                .where("date", isGreaterThanOrEqualTo: Timestamp(date: Calendar.current.date(from: visibleMonth)!.firstDayOfMonth())),
                .where("date", isLessThan: Timestamp(date: Calendar.current.date(from: visibleMonth)!.firstDayOfMonth(advancedBy: 1)))
            ]

        }
    }

    func addFilterPredicates() {
        filterPredicates = []
        if !selectedCategoriesNames.isEmpty {
            filterPredicates.append(.where("categoryName", isIn: Array(selectedCategoriesNames)))
        }
        if startDate > .now {
            filterPredicates.append(.where("date", isGreaterThanOrEqualTo: Timestamp(date: startDate.startOfTheDay)))
        }
        if isEndDateSelected {
            filterPredicates.append(.where("date", isLessThanOrEqualTo: Timestamp(date: endDate.endOfTheDay)))
        }
        areFiltersApplied = true
        if activeFilters == 0 {
            areFiltersApplied = false
        }
    }

    func clearFilters() {
        areFiltersApplied = false
        filterPredicates = []
        categoriesListRows = []
        selectedCategoriesNames = []
        selectedSubcategories = []
        startDate = .now
        endDate = .now
        isEndDateSelected = false
        location = ""
    }

    func addCalendarDecorations(events: [Event]) {
        if selectedDate == nil {
            decoratedDates = Set(events.map({ Calendar.current.dateComponents(in: .current, from: $0.date.dateValue()) }))
        }
    }
}

enum ViewMode: String, CaseIterable {
    case list = "Lista"
    case calendar = "Calendario"
}

enum ToolbarSubsections: String, CaseIterable {
    case allEvents = "Todos"
    case favorites = "Favoritos"
    case myEvents = "Mis eventos"
}

enum SortOption: String, CaseIterable {
    case date = "Fecha"
    case categoryAZ = "Categoría (A-Z)"
    case categoryZA = "Categoría (Z-A)"
}
