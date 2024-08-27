import UIKit

protocol CollectionViewProtocol {
    static var reuseId: String { get }
    init(frame: CGRect)
}

class TagCollectionViewCell: UICollectionViewCell, CollectionViewProtocol  {
    static let reuseId = "TagCollectionCell"
    
    lazy var tagView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.2)
        view.layer.cornerRadius = 15
        view.addSubview(self.tagLabel)
        
        return view
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tagView)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            tagView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagView.topAnchor.constraint(equalTo: topAnchor),
            tagView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tagLabel.topAnchor.constraint(equalTo: tagView.topAnchor, constant: 5),
            tagLabel.bottomAnchor.constraint(equalTo: tagView.bottomAnchor, constant: -5),
            tagLabel.leadingAnchor.constraint(equalTo: tagView.leadingAnchor, constant: 20),
            tagLabel.trailingAnchor.constraint(equalTo: tagView.trailingAnchor, constant: -20),
        ])
    }
    
    func cellConfig(tagText: String) {
        self.tagLabel.text = tagText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
