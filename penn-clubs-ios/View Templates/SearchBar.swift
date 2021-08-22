import SwiftUI
 
// TODO: Must Refactor to remove strange background view initializer
struct SearchBar<BackgroundView>: View where BackgroundView: View {
    @Binding var text: String
    @State private var isEditing = false
    var cancelButtonExists: Bool
    let background: () -> BackgroundView
 
    var body: some View {
        HStack(spacing: 0) {
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.leading, 27)
                .background(background())
                .cornerRadius(8)
                .overlay(searchOverlay)
                .onTapGesture {
                    self.isEditing = true
                }
                .animation(.default)

            if isEditing && cancelButtonExists {
                Spacer()
                
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
    }
    
    var searchOverlay: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)

            Spacer()

            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
            .opacity(isEditing ? 1 : 0)
            .animation(.default)
        }
    }
}
