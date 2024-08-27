import UIKit

class MainPostCell: UICollectionViewCell, CollectionViewProtocol {
    static let reuseId = "MainPostCell"
    
    private var tags: [String] = []
    var completion: (() -> Void)?
    
    private var tagCollectionView: UICollectionView!
    private var photoCountLabel = UILabel()
    private var commentCountLabel = UILabel()
    private var postDescriptionLabel = UILabel()
    
    lazy var postImage: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var countLabelsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        stack.addArrangedSubview(self.photoCountLabel)
        stack.addArrangedSubview(self.commentCountLabel)
        stack.addArrangedSubview(UIView())
        
        return stack
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
            self?.completion?()
        }))
        button.frame = CGRect(x: bounds.width - 60, y: 35, width: 34, height: 27)
        button.tintColor = .appMain
        
        return button
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentViewConfig()
    }
    
    private func contentViewConfig() {
        addSubview(postImage)
        addSubview(favoriteButton)
        layer.cornerRadius = 30
        clipsToBounds = true
        
        setViewGradient(frame: bounds, startPoint: CGPoint(x: 0.5, y: 1), endPoint: CGPoint(x: 0.5, y: 0.5), colors: [.black, .clear], location: [0, 1])
    }
    
    override func prepareForReuse() {
        tagCollectionView.removeFromSuperview()
        postDescriptionLabel.removeFromSuperview()
    }
    
    func configureCell(item: PostItem) {
        favoriteButton.setBackgroundImage(UIImage(systemName: item.isFavorite ? "heart.fill" : "heart"), for: .normal)
        
        tags = item.tags ?? []
        let tagCollection: TagCollectionViewProtocol = TagCollectionView(dataSource: self)
        tagCollectionView = tagCollection.getCollectionView()
        
        postImage.image = UIImage.getCoverPhoto(folderId: item.id ?? "", photos: item.photos)
        
        photoCountLabel = getCellLabel(text: "\(item.photos.count) фото")
        commentCountLabel = getCellLabel(text: "\(item.comments?.count ?? 0 ) комментариев")
        postDescriptionLabel = getCellLabel(text: item.postDescription ?? "")
        
        addSubview(countLabelsStack)
        addSubview(tagCollectionView)
        addSubview(postDescriptionLabel)
        
        NSLayoutConstraint.activate([
            postDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            postDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            postDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            
            tagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagCollectionView.bottomAnchor.constraint(equalTo: postDescriptionLabel.topAnchor, constant: -10),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            countLabelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            countLabelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            countLabelsStack.bottomAnchor.constraint(equalTo: tagCollectionView.topAnchor, constant: -8)
        ])
    }
    
    private func getCellLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainPostCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseId, for: indexPath) as! TagCollectionViewCell
        
        let tag = tags[indexPath.row]
        cell.cellConfig(tagText: tag)
        
        return cell
    }
    
    
}
