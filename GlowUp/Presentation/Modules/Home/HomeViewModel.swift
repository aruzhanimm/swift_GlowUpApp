//
//  HomeViewModel.swift
//  GlowUp
//
//  Created by Аружан Картам on 10.02.2026.
//

import Foundation
import SwiftUI
import Combine

// @MainActor гарантирует, что обновление интерфейса будет на главном потоке
@MainActor
class HomeViewModel: ObservableObject {
    
    // Published свойства - когда они меняются, экран автоматически обновляется
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let apiService = APIService.shared
    
    // Функция загрузки данных
    func loadProducts() {
        self.isLoading = true
        self.errorMessage = nil
        
        Task { // Запускаем асинхронную задачу
            do {
                // Пытаемся скачать косметику бренда Maybelline (для теста, там хорошие картинки)
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
