import UIKit

class SettingViewCell: UITableViewCell {
    
    static let reuseId = "SettingCell"
    
    var completion: (() -> ())?
    
    lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appMain
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.addSubview(stackView )
        
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(cellLabel)
        
        return stack
    }()
    
    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }()
    
    private lazy var locationSwitch: UISwitch = {
        let switchLoc = UISwitch()
        switchLoc.onTintColor = .appBlack
        
        return switchLoc
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(primaryAction: nextButtonAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25 ).isActive = true
        
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var nextButtonAction = UIAction { [weak self] _ in
        self?.completion?()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellView)
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetup(cellType: SettingItems) {
        switch cellType {
            
        case .password, .delete:
            self.stackView.addArrangedSubview(nextButton)
        case .location:
            self.stackView.addArrangedSubview(locationSwitch)
        }
        
        cellLabel.text = cellType.rawValue
    }
}
