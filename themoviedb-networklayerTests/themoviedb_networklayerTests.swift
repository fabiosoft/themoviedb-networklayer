//
//  themoviedb_networklayerTests.swift
//  themoviedb-networklayerTests
//
//  Created by Fabio Nisci on 14/04/22.
//

import XCTest
@testable import themoviedb_networklayer

class themoviedb_networklayerTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func bundle() -> Bundle{
        return Bundle(for: Self.self)
    }
    
    func testFetchMovies() {
        
        let exp = XCTestExpectation()

        let popularMovieRequest = PopularMovieRequest()
        
        let moviesjsonURL = bundle().url(forResource: "PopularMovies", withExtension: "json")!
        let movieResponseData = try! Data(contentsOf: moviesjsonURL)
        
        PopularMoviesURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, movieResponseData, nil)
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [PopularMoviesURLProtocol.self]
        let session = URLSession(configuration: config)
        let network = DefaultNetworkService(session: session)
        
        network.request(popularMovieRequest) { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.count, 4)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
        
    }
    
    
    func testFetchMoviesNetworkError() {
        let exp = XCTestExpectation()

        let popularMovieRequest = PopularMovieRequest()
                
        PopularMoviesURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, nil, NetworkError.networkError)
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [PopularMoviesURLProtocol.self]
        let session = URLSession(configuration: config)
        let network = DefaultNetworkService(session: session)
        
        network.request(popularMovieRequest) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, NetworkError.networkError)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
        
    }
}
