import UIKit

protocol TagCollectionViewProtocol: AnyObject {
    var dataSource: UICollectionViewDataSource { get set }
    var isEditing: Bool { get set }
    
    init(dataSource: UICollectionViewDataSource)
    
    func getCollectionView() -> UICollectionView
}

class TagCollectionView: TagCollectionViewProtocol {
    var dataSource: UICollectionViewDataSource
    var isEditing: Bool = false
    
    required init(dataSource: UICollectionViewDataSource) {
        self.dataSource = dataSource
    }
    
    func getCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self.dataSource
        collectionView.backgroundColor = .clear
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.reuseId)
        
        return collectionView
    }
    
    
}
