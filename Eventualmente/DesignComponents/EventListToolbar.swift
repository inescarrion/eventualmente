//
//  TabToolbar.swift
//  Eventualmente
//
//  Created by Inés Carrión on 2/12/24.
//

import SwiftUI

struct EventListToolbar<Picker: View>: ToolbarContent{
    let title: String
    let sortMenuPicker: () -> Picker
    let filterButtonAction: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text(title.coloredFirstLetter)
                .font(.customTitle1)
                .padding(.leading, 4)
        }

        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                sortMenuPicker()
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
