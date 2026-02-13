
import CoreData
import SwiftUI
import FirebaseAuth 

class StorageManager {

    static let shared = StorageManager()
   
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "GlowUp")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? "guest"
    }
    
    func addToFavorites(product: Product) {
        let context = container.viewContext
        
        let favorite = FavoriteProduct(context: context)
        favorite.id = Int64(product.id)
        favorite.name = product.name
        favorite.brand = product.brand
        favorite.price = product.price
        favorite.imageLink = product.image_link
        favorite.userId = currentUserId
        
        saveContext()
    }
    
   
    func removeFromFavorites(product: Product) {
        let context = container.viewContext
        
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %d AND userId == %@", Int64(product.id), currentUserId)
        
        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Error deleting favorite: \(error)")
        }
    }
  
    func isFavorite(product: Product) -> Bool {
        let context = container.viewContext
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
      
        request.predicate = NSPredicate(format: "id == %d AND userId == %@", Int64(product.id), currentUserId)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
