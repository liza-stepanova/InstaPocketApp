import Foundation
import CoreData

class CoreManager {
    static let shared = CoreManager()
    var allPost: [PostData] = []
    var favoritePost: [PostItem] = []
    private init() {
        fetchPosts()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "instaPocket")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError?  {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchPosts() {
        let request = PostData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let posts = try persistentContainer.viewContext.fetch(request)
            self.allPost = posts
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func savePost(post: PostItem) {
        let calendar = Calendar.current
        let now = Date()
        
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        
        let req = PostData.fetchRequest()
        req.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay as CVarArg, endOfDay! as CVarArg)
        
        do {
            let result = try persistentContainer.viewContext.fetch(req)
            if !result.isEmpty, let parent = result.first {
                post.parent = parent
            } else {
                let parent = PostData(context: persistentContainer.viewContext)
                parent.id = UUID().uuidString
                parent.date = Date()
                
                post.parent = parent
            }
            
            saveContext()
            fetchPosts()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getFavoritePosts() {
        let bool = NSNumber(booleanLiteral: true)
        let req = PostItem.fetchRequest()
        req.predicate = NSPredicate(format: "isFavorite == %@", bool as CVarArg)
        
        do {
            let favoritePosts = try persistentContainer.viewContext.fetch(req)
            self.favoritePost = favoritePosts
            print(favoritePosts.count)
        } catch {
            print(error.localizedDescription)
        }
    }
}
