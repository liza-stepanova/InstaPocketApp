import UIKit

protocol MainScreenViewProtocol: AnyObject {
    func showPosts()
}

class MainScreenView: UIViewController {
    
    var presenter: MainScreenPresenterProtocol!
    
    private var menuViewHeight = UIApplication.topSafeArea + 70
    private var topInsets: CGFloat = 0
    
    private lazy var topMenuView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: menuViewHeight)
        view.backgroundColor = .appMain
        view.addSubview(menuAppName)
        view.addSubview(menuSettingButton)
        
        return view
    }()
    
    private lazy var menuAppName: UILabel = {
        let label = UILabel()
        label.text = "instaPocket"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.frame = CGRect(x: 30, y: menuViewHeight - 40, width: view.bounds.width, height: 30)
        
        return label
    }()
    
    private lazy var menuSettingButton: UIButton = {
        let button = UIButton(primaryAction: settingButtonAction)
        button.frame = CGRect(x: view.bounds.width - 55, y: menuViewHeight - 35, width: 25, height: 25)
        button.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var settingButtonAction = UIAction { [weak self] _ in
        let settingVC = Builder.createSettingsViewController()
        self?.present(settingVC, animated: true)
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let size = view.frame.width - 60
        layout.itemSize = CGSize(width: size, height: size)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 40, right: 0)
        
        collectionView.contentInset.top = 90
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .appMain
        
        collectionView.alwaysBounceVertical = true
        collectionView.register(MainPostCell.self, forCellWithReuseIdentifier: MainPostCell.reuseId)
        collectionView.register(MainPostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainPostHeader.reuseId)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appMain
        view.addSubview(collectionView)
        view.addSubview(topMenuView)
        
        topInsets = self.collectionView.adjustedContentInset.top
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide" : false])
    }

}

extension MainScreenView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.presenter.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter.posts?[section].items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPostCell.reuseId, for: indexPath) as? MainPostCell
        else { return UICollectionViewCell() }
        
        cell.backgroundColor = .green
        if let items = presenter.posts?[indexPath.section].items?.allObjects as? [PostItem] {
            let posts = items.sorted {
                $0.date > $1.date 
            }
            
            let item = posts[indexPath.item]
            cell.configureCell(item: item)
            
            cell.completion = {
                item.toggleFavorite(isFavorite: item.isFavorite)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainPostHeader.reuseId, for: indexPath) as! MainPostHeader
        let text = presenter.posts?[indexPath.section].date.getDateDifference()
        header.setHeaderText(header: text)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width - 60, height: 40)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let menuTopPosition = scrollView.contentOffset.y + topInsets + 59
    
        if menuTopPosition < 55, menuTopPosition > 0 {
            topMenuView.frame.origin.y = -menuTopPosition
            self.menuAppName.font = UIFont.systemFont(ofSize: 30 - menuTopPosition * 0.2, weight: .bold)
        } 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let items = presenter.posts?[indexPath.section].items?.allObjects as? [PostItem] {
            let item = items[indexPath.item]
            
            let detailsVC = Builder.createDetailsController(item: item)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension MainScreenView: MainScreenViewProtocol {
    func showPosts() {
        collectionView.reloadData()
    }
}
