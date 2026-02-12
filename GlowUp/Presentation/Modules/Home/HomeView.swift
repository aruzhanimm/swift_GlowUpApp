//
//  HomeView.swift
//  GlowUp
//
//  Created by Аружан Картам on 10.02.2026.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    // Подключаем ViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    // Настройка сетки: два столбца
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea() // Наш черный фон
                
                if viewModel.isLoading {
                    // Красивый лоадер
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .neonPink))
                        .scaleEffect(2)
                } else if let error = viewModel.errorMessage {
                    // Экран ошибки
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text(error)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Retry") {
                            viewModel.loadProducts()
                        }
                    }
                } else {
                    // Список товаров
                    ScrollView {
                        // Заголовок
                        HStack {
                            Text("New Arrivals")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Сетка товаров
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.products) { product in
                                // --- ВАЖНОЕ ИЗМЕНЕНИЕ: DEEP NAVIGATION ---
                                // Оборачиваем карточку в ссылку на детальный экран
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Загружаем данные при появлении экрана
                if viewModel.products.isEmpty {
                    viewModel.loadProducts()
                }
            }
        }
    }
}

// Отдельная View для карточки товара (Компонент)
struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            // Картинка с кешированием (Kingfisher)
            KFImage(product.imageURL)
                .placeholder {
                    // Что показывать пока грузится
                    Rectangle().fill(Color.gray.opacity(0.2))
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
                .frame(maxWidth: .infinity) // Чтобы картинка занимала всю ширину карточки
                .background(Color.white) // Белый фон под картинку
                .cornerRadius(10)
            
            // Название бренда
            Text(product.brand?.uppercased() ?? "BRAND")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            // Название продукта
            Text(product.name)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2) // Максимум 2 строки
                .multilineTextAlignment(.leading)
            
            // Цена (В ТЕНГЕ)
            // --- ВАЖНОЕ ИЗМЕНЕНИЕ: LOCALIZATION ---
            Text(product.priceInTenge)
                .font(.subheadline)
                .foregroundColor(.neonPink)
                .padding(.top, 2)
        }
        .padding()
        .background(Color.cardDark) // Темно-серый фон карточки
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    HomeView()
}
