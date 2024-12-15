import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(GroupsViewModel.self) var vm: GroupsViewModel

    var body: some View {
        @Bindable var vm = vm
        NavigationStack {
            List {
                Section("Nombre del grupo") {
                    TextField("Introduce un nombre", text: $vm.newGroupName)
                }
            }
            .navigationTitle("Crear nuevo grupo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Crear") {
                        vm.createGroup()
                        dismiss()
                    }
                    .disabled(vm.newGroupName.isEmptyOrWhitespace)
                }
            }
        }
        .presentationDetents([.fraction(0.25)])
    }
}

#Preview {
    CreateGroupView()
}
