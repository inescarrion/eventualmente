import SwiftUI

extension String {
    var coloredFirstLetter: LocalizedStringKey {
        guard self.count > 1 else { return "\(self)" }
        let firstLetter = String(self.first!)
        let remainingLetters = self.dropFirst()
        return "\(Text(firstLetter).foregroundStyle(.accent))\(Text(remainingLetters))"
    }

    var isEmptyOrWhitespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
