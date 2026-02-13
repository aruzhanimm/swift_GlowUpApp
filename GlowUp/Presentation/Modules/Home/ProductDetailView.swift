

import SwiftUI
import Kingfisher
import UIKit
import FirebaseAuth

struct ProductDetailView: View {
   
    let product: Product
    @Environment(\.presentationMode) var presentationMode
    
 
    @State private var isFavorite: Bool = false
    
   
    @StateObject private var dbService = RealtimeDBService()
    @State private var reviews: [Review] = []
    @State private var newReviewText: String = ""
    
   
    var body: some View {
        ZStack {
          
            Color.backgroundDark.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    productImageView
                        .padding(.bottom, 20)
                    
                    
                    productInfoView
                    
                    Divider()
                        .background(Color.gray.opacity(0.5))
                        .padding(.vertical)
                    
                    
                    reviewsSection
                        .padding(.horizontal)
                    
                    
                    Spacer().frame(height: 100)
                }
            }
            
            
            floatingBottomBar
        }
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
       
        .onAppear {
            checkIfFavorite()
            loadReviews()
        }
    }
 
    private var productImageView: some View {
        ZStack(alignment: .topTrailing) {
           
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .frame(height: 350)
                .frame(maxWidth: .infinity)
            
          
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
            
           
            favoriteButton
                .padding(.top, 20)
                .padding(.trailing, 20)
        }
    }
    
   
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
   
    private var productInfoView: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                Text(product.brand?.uppercased() ?? "BRAND")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .tracking(2)
                
                Spacer()
                
               
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
            
            
            Text(product.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
          
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
    
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Reviews & Comments")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
           
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
            
           
            if reviews.isEmpty {
                Text("No reviews yet. Be the first!")
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.top, 10)
            } else {
                ForEach(reviews) { review in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                           
                            Text(review.userName)
                                .fontWeight(.bold)
                                .foregroundColor(.neonLavender)
                            
                            Spacer()
                            
                           
                            Text(Date(timeIntervalSince1970: review.timestamp), style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                     
                        Text(review.text)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    .padding()
                    .background(Color.cardDark.opacity(0.5))
                    .cornerRadius(10)
                }
            }
        }
    }
    

    private var floatingBottomBar: some View {
        VStack {
            Spacer()
            HStack {
                
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
           
            .cornerRadius(25, corners: [.topLeft, .topRight])
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: -5)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    

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

    private func checkIfFavorite() {
        isFavorite = StorageManager.shared.isFavorite(product: product)
    }
    
    private func loadReviews() {
        dbService.observeReviews(productId: product.id) { fetchedReviews in
       
            withAnimation {
                self.reviews = fetchedReviews
            }
        }
    }
    
    private func sendReview() {
        guard !newReviewText.isEmpty else { return }
        
       
        let currentUser = Auth.auth().currentUser?.email?.components(separatedBy: "@").first ?? "Guest"
        

        dbService.addReview(productId: product.id, userName: currentUser, text: newReviewText)
        

        newReviewText = ""
        

        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    private func addToCart() {
        print("Add to cart: \(product.name)")
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}



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
