import SwiftUI
import FirebaseFirestore

struct CreateEventView: View {
    @Environment(\.dismiss) var dismiss
    @FirestoreQuery(collectionPath: "categories") var categories: [Category]
    @State private var vm: CreateEventViewModel

    init(userId: String, groupId: String) {
        vm = CreateEventViewModel(userId: userId, groupId: groupId)
    }

    var body: some View {
        List {
            Section("Título") {
                TextField("Introduce un título descriptivo", text: $vm.title)
            }

            Section("Categoría") {
                categoryPicker
                subcategoryPicker
            }

            Section("Ubicación") {
                TextField("Nombre de la ciudad o pueblo", text: $vm.location)
            }

            Section("Fecha") {
                dateHourPickers
            }

            Section("Más información") {
                TextField("Enlace a más información", text: $vm.link)
                TextField("Descripción del evento o cualquier información relevante", text: $vm.moreInfo, axis: .vertical)
                    .lineLimit(4...)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Crear") {
                    vm.createEvent()
                    dismiss()
                }
                .fontWeight(.semibold)
                .disabled(!vm.isFormValid)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") {
                    // TODO: reset fields?
                    dismiss()
                }
            }
        }
        .navigationTitle("Crear nuevo evento")
        .toolbarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

// Subviews
extension CreateEventView {
    var categoryPicker: some View {
        Picker("Categoría", selection: $vm.selectedCategory) {
            Text("Selecciona una").tag(Category(name: "", subcategories: []))
            ForEach(categories, id: \.id) { category in
                Text(category.name).tag(category)
            }
        }
        .pickerStyle(.navigationLink)
    }

    var subcategoryPicker: some View {
        Picker("Subcategoría", selection: $vm.selectedSubcategory) {
            Text("Ninguna").tag("")
            ForEach(vm.selectedCategory.subcategories, id: \.self) { subcategory in
                Text(subcategory).tag(subcategory)
            }
        }
        .pickerStyle(.navigationLink)
    }

    var dateHourPickers: some View {
        Group {
            DatePicker("Día", selection: $vm.selectedDate, displayedComponents: .date)
            DatePicker("Hora", selection: $vm.selectedDate, displayedComponents: .hourAndMinute)
        }
    }
}

#Preview {
    @Previewable @State var isSheetPresented: Bool = false

    Button("Crear evento") {
        isSheetPresented.toggle()
    }.sheet(isPresented: $isSheetPresented) {
        NavigationStack {
            CreateEventView(userId: "", groupId: "")
        }
    }
}
