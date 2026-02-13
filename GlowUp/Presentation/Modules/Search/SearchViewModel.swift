

import Foundation
import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    

    @Published var searchText: String = ""
    @Published var searchResults: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedCategory: String? = nil
    
  
    private let apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>() 
    

    init() {

        $searchText
          
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
           
            .removeDuplicates()
           
            .sink { [weak self] text in
                guard let self = self else { return }
                
                if !text.isEmpty {
                   
                    self.selectedCategory = nil
                    self.performSearch(query: text, isCategory: false)
                }
            }
            .store(in: &cancellables)
    }
    

    func performSearch(query: String, isCategory: Bool) {
   
        guard !query.isEmpty else {
            self.searchResults = []
            self.errorMessage = nil
            return
        }
        
     
        self.isLoading = true
        self.errorMessage = nil
        self.searchResults = []
        
        Task {
            do {
                
                let products = try await apiService.fetchProducts(
                    query: query.lowercased(),
                    searchByType: isCategory
                )
                
                if products.isEmpty {
                    self.errorMessage = "Nothing found. Try another brand or category."
                } else {
                    self.searchResults = products
                }
                self.isLoading = false
            } catch {
               
                self.errorMessage = "Error loading products. Please try again."
                self.isLoading = false
            }
        }
    }
    
    func selectCategory(_ category: String) {
        self.searchText = "" // Очищаем текстовое поле поиска
        self.selectedCategory = category // Устанавливаем выбранную категорию (для подсветки)
        self.performSearch(query: category, isCategory: true) // Выполняем поиск по категории
    }
}

