import UIKit

class AddPostPhotoCell: UICollectionViewCell, CollectionViewProtocol {
    static var reuseId: String = "AddPostPhotoCell"
    
    var completion: (() -> ())?
    
    private lazy var cellImage: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var photoRemoveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: cellImage.frame.width - 35, y: 20, width: 15, height: 15), primaryAction: photoRemoveAction)
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var photoRemoveAction = UIAction { [weak self] _ in
        self?.completion?()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cellImage)
        layer.cornerRadius = 30
        clipsToBounds = true
        cellImage.addSubview(photoRemoveButton)
    }
    
    func setCellImage(image: UIImage) {
        cellImage.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
