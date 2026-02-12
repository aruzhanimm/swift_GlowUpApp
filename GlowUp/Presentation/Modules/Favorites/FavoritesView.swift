import SwiftUI
import CoreData
import FirebaseAuth

struct FavoritesView: View {
    
    // Мы не используем стандартный @FetchRequest здесь,
    // потому что нам нужно настроить фильтр (NSPredicate) динамически.
    @FetchRequest var favorites: FetchedResults<FavoriteProduct>
    
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    // Специальный инициализатор
    init() {
        // Получаем ID текущего пользователя
        let userId = Auth.auth().currentUser?.uid ?? "guest"
        
        // Настраиваем запрос:
        // 1. Сортируем по имени
        // 2. Фильтруем: userId должен совпадать с текущим
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteProduct.name, ascending: true)]
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        // Присваиваем запрос переменной _favorites (подчеркивание важно, так мы обращаемся к обертке)
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
                            ForEach(favorites, id: \.self) { favorite in // Добавил id: \.self для надежности
                                
                                // Конвертируем CoreData объект в обычный Product
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
