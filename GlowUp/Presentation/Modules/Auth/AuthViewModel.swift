import Foundation
import FirebaseAuth
import FirebaseCrashlytics
import FirebaseAnalytics
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    
    @Published var userName: String = ""
    @Published var userPhotoURL: String = ""
    
    init() {
      
        if let user = Auth.auth().currentUser {
            self.isUserLoggedIn = true
            self.userName = user.displayName ?? "No Name"
            self.userPhotoURL = user.photoURL?.absoluteString ?? ""
            
           
            Analytics.logEvent("session_start_auto", parameters: nil)
        }
    }
    
  
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                self.handleError(error, context: "Login")
            } else {
                print("User logged in: \(result?.user.uid ?? "")")
                self.isUserLoggedIn = true
                self.fetchUserInfo()
                
            
                Analytics.logEvent(AnalyticsEventLogin, parameters: [
                    AnalyticsParameterMethod: "email"
                ])
            }
        }
    }
  
    func signUp(email: String, password: String) {
        guard password.count >= 6 else {
            self.errorMessage = "Password must be at least 6 characters"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                self.handleError(error, context: "SignUp")
            } else {
                print("User registered: \(result?.user.uid ?? "")")
                self.isUserLoggedIn = true
                self.fetchUserInfo()
                
                // Логируем регистрацию
                Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                    AnalyticsParameterMethod: "email"
                ])
            }
        }
    }
    
  
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isUserLoggedIn = false
            self.userName = ""
            self.userPhotoURL = ""
        } catch {
            self.handleError(error, context: "SignOut")
        }
    }
    
  
    func updateProfile(name: String, photoURLString: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        isLoading = true
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        
      
        if !photoURLString.isEmpty {
            changeRequest.photoURL = URL(string: photoURLString)
        }
        
        changeRequest.commitChanges { error in
            self.isLoading = false
            if let error = error {
                self.handleError(error, context: "UpdateProfile")
            } else {
                
                self.userName = name
                self.userPhotoURL = photoURLString
                
                // Логируем обновление профиля
                Analytics.logEvent("profile_updated", parameters: nil)
            }
        }
    }
    
  
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        isLoading = true
        
        user.delete { error in
            self.isLoading = false
            if let error = error {
                
                self.handleError(error, context: "DeleteAccount")
                self.errorMessage = "Please log out and log in again to delete account."
            } else {
                self.isUserLoggedIn = false
                Analytics.logEvent("account_deleted", parameters: nil)
            }
        }
    }

    private func fetchUserInfo() {
        if let user = Auth.auth().currentUser {
            self.userName = user.displayName ?? ""
            self.userPhotoURL = user.photoURL?.absoluteString ?? ""
        }
    }
    

    private func handleError(_ error: Error, context: String) {
        self.errorMessage = error.localizedDescription
        
     
        Crashlytics.crashlytics().record(error: error)
        

        print(" ERROR [\(context)]: \(error.localizedDescription)")
    }
}

