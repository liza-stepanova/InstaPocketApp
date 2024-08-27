import Foundation
import CoreData

@objc(Comment)
public class Comment: NSManagedObject {

}

extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var id: String?
    @NSManaged public var date: Date?
    @NSManaged public var comment: String?
    @NSManaged public var parent: PostItem?

}

extension Comment : Identifiable {

}
