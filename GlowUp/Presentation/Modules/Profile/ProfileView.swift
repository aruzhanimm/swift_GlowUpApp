import SwiftUI
import Kingfisher
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Состояния для редактирования
    @State private var isEditing: Bool = false
    @State private var editedName: String = ""
    @State private var editedPhotoURL: String = ""
    
    // Состояние для алерта удаления
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // --- 1. Аватарка ---
                        if !authViewModel.userPhotoURL.isEmpty, let url = URL(string: authViewModel.userPhotoURL) {
                            KFImage(url)
                                .placeholder {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(.gray)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.neonPink, lineWidth: 2))
                                .padding(.top, 50)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                                .padding(.top, 50)
                        }
                        
                        // --- 2. Информация / Редактирование ---
                        if isEditing {
                            VStack(spacing: 15) {
                                TextField("Enter Nickname", text: $editedName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                                
                                TextField("Enter Photo URL", text: $editedPhotoURL)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                                    .autocapitalization(.none)
                                
                                HStack {
                                    Button("Cancel") {
                                        withAnimation { isEditing = false }
                                    }
                                    .foregroundColor(.gray)
                                    .padding()
                                    
                                    Button("Save Changes") {
                                        authViewModel.updateProfile(name: editedName, photoURLString: editedPhotoURL)
                                        withAnimation { isEditing = false }
                                    }
                                    .foregroundColor(.neonPink)
                                    .fontWeight(.bold)
                                    .padding()
                                }
                            }
                        } else {
                            VStack(spacing: 10) {
                                Text(authViewModel.userName.isEmpty ? "No Name" : authViewModel.userName)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text(Auth.auth().currentUser?.email ?? "No Email")
                                    .foregroundColor(.gray)
                                
                                Button(action: {
                                    // Включаем режим редактирования
                                    editedName = authViewModel.userName
                                    editedPhotoURL = authViewModel.userPhotoURL
                                    withAnimation { isEditing = true }
                                }) {
                                    Text("Edit Profile")
                                        .font(.subheadline)
                                        .foregroundColor(.neonPink)
                                        .padding(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.neonPink, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        
                        Divider().background(Color.gray)
                        
                        // --- 3. Меню действий ---
                        VStack(spacing: 0) {
                            // Кнопка выхода
                            Button(action: {
                                authViewModel.signOut()
                            }) {
                                HStack {
                                    Text("Sign Out")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Image(systemName: "arrow.right.square")
                                }
                                .padding()
                                .foregroundColor(.white)
                            }
                            
                            Divider().background(Color.gray.opacity(0.3))
                            
                            // Кнопка удаления (ОПАСНАЯ ЗОНА)
                            Button(action: {
                                showDeleteAlert = true
                            }) {
                                HStack {
                                    Text("Delete Account")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Image(systemName: "trash")
                                }
                                .padding()
                                .foregroundColor(.red)
                            }
                        }
                        .background(Color.cardDark)
                        .cornerRadius(15)
                        .padding()
                        
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Account?"),
                    message: Text("This action cannot be undone. You will lose all your data."),
                    primaryButton: .destructive(Text("Delete")) {
                        authViewModel.deleteAccount()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
