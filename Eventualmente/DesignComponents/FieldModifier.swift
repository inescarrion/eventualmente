//
//  Watermark.swift
//  Eventualmente
//
//  Created by Inés Carrión on 24/11/24.
//

import SwiftUI

struct FieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
    }
}

extension View {
    func customField() -> some View {
        modifier(FieldModifier())
    }
}
