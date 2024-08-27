 import UIKit

class MainPostHeader: UICollectionReusableView {
    static let reuseId = "MainPostHeader"
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.frame = CGRect(x: 30, y: 0, width: frame.width, height: frame.height)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerLabel)
    }
    
    func setHeaderText(header: String?) {
        headerLabel.text = header
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
