//
//  CustomButton.swift
//  Eventualmente
//
//  Created by Inés Carrión on 22/11/24.
//

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

#Preview {
    VStack {
        CustomPrimaryButton("Primary button") {
            print("Primary button tapped")
        }
        CustomSecondaryButton("Secondary button") {
            print("Secondary button tapped")
        }
    }
}
