import SwiftUI

struct ExploreToolbarContent<Picker: View>: ToolbarContent{
    let sortMenuPicker: () -> Picker
    let filterButtonAction: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Explorar".coloredFirstLetter)
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

        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button("Todos") {}
                    .bold()
                Button("Favoritos") {}
                    .foregroundStyle(.gray)
                Button("Mis eventos") {}
                    .foregroundStyle(.gray)
                Button("Crear", systemImage: "plus") {}
                    .buttonStyle(.borderedProminent)
                    .padding(.leading)
            }
        }
    }
}
