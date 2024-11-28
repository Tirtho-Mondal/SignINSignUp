import SwiftUI
import Firebase
import FirebaseAuth

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
    @Binding var userIsLoggedIn: Bool

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .gray]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                List(dataManager.dogs, id: \.id) { dog in
                    HStack {
                        Text(dog.breed)
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.3)))
                    }
                }
                .navigationTitle("Dogs")
                .navigationBarItems(trailing: Button(action: {
                    showPopup.toggle()
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }))
                .navigationBarItems(trailing: Button(action: {
                    logout()
                }, label: {
                    Text("Logout")
                        .font(.title2)
                        .foregroundColor(.black)
                }))
                .sheet(isPresented: $showPopup) {
                    NewDogView()
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            userIsLoggedIn = false
            print("User logged out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(userIsLoggedIn: .constant(true)).environmentObject(DataManager())
    }
}
