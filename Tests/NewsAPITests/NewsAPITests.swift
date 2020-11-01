import XCTest
import Combine
@testable import NewsAPI

final class NewsAPITests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions.removeAll()
    }
    
    func testInvalidApiKey() {
        let expectation = self.expectation(description: #function)
        let params = SourcesParams(category: nil, language: nil, country: nil)
        var receivedError: Swift.Error? = nil
        
        Source.fetch(from: .sources(apiKey: "x", params: params))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    receivedError = error
                    expectation.fulfill()
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)

        waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("The following error occurred unexpectedly: \(error.localizedDescription)")
            } else if let error = receivedError {
                if let error = error as? Error {
                    switch error {
                    case .apiKeyInvalid:
                        // okay, this error is accepted
                        break
                    default:
                        XCTFail("The following error occurred unexpectedly: \(error.localizedDescription)")
                    }
                } else {
                    XCTFail("The following error occurred unexpectedly: \(error.localizedDescription)")
                }
            } else {
                XCTFail("Should have failed with error \(Error.apiKeyInvalid)")
            }
        }
    }
    
    func testSources() {
        let expectation = self.expectation(description: #function)
        let params = SourcesParams(category: nil, language: nil, country: nil)
        var receivedSources: [Source] = []
        var receivedError: Swift.Error? = nil
        
        Source.fetch(from: .sources(apiKey: "872a667875854dcdb85bf8e00c261758", params: params))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    receivedError = error
                    expectation.fulfill()
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: {
                receivedSources.append(contentsOf: $0)
            }
            .store(in: &subscriptions)

        waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("The following error occurred unexpectedly: \(error.localizedDescription)")
            } else if let error = receivedError {
                XCTFail("The following error occurred unexpectedly: \(error.localizedDescription)")
            } else {
                XCTAssertFalse(receivedSources.isEmpty)
            }
        }
    }

    static var allTests = [
        ("testInvalidApiKey", testInvalidApiKey),
        ("testSources", testSources)
    ]
}
