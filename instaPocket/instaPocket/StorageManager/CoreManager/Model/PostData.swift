import Foundation
import CoreData

@objc(PostData)
public class PostData: NSManagedObject {

}

extension PostData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostData> {
        return NSFetchRequest<PostData>(entityName: "PostData")
    }

    @NSManaged public var id: String?
    @NSManaged public var date: Date
    @NSManaged public var items: NSSet?

}

extension PostData : Identifiable {

}

