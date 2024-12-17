import SwiftUI
import FirebaseFirestore

struct EventFormView: View {
    @Environment(\.dismiss) var dismiss
    @FirestoreQuery(collectionPath: "categories") var categories: [Category]
    @State private var vm: EventFormViewModel
    let isPublic: Bool

    init(type: EventFormType, isPublic: Bool) {
        vm = EventFormViewModel(type: type)
        self.isPublic = isPublic
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Título") {
                    TextField("Introduce un título descriptivo", text: $vm.title)
                        .autocorrectionDisabled(true)
                }

                Section("Categoría\(isPublic ? "" : " (OPCIONAL)")") {
                    categoryPicker
                    subcategoryPicker
                }

                Section("Ubicación\(isPublic ? "" : " (OPCIONAL)")") {
                    TextField("Nombre de la ciudad o pueblo", text: $vm.location)
                        .autocorrectionDisabled(true)
                }

                Section("Fecha") {
                    dateHourPickers
                }

                Section("Más información\(isPublic ? "" : " (OPCIONAL)")") {
                    TextField("Enlace a más información", text: $vm.link)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    TextField("Descripción del evento o cualquier información relevante", text: $vm.moreInfo, axis: .vertical)
                        .lineLimit(4...)
                        .autocorrectionDisabled(true)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(vm.confirmButtonLabel) {
                        vm.createOrUpdateEvent()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!vm.isFormValid)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .navigationTitle(vm.formTitle)
            .toolbarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onChange(of: categories) { _, _ in
                if case .update(let event) = vm.type {
                    if let selectedCategory = categories.first(where: { $0.name == event.categoryName }) {
                        vm.selectedCategory = selectedCategory
                    }
                }
            }
        }
    }
}

// Subviews
extension EventFormView {
    var categoryPicker: some View {
        Picker("Categoría", selection: $vm.selectedCategory) {
            Text("Selecciona una").tag(Category(name: "", symbolName: "", subcategories: []))
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
            EventFormView(type: .create(userId: "", groupId: ""), isPublic: true)
        }
    }
}
