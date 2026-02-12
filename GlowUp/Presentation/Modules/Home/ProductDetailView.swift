//
//  ProductDetailView.swift
//  GlowUp
//
//  Created by Аружан Картам on 10.02.2026.
//

import SwiftUI
import Kingfisher
import UIKit
import FirebaseAuth // Нужно для получения имени пользователя

struct ProductDetailView: View {
    // MARK: - Properties
    let product: Product // Товар, который отображаем
    @Environment(\.presentationMode) var presentationMode // Для кнопки "Назад"
    
    // MARK: - State
    @State private var isFavorite: Bool = false // Состояние лайка (избранное)
    
    // --- НОВЫЕ СОСТОЯНИЯ ДЛЯ ОТЗЫВОВ ---
    @StateObject private var dbService = RealtimeDBService() // Сервис базы данных
    @State private var reviews: [Review] = [] // Список загруженных отзывов
    @State private var newReviewText: String = "" // Текст нового отзыва
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Фон приложения
            Color.backgroundDark.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 1. Блок с картинкой товара и кнопкой лайка
                    productImageView
                        .padding(.bottom, 20)
                    
                    // 2. Блок с информацией о товаре
                    productInfoView
                    
                    Divider()
                        .background(Color.gray.opacity(0.5))
                        .padding(.vertical)
                    
                    // 3. --- СЕКЦИЯ ОТЗЫВОВ (REALTIME) ---
                    reviewsSection
                        .padding(.horizontal)
                    
                    // Отступ снизу, чтобы нижняя панель не перекрывала контент
                    Spacer().frame(height: 100)
                }
            }
            
            // 4. Плавающая нижняя панель с ценой и кнопкой корзины
            floatingBottomBar
        }
        // Настройка навигационной панели
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        // Действия при открытии экрана
        .onAppear {
            checkIfFavorite() // Проверяем лайк
            loadReviews()     // Загружаем отзывы
        }
    }
    
    // MARK: - View Components
    
    /// Блок с изображением товара и кнопкой лайка
    private var productImageView: some View {
        ZStack(alignment: .topTrailing) {
            // Белый фон для лучшей видимости картинки
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .frame(height: 350)
                .frame(maxWidth: .infinity)
            
            // Картинка товара (с кешированием через Kingfisher)
            KFImage(product.imageURL)
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .padding(.top, 25)
            
            // Кнопка лайка (избранное)
            favoriteButton
                .padding(.top, 20)
                .padding(.trailing, 20)
        }
    }
    
    /// Кнопка добавления в избранное
    private var favoriteButton: some View {
        Button(action: {
            toggleFavorite()
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 24))
                .foregroundColor(isFavorite ? .red : .gray)
                .padding(12)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
    }
    
    /// Блок с информацией о товаре (бренд, название, описание)
    private var productInfoView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Бренд и рейтинг
            HStack {
                Text(product.brand?.uppercased() ?? "BRAND")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .tracking(2)
                
                Spacer()
                
                // Рейтинг товара
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.neonLavender)
                    Text(String(format: "%.1f", product.rating ?? 0.0))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.cardDark)
                .cornerRadius(10)
            }
            
            // Название товара
            Text(product.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            // Описание товара
            if let description = product.description {
                Text("Description")
                    .font(.headline)
                    .foregroundColor(.neonPink)
                    .padding(.top, 10)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .lineSpacing(5)
            }
        }
        .padding(.horizontal)
    }
    
    /// Секция отзывов и комментариев
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Reviews & Comments")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // Поле ввода нового отзыва
            HStack {
                TextField("Write a review...", text: $newReviewText)
                    .padding()
                    .background(Color.cardDark)
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    // Убираем автокоррекцию для удобства
                    .disableAutocorrection(true)
                
                Button(action: {
                    sendReview()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.neonPink) // Твой акцентный цвет
                        .padding(10)
                        .background(Color.cardDark)
                        .clipShape(Circle())
                }
                .disabled(newReviewText.isEmpty) // Неактивна, если текст пустой
            }
            
            // Список отзывов
            if reviews.isEmpty {
                Text("No reviews yet. Be the first!")
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.top, 10)
            } else {
                ForEach(reviews) { review in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            // Имя пользователя
                            Text(review.userName)
                                .fontWeight(.bold)
                                .foregroundColor(.neonLavender)
                            
                            Spacer()
                            
                            // Дата
                            Text(Date(timeIntervalSince1970: review.timestamp), style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // Текст отзыва
                        Text(review.text)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    .padding()
                    .background(Color.cardDark.opacity(0.5)) // Полупрозрачный фон
                    .cornerRadius(10)
                }
            }
        }
    }
    
    /// Нижняя плавающая панель с ценой и кнопкой корзины
    private var floatingBottomBar: some View {
        VStack {
            Spacer()
            HStack {
                // Цена товара
                VStack(alignment: .leading) {
                    Text("Price")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(product.priceInTenge)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Кнопка добавления в корзину
                Button(action: {
                    addToCart()
                }) {
                    Text("Add to Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .padding(.horizontal, 20)
                        .background(Color.neonPink)
                        .cornerRadius(20)
                }
            }
            .padding()
            .background(Color.cardDark.opacity(0.95))
            // Используем стандартный синтаксис Swift для OptionSet
            .cornerRadius(25, corners: [.topLeft, .topRight])
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: -5)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    /// Кнопка "Назад"
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.cardDark)
                .clipShape(Circle())
        }
    }
    
    // MARK: - Functions
    
    /// Переключает состояние лайка
    private func toggleFavorite() {
        if isFavorite {
            StorageManager.shared.removeFromFavorites(product: product)
        } else {
            StorageManager.shared.addToFavorites(product: product)
        }
        
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
        isFavorite.toggle()
    }
    
    /// Проверяет, лайкнут ли товар
    private func checkIfFavorite() {
        isFavorite = StorageManager.shared.isFavorite(product: product)
    }
    
    /// Загружает отзывы из Firebase в реальном времени
    private func loadReviews() {
        dbService.observeReviews(productId: product.id) { fetchedReviews in
            // Анимация при появлении новых отзывов
            withAnimation {
                self.reviews = fetchedReviews
            }
        }
    }
    
    /// Отправляет новый отзыв в Firebase
    private func sendReview() {
        guard !newReviewText.isEmpty else { return }
        
        // Получаем имя текущего пользователя из Auth, или пишем "Guest"
        let currentUser = Auth.auth().currentUser?.email?.components(separatedBy: "@").first ?? "Guest"
        
        // Отправляем
        dbService.addReview(productId: product.id, userName: currentUser, text: newReviewText)
        
        // Очищаем поле
        newReviewText = ""
        
        // Скрываем клавиатуру
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Логика корзины (заглушка)
    private func addToCart() {
        print("Add to cart: \(product.name)")
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Preview & Extensions

#Preview {
    NavigationView {
        ProductDetailView(product: Product(
            id: 495,
            brand: "Maybelline",
            name: "Super Stay Matte Ink",
            price: "9.99",
            image_link: "https://d3t32hsnjxo7q6.cloudfront.net/i/991799d3e70b88584979f8f9e243f02c_ra,w158,h184_pa,w158,h184.png",
            description: "Long lasting matte lipstick...",
            product_type: "lipstick",
            rating: 4.5
        ))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
