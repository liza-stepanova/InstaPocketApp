import UIKit

class NavigationHeader {
    
    var backAction: UIAction?
    var menuAction: UIAction?
    var closeAction: UIAction?
    var date: Date
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width - 60, height: 44)
        view.backgroundColor = .appMain
        view.addSubview(dateStack)
        
        return view
    }()
    
    lazy var dateLabel: UILabel = getHeaderLabel(text: date.formattDate(type: .onlyDate), size: 30, weight: .bold)
    lazy var yearLabel: UILabel = getHeaderLabel(text: date.formattDate(type: .onlyYear) + "год", size: 14, weight: .light)
    lazy var dateStack: UIStackView = {
        let stack = UIStackView(frame: CGRect(x: 45, y: 0, width: 200, height: 44))
        stack.axis = .vertical
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(yearLabel)
        
        return stack
    }()
    
    lazy var backButton: UIButton = getActionButton(origin: CGPoint(x: 0, y: 9), icon: UIImage(systemName: "chevron.backward")!, action: backAction)
    lazy var closeButton: UIButton = getActionButton(origin: CGPoint(x: navigationView.frame.width - 30, y: 0), icon: UIImage(systemName: "xmark")!, action: closeAction)
    lazy var menuButton: UIButton = getActionButton(origin: CGPoint(x: navigationView.frame.width - 30, y: 9), icon: UIImage(systemName: "text.justify")!, action: menuAction)
        
    init(backAction: UIAction? = nil, menuAction: UIAction? = nil, closeAction: UIAction? = nil, date: Date) {
        self.backAction = backAction
        self.menuAction = menuAction
        self.closeAction = closeAction
        self.date = date
    }
    
    func getNavigationHeader(type: NavigationHeaderType) -> UIView {
        switch type {
            
        case .addPost:
            navigationView.addSubview(backButton)
        case .detail:
            navigationView.addSubview(backButton)
            navigationView.addSubview(menuButton)
        }
        
        return navigationView
    }
    
    private func getActionButton(origin: CGPoint, icon: UIImage, action: UIAction?) -> UIButton {
        let button = UIButton(primaryAction: action)
        button.setImage(icon, for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.frame.origin = origin
        button.tintColor = .white
        
        return button
    }
    
    private func getHeaderLabel(text: String, size: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        
        return label
    }
}

enum NavigationHeaderType {
    case addPost, detail
}
