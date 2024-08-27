import UIKit

protocol PhotoViewProtocol: AnyObject {
    var closeButtonAction: UIAction { get set }
}

class PhotoView: UIViewController, PhotoViewProtocol {
    
    var completion: (() -> ())?
    var presenter: PhotoViewPresenterProtocol!
    
    lazy var closeButtonAction = UIAction { [weak self] _ in
        self?.completion?()
    }
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: view.bounds.width - 60, y: 60, width: 25, height: 25), primaryAction: closeButtonAction)
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: view.bounds)
        scroll.delegate = self
        scroll.backgroundColor = .appBlack
        scroll.maximumZoomScale = 10
        scroll.addSubview(image)
        
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        
        return scroll
    }()
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = presenter.image
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture )
        
        return imageView
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 2
        gesture.addTarget(self, action: #selector(zoomImage))
        
        return gesture
    }()
    
    @objc func zoomImage() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            if self?.scrollView.zoomScale ?? 1 > 1 {
                self?.scrollView.zoomScale = 1
            } else {
                self?.scrollView.zoomScale = 2
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        view.addSubview(closeButton)
        setImageSize()
    }
    
    private func setImageSize() {
        let imageSize = image.image?.size
        let imageHeight = imageSize?.height ?? 0
        let imageWidth = imageSize?.width ?? 0
        
        let ratio = imageHeight / imageWidth
        
        image.frame.size = CGSize(width: view.frame.width, height: view.frame.width * ratio)
        image.center = view.center
    }
}

extension PhotoView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > view.frame.height {
            image.center.y = scrollView.contentSize.height / 2
        } else {
            image.center.y = view.center.y
        }
    }
}
