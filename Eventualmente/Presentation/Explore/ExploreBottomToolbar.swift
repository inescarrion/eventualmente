import SwiftUI

struct ExploreBottomToolbar: ToolbarContent {
    let vm: ExploreViewModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                ForEach(ToolbarSubsections.allCases, id: \.rawValue) { subsection in
                    Button(subsection.rawValue) {
                        switch subsection {
                        case .allEvents:
                            vm.selectedSubsection = .allEvents
                            vm.subsectionPredicates = []
                        case .favorites:
                            vm.selectedSubsection = .favorites
                            vm.subsectionPredicates = [.where("usersFavourite", arrayContainsAny: [AppModel.userId])]
                        case .myEvents:
                            vm.selectedSubsection = .myEvents
                            vm.subsectionPredicates = [.where("userId", isEqualTo: AppModel.userId)]
                        }
                    }
                    .foregroundStyle(vm.selectedSubsection == subsection ? .accent : .gray)
                    .fontWeight(vm.selectedSubsection == subsection ? .bold : .regular)
                }

                Button("Crear", systemImage: "plus") {
                    vm.isCreatingEvent = true
                }
                .buttonStyle(.borderedProminent)
                .padding(.leading)
            }
            .padding(.bottom, 5)
        }
    }
}

#Preview {
    EmptyView()
        .toolbar {
            ExploreBottomToolbar(vm: ExploreViewModel())
        }
}
