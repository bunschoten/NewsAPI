//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public struct Response {
    
    public enum Status: String, CaseIterable, Decodable {
        case ok, error
    }
    
    public let totalResults: Int?
    public let sources: [Source]?
    public let articles: [Article]?
    
}

extension CodingUserInfoKey {
    public static let failOnDecodingSourceFailure = CodingUserInfoKey(rawValue: "failOnDecodingSourceFailure")!
    public static let failOnDecodingArticleFailure = CodingUserInfoKey(rawValue: "failOnDecodingArticleFailure")!
}

extension Response: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
        case totalResults
        case sources
        case articles
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let status = try container.decode(Response.Status.self, forKey: .status)
        
        if status == .error {
            let code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
            let message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
            throw Error(code: code, message: message)
        }
        
        self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
        
        if container.contains(.sources) {
            var sourcesContainer = try container.nestedUnkeyedContainer(forKey: .sources)
            var sources: [Source] = []
            if let count = sourcesContainer.count {
                sources.reserveCapacity(count)
            }
            
            while !sourcesContainer.isAtEnd {
                do {
                    let source = try sourcesContainer.decode(Source.self)
                    sources.append(source)
                } catch {
                    if let value = decoder.userInfo[.failOnDecodingSourceFailure] as? Bool, value == true {
                        throw error
                    }
                    warn(message: "Failed decoding a source from JSON: ", error: error)
                }
            }
            
            self.sources = sources
        } else {
            self.sources = nil
        }
        
        if container.contains(.articles) {
            var articlesContainer = try container.nestedUnkeyedContainer(forKey: .articles)
            var articles: [Article] = []
            if let count = articlesContainer.count {
                articles.reserveCapacity(count)
            }
            
            while !articlesContainer.isAtEnd {
                do {
                    let article = try articlesContainer.decode(Article.self)
                    articles.append(article)
                } catch {
                    if let value = decoder.userInfo[.failOnDecodingArticleFailure] as? Bool, value == true {
                        throw error
                    }
                    warn(message: "Failed decoding an article from JSON: ", error: error)
                }
            }
            
            self.articles = articles
        } else {
            self.articles = nil
        }
    }
    
}

@available(iOS 10.0, OSX 10.12, *)
extension Response {
    
    /// Creates a JSON decoder to decode a `Response` from JSON data.
    /// - Parameter userInfo: additional options to pass to the decoder, optional
    /// - Returns: the JSON decoder
    public static func jsonDecoder(userInfo: [CodingUserInfoKey: Any?] = [:]) -> JSONDecoder {
        let decoder = JSONDecoder()
        
        // Register additional user info.
        for key in userInfo.keys {
            if let value = userInfo[key] {
                decoder.userInfo[key] = value
            }
        }
        
        // Register custom date decoding strategy.
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .custom({ (decoder: Decoder) throws -> Date in
            var string = try decoder.singleValueContainer().decode(String.self)
            string.deleteTimestampMilliseconds()
            return dateFormatter.date(from: string) ?? Date(timeIntervalSince1970: 0)
        })
        
        return decoder
    }
    
}


fileprivate func warn(message: String, error: Swift.Error) {
    var lines: [String] = [message]
    
    if let localizedError = error as? LocalizedError {
        if let description = localizedError.errorDescription, !description.isEmpty {
            lines.append(description)
        } else {
            lines.append(error.localizedDescription)
        }
        if let failureReason = localizedError.failureReason, !failureReason.isEmpty {
            lines.append(failureReason)
        }
        if let recoverySuggestion = localizedError.recoverySuggestion, !recoverySuggestion.isEmpty {
            lines.append(recoverySuggestion)
        }
        if let helpAnchor = localizedError.helpAnchor, !helpAnchor.isEmpty {
            lines.append("See \(helpAnchor)")
        }
    } else {
        lines.append(error.localizedDescription)
    }
    
    let output = lines
        .filter { !$0.isEmpty }
        .joined(separator: "\n          ")
    
    print("WARNING - \(output)")
}

fileprivate extension String {
    
    mutating func deleteTimestampMilliseconds() {
        guard count == 24 else { return }
        removeSubrange(index(endIndex, offsetBy: -5) ..< index(endIndex, offsetBy: -1))
    }
    
}
