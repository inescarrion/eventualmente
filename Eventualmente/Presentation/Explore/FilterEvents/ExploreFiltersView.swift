import SwiftUI
import FirebaseFirestore

struct ExploreFiltersView: View {
    @Environment(\.dismiss) var dismiss
    @FirestoreQuery(collectionPath: "categories", predicates: [.orderBy("name", false)]) var categories: [Category]
    @Environment(ExploreViewModel.self) var vm: ExploreViewModel

    var body: some View {
        @Bindable var vm = vm
        List {
            Section("Categorías y subcategorías") {
                categoriesAndSubcategoriesList
            }

            Section("Fecha") {
                DatePicker("Desde", selection: $vm.startDate, in: Date()..., displayedComponents: .date)
                endDatePicker
            }
            .listRowBackground(Color.white)
            .animation(.easeInOut(duration: 0.2), value: vm.isEndDateSelected)

            Section("Ubicación") {
                TextField("Nombre de la ciudad o pueblo", text: $vm.location)
                    .lineLimit(1)
                    .autocorrectionDisabled(true)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Aplicar") {
                    vm.addFilterPredicates()
                    dismiss()
                }
                .fontWeight(.semibold)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Borrar") {
                    vm.clearFilters()
                    dismiss()
                }
            }
        }
        .navigationTitle("Filtrar eventos")
        .toolbarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onChange(of: categories) { _, newValue in
            if vm.categoriesListRows.isEmpty {
                for category in newValue {
                    vm.categoriesListRows.append(
                        CategoryRow(isSelected: false, name: category.name, isSubcategory: false, subcategories: category.subcategories)
                    )
                }
            }
        }
        .onChange(of: vm.endDate) { _, newValue in
            if newValue.startOfTheDay != .now.startOfTheDay {
                vm.isEndDateSelected = true
            }
        }
    }
}

// Subviews
extension ExploreFiltersView {
    var categoriesAndSubcategoriesList: some View {
        @Bindable var vm = vm
        return ForEach($vm.categoriesListRows, id: \.self) { $categoryRow in
            HStack {
                Image(systemName: categoryRow.isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(.accent)
                VStack(alignment: .leading) {
                    Text(categoryRow.name)
                }
                Spacer()
                Button {
                    var index: Int = vm.categoriesListRows.firstIndex(of: categoryRow) ?? 0
                    if categoryRow.isExpanded {
                        // Hide subcategories
                        while vm.categoriesListRows[index+1].isSubcategory {
                            vm.categoriesListRows.remove(at: index+1)
                        }
                    } else {
                        // Show subcategories
                        for subcategory in categoryRow.subcategories {
                            index += 1
                            let isSelected = vm.selectedSubcategories.contains(subcategory)
                            vm.categoriesListRows.insert(
                                .init(
                                    isSelected: isSelected,
                                    name: subcategory,
                                    isSubcategory: true,
                                    subcategories: []
                                ),
                                at: index)
                        }
                    }
                    categoryRow.isExpanded.toggle()
                } label: {
                    Image(systemName: categoryRow.isExpanded ? "chevron.up" : "chevron.down")
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderless)
                .frame(maxHeight: .infinity)
                .opacity(categoryRow.subcategories.isEmpty ? 0 : 1)
            }
            .padding(.leading, categoryRow.isSubcategory ? 30 : 0)
            .contentShape(Rectangle())
            .onTapGesture {
                categoryRow.isSelected.toggle()
                if categoryRow.isSelected {
                    if categoryRow.isSubcategory {
                        vm.selectedSubcategories.insert(categoryRow.name)
                    } else {
                        vm.selectedCategoriesNames.insert(categoryRow.name)
                    }
                } else {
                    if categoryRow.isSubcategory {
                        vm.selectedSubcategories.remove(categoryRow.name)
                    } else {
                        vm.selectedCategoriesNames.remove(categoryRow.name)
                    }
                }
            }
        }
    }

    var endDatePicker: some View {
        @Bindable var vm = vm
        return HStack {
            Text("Hasta")
            Spacer()
            if vm.isEndDateSelected {
                clearDateButton
            }
            DatePicker("",
                selection: $vm.endDate,
                in: Calendar.current.date(byAdding: .day, value: 1, to: vm.startDate)!...,
                displayedComponents: .date
            )
            .labelsHidden()
            .overlay(alignment: .trailing) {
                addEndDateOverlay
            }
        }
    }

    var addEndDateOverlay: some View {
        Text("Añadir fecha")
            .bold()
            .fixedSize()
            .padding(8)
            .foregroundStyle(.accent)
            .background(.background)
            .clipShape(.rect(cornerRadius: 8))
            .allowsHitTesting(false)
            .opacity(vm.isEndDateSelected ? 0 : 1)
    }

    var clearDateButton: some View {
        Button {
            vm.endDate = .now
            vm.isEndDateSelected = false
        } label: {
            Image(systemName: "minus.circle.fill")
                .symbolRenderingMode(.hierarchical)
        }
    }
}

#Preview {
    ExploreFiltersView()
        .environment(ExploreViewModel())
        .tint(.accent)
}
