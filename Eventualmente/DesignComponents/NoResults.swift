//
//  NoResults.swift
//  Eventualmente
//
//  Created by Inés Carrión on 3/12/24.
//

import SwiftUI

struct NoResults: View {
    let message: String
    var body: some View {
        VStack {
            Image("NoResults")
            Text(message)
                .fontWeight(.semibold)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NoResults(message: "No se ha encontrado ningún evento")
}
