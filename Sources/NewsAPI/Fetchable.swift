//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation
import Combine

public protocol Fetchable {
    
    /// Parses the fetchable entities from the given response.
    /// - Parameter response: News API response
    static func from(response: Response) throws -> [Self]
    
    /// Fetches the entities from the given endpoint.
    /// - Parameter endpoint: News API endpoint
    static func fetch(from endpoint: Endpoint) -> AnyPublisher<[Self], Swift.Error>
    
}

extension Fetchable {
    
    private static func logRequest(_ endpoint: Endpoint) -> ((Subscribers.Demand) -> Void)? {
        #if DEBUG && os(iOS)
        return { _ in
            NewsAPI.logger.log("Requesting \(endpoint.pathComponent, privacy: .public)...")
        }
        #elseif DEBUG
        return { _ in
            print("INFO - Requesting \(endpoint.pathComponent)...")
        }
        #else
        return nil
        #endif
    }
    
    private static func logCompletion(_ endpoint: Endpoint) -> ((Subscribers.Completion<Swift.Error>) -> Void)? {
        #if DEBUG && os(iOS)
        return { completion in
            switch completion {
            case .finished:
                NewsAPI.logger.log("Request for \(endpoint.pathComponent, privacy: .public) finished successfully.")
            case .failure(let error):
                NewsAPI.logger.error("Request for \(endpoint.pathComponent, privacy: .private) failed with error: \(error as NSError)")
            }
        }
        #elseif DEBUG
        return { completion in
            switch completion {
            case .finished:
                print("INFO - Request for \(endpoint.pathComponent) finished successfully.")
            case .failure(let error):
                print("WARNING - Request for \(endpoint.pathComponent) failed with error: \(error as NSError)")
            }
        }
        #else
        return nil
        #endif
    }
    
    private static func logCancel(_ endpoint: Endpoint) -> (() -> Void)? {
        #if DEBUG && os(iOS)
        return {
            NewsAPI.logger.log("Request for \(endpoint.pathComponent, privacy: .public) cancelled.")
        }
        #elseif DEBUG
        return {
            print("INFO - Request for \(endpoint.pathComponent) cancelled.")
        }
        #else
        return nil
        #endif
    }
    
    public static func fetch(from endpoint: Endpoint) -> AnyPublisher<[Self], Swift.Error> {
        
        // Use a shared HTTP session ...
        NewsAPI.session
            
            // ... set up the HTTP request ...
            .dataTaskPublisher(for: endpoint.request())
            .receive(on: NewsAPI.dispatchQueue)
            
            // ... map to JSON, then to the `Response` ...
            .map(\.data)
            .decode(type: Response.self, decoder: Response.jsonDecoder(userInfo: NewsAPI.decoderOptions))
            .tryMap { try from(response: $0) }
            
            // ... log events ...
            .handleEvents(receiveCompletion: logCompletion(endpoint), receiveCancel: logCancel(endpoint), receiveRequest: logRequest(endpoint))
            
            // ... and return as any publisher.
            .eraseToAnyPublisher()
    }
    
}

extension Source: Fetchable {
    
    public static func from(response: Response) throws -> [Source] {
        response.sources ?? []
    }
    
}

extension Article: Fetchable {
    
    public static func from(response: Response) throws -> [Article] {
        response.articles ?? []
    }
    
}
