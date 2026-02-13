//
//  RealtimeDBService.swift
//  GlowUp
//
//  Created by Аружан Картам on 11.02.2026.
//

import Foundation
import SwiftUI
import Combine
import FirebaseDatabase


class RealtimeDBService: ObservableObject {
  
    private var ref = Database.database().reference()
    
   
    func addReview(productId: Int, userName: String, text: String) {
        let reviewData: [String: Any] = [
            "productId": productId,
            "userName": userName,
            "text": text,
            "timestamp": Date().timeIntervalSince1970
        ]
       
        ref.child("reviews").child("\(productId)").childByAutoId().setValue(reviewData)
    }
    
  
    func observeReviews(productId: Int, completion: @escaping ([Review]) -> Void) {
      
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
            
           
            newReviews.sort { $0.timestamp > $1.timestamp }
            
           
            completion(newReviews)
        }
    }
}
