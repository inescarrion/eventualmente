import OSLog

extension Logger {
    static let subsystem = Bundle.main.bundleIdentifier!

    static let global = Logger(subsystem: subsystem, category: "global")
}
