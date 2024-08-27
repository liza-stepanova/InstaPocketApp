import UIKit

extension Date {
    func getDateDifference() -> String {
        let currentDateInterval = Int(Date.timeIntervalSinceReferenceDate)
        let dateDifferences = Double(currentDateInterval - Int(self.timeIntervalSinceReferenceDate))
        let dateDifferencesDate = Int(round(dateDifferences / 86400))
        
        switch dateDifferencesDate{
        case 0:
            return "Сегодня"
        case 1:
            return "Вчера"
        case 2...4:
            return "\(dateDifferencesDate) дня назад"
        default:
            return "\(dateDifferencesDate) дней назад"
        }
    }
    
    func formattDate(type: DateFormatType) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        
        switch type {
        case .full:
            formatter.dateFormat = "dd MMMM yyyy"
        case .onlyDate:
            formatter.dateFormat = "dd MMMM"
        case .onlyYear:
            formatter.dateFormat = "yyyy"
        }
        
        return formatter.string(from: self)
    }
    
}

enum DateFormatType {
    case full, onlyYear, onlyDate
}
