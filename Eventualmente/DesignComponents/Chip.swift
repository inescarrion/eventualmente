import SwiftUI

enum ChipStyle {
    case primary
    case secondary
}

struct Chip: View {
    let text: String
    let symbolName: String
    let style: ChipStyle

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: symbolName)
            Text(text)
        }
        .fontWeight(.semibold)
        .foregroundStyle(style == .primary ? .white : .accent)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.accent.opacity(style == .primary ? 1 : 0.12))
        .cornerRadius(20)
    }
}

#Preview {
    Group {
        Chip(text: "Category", symbolName: "music.note", style: .primary)
        Chip(text: "Subcategory", symbolName: "music.note", style: .secondary)
    }
}
