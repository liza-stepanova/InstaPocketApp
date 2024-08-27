import UIKit

class DetailAddCommentCell: UICollectionViewCell, CollectionViewProtocol {
    static var reuseId: String = "DetailAddCommentCell"
    
    var completion: ((String) -> ())?
    
    lazy var action = UIAction { [weak self] sender in
        let textField = sender.sender as! UITextField
        self?.completion?(textField.text ?? "")
        self?.endEditing(true)
    }
    
    lazy var textField: UITextField = {
        let field = UITextField(frame: bounds, primaryAction: action)
        field.backgroundColor = .white
        field.layer.cornerRadius = bounds.height / 2
        field.placeholder = "Добавить комментарий"
        field.setLeftOffset()
        
        return field
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
