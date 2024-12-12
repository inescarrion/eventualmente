import SwiftUI
import FirebaseFirestore

struct CreateEventView: View {
    @FirestoreQuery(collectionPath: "categories") var categories: [Category]
    @State private var title: String = ""
    @State private var selectedCategory: Category = .init(name: "", subcategories: [])
    @State private var selectedSubcategory: String = ""
    @State private var location: String = ""
    @State private var selectedDate: Date = .now
    @State private var link: String = ""
    @State private var moreInfo: String = ""

    var body: some View {
        List {
            Section("Título") {
                TextField("Introduce un título descriptivo", text: $title)
            }

            Section("Categoría") {
                Picker("Categoría", selection: $selectedCategory) {
                    Text("Selecciona una").tag(Category(name: "", subcategories: []))
                    ForEach(categories, id: \.id) { category in
                        Text(category.name).tag(category)
                    }
                }
                .pickerStyle(.navigationLink)
                Picker("Subcategoría", selection: $selectedSubcategory) {
                    Text("Ninguna").tag("")
                    ForEach(selectedCategory.subcategories, id: \.self) { subcategory in
                        Text(subcategory).tag(subcategory)
                    }
                }
                .pickerStyle(.navigationLink)
            }

            Section("Ubicación") {
                TextField("Nombre de la ciudad o pueblo", text: $location)
            }

            Section("Fecha") {
                DatePicker("Día", selection: $selectedDate, displayedComponents: .date)
                DatePicker("Hora", selection: $selectedDate, displayedComponents: .hourAndMinute)
            }

            Section("Más información") {
                TextField("Enlace a más información", text: $link)
                TextField("Descripción del evento o cualquier información relevante", text: $moreInfo, axis: .vertical)
                    .lineLimit(4...)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Crear") {}
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") {}
            }
        }
        .navigationTitle("Crear nuevo evento")
        .toolbarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    @Previewable @State var isSheetPresented: Bool = false

    Button("Crear evento") {
        isSheetPresented.toggle()
    }.sheet(isPresented: $isSheetPresented) {
        NavigationStack {
            CreateEventView()
        }
    }
}
