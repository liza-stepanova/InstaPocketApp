import UIKit
import MapKit

class DetailMapCell: UICollectionViewCell, CollectionViewProtocol {
    static var reuseId: String = "DetailMapCell"
    
    lazy var mapView: MKMapView = {
        let map = MKMapView(frame: bounds)
        map.layer.cornerRadius = 30
        
        return map
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
    }
    
    func configureCell(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
