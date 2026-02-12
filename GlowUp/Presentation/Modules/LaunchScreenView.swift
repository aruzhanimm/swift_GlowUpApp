import SwiftUI

struct LaunchScreenView: View {
    // 1. Получаем доступ к AuthViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            // 2. Логика маршрутизации ПОСЛЕ заставки
            if authViewModel.isUserLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        } else {
            // ЭКРАН ЗАСТАВКИ (Анимация)
            ZStack {
                Color.backgroundDark.ignoresSafeArea()
                
                VStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 80))
                        .foregroundColor(.neonPink)
                    
                    Text("GlowUp")
                        .font(.custom("Baskerville-Bold", size: 40))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                // Ждем 2 секунды и переключаем
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
