import SwiftUI
import FirebaseCore
import CoreData

// Создаем класс-делегат для настройки Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    // Используем dprint (если создала Logger) или print
    print("Firebase Configured!")
    return true
  }
}

@main
struct GlowUpApp: App {
    // Подключаем делегат
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared
    
    // ViewModel для проверки авторизации
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            // 1. Запускаем СРАЗУ экран заставки
            LaunchScreenView()
                // 2. Передаем все настройки внутрь
                .environmentObject(authViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
