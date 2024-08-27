import UIKit

class AddPostTagCell: UICollectionViewCell, CollectionViewProtocol {
    static var reuseId: String = "AddPostTagCell"
    private var tagIndex = 0
    
    var deleteCompletion: ( (Int) -> () )?
    
    private lazy var tagView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.2)
        view.layer.cornerRadius = 14
        view.addSubview(tagStack)
        
        return view
    }()
    
    private lazy var tagStack: UIStackView = {
        let tagStack = UIStackView()
        tagStack.translatesAutoresizingMaskIntoConstraints = false
        tagStack.axis = .horizontal
        tagStack.spacing = 15
        
        tagStack.addArrangedSubview(tagLabel)
        tagStack.addArrangedSubview(tagButton)
        
        return tagStack
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var tagButton: UIButton = {
        let button = UIButton(primaryAction: removeAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 11).isActive = true
        button.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        return button
    }()
    
    private lazy var removeAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        deleteCompletion?(tagIndex)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tagView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tagView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagView.topAnchor.constraint(equalTo: topAnchor),
            tagView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tagStack.topAnchor.constraint(equalTo: tagView.topAnchor, constant: 7),
            tagStack.bottomAnchor.constraint(equalTo: tagView.bottomAnchor, constant: -7),
            tagStack.leadingAnchor.constraint(equalTo: tagView.leadingAnchor, constant: 20),
            tagStack.trailingAnchor.constraint(equalTo: tagView.trailingAnchor, constant: -20),
        ])
    }
    
    func setTagText(tagText: String, tagIndex: Int) {
        self.tagLabel.text = tagText
        self.tagIndex = tagIndex
    }
    
}
