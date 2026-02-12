//
//  Review.swift
//  GlowUp
//
//  Created by Аружан Картам on 11.02.2026.
//

import Foundation

struct Review: Identifiable, Codable {
    let id: String
    let productId: Int
    let userName: String
    let text: String
    let timestamp: TimeInterval
    
    // Превращаем словарь из Firebase в наш объект
    init?(id: String, data: [String: Any]) {
        guard let productId = data["productId"] as? Int,
              let userName = data["userName"] as? String,
              let text = data["text"] as? String,
              let timestamp = data["timestamp"] as? TimeInterval else {
            return nil
        }
        
        self.id = id
        self.productId = productId
        self.userName = userName
        self.text = text
        self.timestamp = timestamp
    }
    
    // Для отправки в Firebase
    var toDictionary: [String: Any] {
        return [
            "productId": productId,
            "userName": userName,
            "text": text,
            "timestamp": timestamp
        ]
    }
}
