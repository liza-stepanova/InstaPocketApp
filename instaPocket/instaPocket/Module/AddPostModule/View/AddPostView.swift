import UIKit

protocol AddPostViewProtocol: AnyObject {
    var delegate: CameraViewDelegate? { get set }
}

protocol AddPostViewDelegate: AnyObject {
    func addTag(tag: String?)
    func addDescription(text: String?)
}

class AddPostView: UIViewController, AddPostViewProtocol {
    var delegate: CameraViewDelegate?
    
    var presenter: AddPostPresenterProtocol!
    
    private var menuViewHeight = UIApplication.topSafeArea + 50
    
    lazy var topMenuView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: menuViewHeight)
        view.backgroundColor = .appMain
        
        return view
    }()
    
    lazy var navigationHeader: NavigationHeader = {
        NavigationHeader(backAction: backAction, date: Date())
    }()
    
    lazy var backAction = UIAction { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
    }
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionLayout())
        collection.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 100, right: 0)
        collection.backgroundColor = .none
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.register(AddPostPhotoCell.self, forCellWithReuseIdentifier: AddPostPhotoCell.reuseId)
        collection.register(AddPostTagCell.self, forCellWithReuseIdentifier: AddPostTagCell.reuseId)
        collection.register(AddPostFieldCell.self, forCellWithReuseIdentifier: AddPostFieldCell.reuseId)
        
        return collection
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 30, y: view.bounds.height - 98, width: view.bounds.width - 60, height: 55), primaryAction: saveAction)
        button.backgroundColor = .appBlack
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 27.5
        
        return button
    }()
    
    lazy var saveAction = UIAction { [weak self] _ in
        self?.presenter.savePost()
        NotificationCenter.default.post(name: .dismissCameraView, object: nil)
        self?.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appMain
        view.addSubview(collectionView)
        view.addSubview(topMenuView)
        view.addSubview(saveButton)
        setupHeader()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupHeader() {
        let header = navigationHeader.getNavigationHeader(type: .addPost)
        header.frame.origin.y = UIApplication.topSafeArea
        view.addSubview(header)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @objc func keyboardChange(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardViewFrame = view.convert(keyboardValue.cgRectValue, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            collectionView.contentInset.bottom = 100
        } else {
            collectionView.contentInset.bottom = keyboardViewFrame.height
        }
    }
}

extension AddPostView {
    // composition layout
    
    private func getCompositionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch section {
            case 0:
                return self?.createPhotoSection()
            case 1:
                return self?.createTagSection()
            default:
                return self?.createFormSection()
            }
        }
    }
    
    // item -> group -> section
    private func createPhotoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(185), heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 30, bottom: 30, trailing: 30)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func createTagSection() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                               heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [.init(layoutSize: groupSize)])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: nil)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createFormSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(185))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        return section
    }
}

extension AddPostView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return presenter.photos.count
        case 1:
            return presenter.tag.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPostPhotoCell.reuseId, for: indexPath) as! AddPostPhotoCell
            let image = presenter.photos[indexPath.row]
            cell.setCellImage(image: image)
            
            cell.completion = { [weak self] in
                self?.delegate?.deletePhoto(index: indexPath.row)
                self?.presenter.photos.remove(at: indexPath.row)
                self?.collectionView.reloadData()
            }
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPostTagCell.reuseId, for: indexPath) as! AddPostTagCell
            cell.setTagText(tagText: presenter.tag[indexPath.row], tagIndex: indexPath.row)
            cell.deleteCompletion = { [weak self] in
                guard let self = self else { return }
                presenter.tag.remove(at: $0)
                collectionView.reloadSections(.init(integer: 1))
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPostFieldCell.reuseId, for: indexPath) as! AddPostFieldCell
            cell.delegate = self
            return cell
        }
    }
}

extension AddPostView: AddPostViewDelegate {
    func addTag(tag: String?) {
        guard let tag else { return }
        presenter.tag.append(tag)
        collectionView.reloadSections(.init(integer: 1))
    }
    
    func addDescription(text: String?) {
        guard let text else { return }
        presenter.postDescription = text
    }
}
