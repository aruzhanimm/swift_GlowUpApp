
import CoreData
import SwiftUI
import FirebaseAuth // <-- ОБЯЗАТЕЛЬНО ДОБАВИТЬ ЭТОТ ИМПОРТ

class StorageManager {
    // Singleton - чтобы использовать один менеджер везде
    static let shared = StorageManager()
    // Ссылка на контейнер Core Data (создается в Persistence.swift)
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "GlowUp")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    // Вспомогательная переменная для получения ID текущего юзера
    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? "guest"
    }
    
    // 1. Сохранить в избранное (с привязкой к UserID)
    func addToFavorites(product: Product) {
        let context = container.viewContext
        
        let favorite = FavoriteProduct(context: context)
        favorite.id = Int64(product.id)
        favorite.name = product.name
        favorite.brand = product.brand
        favorite.price = product.price
        favorite.imageLink = product.image_link
        favorite.userId = currentUserId // <-- ВАЖНО: Записываем ID текущего пользователя
        
        saveContext()
    }
    
    // 2. Удалить из избранного (Ищем по ID товара И по ID юзера)
    func removeFromFavorites(product: Product) {
        let context = container.viewContext
        
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        // Удаляем только если совпадает и ID товара, и ID юзера
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
    
    // 3. Проверка лайка (Только для текущего юзера)
    func isFavorite(product: Product) -> Bool {
        let context = container.viewContext
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        // Ищем: есть ли такой товар У ЭТОГО пользователя
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
