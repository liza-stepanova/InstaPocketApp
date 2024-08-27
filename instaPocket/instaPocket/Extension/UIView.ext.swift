import UIKit

extension UIView {
    static func confifure<T: UIView>(view: T, block: @escaping (T) -> ()) -> T {
        view.translatesAutoresizingMaskIntoConstraints = false
        block(view)
        return view
    }
}
