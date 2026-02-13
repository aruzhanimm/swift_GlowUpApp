import SwiftUI
import FirebaseCore
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    print("Firebase Configured!")
    return true
  }
}

@main
struct GlowUpApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared
    

    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
         
            LaunchScreenView()
              
                .environmentObject(authViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
