import UIKit

class DetailPhotoCell: UICollectionViewCell, CollectionViewProtocol  {
    static var reuseId: String = "DetailPhotoCell"
    
    lazy var cellImage: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var imageMenuButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ellipsis")!, for: .normal)
        button.frame = CGRect(x: cellImage.frame.width - 50, y: 30, width: 32, height: 9)
        button.tintColor = .white
        
        return button
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 30
        clipsToBounds = true
        addSubview(cellImage)
        cellImage.addSubview(imageMenuButton )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(postId: String, image: String) {
        cellImage.image = .getOnePhoto(folderId: postId, photo: image)
    }
}
