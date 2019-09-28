// swiftlint:disable all
// Created by Jamal alayq
// gamalal3yk@gmail.com

import Foundation

public struct PhoneNumber: ExpressibleByStringLiteral, CustomStringConvertible {
    
    // var value: String
    public private(set) var value: String
    var dialCode = String()
    
    public init(stringLiteral value: String) {
        self = PhoneNumber(value.cleaned)
    }
    
    public init(_ value: String) {
        self.value = value.cleaned
    }
    
    public var description: String {
        return "Phone number value: \(value)"
    }
    
    public var isValid: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(
                in: value,
                options: [],
                range: .init(location: 0, length: value.count)
            )
            if let result = matches.first {
                let isMobile = result.resultType == .phoneNumber
                return isMobile && result.range.location == 0 && result.range.length == value.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// Convert other language numbers to english number
    ///
    /// - Returns: Instance from PhoneNumber
    public mutating func converted() -> PhoneNumber {
        let formatter = NumberFormatter()
        let number = formatter.number(from: value) ?? .init()
        self.value = formatter.string(from: number) ?? .empty
        return .init(self.value)
    }
    
    /// Remove country dial code from number
    ///
    /// - Returns: new instance from PhoneNumber with without dial code
    public mutating func separated() -> Self {
        if dialCode.isEmpty { fatalError("Can't pass empty dial code.") }
        dialCode = dialCode.replacingOccurrences(of: "+", with: String.empty)
        if value.hasPrefix("0") {
            self.value = value.replacingOccurrences(of: "0", with: String.empty, options: .numeric, range: value.range(of: "0"))
        }
        if value.hasPrefix(dialCode) {
            self.value = value.replacingOccurrences(of: dialCode,
                                                    with: String.empty,
                                                    options: .numeric,
                                                    range: value.range(of: dialCode))
        }
        return .init(self.value)
    }
    
    public enum PhoneNumberErrors: Error {
        case invalidMobile
    }
    
}

// MARK:- Codablity

extension PhoneNumber: Codable {
    
    public init(from decoder: Decoder) throws {
        if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
            value = stringValue
            return
        }
        if let numberValue = try? decoder.singleValueContainer().decode(UInt64.self) {
            value = "\(numberValue)"
            return
        }
        throw PhoneNumberErrors.invalidMobile
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
}


// MARK:- Conform equatability

extension PhoneNumber: Equatable {
    
    public static func == (lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        return lhs.value == rhs.value && lhs.isValid && rhs.isValid
    }
    
}

// MARK:- Hashing

extension PhoneNumber: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
}

// MARK:- Helpers

fileprivate extension String {
    
    var cleaned: Self {
        return replacingOccurrences(of: "+", with: String.empty)
            .replacingOccurrences(of: "(", with: String.empty)
            .replacingOccurrences(of: ")", with: String.empty)
            .replacingOccurrences(of: "-", with: String.empty)
    }
    
    static var empty: Self { "" }
    
}

