import Foundation

protocol SettingViewPresenterProtocol: AnyObject {
    init(view: SettingViewProtocol)
}

class SettingViewPresenter: SettingViewPresenterProtocol {
    private weak var view: SettingViewProtocol?
    
    required init(view: SettingViewProtocol) {
        self.view = view
    }
}
