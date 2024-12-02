//
//  TabToolbar.swift
//  Eventualmente
//
//  Created by Inés Carrión on 2/12/24.
//

import SwiftUI

struct EventListToolbar: ToolbarContent {
    let title: String
    let sortButtonAction: () -> Void
    let filterButtonAction: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text(title.coloredFirstLetter)
                .font(.customTitle1)
                .padding(.leading, 4)
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                sortButtonAction()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Ordenar")
                }
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                filterButtonAction()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "line.3.horizontal.decrease")
                    Text("Filtrar")
                }
            }
        }
    }
}
