//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public struct NewsCategory {
    
    /// The slug identifying this category.
    public var slug: String
    
    /// The name of this category.
    public var name: String
    
    /// Initializes the category using the given attributes.
    /// - Parameters:
    ///   - slug: slug
    ///   - name: name
    public init(slug: String, name: String) {
        self.slug = slug
        self.name = name
    }
    
    /// Initializes the category using the given slug.
    ///
    /// Derives the name from the slug.
    ///
    /// - Parameter slug: slug
    public init(slug: String) {
        let name = slug
            .split(separator: "-")
            .map { String($0) }
            .map { $0 == "and" ? "&" : $0.capitalized }
            .joined(separator: " ")
        
        self.init(slug: slug, name: NSLocalizedString(name, comment: "NewsCategory Name"))
    }
    
}

extension NewsCategory: Equatable {
    
    public static func == (lhs: NewsCategory, rhs: NewsCategory) -> Bool {
        lhs.slug == rhs.slug
    }
    
}

extension NewsCategory: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(slug)
    }
    
}

extension NewsCategory: Identifiable {
    
    public var id: String { slug }
    
}

extension NewsCategory: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let slug = try container.decode(String.self)
        self.init(slug: slug)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(slug)
    }
    
}

extension NewsCategory: CustomStringConvertible {
    
    public var description: String { name }
    
}

extension NewsCategory {
    
    public static let business = NewsCategory(slug: "business")
    public static let entertainment = NewsCategory(slug: "entertainment")
    public static let general = NewsCategory(slug: "general")
    public static let health = NewsCategory(slug: "health")
    public static let science = NewsCategory(slug: "science")
    public static let sports = NewsCategory(slug: "sports")
    public static let technology = NewsCategory(slug: "technology")
    
}

extension Array where Element == NewsCategory {
    
    /// Array of all categories available in filteringn sources and top headlines.
    public static let availableCategories: [NewsCategory] = [.business, .entertainment, .general, .health, .science, .sports, .technology]
        .sorted(by: { $0.name < $1.name })
    
}

extension URLQueryItem {
    
    /// Initializes a URL query item with the given category.
    /// - Parameter category: category
    init(category: NewsCategory) {
        self.init(name: "category", value: category.slug)
    }
    
}
