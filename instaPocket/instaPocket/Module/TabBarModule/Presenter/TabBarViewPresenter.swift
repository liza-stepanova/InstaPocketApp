import UIKit

protocol TabBarViewPresenterProtocol: AnyObject {
    init(view: TabBarViewProtocol)
}

class TabBarViewPresenter: TabBarViewPresenterProtocol {
    
    private weak var view: TabBarViewProtocol?
    
    required init(view: TabBarViewProtocol) {
        self.view = view
    }
    
}
