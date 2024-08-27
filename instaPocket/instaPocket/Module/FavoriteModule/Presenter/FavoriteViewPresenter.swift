import UIKit

protocol FavoriteViewPresenterProtocol: AnyObject {
    init(view: FavoriteViewProtocol)
    
    var post: [PostItem]? { get set }
    func getPosts()
}

class FavoriteViewPresenter: FavoriteViewPresenterProtocol {
    private weak var view: FavoriteViewProtocol?
    private let coreManager = CoreManager.shared
    var post: [PostItem]?
    
    required init(view: FavoriteViewProtocol) {
        self.view = view
        getPosts()
    }
    
    func getPosts() {
        //self.post = PostItem.getMockItem()
        coreManager.getFavoritePosts()
        self.post = coreManager.favoritePost
        self.view?.showPost()
    }
}
