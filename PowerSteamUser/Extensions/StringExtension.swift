//
//  StringExtension.swift
//  Supership
//
//  Created by Mac on 8/8/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

extension String {
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        
        return String(self[start..<end])
    }
    
    func substring(from: Int) -> String {
        return from < self.count ? self[from..<self.count] : ""
    }
    
    func substring(to: Int) -> String {
        return self[0..<(to + 1)]
    }
    
    func stringHeightWithMaxWidth(_ maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font : font]
        let size: CGSize = self.boundingRect(
            with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
            ).size
        
        return size.height
    }
    
    func evaluateStringWidth(_ font: UIFont) -> CGFloat {
        //let font = UIFont.systemFontOfSize(15)
        let attributes = NSDictionary(object: font, forKey:NSAttributedString.Key.font as NSCopying)
        let sizeOfText = self.size(withAttributes: (attributes as! [NSAttributedString.Key : Any]))
        
        return sizeOfText.width
    }
    
    func intValue() -> Int {
        if let value = Int(self) {
            return value
        }
        
        return 0
    }
    
    func floatValue() -> Float {
        if let value = Float(self) {
            return value
        }
        
        return 0.0
    }
    
    func doubleValue() -> Double {
        if let value = Double(self) {
            return value
        }
        
        return 0.0
    }
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func numbersOnly() -> String {
        return self.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
    }
    
    func isValidUsername() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "([一-龯]+|[ぁ-んァ-ン]+|[a-zA-Z0-9]+|[ａ-ｚＡ-Ｚ０-９]+)$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidBankAccount() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "([ァ-ン]+|[a-zA-Z0-9]+|[ａ-ｚＡ-Ｚ０-９]+|\\(|\\)|\\.|\\-|\\/| |¥|,|「|」)$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidPassword() -> Bool {
        //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,12}"
        let stricterFilterString = "^.{6,12}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        
        return passwordTest.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
        
        if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, count)).first?.phoneNumber {
            return match == self
        } else {
            return false
        }
    }
}

// MARK: - HTML attribute

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func formatHTML() -> String {
        let modifiedFont = String(format:"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"w3.org/1999/xhtml\" lang=\"it\" dir=\"ltr\"><html><head><title>Receigo</title></head><body><style type='text/css'>img {width:100%@ %@important;height: auto !important;}</style>%@</body></html>", "%", "!", self)
        
        return modifiedFont
    }
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}








