import UIKit

protocol FavoriteViewProtocol: AnyObject {
    func showPost()
}

class FavoriteView: UIViewController {
    
    var presenter: FavoriteViewPresenterProtocol!
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        let itemSize = (view.bounds.width - 60) / 2 - 15
        let layout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 50, left: 30, bottom: 80, right: 30)
        
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
        collection.backgroundColor = .appMain
        collection.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseId)
        
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appMain
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
        
        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide" : false]) 
    }
    
    private func setupNavBar() {
        title = "Избранное"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .appMain
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
    }
}

extension FavoriteView: FavoriteViewProtocol {
    func showPost() {
        collectionView.reloadData()
    }
}

extension FavoriteView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = presenter.post?[indexPath.item] else { return }
        
        let detailsView = Builder.createDetailsController(item: item)
        navigationController?.pushViewController(detailsView, animated: true)
    }
}

extension FavoriteView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.post?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        
        if let item = presenter.post?[indexPath.item] {
            cell.configureCell(item: item)
            
            cell.completion = {
                item.toggleFavorite(isFavorite: true)
            }
        }
        
        return cell
    }
}
