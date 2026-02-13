
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUpMode = false
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
           
            Circle()
                .fill(Color.neonPink.opacity(0.2))
                .frame(width: 200, height: 200)
                .offset(x: -100, y: -200)
                .blur(radius: 50)
            
            Circle()
                .fill(Color.neonLavender.opacity(0.2))
                .frame(width: 200, height: 200)
                .offset(x: 100, y: 200)
                .blur(radius: 50)
            
            VStack(spacing: 20) {
                Text(isSignUpMode ? "Create Account" : "Welcome Back")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                
                CustomTextField(icon: "envelope", placeholder: "Email", text: $email)
                
                
                CustomTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    if isSignUpMode {
                        viewModel.signUp(email: email, password: password)
                    } else {
                        viewModel.login(email: email, password: password)
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Text(isSignUpMode ? "Sign Up" : "Log In")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.neonPink)
                .foregroundColor(.black)
                .cornerRadius(15)
                .shadow(color: .neonPink.opacity(0.5), radius: 10, x: 0, y: 5)
                .padding(.top, 10)
                
               
                Button(action: {
                    withAnimation {
                        isSignUpMode.toggle()
                        viewModel.errorMessage = nil
                    }
                }) {
                    Text(isSignUpMode ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            .padding(30)
        }
    }
}

struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
        }
        .padding()
        .background(Color.cardDark)
        .cornerRadius(15)
        .foregroundColor(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
