import SwiftUI

struct NoResults: View {
    let message: String
    var body: some View {
        VStack {
            Image("NoResults")
            Text(message)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 50)
    }
}

#Preview {
    NoResults(message: "No se ha encontrado ningún evento, prueba a crear uno.")
}
