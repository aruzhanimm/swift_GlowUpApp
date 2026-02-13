

import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
   
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let apiService = APIService.shared
    
 
    func loadProducts() {
        self.isLoading = true
        self.errorMessage = nil
        
        Task {
            do {
               
                let fetchedProducts = try await apiService.fetchProducts(query: "maybelline")
                self.products = fetchedProducts
                self.isLoading = false
            } catch {
                self.errorMessage = "Failed to load products: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
