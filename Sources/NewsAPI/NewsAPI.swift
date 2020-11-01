//
//  File.swift
//
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation
import os

public class NewsAPI {
    
    public static var requestTimeout: TimeInterval = 30
    public static var dispatchQueue = DispatchQueue(label: "org.newsapi", qos: .default, attributes: .concurrent)
    public static var session = URLSession.shared
    public static var decoderOptions: [CodingUserInfoKey: Any?] = [:]
    
    #if os(iOS)
    public static let logger = Logger(subsystem: "org.newsapi", category: "Client")
    #endif
    
}
