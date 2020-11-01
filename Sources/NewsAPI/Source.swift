//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public struct Source {
    
    /// The News API identifier of this source.
    public var id: String
    
    /// The source name.
    public var name: String
    
    /// An overview text describing this source. May be empty.
    public var overview: String
    
    /// The URL to the source's web site.
    public var url: URL?
    
    /// The category.
    public var category: Category
    
    /// The language.
    public var language: Language
    
    /// The country.
    public var country: Country
    
    /// Initializes a source.
    /// - Parameters:
    ///   - id: ID of the source
    ///   - name: name
    ///   - overview: overview text
    ///   - url: URL to the source's web site, or `nil` if not available
    ///   - category: category
    ///   - language: language
    ///   - country: country
    public init(id: String, name: String, overview: String, url: URL?, category: Category, language: Language, country: Country) {
        self.id = id
        self.name = name
        self.overview = overview
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
    
}

extension Source: Equatable {
    
    public static func == (lhs: Source, rhs: Source) -> Bool {
        lhs.id == rhs.id
    }
    
}

extension Source: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

extension Source: Identifiable {}

extension Source: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overview = "description"
        case url
        case category
        case language
        case country
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        
        var url: URL? = nil
        do {
            url = try container.decodeIfPresent(URL.self, forKey: .url)
        } catch {
            url = nil // ignoring any error decoding a URL
        }
        
        let category = try container.decode(Category.self, forKey: .category)
        let language = try container.decode(Language.self, forKey: .language)
        let country = try container.decode(Country.self, forKey: .country)
        
        self.init(id: id, name: name, overview: overview, url: url, category: category, language: language, country: country)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(overview, forKey: .overview)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encode(category, forKey: .category)
        try container.encode(language, forKey: .language)
        try container.encode(country, forKey: .country)
    }
    
}

extension URLQueryItem {
    
    init(sources: [Source]) {
        self.init(name: "sources", value: sources.map({ $0.id }).joined(separator: ","))
    }
    
}

extension Array where Element == Source {
    
    /// Returns a dictionary grouping all sources by their categories.
    /// - Returns: dictionary of sources by category
    public func groupedByCategory() -> [Category: [Source]] {
        let categories = Set(self.map { $0.category })
        var grouped: [Category: [Source]] = [:]
        
        for category in categories {
            grouped[category] = self.filter { $0.category == category }
        }
        
        return grouped
    }
    
}
