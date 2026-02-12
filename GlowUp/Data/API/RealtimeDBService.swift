//
//  RealtimeDBService.swift
//  GlowUp
//
//  Created by Аружан Картам on 11.02.2026.
//

import Foundation
import SwiftUI // <--- ЭТО ВАЖНО: ObservableObject живет здесь
import Combine // <--- И здесь
import FirebaseDatabase

// Conforms to ObservableObject for SwiftUI state updates
class RealtimeDBService: ObservableObject {
    
    // Ссылка на базу данных
    // Используем lazy или init, чтобы база точно инициализировалась
    private var ref = Database.database().reference()
    
    // Отправка отзыва
    func addReview(productId: Int, userName: String, text: String) {
        let reviewData: [String: Any] = [
            "productId": productId,
            "userName": userName,
            "text": text,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        // Создаем уникальный ключ для отзыва
        // Структура в базе: reviews -> productId -> reviewID -> данные
        ref.child("reviews").child("\(productId)").childByAutoId().setValue(reviewData)
    }
    
    // Слушатель отзывов (Live Updates)
    func observeReviews(productId: Int, completion: @escaping ([Review]) -> Void) {
        // .observe(.value) означает "слушай постоянно"
        ref.child("reviews").child("\(productId)").observe(.value) { snapshot in
            var newReviews: [Review] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any] {
                    // Используем наш инициализатор из Review.swift
                    if let review = Review(id: snapshot.key, data: value) {
                        newReviews.append(review)
                    }
                }
            }
            
            // Сортируем: новые сверху
            newReviews.sort { $0.timestamp > $1.timestamp }
            
            // Возвращаем данные в completion handler
            completion(newReviews)
        }
    }
}
