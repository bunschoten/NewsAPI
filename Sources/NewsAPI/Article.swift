//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public struct Article {
    
    /// The name of the author or authors.
    public var author: String?
    
    /// The title of the article.
    public var title: String
    
    /// Some overview text, usually the headline. May be empty.
    public var overview: String
    
    /// The URL of the website for this article.
    public var url: URL
    
    /// The URL to an image for this article.
    public var imageURL: URL?
    
    /// The date and time of publication.
    public var publicationDate: Date?
    
    /// The ID of the source.
    public var sourceId: String
    
}

extension Article: Equatable {
    
    public static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.url == rhs.url
    }
    
}

extension Article: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
    
}

extension Article: Identifiable {
    
    public var id: URL { url }
    
}

extension Article: Codable {
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case overview = "description"
        case url
        case imageURL = "urlToImage"
        case publicationDate = "publishedAt"
        case sourceId = "source"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let author = try container.decodeIfPresent(String.self, forKey: .author)
        let title = try container.decode(String.self, forKey: .title)
        let overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        let url = try container.decode(URL.self, forKey: .url)
        
        var imageURL: URL?
        do {
            imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        } catch {
            imageURL = nil // ignore any error decoding a URL
        }
        
        var publicationDate: Date?
        if let date = try container.decodeIfPresent(Date.self, forKey: .publicationDate), date.timeIntervalSince1970 > 0 {
            publicationDate = date
        }
        
        let sourceId = try container.decodeIfPresent(String.self, forKey: .sourceId) ?? ""
        
        self.init(author: author, title: title, overview: overview, url: url, imageURL: imageURL, publicationDate: publicationDate, sourceId: sourceId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(author, forKey: .author)
        try container.encode(title, forKey: .title)
        try container.encode(overview, forKey: .overview)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
        try container.encodeIfPresent(publicationDate, forKey: .publicationDate)
        try container.encode(sourceId, forKey: .sourceId)
    }
    
}
