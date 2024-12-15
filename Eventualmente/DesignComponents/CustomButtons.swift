import SwiftUI

struct CustomPrimaryButton: View {
    let label: String
    let action: () -> Void

    init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .padding(.vertical, 8)
                .bold()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct CustomSecondaryButton: View {
    let label: String
    let action: () -> Void

    init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .padding(.vertical, 14)
                .bold()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderless)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(.accent, lineWidth: 2)
        )
    }
}

struct NavigationButtonLabel: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            CustomPrimaryButton("Primary button") {
                print("Primary button tapped")
            }
            CustomSecondaryButton("Secondary button") {
                print("Secondary button tapped")
            }
        }
        .toolbar {
            Button {} label: { NavigationButtonLabel(icon: "arrow.up.arrow.down", text: "Ordenar") }
        }
    }
    .tint(.accent)
}
