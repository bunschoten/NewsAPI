//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public protocol QueryParams {
    
    /// Builds an array of URL query items.
    /// - Returns: array of URL query items
    func buildURLQueryItems() -> [URLQueryItem]
    
}

public struct SourcesParams: QueryParams {
    
    var category: Category? = nil
    var language: Language? = nil
    var country: Country? = nil
    
    public func buildURLQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        if let category = category {
            items.append(URLQueryItem(category: category))
        }
        
        if let language = language {
            items.append(URLQueryItem(language: language))
        }
        
        if let country = country {
            items.append(URLQueryItem(country: country))
        }
        
        return items
    }
    
}

public struct TopHeadlinesParams: QueryParams {
    
    var country: Country? = nil
    var category: Category? = nil
    var sources: [Source] = []
    var searchTerm: String? = nil
    var paging = Paging()
    
    public func buildURLQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        if let country = country {
            items.append(URLQueryItem(country: country))
        }
        
        if let category = category {
            items.append(URLQueryItem(category: category))
        }
        
        if !sources.isEmpty {
            items.append(URLQueryItem(sources: sources))
        }
        
        if let searchTerm = searchTerm?.trimmingCharacters(in: .whitespaces), !searchTerm.isEmpty {
            items.append(URLQueryItem(name: "q", value: searchTerm))
        }
        
        if paging.pageSize != Paging.defaultPageSize {
            items.append(URLQueryItem(name: "pageSize", value: "\(paging.pageSize)"))
        }
        
        if paging.pageNumber > Paging.defaultPageNumber {
            items.append(URLQueryItem(name: "page", value: "\(paging.pageNumber)"))
        }
        
        return items
    }
    
}

public struct EverythingParams: QueryParams {
    
    var searchTerm: String? = nil
    var titleSearchTerm: String? = nil
    var sources: [Source] = []
    var domains: [String] = []
    var excludedDomains: [String] = []
    var minDate: Date? = nil
    var maxDate: Date? = nil
    var language: Language? = nil
    var sortOrder: SortOrder? = nil
    var paging = Paging()
    
    public func buildURLQueryItems() -> [URLQueryItem] {
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd"
        
        var items: [URLQueryItem] = []
        
        if let searchTerm = searchTerm?.trimmingCharacters(in: .whitespaces), !searchTerm.isEmpty {
            items.append(URLQueryItem(name: "q", value: searchTerm))
        }
        
        if let searchTerm = titleSearchTerm?.trimmingCharacters(in: .whitespaces), !searchTerm.isEmpty {
            items.append(URLQueryItem(name: "qInTitle", value: searchTerm))
        }
        
        if !sources.isEmpty {
            items.append(URLQueryItem(sources: sources))
        }
        
        if !domains.isEmpty {
            items.append(URLQueryItem(name: "domains", value: domains.joined(separator: ",")))
        }
        
        if !excludedDomains.isEmpty {
            items.append(URLQueryItem(name: "excludeDomains", value: excludedDomains.joined(separator: ",")))
        }
        
        if let date = minDate {
            items.append(URLQueryItem(name: "from", value: isoDateFormatter.string(from: date)))
        }
        
        if let date = maxDate {
            items.append(URLQueryItem(name: "to", value: isoDateFormatter.string(from: date)))
        }
        
        if let language = language {
            items.append(URLQueryItem(language: language))
        }
        
        if let sortOrder = sortOrder {
            items.append(URLQueryItem(sortOrder: sortOrder))
        }
        
        if paging.pageSize != Paging.defaultPageSize {
            items.append(URLQueryItem(name: "pageSize", value: "\(paging.pageSize)"))
        }
        
        if paging.pageNumber > Paging.defaultPageNumber {
            items.append(URLQueryItem(name: "page", value: "\(paging.pageNumber)"))
        }
        
        return items
    }
    
}
