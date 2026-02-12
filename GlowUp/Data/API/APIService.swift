
import Foundation

//уrror Handlin
enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingError
    case unknown
}

class APIService {
    
    // Singleton
    static let shared = APIService()
    private init() {}
    
   
    private let baseURL = "https://makeup-api.herokuapp.com/api/v1/products.json"
    
    // Функция загрузки продуктов (асинхронная)
    // brand: опциональный параметр, если хотим искать конкретный бренд
    // Мы изменили эту функцию: теперь можно искать либо по бренду (по умолчанию), либо по типу

    func fetchProducts(query: String, searchByType: Bool = false) async throws -> [Product] {
        
        // 1. Собираем URL
        var urlString = baseURL
        // Логика: если ищем по типу, используем ?product_type=, иначе ?brand=
               
        if searchByType {
            
            urlString += "?product_type=\(query)"
            
        } else {
            
            urlString += "?brand=\(query)"
            
        }
        guard let url = URL(string: urlString) else {
                    throw APIError.invalidURL
                }
        
        // 2. Делаем запрос (URLSession)
        // try await - ждем ответ от сервера, не блокируя интерфейс
        let (data, response) = try await URLSession.shared.data(from: url)
        

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.requestFailed
                }
        
        // 4. Декодируем JSON в массив Product
        do {
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    return products
        } catch {
            print("Decoding Error: \(error)")
            throw APIError.decodingError
        }
    }
}
