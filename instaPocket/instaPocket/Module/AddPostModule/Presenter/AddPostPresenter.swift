import UIKit

protocol AddPostPresenterProtocol: AnyObject {
    //init(view: AddPostViewProtocol, photos: [UIImage])
    var photos: [UIImage] { get set }
    var tag: [String] { get set }
    var postDescription: String? { get set }
    
    func savePost()
}

class AddPostPresenter: AddPostPresenterProtocol {
    
    private weak var view: AddPostViewProtocol?
    private let coreManager = CoreManager.shared
    
    var photos: [UIImage]
    var tag: [String] = []
    var postDescription: String?
    private var storeManager = StoreManager.shared
    
    required init(view: AddPostViewProtocol, photos: [UIImage]) {
        self.view = view
        self.photos = photos
    }
    
    func savePost() {
        let id = UUID().uuidString
        var photoData: [Data?] = []
        
        photos.forEach {
            let imageData = $0.jpegData(compressionQuality: 1)
            photoData.append(imageData)
        }
        
        let photos = storeManager.savePhotos(postId: id, photos: photoData)
        
        let post: PostItem = {
            let postItem = PostItem(context: coreManager.persistentContainer.viewContext)
            postItem.id = id
            postItem.photos = photos
            postItem.comments = []
            postItem.tags = self.tag
            postItem.date = Date()
            postItem.isFavorite = false
            postItem.lat = 0
            postItem.long = 0
            postItem.postDescription = self.postDescription
            
            return postItem
        }()
        
        coreManager.savePost(post: post)
    }
}
