import UIKit

protocol DetailsViewProtocol: AnyObject {
    
}

class DetailsView: UIViewController {
    
    var presenter: DetailsViewPresenterProtocol!
    var photoView: PhotoView!
    
    private var menuViewHeight = UIApplication.topSafeArea + 50
    
    lazy var topMenuView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: menuViewHeight)
        view.backgroundColor = .appMain
        
        return view
    }()
    
    lazy var backAction = UIAction { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
    }
    
    lazy var menuAction = UIAction { [weak self] _ in
         print("menu open")
    }
    
    lazy var navigationHeader: NavigationHeader = {
        NavigationHeader(backAction: backAction, menuAction: menuAction, date: presenter.item.date)
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionalLayout())
        collection.backgroundColor = .none
        collection.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 100, right: 0)
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.reuseId)
        collection.register(DetailPhotoCell.self, forCellWithReuseIdentifier: DetailPhotoCell.reuseId)
        collection.register(DetailDescriptionCell.self, forCellWithReuseIdentifier: DetailDescriptionCell.reuseId)
        collection.register(DetailAddCommentCell.self, forCellWithReuseIdentifier: DetailAddCommentCell.reuseId)
        collection.register(DetailMapCell.self, forCellWithReuseIdentifier: DetailMapCell.reuseId)
        
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appMain
        view.addSubview(collectionView )
        view.addSubview(topMenuView)
        setupPageHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide" : true])
    }
    
    private func setupPageHeader() {
        let headerView = navigationHeader.getNavigationHeader(type: .detail)
        headerView.frame.origin.y = UIApplication.topSafeArea
        view.addSubview(headerView)
    }
    
}

extension DetailsView: DetailsViewProtocol {
    
}

extension DetailsView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return presenter.item.photos.count
        case 1:
            return presenter.item.tags?.count ?? 0
        case 2, 4, 5:
            return 1
        case 3:
            return presenter.item.comments?.count ?? 0
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = presenter.item
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCell.reuseId, for: indexPath) as! DetailPhotoCell
            cell.configureCell(postId: item.id ?? "" , image: item.photos[indexPath.item])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseId,
                                                          for: indexPath) as! TagCollectionViewCell
            cell.cellConfig(tagText: item.tags?[indexPath.item] ?? "")
            return cell
        case 2, 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailDescriptionCell.reuseId, for: indexPath) as! DetailDescriptionCell
            if indexPath.section == 2 {
                cell.configureCell(date: nil, text: item.postDescription ?? "")
            } else {
                if let comment = item.comments?.allObjects as? [Comment] {
                    cell.configureCell(date: comment[indexPath.row].date, text: comment[indexPath.row].comment ?? "")
                }
            }
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAddCommentCell.reuseId,
                                                          for: indexPath) as! DetailAddCommentCell
            cell.completion = { [weak self] comment in
                guard let _ = self else { return }
                print(comment)
            }
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailMapCell.reuseId,
                                                          for: indexPath) as! DetailMapCell
            //cell.configureCell(coordinate: item.location)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .red
            return cell
        }
    
    }
}

extension DetailsView {
    private func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch section {
            case 0:
                return self?.createPhotoSection()
            case 1:
                return self?.createTagSection()
            case 2, 3 :
                return self?.createDescriptionSection()
            case 4:
                return self?.createCommentFieldSection()
            case 5:
                return self?.createMapSection()
            default:
                return self?.createPhotoSection()
            }
        }
    }
    
    private func createPhotoSection() -> NSCollectionLayoutSection {
        //item (size)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 30)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .fractionalHeight(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30)
        
        return section
    }
    private func createTagSection() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(110),
                                               heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [.init(layoutSize: groupSize)])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: nil)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    private func createDescriptionSection() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [.init(layoutSize: groupSize)])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(10))
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30)
        
        return section
    }
    private func createCommentFieldSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 30, bottom: 60, trailing: 30)
        
        return section
    }
    
    private func createMapSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        return section
    }
    
}

extension DetailsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let itemPhoto = presenter.item.photos[indexPath.item]
            if let photo: UIImage = .getOnePhoto(folderId: presenter.item.id ?? "", photo: itemPhoto) {
                photoView = Builder.createPhotoViewController(image: photo) as? PhotoView
            }
            
            if photoView != nil {
                addChild(photoView!)
                self .photoView.view.frame = view.bounds
                view.addSubview(photoView!.view)
                
                photoView!.completion = { [weak self] in
                    self?.photoView.view.removeFromSuperview()
                    self?.photoView.removeFromParent()
                    self?.photoView = nil
                }
            }
        }
    }
}
