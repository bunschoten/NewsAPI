//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public struct Paging: Hashable {
    
    static let defaultPageSize = 20
    static let defaultPageNumber = 1
    
    /// The number of articles or sources per page. Defaults to 20, the maximum is 100.
    public var pageSize: Int = Paging.defaultPageSize
    
    /// The page number, defaults to the first page.
    public var pageNumber: Int = Paging.defaultPageNumber
    
}
