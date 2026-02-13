
import Foundation

//уrror Handlin
enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingError
    case unknown
}

class APIService {
    

    static let shared = APIService()
    private init() {}
    
   
    private let baseURL = "https://makeup-api.herokuapp.com/api/v1/products.json"
    

    func fetchProducts(query: String, searchByType: Bool = false) async throws -> [Product] {
        
      
        var urlString = baseURL
     
        if searchByType {
            
            urlString += "?product_type=\(query)"
            
        } else {
            
            urlString += "?brand=\(query)"
            
        }
        guard let url = URL(string: urlString) else {
                    throw APIError.invalidURL
                }
        
       
        let (data, response) = try await URLSession.shared.data(from: url)
        

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.requestFailed
                }
        
        
        do {
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    return products
        } catch {
            print("Decoding Error: \(error)")
            throw APIError.decodingError
        }
    }
}
