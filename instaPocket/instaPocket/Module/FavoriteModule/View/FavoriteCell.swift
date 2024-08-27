import UIKit

class FavoriteCell: UICollectionViewCell, CollectionViewProtocol {
    static let reuseId = "FavoriteCell"
    var completion: ( () -> Void )?
    
    lazy var postImage: UIImageView = {
        let post = UIImageView(frame: bounds)
        post.contentMode = .scaleAspectFill
        post.clipsToBounds = true
        
        return post
    }()
    
    lazy var removeInFavoriteButton: UIButton = {
        let button = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
            self?.completion?()
        }))
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .appMain
        button.frame = CGRect(x: bounds.width -  43, y: 21, width: 28, height: 25)
        return button
    }()
    
    lazy var dateView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 10, y: bounds.height - 47, width: bounds.width - 20, height: 27)
        view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        view.layer.cornerRadius = 14
        view.addSubview(dateLabel)
        
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.frame = CGRect(x: 0, y: 0, width: bounds.width - 20, height: 27)
        label.textAlignment = .center
        
        return label
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        [postImage, removeInFavoriteButton, dateView].forEach {
            addSubview($0)
        }
        
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    func configureCell(item: PostItem) {
        postImage.image = .getOnePhoto(folderId: item.id ?? "", photo: item.photos.first ?? "")
        dateLabel.text = item.date.formattDate(type: .full)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
