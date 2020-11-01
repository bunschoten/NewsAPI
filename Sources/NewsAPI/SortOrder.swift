//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public enum SortOrder: String, CaseIterable {
    
    /// Sort articles by their date and time of publication. This is the default sort order.
    case publication = "publishedAt"
    
    /// Sort articles by their relevancy.
    case relevancy
    
    /// Sort articles by their popularity.
    case popularity
    
}

extension URLQueryItem {
    
    /// Initializes a URL query item with the given sort order.
    /// - Parameter sortOrder: sort order
    init(sortOrder: SortOrder) {
        self.init(name: "sortBy", value: sortOrder.rawValue)
    }
    
}
