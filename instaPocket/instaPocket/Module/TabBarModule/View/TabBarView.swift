import UIKit

protocol TabBarViewProtocol: AnyObject {
    func setControllers(controllers: [UIViewController])
}

class TabBarView: UITabBarController {

    var presenter: TabBarViewPresenterProtocol!
    private var tabs: [UIImage] = [UIImage(systemName: "house")!, UIImage(systemName: "plus.circle")!, UIImage(systemName: "heart")!]
    
    private lazy var tabBarView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 100, width: self.view.frame.width, height: 60))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideTabBar), name: .hideTabBar, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToMain), name: .goToMain, object: nil)
        
        view.backgroundColor = .appMain

        let offsets: [Double] = [-100, 0, 100]
        tabs.enumerated().forEach {
            let tabButton = createTabBarButton(image: $0.element, tag: $0.offset, offsetX: offsets[$0.offset], isBigButton: $0.offset == 1 ? true : false)
            
            tabBarView.addSubview(tabButton)
        }
        view.addSubview(tabBarView)
    }
    
    lazy var selectedItem = UIAction { [weak self] sender in
        guard let self = self, let sender = sender.sender as? UIButton else { return }
        
        self.selectedIndex = sender.tag
    }
    
    @objc func goToMain() {
        self.selectedIndex = 0
    }
    
    @objc func hideTabBar(sendeer: Notification) {
        let isHide = sendeer.userInfo?["isHide"] as! Bool
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            if isHide {
                self.tabBarView.frame.origin.y = self.view.frame.height
            } else {
                self.tabBarView.frame.origin.y = self.view.frame.height - 100
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.isHidden = true
        buildTabBar()
    }
}

extension TabBarView {
    
    private func createTabBarButton(image: UIImage, tag: Int, offsetX: Double, isBigButton: Bool = false) -> UIButton {
        let button = UIButton(primaryAction: selectedItem)
        let offsetY = isBigButton ? 0 : 15
        let btnSize: Double  = isBigButton ? 60.0 : 25.0
        
        button.frame.size = CGSize(width: btnSize + 3.0, height: btnSize)
        button.tag = tag
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .white
        button.frame.origin = CGPoint(x: .zero, y: offsetY)
        button.center.x = view.center.x + offsetX
        
        return button
    }
}

extension TabBarView: TabBarViewProtocol {
    private func buildTabBar() {
        let mainScreen = Builder.createMainScreenController()
        let cameraScreen = Builder.createCameraScreenController()
        let favoriteScreen = Builder.createFavoriteScreenController()
        self.setControllers(controllers: [mainScreen, cameraScreen, favoriteScreen])
    }
    
    func setControllers(controllers: [UIViewController]) {
        setViewControllers(controllers, animated: true)
    }
}
