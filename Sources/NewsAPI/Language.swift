//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public struct Language {
    
    /// The two-letter ISO 639-1 lanaguage code.
    public var code: String
    
    /// The name of this language.
    public var name: String
    
    /// Initializes the language using the given two-letter language code.
    /// - Parameters:
    ///   - code: ISO 639-1 laanguage code (two letters)
    ///   - name: language name
    public init(code: String, name: String) {
        self.code = code
        self.name = name
    }
    
    /// Initializes the language using the given two-letter language code.
    ///
    /// The name of the language is determined by the current locale.
    ///
    /// - Parameter code: ISO 639-1 language code (two letters)
    public init(code: String) {
        let name = Locale.current.localizedString(forLanguageCode: code) ?? code
        
        self.init(code: code, name: name)
    }
    
    /// Attempts to initialize the language from the given locale.
    ///
    /// Returns `nil` if the locale does not have an ISO 639-1 language code.
    ///
    /// - Parameter locale: the locale
    public init?(locale: Locale) {
        guard var code = locale.languageCode, code.count >= 2 else { return nil }
        code = String(code.prefix(2))
        
        let name = locale.localizedString(forLanguageCode: code) ?? code
        
        self.init(code: code, name: name)
    }
    
    /// The language matching the current locale, if available.
    public static var current: Language? { Language(locale: .current) }
    
}

extension Language: Equatable {
    
    public static func == (lhs: Language, rhs: Language) -> Bool {
        lhs.code == rhs.code
    }
    
}

extension Language: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
}

extension Language: Identifiable {
    
    public var id: String { code }
    
}

extension Language: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        self.init(code: code)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(code)
    }
    
}

extension Language: CustomStringConvertible {
    
    public var description: String { name }
    
}

extension Language {
    
    public static let arabic = Language(code: "ar")
    public static let german = Language(code: "de")
    public static let english = Language(code: "en")
    public static let spanish = Language(code: "es")
    public static let french = Language(code: "fr")
    public static let hebrew = Language(code: "he")
    public static let italian = Language(code: "it")
    public static let dutch = Language(code: "nl")
    public static let norwegian = Language(code: "no")
    public static let portuguese = Language(code: "pt")
    public static let russian = Language(code: "ru")
    public static let sami = Language(code: "se")
    // unmapped language code: "ud"
    public static let chinese = Language(code: "zh")
    
}

extension Array where Element == Language {
    
    /// Array of all languages available in filtering sources and articles.
    public static let availableLanguages: [Language] = [.arabic, .german, .english, .spanish, .french, .hebrew, .italian, .dutch, .norwegian, .portuguese, .russian, .sami, Language(code: "ud"), .chinese]
        .sorted(by: { $0.name < $1.name })
    
}

extension URLQueryItem {
    
    /// Initializes a URL query item with the given language.
    /// - Parameter language: language
    init(language: Language) {
        self.init(name: "language", value: language.code)
    }
    
}
