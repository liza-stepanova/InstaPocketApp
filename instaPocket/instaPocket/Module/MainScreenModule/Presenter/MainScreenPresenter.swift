import UIKit

protocol MainScreenPresenterProtocol: AnyObject {
    init(view: MainScreenViewProtocol)
    var posts: [PostData]? { get set }
    func getPosts()
}

class MainScreenPresenter {
    private weak var view: MainScreenViewProtocol?
    private let coreManager = CoreManager.shared
    
    var posts: [PostData]?
    
    required init(view: MainScreenViewProtocol) {
        self.view = view
        getPosts()
    }
}

extension MainScreenPresenter: MainScreenPresenterProtocol {
    func getPosts() {
        self.posts = coreManager.allPost
        
        view?.showPosts()
    }
}
