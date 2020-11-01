//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public enum Endpoint {
    
    /// Endpoing to fetch a list of sources.
    case sources(apiKey: String, params: SourcesParams)
    
    /// Endpoint to fetch the top headlines.
    case topHeadlines(apiKey: String, params: TopHeadlinesParams)
    
    /// Endpoint to fetch every article matching the parameters.
    case everything(apiKey: String, params: EverythingParams)
    
    /// The query parameters.
    public var queryParams: QueryParams {
        switch self {
        case .sources(_, let params):
            return params
        case .topHeadlines(_, let params):
            return params
        case .everything(_, let params):
            return params
        }
    }
    
    /// The API key.
    public var apiKey: String {
        switch self {
        case .sources(let apiKey, _):
            return apiKey
        case .topHeadlines(let apiKey, _):
            return apiKey
        case .everything(let apiKey, _):
            return apiKey
        }
    }
    
    /// Base URL of the News API.
    private static let baseURL = URL(string: "https://newsapi.org/v2")!
    
    /// The URL path component for this endpoint.
    public var pathComponent: String {
        switch self {
        case .sources:
            return "sources"
        case .topHeadlines:
            return "top-headlines"
        case .everything:
            return "everything"
        }
    }
    
    /// A complete URL of this endpoing, including the query parameters.
    public var url: URL {
        var components = URLComponents(url: Endpoint.baseURL.appendingPathComponent(pathComponent), resolvingAgainstBaseURL: false)!
        components.queryItems = queryParams.buildURLQueryItems()
        return components.url!
    }
    
    /// Creates a request to use this endpoing.
    /// - Returns: The HTTP request
    public func request() -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: NewsAPI.requestTimeout)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
}
