import SwiftUI

struct EventDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var vm: EventDetailViewModel
    @State private var isDeleteAlertPresented: Bool = false
    @State private var isUpdateSheetPresented: Bool = false

    init(event: Event) {
        self.vm = EventDetailViewModel(event: event)
    }

    var body: some View {
        List {
            if !vm.event.categoryName.isEmpty {
                Section("CATEGORÍA Y SUBCATEGORÍA") {
                    HStack(spacing: 14) {
                        Chip(text: vm.event.categoryName, symbolName: vm.event.categorySymbol, style: .primary)
                        if !vm.event.subcategoryName.isEmpty {
                            Chip(text: vm.event.subcategoryName, symbolName: vm.event.categorySymbol, style: .secondary)
                        }
                    }
                }
                .listRowSeparator(.hidden, edges: .bottom)
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    return 0
                }
            }

            if !vm.event.location.isEmpty {
                Section("UBICACIÓN") {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(vm.event.location)
                    }
                }
                .listRowSeparator(.hidden, edges: .bottom)
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    return 0
                }
            }

            Section("FECHA Y HORA") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        Text(vm.event.date.dateValue().formatted(date: .numeric, time: .omitted))
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(vm.event.date.dateValue().formatted(date: .omitted, time: .shortened))
                    }
                }
            }
            .listRowSeparator(.hidden, edges: .bottom)
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                return 0
            }

            if !vm.event.link.isEmpty {
                Section("ENLACE") {
                    Link(vm.event.link, destination: URL(string: vm.event.link)!)
                        .foregroundStyle(.accent)
                        .underline()
                }
                .listRowSeparator(.hidden, edges: .bottom)
            }

            if !vm.event.moreInfo.isEmpty {
                Section("MÁS INFORMACIÓN") {
                    Text(vm.event.moreInfo)
                        .multilineTextAlignment(.leading)
                }
                .listRowSeparator(.hidden, edges: .bottom)
            }
        }
        .navigationTitle(vm.event.title)
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if vm.isAuthor, !vm.event.isPublic {
                    HStack {
                        Button {
                            isUpdateSheetPresented = true
                        } label: {
                            NavigationButtonLabel(icon: "pencil", text: "Editar")
                        }
                        Button {
                            isDeleteAlertPresented = true
                        } label: {
                            NavigationButtonLabel(icon: "trash", text: "Eliminar")
                        }
                    }
                } else {
                    Button {
                        vm.updateFavourite()
                    } label: {
                        NavigationButtonLabel(
                            icon: vm.isFavourite ? "heart.fill" : "heart",
                            text: vm.isFavourite ? "Eliminar de favoritos" : "Añadir a favoritos")
                    }
                }
            }
        }
        .animation(.none, value: vm.isFavourite)
        .sheet(isPresented: $isUpdateSheetPresented) {
            EventFormView(type: .update(event: vm.event), isPublic: vm.event.isPublic)
        }
        .onChange(of: isUpdateSheetPresented) { _, isPresented in
            if !isPresented, let id = vm.event.id {
                vm.fetchUpdatedEvent(id: id)
            }
        }
        .alert("¿Deseas eliminar el evento?", isPresented: $isDeleteAlertPresented) {
            Button("Cancelar", role: .cancel) {
                isDeleteAlertPresented = false
            }
            Button("Eliminar", role: .destructive) {
                vm.deleteEvent()
                dismiss()
            }
        } message: {
            Text("Se eliminará de forma permanente")
        }
    }
}

#Preview {
    NavigationStack {
        EventDetailView(event: .init(userId: "", groupId: "", usersFavourite: [], title: "Título del evento",
            categoryName: "Categoría", categorySymbol: "music.note", subcategoryName: "Subcategoría", location: "Ubicación",
                                     date: .init(), link: "example.com", moreInfo: "Esta es una breve descripción del evento."))
    }
    .tint(.accent)
}
