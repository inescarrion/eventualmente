import SwiftUI

struct GroupDetailsView: View {
    @State private var vm: GroupDetailsViewModel
    @Binding var path: [Path]
    @Binding var group: PrivateGroup
    @State private var isUpdateGroupSheetPresented: Bool = false
    @State private var isDeleteGroupAlertPresented: Bool = false
    @State private var isAddMemberAlertPresented: Bool = false
    @State private var isDeleteMemberAlertPresented: Bool = false
    @State private var selectedMemberToDelete: UserData?

    init(group: Binding<PrivateGroup>, path: Binding<[Path]>) {
        self.vm = GroupDetailsViewModel(group: group)
        _path = path
        _group = group
    }

    var body: some View {
        List {
            Section("Nombre del grupo") {
                ListRowWithButton(text: group.name) {
                    isUpdateGroupSheetPresented = true
                }
            }

            Section("Miembros del grupo") {
                ForEach(vm.membersData, id: \.id) { member in
                    HStack {
                        Text("\(member.name)\(member.id == AppModel.userId ? " (Yo)" : "")")
                        Spacer()
                        Button {
                            selectedMemberToDelete = member
                            isDeleteMemberAlertPresented = true
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
                Button("+ Añadir nuevo miembro") {
                    isAddMemberAlertPresented = true
                }
            }

            Button {
                isDeleteGroupAlertPresented = true
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("Eliminar grupo")
                }
                .fontWeight(.semibold)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle("Detalles")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.fetchGroupMembers(group: group)
        }
        .sheet(isPresented: $isUpdateGroupSheetPresented) {
            GroupFormView(type: .update(group: $group))
        }
        .alert("¿Deseas eliminar el grupo?", isPresented: $isDeleteGroupAlertPresented) {
            Button("Cancelar", role: .cancel) {
                isDeleteGroupAlertPresented = false
            }
            Button("Eliminar", role: .destructive) {
                vm.deleteGroup(group: group)
                path.removeAll()
            }
        } message: {
            Text("Se eliminará de forma permanente")
        }
        .alert("Código de invitación:\n\(group.id!)", isPresented: $isAddMemberAlertPresented) {
            Button("Cancelar", role: .cancel) {
                isAddMemberAlertPresented = false
            }
            Button("Copiar código") {
                UIPasteboard.general.string = vm.group.wrappedValue.id!
            }
            .keyboardShortcut(.defaultAction)
        } message: {
            Text("Envía el código a las personas que quieras añadir al grupo")
        }
        .alert("¿Deseas eliminar a \(selectedMemberToDelete?.name ?? "un miembro") del grupo?",
               isPresented: $isDeleteMemberAlertPresented,
               presenting: selectedMemberToDelete) { member in
            Button("Cancelar", role: .cancel) {
                isDeleteMemberAlertPresented = false
            }
            Button("Eliminar", role: .destructive) {
                vm.deleteMember(member: member, group: $group)
                if member.id == AppModel.userId {
                    path.removeAll()
                }
            }
        } message: { _ in
            Text("Tendrá que volver a introducir el código para entrar al grupo de nuevo")
        }
    }
}

#Preview {
    GroupDetailsView(group: .constant(.init(name: "Nombre", membersIds: [])), path: .constant([]))
}
