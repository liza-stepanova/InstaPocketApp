import UIKit

class AddPostFieldCell: UICollectionViewCell, CollectionViewProtocol {
    static var reuseId: String = "AddPostFieldCell"
    
    var tagCompletion: ( (String?) -> () )?
    weak var delegate: AddPostViewDelegate?
    
    private lazy var tagField: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 48), primaryAction: tagfieldAction)
        field.backgroundColor = .appBlack
        field.attributedPlaceholder = NSAttributedString(string: "Добавить тэг", attributes:
                                    [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 1))
        field.leftViewMode = .always
        field.layer.cornerRadius = 24
        field.textColor = .white
        field.font = UIFont.systemFont(ofSize: 15)
        
        return field
    }()
    
    private lazy var tagfieldAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        delegate?.addTag(tag: tagField.text)
        tagField.text = ""
        
    }
    
    private lazy var textView: UITextView = {
        let view = UITextView(frame: CGRect(x: 0, y: 68, width: bounds.width, height: 115))
        view.backgroundColor = .appBlack
        view.layer.cornerRadius = 30
        view.textColor = .white
        view.font = .systemFont(ofSize: 15)
        view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(placeholder)
        view.delegate = self
        
        return view
    }()
    
    private lazy var placeholder: UILabel = {
        let label = UILabel(frame: CGRect(x: 24, y: 19, width: 150, height: 20))
        label.text = "Добавить описание"
        label.textColor = UIColor.white.withAlphaComponent(0.4)
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tagField)
        addSubview(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension AddPostFieldCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 {
            placeholder.isHidden = false
        } else {
            placeholder.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.addDescription(text: textView.text)
    }
}
