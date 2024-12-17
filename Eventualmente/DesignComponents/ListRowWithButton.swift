import Foundation
import SwiftUI

struct ListRowWithButton: View {
    let text: String?
    let action: () -> Void

    var body: some View {
        HStack {
            Text(text ?? "")
                .overlay {
                    if text == nil {
                        ProgressView()
                    }
                }
            Spacer()
            Button {
                action()
            } label: {
                Image(systemName: "pencil")
            }
        }
    }
}
