import UIKit

extension UIView {
    func setViewGradient(frame: CGRect, startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor], location: [NSNumber]) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{ $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = location
        
        self.layer.addSublayer(gradient)
    }
}
