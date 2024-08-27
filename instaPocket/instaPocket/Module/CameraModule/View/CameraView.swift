import UIKit
import AVFoundation

protocol CameraViewDelegate {
    func deletePhoto(index: Int)
}

protocol CameraViewProtocol: AnyObject {
    
}

class CameraView: UIViewController, CameraViewProtocol {
    var presenter: CameraViewPresenterProtocol!
    
    lazy var shotsCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 60, width: view.frame.width - 110, height: 60 ), collectionViewLayout: UICollectionViewFlowLayout())
        let layout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "shotCell")
        collection.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.dataSource = self
        
        return collection
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: view.frame.width - 60, y: 60, width: 25, height: 25), primaryAction: presenter.closeViewAction)
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var shotButton: UIButton = {
        let button = UIButton(frame: CGRect(x: view.center.x - 30, y: view.frame.height - 110, width: 70, height: 70), primaryAction: shotAction)
        button.setBackgroundImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var switchButton: UIButton = {
        let button = UIButton(frame: CGRect(x: view.center.x - 90, y: view.frame.height - 88, width: 30, height: 25), primaryAction: presenter.switchCamera)
        button.setBackgroundImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(primaryAction: nextAction)
        button.setTitle("Далее", for: .normal)
        button.layer.opacity = 0.6
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBlack
        button.layer.cornerRadius = 17.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.frame.size = CGSize(width: 90, height: 35)
        button.frame.origin = CGPoint(x: shotButton.frame.origin.x + 100, y: shotButton.frame.origin.y + 17.5)
        
        return button
    }()
    
    private lazy var shotAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .off
        self.presenter.cameraService.output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    private lazy var nextAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        if let addPostVC = Builder.createAddPostViewController(photos: self.presenter.photos) as? AddPostView {
            addPostVC.delegate = self
            navigationController?.pushViewController(addPostVC, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermisions()
        setupPreviewLayer()

        view.backgroundColor = .gray
        view.addSubview(shotsCollectionView)
        view.addSubview(closeButton)
        view.addSubview(shotButton)
        view.addSubview(switchButton)
        view.addSubview(nextButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAllPhotos ), name: .dismissCameraView, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.cameraService.setupCaptureSession()
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide" : true])
    }
    
    private func checkPermisions() {
        let cameraStatusAuth = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraStatusAuth {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { auth in
                if !auth {
                    abort()
                }
            }
        case .restricted, .denied:
            abort()
        case .authorized:
            return
        default:
            fatalError()
        }
    }
    
    private func setupPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: presenter.cameraService.captureSession)
        
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    private func getImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 60, height: 60)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }
 
}

extension CameraView: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        if let image = UIImage(data: imageData) {
            presenter.photos.append(image)
            
            nextButton.layer.opacity = 1
            nextButton.isEnabled = true
            
            self.shotsCollectionView.reloadData()
        }
        
    }
}

extension CameraView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  presenter.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shotCell", for: indexPath)
        
        let photo = presenter.photos[indexPath.item]
        let imageView = self.getImageView(image: photo)
        cell.addSubview(imageView)
        
        return cell
    }
}

extension CameraView: CameraViewDelegate {
    @objc func deleteAllPhotos() {
        presenter.photos.removeAll()
        nextButton.layer.opacity = 0.6
        nextButton.isEnabled = false
        shotsCollectionView.reloadData()
    }
    
    func deletePhoto(index: Int) {
        presenter.deletePhoto(index: index)
        
        if presenter.photos.count == 0 {
            nextButton.layer.opacity = 0.6
            nextButton.isEnabled = false
        }
        shotsCollectionView.reloadData()
    }
}
