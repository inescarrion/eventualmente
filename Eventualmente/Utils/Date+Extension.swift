import Foundation

extension Date {
    var startOfTheDay: Self {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }

    var endOfTheDay: Self {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }

    func firstDayOfMonth(advancedBy: Int = 0) -> Self {
        var components = Calendar.current.dateComponents([.year, .month, .calendar], from: self)
        components.day = 1
        components.month = components.month?.advanced(by: advancedBy)
        return components.date!
    }

    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}

extension DateComponents {
    var date: Date? {
        Calendar.current.date(from: self)
    }
}
