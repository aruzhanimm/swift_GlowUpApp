//  SearchViewModel.swift
//  GlowUp
//
//  Created by Аружан Картам on 10.02.2026.
//

import Foundation
import SwiftUI
import Combine // Обязательно для debounce и реактивного программирования

@MainActor
class SearchViewModel: ObservableObject {
    
    // MARK: - Published Properties (Изменяемые данные для View)
    @Published var searchText: String = "" // Текст из поисковой строки
    @Published var searchResults: [Product] = [] // Массив найденных продуктов
    @Published var isLoading: Bool = false // Флаг загрузки для показа индикатора
    @Published var errorMessage: String? = nil // Сообщение об ошибке (nil если ошибки нет)
    @Published var selectedCategory: String? = nil // Выбранная категория для подсветки кнопки
    
    // MARK: - Private Properties
    private let apiService = APIService.shared // Общий экземпляр API сервиса
    private var cancellables = Set<AnyCancellable>() // Коллекция подписок для управления жизненным циклом
    
    // MARK: - Initializer
    init() {
        // Настраиваем реактивный поиск по тексту (для поиска по бренду)
        $searchText
            // Debounce: ждем 0.5 секунды после того как пользователь перестал печатать
            // Это предотвращает лишние запросы при быстром наборе текста
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            // Убираем дубликаты подряд (если пользователь стер и написал то же самое)
            .removeDuplicates()
            // Обрабатываем изменения текста
            .sink { [weak self] text in
                guard let self = self else { return }
                
                if !text.isEmpty {
                    // Если начали писать в поиск, сбрасываем выбранную категорию
                    self.selectedCategory = nil
                    self.performSearch(query: text, isCategory: false)
                }
            }
            .store(in: &cancellables) // Сохраняем подписку для очистки при деинициализации
    }
    
    // MARK: - Search Methods
    
    /// Основная функция поиска продуктов
    /// - Parameters:
    ///   - query: Поисковый запрос (бренд или категория)
    ///   - isCategory: Флаг, указывающий что ищем по категории (true) или бренду (false)
    func performSearch(query: String, isCategory: Bool) {
        // Выходим если запрос пустой
        guard !query.isEmpty else {
            self.searchResults = []
            self.errorMessage = nil
            return
        }
        
        // Устанавливаем флаги загрузки
        self.isLoading = true
        self.errorMessage = nil
        self.searchResults = [] // Очищаем предыдущие результаты
        
        Task {
            do {
                // Вызываем обновленный API метод с параметром searchByType
                let products = try await apiService.fetchProducts(
                    query: query.lowercased(),
                    searchByType: isCategory
                )
                
                // Обрабатываем результат
                if products.isEmpty {
                    self.errorMessage = "Nothing found. Try another brand or category."
                } else {
                    self.searchResults = products
                }
                self.isLoading = false
            } catch {
                // Обрабатываем ошибки
                self.errorMessage = "Error loading products. Please try again."
                self.isLoading = false
            }
        }
    }
    
    /// Метод для выбора категории из списка кнопок
    /// - Parameter category: Название категории (например: "lipstick", "foundation")
    func selectCategory(_ category: String) {
        self.searchText = "" // Очищаем текстовое поле поиска
        self.selectedCategory = category // Устанавливаем выбранную категорию (для подсветки)
        self.performSearch(query: category, isCategory: true) // Выполняем поиск по категории
    }
}

