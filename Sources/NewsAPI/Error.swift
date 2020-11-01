//
//  File.swift
//  
//
//  Created by Jan Bunschoten on 24.10.20.
//

import Foundation

public enum Error: LocalizedError {
    
    case apiKeyDisabled
    case apiKeyExhausted
    case apiKeyInvalid
    case apiKeyMissing
    case parameterInvalid(message: String)
    case parametersMissing(message: String)
    case rateLimited
    case sourcesTooMany
    case sourceDoesNotExist
    case unexpectedError(code: String, message: String)
    
    public var errorDescription: String? {
        switch self {
        case .apiKeyDisabled:
            return NSLocalizedString("Your API key has been disabled.", comment: "Error Description")
        case .apiKeyExhausted:
            return NSLocalizedString("Your API key has no more requests available.", comment: "Error Description")
        case .apiKeyInvalid:
            return NSLocalizedString("Your API key hasn't been entered correctly. Double check it and try again.", comment: "Error Description")
        case .apiKeyMissing:
            return NSLocalizedString("Your API key is missing from the request.", comment: "Error Description")
        case .parameterInvalid:
            return NSLocalizedString("You've included a parameter in your request which is currently not supported.", comment: "Error Description")
        case .parametersMissing:
            return NSLocalizedString("Required parameters are missing from the request and it cannot be completed.", comment: "Error Description")
        case .rateLimited:
            return NSLocalizedString("You have been rate limited.", comment: "Error Description")
        case .sourcesTooMany:
            return NSLocalizedString("You have requested too many sources in a single request.", comment: "Error Description")
        case .sourceDoesNotExist:
            return NSLocalizedString("You have requested a source which does not exist.", comment: "Error Description")
        case .unexpectedError(let code, _):
            return String(format: NSLocalizedString("An unexpected error occurred (error code %@)", comment: "Error Description"), code)
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .parameterInvalid(let message):
            return message.isEmpty ? nil : message
        case .parametersMissing(let message):
            return message.isEmpty ? nil : message
        case .unexpectedError(_, let message):
            return message.isEmpty ? nil : message
        default:
            return nil
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .apiKeyMissing:
            return NSLocalizedString("Append the API key and try again.", comment: "Error Recovery Suggestion")
        case .rateLimited:
            return NSLocalizedString("Back off for a while before trying the request again.", comment: "Error Recovery Suggestion")
        case .sourcesTooMany:
            return NSLocalizedString("Try splitting the request into two smaller requests.", comment: "Error Recovery Suggestion")
        case .unexpectedError:
            return NSLocalizedString("Try the request again shortly.", comment: "Error Recovery Suggestion")
        default:
            return nil
        }
    }
    
    public var helpAnchor: String? { "https://newsapi.org/docs/errors" }
    
}

extension Error {
    
    init(code: String, message: String) {
        switch code {
        case "apiKeyDisabled":
            self = .apiKeyDisabled
        case "apiKeyExhausted":
            self = .apiKeyExhausted
        case "apiKeyInvalid":
            self = .apiKeyInvalid
        case "apiKeyMissing":
            self = .apiKeyMissing
        case "parameterInvalid":
            self = .parameterInvalid(message: message)
        case "parametersMissing":
            self = .parametersMissing(message: message)
        case "rateLimited":
            self = .rateLimited
        case "sourcesTooMany":
            self = .sourcesTooMany
        case "sourceDoesNotExist":
            self = .sourceDoesNotExist
        case "unexpectedError":
            self = .unexpectedError(code: code, message: message)
        default:
            self = .unexpectedError(code: code, message: message)
        }
    }
    
}
