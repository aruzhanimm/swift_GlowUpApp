
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
            
            guard let priceString = price,
                  let priceDouble = Double(priceString) else {
                return "₸ --"
            }
            
          
            let exchangeRate = 510.0
            
          
            let tengePrice = priceDouble * exchangeRate
            
          
            return String(format: "₸ %.0f", tengePrice)
        }
 
    var imageURL: URL? {
        guard let link = image_link else { return nil }
        return URL(string: link)
    }
}
