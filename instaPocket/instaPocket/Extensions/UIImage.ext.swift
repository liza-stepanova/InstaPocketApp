import UIKit

extension UIImage {
    
    static func getCoverPhoto(folderId: String, photos: [String]) -> UIImage? {
        let imagesName = StoreManager.shared.getPhotos(postId: folderId, photos: photos)
        return UIImage(data: imagesName.first ?? Data())
    }
    
    static func getOnePhoto(folderId: String, photo: String) -> UIImage? {
        guard let imageName = StoreManager.shared.getPhoto(postId: folderId, photoName: photo) else { return nil }
        return UIImage(data: imageName)
    }
}
