//
//  Extensions.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 22/7/2021.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension UITextView {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font?.pointSize ?? 12)\">%@</span>", htmlText)

        let attrStr = try? NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true) ?? Data(),
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr ?? NSAttributedString(string: "error")
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

// Decodes .json data for SwiftUI Previews https://www.hackingwithswift.com/books/ios-swiftui/using-generics-to-load-any-kind-of-codable-data
extension Bundle {
    func decode<T: Codable>(_ file: String, dateFormat: String? = nil) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("unable to find data")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            print(error)
            fatalError("Data does not conform to desired structure")
        }
    }
}

extension String {
  public var initials: String {
    var finalString = String()
    var words = components(separatedBy: .whitespacesAndNewlines)
    
    if let firstCharacter = words.first?.first {
      finalString.append(String(firstCharacter))
      words.removeFirst()
    }
    
    if let lastCharacter = words.last?.first {
      finalString.append(String(lastCharacter))
    }
    
    return finalString.uppercased()
  }
}

extension Date {
    func daysFrom(date: Date) -> Int {
        let difference = Calendar.current.dateComponents([.day], from: self, to: date)
        return difference.day ?? 0
    }
    
    func humanReadableDistanceFrom(_ date: Date) -> String {
        // Opens in 55m
        // Opens at 6pm
        let days = daysFrom(date: date)
        let weeks = days / 7

        if weeks != 0 {
            return "\(weeks) week from now"
        } else {
            if (days == 0) {
                return "TODAY"
            } else if (days == 1) {
                return "1 day from now"
            } else {
                return "\(days) days from now"
            }
        }
    }
    
    static func humanReadableDuration(from start: Date, to end: Date) -> String {
        if (start.month == end.month && start.day == end.day) {
            return "\(start.dayOfWeek), \(start.monthAbbreviated()) \(start.day) | \(start.hourMinute(showSuffix: false)) - \(end.hourMinute())"
        } else {
            return "\(start.dayOfWeek), \(start.monthAbbreviated()) \(start.day) - \(end.dayOfWeek), \(end.monthAbbreviated()) \(end.day)"
        }
    }
    
    func monthDay() -> String {
        if (Date().day == self.day && Date().month == self.month) {
            return "today"
        } else {
            return "\(self.monthAbbreviated()) \(self.day)"
        }
    }
    
    static func humanReadableDurationSameDay(from start: Date, to end: Date) -> String {
        return "\(start.hourMinute(showSuffix: false)) - \(end.hourMinute())"
    }
    
    func nearestHour() -> Date {
        if self.minutes == 0 {
            return self
        } else {
            return self.advanced(by: (Double) (60 - self.minutes) * 60)
        }
    }
    
    var dayOfWeek: String {
        let weekdayArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        myCalendar.timeZone = TimeZone(abbreviation: "EST")!
        let myComponents = myCalendar.components(.weekday, from: self)
        let weekDay = myComponents.weekday!
        return weekdayArray[weekDay-1]
    }
    
    
    var minutes: Int {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: self)
        return minute
    }
    
    var day: Int {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        return day
    }
    
    var month: Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        return month
    }
    
    func monthAbbreviated() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        return formatter.string(from: self)
    }

    func hourMinute(showSuffix: Bool = true) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "EST")
        
        if showSuffix {
            formatter.dateFormat = "h:mm a"
        } else {
            formatter.dateFormat = "h:mm"
        }
        
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        return formatter.string(from: self)
    }
}
