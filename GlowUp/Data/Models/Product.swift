
import Foundation

// Codable: Позволяет превращать JSON из интернета в этот Swift-класс и обратно.
// Identifiable: Позволяет использовать этот объект в списках SwiftUI (List/ForEach).

struct Product: Codable, Identifiable {
    let id: Int
        let brand: String?
        let name: String
        let price: String?
        let image_link: String?
        let description: String?
        let product_type: String?
        let rating: Double?
    
    var priceInTenge: String {
            // 1. Проверяем, есть ли цена вообще
            guard let priceString = price,
                  let priceDouble = Double(priceString) else {
                return "₸ --"
            }
            
            // 2. Хардкодим курс (для учебного проекта это ОК, можно сказать "Mock Exchange Rate")
            let exchangeRate = 510.0
            
            // 3. Считаем
            let tengePrice = priceDouble * exchangeRate
            
            // 4. Форматируем: убираем копейки (%.0f) и добавляем знак тенге
            return String(format: "₸ %.0f", tengePrice)
        }
    // Безопасная ссылка на картинку (иногда API присылает кривые ссылки)
    var imageURL: URL? {
        guard let link = image_link else { return nil }
        return URL(string: link)
    }
}
