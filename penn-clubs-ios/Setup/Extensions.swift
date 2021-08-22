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
        
//        guard let decoded = try? decoder.decode(T.self, from: data) else {
//            fatalError("Data does not conform to desired structure")
//        }
        
       
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
