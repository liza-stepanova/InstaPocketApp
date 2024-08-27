import UIKit

class DetailDescriptionCell: UICollectionViewCell, CollectionViewProtocol {
    static var reuseId: String = "DetailDescriptionCell"
    
    lazy var dateTextLabel = UILabel()
    lazy var descriptionTextLabel = UILabel()
    
    lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 7
        stack.alignment = .leading
        
        return stack
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cellStack)
        backgroundColor = .appBlack
        layer.cornerRadius = 30
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            cellStack.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            cellStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            cellStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            cellStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ])
    }
    
    func configureCell(date: Date?, text: String) {
        if date != nil {
            dateTextLabel = createCellLabel(text: date?.formattDate(type: .full) ?? "", weight: .bold)
            cellStack.addArrangedSubview(dateTextLabel)
        }
        descriptionTextLabel = createCellLabel(text: text, weight: .regular)
        cellStack.addArrangedSubview(descriptionTextLabel)
    }
    
    private func createCellLabel(text: String, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: weight)
        label.textColor = .white
        
        return label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
