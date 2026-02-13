import SwiftUI
import CoreData
import FirebaseAuth

struct FavoritesView: View {
    
  
    @FetchRequest var favorites: FetchedResults<FavoriteProduct>
    
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
   
    init() {
       
        let userId = Auth.auth().currentUser?.uid ?? "guest"
       
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteProduct.name, ascending: true)]
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
       
        self._favorites = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()
                
                if favorites.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No favorites yet")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Go like some makeup!")
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        HStack {
                            Text("My Favorites")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(favorites, id: \.self) { favorite in
                                
                                let product = Product(
                                    id: Int(favorite.id),
                                    brand: favorite.brand,
                                    name: favorite.name ?? "Unknown",
                                    price: favorite.price,
                                    image_link: favorite.imageLink,
                                    description: nil,
                                    product_type: nil,
                                    rating: nil
                                )
                                
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
        }
    }
}

#Preview {
    FavoritesView()
}
