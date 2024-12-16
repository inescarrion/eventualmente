import SwiftUI

struct GroupFormView: View {
    @Environment(\.dismiss) var dismiss
    @State private var vm: GroupFormViewModel

    init(type: GroupFormType) {
        self.vm = GroupFormViewModel(type: type)
    }

    var body: some View {
        @Bindable var vm = vm
        NavigationStack {
            List {
                Section("Nombre del grupo") {
                    TextField("Introduce un nombre", text: $vm.newGroupName)
                        .autocorrectionDisabled(true)
                }
            }
            .navigationTitle(vm.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(vm.confirmButtonText) {
                        Task {
                            await vm.createOrUpdateGroup()
                            dismiss()
                        }
                    }
                    .disabled(vm.newGroupName.isEmptyOrWhitespace)
                }
            }
        }
        .presentationDetents([.fraction(0.25)])
    }
}

#Preview {
    GroupFormView(type: .create)
}
