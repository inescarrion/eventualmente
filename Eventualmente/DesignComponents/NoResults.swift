import SwiftUI

struct NoResults: View {
    let message: String
    var body: some View {
        VStack {
            Image("NoResults")
            Text(message)
                .fontWeight(.semibold)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NoResults(message: "No se ha encontrado ningún evento")
}
