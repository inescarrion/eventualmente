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
    var allPredicates: [QueryPredicate] {
        return basePredicates + datePredicates
    }

    var selectedViewMode: ViewMode = .list
    var searchText: String = ""
    var selectedSortOption: SortOption = .date

    // Calendar
    var visibleMonth: DateComponents = Calendar.current.dateComponents([.year, .month], from: .now)
    var selectedDate: DateComponents?
    var decoratedDates: Set<DateComponents> = []

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

    func addCalendarDecorations(events: [Event]) {
        if selectedDate == nil {
            decoratedDates = Set(events.map({ Calendar.current.dateComponents(in: .current, from: $0.date) }))
        }
    }
}

enum ViewMode: String, CaseIterable {
    case list = "Lista"
    case calendar = "Calendario"
}

enum SortOption: String, CaseIterable {
    case date = "Fecha"
    case categoryAZ = "Categoría (A-Z)"
    case categoryZA = "Categoría (Z-A)"
}
