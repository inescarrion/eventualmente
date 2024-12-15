import UIKit

extension UIPasteboard {
    static func copy(_ string: String) {
        self.general.string = string
    }

    static func paste() -> String? {
        return self.general.string
    }
}
