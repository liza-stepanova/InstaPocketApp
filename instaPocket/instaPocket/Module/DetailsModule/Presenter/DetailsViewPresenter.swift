import UIKit

protocol DetailsViewPresenterProtocol: AnyObject {
    init(view: DetailsViewProtocol, item: PostItem)
    var item: PostItem { get }
}

class DetailsViewPresenter: DetailsViewPresenterProtocol {

    private weak var view: DetailsViewProtocol?
    var item: PostItem
    
    required init(view: DetailsViewProtocol, item: PostItem) {
        self.view = view
        self.item = item
    }
    
    
   
}
