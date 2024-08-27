import Foundation

extension StringProtocol {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
