
import SwiftUI

// Это расширение (Extension) позволяет нам обращаться к цветам через Color.brandBlack
// Мы не пишем hex-коды каждый раз, мы используем названия.
extension Color {
    
    // Глубокий черный фон (не совсем #000000, чуть мягче для глаз, как в премиум аппах)
    static let backgroundDark = Color(hex: "0A0A0A")
    
    // Вторичный фон (для карточек товаров)
    static let cardDark = Color(hex: "1C1C1E")
    
    // Твой акцентный неоново-розовый
    static let neonPink = Color(hex: "FF00CC")
    
    // Лавандовый акцент
    static let neonLavender = Color(hex: "B98EFF")
    
    // Белый текст (с легкой прозрачностью, чтобы не резало глаза)
    static let textPrimary = Color.white
    static let textSecondary = Color.gray
}

// Вспомогательный код, чтобы Swift понимал HEX коды (вроде #FFFFFF)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
