//
//  Logger+Extension.swift
//  Eventualmente
//
//  Created by Inés Carrión on 24/11/24.
//

import OSLog

extension Logger {
    static let subsystem = Bundle.main.bundleIdentifier!

    static let global = Logger(subsystem: subsystem, category: "global")
}
