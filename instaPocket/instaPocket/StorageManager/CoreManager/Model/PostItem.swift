import Foundation
import CoreData

@objc(PostItem)
public class PostItem: NSManagedObject {

}

extension PostItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostItem> {
        return NSFetchRequest<PostItem>(entityName: "PostItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var photos: [String]
    @NSManaged public var postDescription: String?
    @NSManaged public var tags: [String]?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var date: Date
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var parent: PostData?
    @NSManaged public var comments: NSSet?

}

extension PostItem : Identifiable {
    func toggleFavorite(isFavorite: Bool) {
        self.isFavorite = !isFavorite
        
        try? managedObjectContext?.save()
    }
}
