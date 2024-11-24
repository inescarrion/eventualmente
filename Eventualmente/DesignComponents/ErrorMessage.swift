//
//  ErrorMessage.swift
//  Eventualmente
//
//  Created by Inés Carrión on 24/11/24.
//

import SwiftUI

struct ErrorMessage: View {
    let text: String
    let isVisible: Bool

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "exclamationmark.circle")
            Text(text)
                .padding(.top, 2)
                .font(.footnote)
                .lineLimit(2)
        }
        .foregroundStyle(.red)
        .padding(.top, 0.5)
        .padding(.bottom, 5)
        .opacity(isVisible ? 1 : 0)
    }
}

#Preview {
    ErrorMessage(text: "Este es un mensaje de error de una línea", isVisible: true)
    ErrorMessage(text: "Este es un mensaje de error muy largo que ocupa más de una línea", isVisible: true)
}
