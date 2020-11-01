//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public struct Country {
    
    /// The two-letter ISO 3166-1 alpha-2 country code.
    public var code: String
    
    /// The name of this country.
    public var name: String
    
    /// The flag emoji matching this country.
    public var flag: String
    
    /// Initializes the country using the given two-letter country code.
    /// - Parameters:
    ///   - code: ISO 3166-1 alpha-2 country code (two letters)
    ///   - name: country name
    ///   - flag: flag emoji
    public init(code: String, name: String, flag: String) {
        self.code = code
        self.name = name
        self.flag = flag
    }
    
    /// Initializes the country using the given two-letter country code.
    ///
    /// The name of the country is determined by the current locale. The flag is derived from the cuntry code.
    /// - Parameter code: ISO 3166-1 alpha-2 country code (two letters)
    public init(code: String) {
        var flag = ""
        if code == "zh" {
            flag = "🇨🇳"
        } else {
            for unicodeScalar in code.uppercased().unicodeScalars {
                guard let next = UnicodeScalar(127397 + unicodeScalar.value) else { continue }
                flag.append(String(next))
            }
        }
        
        let name = Locale.current.localizedString(forRegionCode: code) ?? code
        
        self.init(code: code, name: name, flag: flag)
    }
    
    /// Attempts to initialize the country from the given locale.
    ///
    /// Returns `nil` if the locale does not have an ISO 3166-1 alpha-2 country code.
    ///
    /// - Parameter locale: the locale
    public init?(locale: Locale) {
        guard var code = locale.regionCode, code.count >= 2 else { return nil }
        code = String(code.prefix(2)).lowercased()
        
        self.init(code: code)
    }
    
    /// The country matching the current locale, if available.
    public static var current: Country? { Country(locale: .current) }
    
}

extension Country: Equatable {
    
    public static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.code == rhs.code
    }
    
}

extension Country: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
}

extension Country: Identifiable {
    
    public var id: String { code }
    
}

extension Country: Codable {
    
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

extension Country: CustomStringConvertible {
    
    public var description: String { name }
    
}

extension Country {
    
    public static let unitedArabEmirates = Country(code: "ae")
    public static let argentina = Country(code: "ar")
    public static let austria = Country(code: "at")
    public static let australia = Country(code: "au")
    public static let belgium = Country(code: "be")
    public static let bulgaria = Country(code: "bg")
    public static let brazil = Country(code: "br")
    public static let canada = Country(code: "ca")
    public static let switzerland = Country(code: "ch")
    public static let china = Country(code: "cn")
    public static let colombia = Country(code: "co")
    public static let cuba = Country(code: "cu")
    public static let czechia = Country(code: "cz")
    public static let germany = Country(code: "de")
    public static let egypt = Country(code: "eg")
    public static let france = Country(code: "fr")
    public static let unitedKingdom = Country(code: "gb")
    public static let greece = Country(code: "gr")
    public static let hongKong = Country(code: "hk")
    public static let hungary = Country(code: "hu")
    public static let indonesia = Country(code: "id")
    public static let ireland = Country(code: "ie")
    public static let israel = Country(code: "il")
    public static let india = Country(code: "in")
    public static let italy = Country(code: "it")
    public static let japan = Country(code: "jp")
    public static let korea = Country(code: "kr")
    public static let lithuania = Country(code: "lt")
    public static let latvia = Country(code: "lv")
    public static let morocco = Country(code: "ma")
    public static let mexico = Country(code: "mx")
    public static let malaysia = Country(code: "my")
    public static let nigeria = Country(code: "ng")
    public static let netherlands = Country(code: "nl")
    public static let norway = Country(code: "norway")
    public static let newZealand = Country(code: "nz")
    public static let philippines = Country(code: "ph")
    public static let poland = Country(code: "pl")
    public static let portugal = Country(code: "pt")
    public static let romania = Country(code: "ro")
    public static let serbia = Country(code: "rs")
    public static let russia = Country(code: "ru")
    public static let saudiArabia = Country(code: "sa")
    public static let sweden = Country(code: "se")
    public static let singapore = Country(code: "sg")
    public static let slovenia = Country(code: "si")
    public static let slovakia = Country(code: "sk")
    public static let thailand = Country(code: "th")
    public static let turkey = Country(code: "tr")
    public static let taiwan = Country(code: "tw")
    public static let ukraine = Country(code: "ua")
    public static let unitedStates = Country(code: "us")
    public static let venezuela = Country(code: "ve")
    public static let southAfrica = Country(code: "za")
    
}

extension Array where Element == Country {
    
    /// Array of all countries availabel in filtering sources and top headlines.
    public static let availableCountries: [Country] = [.unitedArabEmirates, .argentina, .austria, .australia, .belgium, .bulgaria, .brazil, .canada, .switzerland, .china, .colombia, .cuba, .czechia, .germany, .egypt, .france, .unitedKingdom, .greece, .hongKong, .hungary, .indonesia, .ireland, .israel, .india, .italy, .japan, .korea, .lithuania, .latvia, .morocco, .mexico, .malaysia, .nigeria, .netherlands, .norway, .newZealand, .philippines, .poland, .portugal, .romania, .serbia, .russia, .saudiArabia, .sweden, .singapore, .slovenia, .slovakia, .thailand, .turkey, .taiwan, .ukraine, .unitedStates, .venezuela, .southAfrica]
        .sorted(by: { $0.name < $1.name })
    
}

extension URLQueryItem {
    
    /// Initializes a URL query item with the given country.
    /// - Parameter country: country
    init(country: Country) {
        self.init(name: "country", value: country.code)
    }
    
}
