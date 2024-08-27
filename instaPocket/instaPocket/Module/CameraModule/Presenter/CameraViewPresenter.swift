import UIKit

protocol CameraViewPresenterProtocol: AnyObject {
    init(view: CameraViewProtocol, cameraService: CameraServiceProtocol)
    var photos: [UIImage] { get set }
    var cameraService: CameraServiceProtocol { get set }
    
    var closeViewAction: UIAction? { get set }
    var switchCamera: UIAction? { get set }
    
    func deletePhoto(index: Int)
}

class CameraViewPresenter: CameraViewPresenterProtocol {
    var cameraService: CameraServiceProtocol
    
    private weak var view: CameraViewProtocol?
    
    required init(view: CameraViewProtocol, cameraService: CameraServiceProtocol) {
        self.view = view
        self.cameraService = cameraService
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeView), name: .dismissCameraView, object: nil)
    }
    
    var photos: [UIImage] = []
    
    lazy var closeViewAction: UIAction? = UIAction { [weak self] _ in
        self?.closeView()
    }
    
    lazy var switchCamera: UIAction? = UIAction { [weak self] _ in
        self?.cameraService.switchCamera()
    }
    
    func deletePhoto(index: Int) {
        self.photos.remove(at: index)
    }
    
    @objc func closeView() {
        NotificationCenter.default.post(name: .goToMain, object: nil)
        self.cameraService.stopSession()
    }
}
